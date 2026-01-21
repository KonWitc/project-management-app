import { Injectable, NotFoundException } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { FilterQuery, Model, Types } from "mongoose";
import { Milestone } from "./milestone.schema";
import { Task, TaskStatus } from "../../tasks/task.schema";
import { CreateMilestoneDto } from "./dto/create-milestone.dto";
import { UpdateMilestoneDto } from "./dto/update-milestone.dto";
import { GetMilestonesQueryDto } from "./dto/get-milestones.query.dto";

@Injectable()
export class MilestonesService {
  constructor(
    @InjectModel(Milestone.name)
    private readonly milestoneModel: Model<Milestone>,
    @InjectModel(Task.name)
    private readonly taskModel: Model<Task>,
  ) {}

  async create(projectId: string, createMilestoneDto: CreateMilestoneDto, currentUserId: string) {
    const milestone = new this.milestoneModel({
      ...createMilestoneDto,
      projectId: new Types.ObjectId(projectId),
      createdBy: new Types.ObjectId(currentUserId),
      updatedBy: new Types.ObjectId(currentUserId),
      progress: 0,
      taskIds: [],
    });

    return milestone.save();
  }

  async findAll(projectId: string, query: GetMilestonesQueryDto) {
    const { page = 1, limit = 10, sortBy = "dueDate", sortDir = "asc", search, status } = query;

    const filter: FilterQuery<Milestone> = {
      projectId: new Types.ObjectId(projectId),
      deletedAt: null,
    };

    if (status) {
      filter.status = status;
    }

    if (search) {
      const regex = new RegExp(search.trim(), "i");
      filter.$or = [{ name: regex }, { description: regex }];
    }

    const sortField = sortBy;
    const sortDirection = sortDir === "asc" ? 1 : -1;

    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.milestoneModel
        .find(filter)
        .sort({ [sortField]: sortDirection })
        .skip(skip)
        .limit(limit)
        .lean()
        .exec(),
      this.milestoneModel.countDocuments(filter).exec(),
    ]);

    return {
      items,
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    };
  }

  async findOne(projectId: string, milestoneId: string) {
    const milestone = await this.milestoneModel
      .findOne({
        _id: new Types.ObjectId(milestoneId),
        projectId: new Types.ObjectId(projectId),
        deletedAt: null,
      })
      .lean()
      .exec();

    if (!milestone) {
      throw new NotFoundException("Milestone not found");
    }

    return milestone;
  }

  async update(
    projectId: string,
    milestoneId: string,
    updateMilestoneDto: UpdateMilestoneDto,
    currentUserId: string,
  ) {
    const milestone = await this.milestoneModel
      .findOneAndUpdate(
        {
          _id: new Types.ObjectId(milestoneId),
          projectId: new Types.ObjectId(projectId),
          deletedAt: null,
        },
        {
          ...updateMilestoneDto,
          updatedBy: new Types.ObjectId(currentUserId),
        },
        { new: true },
      )
      .lean()
      .exec();

    if (!milestone) {
      throw new NotFoundException("Milestone not found");
    }

    return milestone;
  }

  async remove(projectId: string, milestoneId: string) {
    const milestone = await this.milestoneModel
      .findOneAndUpdate(
        {
          _id: new Types.ObjectId(milestoneId),
          projectId: new Types.ObjectId(projectId),
          deletedAt: null,
        },
        { deletedAt: new Date() },
        { new: true },
      )
      .lean()
      .exec();

    if (!milestone) {
      throw new NotFoundException("Milestone not found");
    }

    // Also update any tasks linked to this milestone to remove the link
    await this.taskModel
      .updateMany(
        {
          milestoneId: new Types.ObjectId(milestoneId),
          deletedAt: null,
        },
        { $unset: { milestoneId: "" } },
      )
      .exec();

    return { message: "Milestone deleted successfully" };
  }

  async calculateProgress(milestoneId: string): Promise<number> {
    const milestone = await this.milestoneModel
      .findOne({
        _id: new Types.ObjectId(milestoneId),
        deletedAt: null,
      })
      .lean()
      .exec();

    if (!milestone) {
      throw new NotFoundException("Milestone not found");
    }

    // Get all tasks linked to this milestone
    const tasks = await this.taskModel
      .find({
        milestoneId: new Types.ObjectId(milestoneId),
        deletedAt: null,
      })
      .lean()
      .exec();

    if (tasks.length === 0) {
      return 0;
    }

    // Calculate progress based on completed tasks
    const completedTasks = tasks.filter((task) => task.status === TaskStatus.COMPLETED).length;

    const progress = Math.round((completedTasks / tasks.length) * 100);

    // Update the milestone with calculated progress
    await this.milestoneModel
      .updateOne({ _id: new Types.ObjectId(milestoneId) }, { progress })
      .exec();

    return progress;
  }

  async linkTask(milestoneId: string, taskId: string): Promise<void> {
    const milestone = await this.milestoneModel
      .findOne({
        _id: new Types.ObjectId(milestoneId),
        deletedAt: null,
      })
      .exec();

    if (!milestone) {
      throw new NotFoundException("Milestone not found");
    }

    const task = await this.taskModel
      .findOne({
        _id: new Types.ObjectId(taskId),
        deletedAt: null,
      })
      .exec();

    if (!task) {
      throw new NotFoundException("Task not found");
    }

    // Update task with milestone reference
    await this.taskModel
      .updateOne(
        { _id: new Types.ObjectId(taskId) },
        { milestoneId: new Types.ObjectId(milestoneId) },
      )
      .exec();

    // Add task to milestone's taskIds if not already there
    if (!milestone.taskIds.some((id) => id.equals(new Types.ObjectId(taskId)))) {
      milestone.taskIds.push(new Types.ObjectId(taskId));
      await milestone.save();
    }

    // Recalculate progress
    await this.calculateProgress(milestoneId);
  }

  async unlinkTask(milestoneId: string, taskId: string): Promise<void> {
    const milestone = await this.milestoneModel
      .findOne({
        _id: new Types.ObjectId(milestoneId),
        deletedAt: null,
      })
      .exec();

    if (!milestone) {
      throw new NotFoundException("Milestone not found");
    }

    // Remove milestone reference from task
    await this.taskModel
      .updateOne({ _id: new Types.ObjectId(taskId) }, { $unset: { milestoneId: "" } })
      .exec();

    // Remove task from milestone's taskIds
    milestone.taskIds = milestone.taskIds.filter((id) => !id.equals(new Types.ObjectId(taskId)));
    await milestone.save();

    // Recalculate progress
    await this.calculateProgress(milestoneId);
  }

  async getTasks(projectId: string, milestoneId: string) {
    // const milestone = await this.findOne(projectId, milestoneId);

    const tasks = await this.taskModel
      .find({
        milestoneId: new Types.ObjectId(milestoneId),
        deletedAt: null,
      })
      .lean()
      .exec();

    return tasks;
  }
}
