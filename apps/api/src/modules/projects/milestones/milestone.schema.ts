import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { HydratedDocument, SchemaTypes, Types } from "mongoose";

export type MilestoneDocument = HydratedDocument<Milestone>;

export enum MilestoneStatus {
  NOT_STARTED = "not_started",
  IN_PROGRESS = "in_progress",
  COMPLETED = "completed",
  CANCELLED = "cancelled",
}

@Schema({ timestamps: true })
export class Milestone {
  @Prop({ required: true, trim: true })
  declare name: string;

  @Prop()
  declare description?: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: "Project", index: true, required: true })
  declare projectId: Types.ObjectId;

  @Prop({
    enum: MilestoneStatus,
    default: MilestoneStatus.NOT_STARTED,
    index: true,
  })
  declare status: MilestoneStatus;

  @Prop()
  declare dueDate?: Date;

  @Prop({ min: 0, max: 100, default: 0 })
  declare progress?: number; // 0–100

  @Prop({ type: [SchemaTypes.ObjectId], ref: "Task", default: [] })
  declare taskIds: Types.ObjectId[];

  @Prop({ type: [String], default: [] })
  declare tags: string[];

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  declare ownerId?: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  declare createdBy?: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  declare updatedBy?: Types.ObjectId;

  // soft delete
  @Prop({ index: true, default: null })
  declare deletedAt?: Date;
}

export const MilestoneSchema = SchemaFactory.createForClass(Milestone);

// indexes
MilestoneSchema.index({ projectId: 1, status: 1, dueDate: 1 });
MilestoneSchema.index({ projectId: 1, deletedAt: 1 });
MilestoneSchema.index({ deletedAt: 1 });
MilestoneSchema.index({ name: "text", description: "text" });
