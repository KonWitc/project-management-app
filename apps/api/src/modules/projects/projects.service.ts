// src/modules/projects/projects.service.ts
import { Injectable } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Project } from "./project.schema";
import { GetProjectsQueryDto } from "./dto/get-projects.query.dto";
import { FilterQuery, Model } from "mongoose";

type DateFieldQuery = {
  $gte?: Date;
  $lte?: Date;
};

@Injectable()
export class ProjectsService {
  constructor(@InjectModel(Project.name) private readonly projectModel: Model<Project>) {}

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

  async getTags(): Promise<string[]> {
    const tags: string[] = await this.projectModel.distinct("tags");
    return tags.sort();
  }
}
