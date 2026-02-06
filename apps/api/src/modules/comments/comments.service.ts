import { Injectable, NotFoundException } from "@nestjs/common";
import { InjectModel } from "@nestjs/mongoose";
import { Model, Types } from "mongoose";
import { Comment, CommentDocument } from "./comment.schema";
import { CreateCommentDto } from "./dto/create-comment.dto";
import { UpdateCommentDto } from "./dto/update-comment.dto";

@Injectable()
export class CommentsService {
  constructor(
    @InjectModel(Comment.name) private commentModel: Model<CommentDocument>,
  ) {}

  async create(taskId: string, dto: CreateCommentDto, authorId: string) {
    const comment = await this.commentModel.create({
      taskId: new Types.ObjectId(taskId),
      authorId: new Types.ObjectId(authorId),
      content: dto.content,
      parentId: dto.parentId ? new Types.ObjectId(dto.parentId) : undefined,
    });

    return this.findOne(comment._id.toString());
  }

  async findByTaskId(taskId: string) {
    const comments = await this.commentModel
      .find({
        taskId: new Types.ObjectId(taskId),
        deletedAt: null,
      })
      .sort({ createdAt: -1 })
      .populate("authorId", "name email avatar")
      .lean()
      .exec();

    return comments.map((comment) => this.mapToResponse(comment));
  }

  async findOne(id: string) {
    const comment = await this.commentModel
      .findOne({
        _id: new Types.ObjectId(id),
        deletedAt: null,
      })
      .populate("authorId", "name email avatar")
      .lean()
      .exec();

    if (!comment) {
      throw new NotFoundException(`Comment with ID ${id} not found`);
    }

    return this.mapToResponse(comment);
  }

  async update(id: string, dto: UpdateCommentDto, userId: string) {
    const comment = await this.commentModel.findOne({
      _id: new Types.ObjectId(id),
      deletedAt: null,
    });

    if (!comment) {
      throw new NotFoundException(`Comment with ID ${id} not found`);
    }

    if (comment.authorId.toString() !== userId) {
      throw new NotFoundException("You can only edit your own comments");
    }

    comment.content = dto.content;
    comment.isEdited = true;
    await comment.save();

    return this.findOne(id);
  }

  async remove(id: string, userId: string) {
    const comment = await this.commentModel.findOne({
      _id: new Types.ObjectId(id),
      deletedAt: null,
    });

    if (!comment) {
      throw new NotFoundException(`Comment with ID ${id} not found`);
    }

    if (comment.authorId.toString() !== userId) {
      throw new NotFoundException("You can only delete your own comments");
    }

    comment.deletedAt = new Date();
    await comment.save();
  }

  private mapToResponse(comment: any) {
    const author = comment.authorId;
    return {
      id: comment._id.toString(),
      taskId: comment.taskId.toString(),
      author: author
        ? {
            id: author._id?.toString() || author.toString(),
            name: author.name || "Unknown",
            email: author.email,
            avatar: author.avatar,
          }
        : null,
      content: comment.content,
      parentId: comment.parentId?.toString() || null,
      isEdited: comment.isEdited || false,
      createdAt: comment.createdAt,
      updatedAt: comment.updatedAt,
    };
  }
}
