import { Injectable, NotFoundException, BadRequestException } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { FilterQuery, Model, Types } from "mongoose";
import { Task } from "./task.schema";
import { CreateTaskDto } from "./dto/create-task.dto";
import { UpdateTaskDto } from "./dto/update-task.dto";
import { GetTasksQueryDto } from "./dto/get-tasks-query.dto";

type DateFieldQuery = {
  $gte?: Date;
  $lte?: Date;
};

@Injectable()
export class TasksService {
  constructor(@InjectModel(Task.name) private readonly taskModel: Model<Task>) {}

  async create(createTaskDto: CreateTaskDto, userId: string): Promise<Task> {
    const task = new this.taskModel({
      ...createTaskDto,
      projectId: new Types.ObjectId(createTaskDto.projectId),
      milestoneId: createTaskDto.milestoneId
        ? new Types.ObjectId(createTaskDto.milestoneId)
        : undefined,
      assigneeId: createTaskDto.assigneeId
        ? new Types.ObjectId(createTaskDto.assigneeId)
        : undefined,
      reporterId: createTaskDto.reporterId
        ? new Types.ObjectId(createTaskDto.reporterId)
        : undefined,
      createdBy: new Types.ObjectId(userId),
      updatedBy: new Types.ObjectId(userId),
    });

    return task.save();
  }

  async findAll(query: GetTasksQueryDto) {
    const {
      page = 1,
      limit = 20,
      sortBy,
      sortOrder,
      search,
      projectId,
      milestoneId,
      assigneeId,
      reporterId,
      status,
      priority,
      tags,
      taskType,
    } = query;

    type TaskFilter = FilterQuery<Task> & {
      dueDate?: DateFieldQuery;
    };

    const filter: TaskFilter = {
      deletedAt: null,
    };

    // Filter by project
    if (projectId) {
      filter.projectId = new Types.ObjectId(projectId);
    }

    // Filter by milestone
    if (milestoneId) {
      filter.milestoneId = new Types.ObjectId(milestoneId);
    }

    // Filter by assignee
    if (assigneeId) {
      filter.assigneeId = new Types.ObjectId(assigneeId);
    }

    // Filter by reporter
    if (reporterId) {
      filter.reporterId = new Types.ObjectId(reporterId);
    }

    // Filter by status
    if (status) {
      filter.status = status;
    }

    // Filter by priority
    if (priority) {
      filter.priority = priority;
    }

    // Filter by task type
    if (taskType) {
      filter.taskType = taskType;
    }

    // Filter by tags
    if (tags?.length) {
      filter.tags = { $in: tags };
    }

    // Search in title and description
    if (search) {
      const regex = new RegExp(search.trim(), "i");
      filter.$and = (filter.$and || []).concat([
        {
          $or: [{ title: regex }, { description: regex }],
        },
      ]);
    }

    const sortField = sortBy || "createdAt";
    const sortDirection = sortOrder === "asc" ? 1 : -1;

    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      this.taskModel
        .find(filter)
        .sort({ [sortField]: sortDirection })
        .skip(skip)
        .limit(limit)
        .populate("assigneeId", "profile.displayName profile.username email")
        .populate("reporterId", "profile.displayName profile.username email")
        .populate("createdBy", "profile.displayName profile.username email")
        .populate("updatedBy", "profile.displayName profile.username email")
        .lean()
        .exec(),
      this.taskModel.countDocuments(filter),
    ]);

    return {
      items,
      page,
      limit,
      total,
      totalPages: Math.ceil(total / limit),
    };
  }

  async findOne(id: string): Promise<Task> {
    if (!Types.ObjectId.isValid(id)) {
      throw new BadRequestException("Invalid task ID");
    }

    const task = await this.taskModel
      .findOne({ _id: new Types.ObjectId(id), deletedAt: null })
      .populate("assigneeId", "profile.displayName profile.username email")
      .populate("reporterId", "profile.displayName profile.username email")
      .populate("createdBy", "profile.displayName profile.username email")
      .populate("updatedBy", "profile.displayName profile.username email")
      .lean()
      .exec();

    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }

    return task;
  }

  async update(id: string, updateTaskDto: UpdateTaskDto, userId: string): Promise<Task> {
    if (!Types.ObjectId.isValid(id)) {
      throw new BadRequestException("Invalid task ID");
    }

    type UpdateDataType = Omit<
      UpdateTaskDto,
      "projectId" | "milestoneId" | "assigneeId" | "reporterId"
    > & {
      updatedBy: Types.ObjectId;
      projectId?: Types.ObjectId;
      milestoneId?: Types.ObjectId;
      assigneeId?: Types.ObjectId;
      reporterId?: Types.ObjectId;
    };

    // Extract ID fields separately to avoid type conflicts
    const { projectId, milestoneId, assigneeId, reporterId, ...restDto } = updateTaskDto;

    const updateData: UpdateDataType = {
      ...restDto,
      updatedBy: new Types.ObjectId(userId),
    };

    // Convert string IDs to ObjectIds
    if (projectId) {
      updateData.projectId = new Types.ObjectId(projectId);
    }
    if (milestoneId) {
      updateData.milestoneId = new Types.ObjectId(milestoneId);
    }
    if (assigneeId) {
      updateData.assigneeId = new Types.ObjectId(assigneeId);
    }
    if (reporterId) {
      updateData.reporterId = new Types.ObjectId(reporterId);
    }

    const task = await this.taskModel
      .findOneAndUpdate(
        { _id: new Types.ObjectId(id), deletedAt: null },
        { $set: updateData },
        { new: true },
      )
      .populate("assigneeId", "profile.displayName profile.username email")
      .populate("reporterId", "profile.displayName profile.username email")
      .lean()
      .exec();

    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }

    return task;
  }

  async remove(id: string): Promise<void> {
    if (!Types.ObjectId.isValid(id)) {
      throw new BadRequestException("Invalid task ID");
    }

    // Soft delete
    const result = await this.taskModel
      .updateOne(
        { _id: new Types.ObjectId(id), deletedAt: null },
        { $set: { deletedAt: new Date() } },
      )
      .exec();

    if (result.matchedCount === 0) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }
  }

  async getTags(projectId?: string): Promise<string[]> {
    const filter: FilterQuery<Task> = { deletedAt: null };

    if (projectId) {
      filter.projectId = new Types.ObjectId(projectId);
    }

    const tags: string[] = await this.taskModel.distinct("tags", filter);
    return tags.sort();
  }

  async getTaskTypes(projectId?: string): Promise<string[]> {
    const filter: FilterQuery<Task> = {
      deletedAt: null,
      taskType: { $ne: null, $exists: true },
    };

    if (projectId) {
      filter.projectId = new Types.ObjectId(projectId);
    }

    const types: string[] = await this.taskModel.distinct("taskType", filter);
    return types.sort();
  }
}
