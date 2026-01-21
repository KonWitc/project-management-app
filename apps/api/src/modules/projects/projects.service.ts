// src/modules/projects/projects.service.ts
import { Injectable, NotFoundException } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Project } from "./project.schema";
import { GetProjectsQueryDto } from "./dto/get-projects.query.dto";
import { FilterQuery, Model, Types } from "mongoose";
import { Task, TaskStatus } from "../tasks/task.schema";
import { Milestone, MilestoneStatus } from "./milestones/milestone.schema";
import { MilestoneDto, ProjectDetailsDto, TaskPreviewDto } from "./dto/project-details.dto";

type DateFieldQuery = {
  $gte?: Date;
  $lte?: Date;
};

type TaskStats = {
  total: number;
  completed: number;
  open: number;
};

@Injectable()
export class ProjectsService {
  constructor(
    @InjectModel(Project.name)
    private readonly projectModel: Model<Project>,
    @InjectModel(Milestone.name)
    private readonly milestoneModel: Model<Milestone>,
    @InjectModel(Task.name)
    private readonly taskModel: Model<Task>,
  ) {}

  async getProjects(currentUserId: string, query: GetProjectsQueryDto) {
    const {
      page = 1,
      limit = 20,
      sortBy,
      sortDir,
      search,
      status,
      // ownerId,
      // memberId,
      tags,
      // startFrom,
      // startTo,
      deadlineFrom,
      deadlineTo,
    } = query;

    type ProjectFilter = FilterQuery<Project> & {
      startDate?: DateFieldQuery;
      deadline?: DateFieldQuery;
    };

    const filter: ProjectFilter = {
      deletedAt: null,
    };

    // // limited to organization
    // if (organizationId) {
    //   filter.organizationId = new Types.ObjectId(organizationId);
    // }

    // // access: projects, in which user is owner or member
    // filter.$or = [
    //   { ownerId: new Types.ObjectId(currentUserId) },
    //   { memberIds: new Types.ObjectId(currentUserId) },
    // ];

    // status (single or array)
    if (status) {
      if (Array.isArray(status)) {
        filter.status = { $in: status };
      } else {
        filter.status = status;
      }
    }

    // // ownerId
    // if (ownerId) {
    //   filter.ownerId = new Types.ObjectId(ownerId);
    // }

    // // memberId
    // if (memberId) {
    //   filter.memberIds = new Types.ObjectId(memberId);
    // }

    // tags – at least one tag needs to be present
    if (tags?.length) {
      filter.tags = { $in: tags };
    }

    // search – regex for name/description
    if (search) {
      const regex = new RegExp(search.trim(), "i");
      filter.$and = (filter.$and || []).concat([
        {
          $or: [{ name: regex }, { description: regex }],
        },
      ]);
    }

    // deadline range
    if (deadlineFrom || deadlineTo) {
      const deadlineFilter: DateFieldQuery = {};
      if (deadlineFrom) {
        deadlineFilter.$gte = new Date(deadlineFrom);
      }
      if (deadlineTo) {
        deadlineFilter.$lte = new Date(deadlineTo);
      }
      filter.deadline = deadlineFilter;
    }

    const sortField = sortBy || "createdAt";
    const sortDirection = sortDir === "asc" ? 1 : -1;

    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.projectModel
        .find(filter)
        .sort({ [sortField]: sortDirection })
        .skip(skip)
        .limit(limit)
        .lean()
        .exec(),
      this.projectModel.countDocuments(),
    ]);

    return {
      items,
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    };
  }

  async getProjectById(id: string) {
    const projectId = new Types.ObjectId(id);

    // Project
    const project = await this.projectModel
      .findOne({ _id: projectId, deletedAt: null })
      .lean<Project & { _id: Types.ObjectId }>() // ⬅️ typ generics
      .exec();

    if (!project) {
      throw new NotFoundException("Project not found");
    }

    // Milestones
    const milestones = await this.milestoneModel
      .find({ projectId, deletedAt: null })
      .sort({ dueDate: 1 })
      .lean<(Milestone & { _id: Types.ObjectId })[]>()
      .exec();

    // Tasks stats + upcoming tasks
    const [tasksStatsRaw, upcomingTasks] = await Promise.all([
      this.taskModel
        .aggregate<TaskStats>([
          {
            $match: {
              projectId,
              deletedAt: null,
            },
          },
          {
            $group: {
              _id: null,
              total: { $sum: 1 },
              completed: {
                $sum: {
                  $cond: [{ $eq: ["$status", TaskStatus.COMPLETED] }, 1, 0],
                },
              },
              open: {
                $sum: {
                  $cond: [
                    {
                      $in: ["$status", [TaskStatus.NOT_STARTED, TaskStatus.IN_PROGRESS]],
                    },
                    1,
                    0,
                  ],
                },
              },
            },
          },
        ])
        .exec(),

      this.taskModel
        .find({
          projectId,
          deletedAt: null,
          status: {
            $in: [TaskStatus.NOT_STARTED, TaskStatus.IN_PROGRESS],
          },
        })
        .sort({ dueDate: 1 })
        .limit(5)
        .lean<(Task & { _id: Types.ObjectId })[]>()
        .exec(),
    ]);

    const tasksStats: TaskStats = tasksStatsRaw[0] ?? {
      total: 0,
      completed: 0,
      open: 0,
    };

    const milestoneDtos: MilestoneDto[] = milestones.map((m) => ({
      id: m._id.toString(),
      name: m.name,
      description: m.description,
      status: m.status,
      dueDate: m.dueDate ?? undefined,
      progress: m.progress ?? 0,
    }));

    const upcomingTaskDtos: TaskPreviewDto[] = upcomingTasks.map((t) => ({
      id: t._id.toString(),
      projectId: t.projectId.toString(),
      title: t.title,
      status: t.status,
      priority: t.priority,
      dueDate: t.dueDate ?? undefined,
      milestoneId: t.milestoneId ? t.milestoneId.toString() : undefined,
    }));

    const memberIds: string[] = (project.memberIds ?? []).map((m) => m.toString());

    const completedMilestonesCount = milestones.filter(
      (m) => m.status === MilestoneStatus.COMPLETED,
    ).length;

    const dto: ProjectDetailsDto = {
      id: project._id.toString(),
      name: project.name,
      description: project.description,
      status: project.status,
      organizationId: project.organizationId ? project.organizationId.toString() : undefined,
      ownerId: project.ownerId.toString(),
      memberIds,

      startDate: project.startDate ?? undefined,
      endDate: project.endDate ?? undefined,
      deadline: project.deadline ?? undefined,

      tags: project.tags ?? [],
      category: project.category ?? undefined,

      milestonesCount: milestones.length,
      completedMilestonesCount,

      tasksCount: tasksStats.total,
      openTasksCount: tasksStats.open,
      completedTasksCount: tasksStats.completed,

      milestones: milestoneDtos,
      upcomingTasks: upcomingTaskDtos,
    };

    return dto;
  }

  async getTags(): Promise<string[]> {
    const tags: string[] = await this.projectModel.distinct("tags");
    return tags.sort();
  }
}
