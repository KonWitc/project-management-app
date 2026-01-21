import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { HydratedDocument, SchemaTypes, Types } from "mongoose";

export type TaskDocument = HydratedDocument<Task>;

export enum TaskStatus {
  NOT_STARTED = "not_started",
  IN_PROGRESS = "in_progress",
  COMPLETED = "completed",
  CANCELLED = "cancelled",
  BLOCKED = "blocked",
}

export enum TaskPriority {
  LOW = "low",
  MEDIUM = "medium",
  HIGH = "high",
  CRITICAL = "critical",
}

@Schema({ timestamps: true })
export class Task {
  @Prop({ required: true, trim: true })
  declare title: string;

  @Prop()
  description?: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: "Project", index: true })
  declare projectId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "Milestone", index: true })
  milestoneId?: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User", index: true })
  assigneeId?: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  reporterId?: Types.ObjectId;

  @Prop({ enum: TaskStatus, default: TaskStatus.NOT_STARTED, index: true })
  declare status: TaskStatus;

  @Prop({ enum: TaskPriority, default: TaskPriority.MEDIUM })
  declare priority: TaskPriority;

  // order in column (kanban)
  @Prop({ default: 0 })
  declare orderIndex: number;

  @Prop() startDate?: Date;
  @Prop() dueDate?: Date;
  @Prop() completedAt?: Date;

  @Prop() estimateHours?: number;
  @Prop() loggedHours?: number;

  @Prop({ type: [String], default: [] })
  declare tags: string[];

  @Prop() taskType?: string; // eg. 'issue', 'risk', 'milestone-task'

  // soft delete
  @Prop({ index: true, default: null })
  deletedAt?: Date;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  createdBy?: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  updatedBy?: Types.ObjectId;
}

export const TaskSchema = SchemaFactory.createForClass(Task);

// indexes
TaskSchema.index({ projectId: 1, status: 1, orderIndex: 1 });
TaskSchema.index({ assigneeId: 1, status: 1, dueDate: 1 });
TaskSchema.index({ tags: 1 });
TaskSchema.index({ deletedAt: 1 });
