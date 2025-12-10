import { Schema, Prop, SchemaFactory } from "@nestjs/mongoose";
import { SchemaTypes, Types } from "mongoose";

@Schema({ timestamps: true })
export class Project {
  @Prop({ required: true })
  declare name: string;

  @Prop() description?: string;

  @Prop({ default: "draft", enum: ["draft", "active", "completed", "archived"] })
  declare status: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: "Organization", index: true })
  declare organizationId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  declare ownerId: Types.ObjectId;

  @Prop({ type: [SchemaTypes.ObjectId], ref: "User", default: [] })
  declare memberIds: Types.ObjectId[];

  @Prop() startDate?: Date;
  @Prop() endDate?: Date;
  @Prop() deadline?: Date;

  @Prop({ type: [SchemaTypes.ObjectId], ref: "Task", default: [] })
  declare taskIds: Types.ObjectId[];

  @Prop() budget?: number;
  @Prop() actualCost?: number;
  @Prop() revenueEstimate?: number;

  @Prop({ type: [String], default: [] })
  declare tags: string[];

  @Prop() category?: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  createdBy?: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User" })
  updatedBy?: Types.ObjectId;

  @Prop({ default: null })
  deletedAt?: Date;
}

export const ProjectSchema = SchemaFactory.createForClass(Project);
