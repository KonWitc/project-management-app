import { Prop, Schema, SchemaFactory } from "@nestjs/mongoose";
import { HydratedDocument, SchemaTypes, Types } from "mongoose";

export type CommentDocument = HydratedDocument<Comment>;

@Schema({ timestamps: true })
export class Comment {
  @Prop({ type: SchemaTypes.ObjectId, ref: "Task", required: true, index: true })
  declare taskId: Types.ObjectId;

  @Prop({ type: SchemaTypes.ObjectId, ref: "User", required: true })
  declare authorId: Types.ObjectId;

  @Prop({ required: true, trim: true })
  declare content: string;

  @Prop({ type: SchemaTypes.ObjectId, ref: "Comment" })
  parentId?: Types.ObjectId;

  @Prop({ default: false })
  declare isEdited: boolean;

  @Prop({ index: true, default: null })
  deletedAt?: Date;
}

export const CommentSchema = SchemaFactory.createForClass(Comment);

CommentSchema.index({ taskId: 1, createdAt: -1 });
CommentSchema.index({ deletedAt: 1 });
