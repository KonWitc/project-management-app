import {
  IsString,
  IsOptional,
  IsEnum,
  IsNumber,
  IsDateString,
  IsArray,
  IsMongoId,
  Min,
} from "class-validator";
import { TaskStatus, TaskPriority } from "../task.schema";

export class UpdateTaskDto {
  @IsString()
  @IsOptional()
  title?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsMongoId()
  @IsOptional()
  projectId?: string;

  @IsMongoId()
  @IsOptional()
  milestoneId?: string;

  @IsMongoId()
  @IsOptional()
  assigneeId?: string;

  @IsMongoId()
  @IsOptional()
  reporterId?: string;

  @IsEnum(TaskStatus)
  @IsOptional()
  status?: TaskStatus;

  @IsEnum(TaskPriority)
  @IsOptional()
  priority?: TaskPriority;

  @IsNumber()
  @IsOptional()
  orderIndex?: number;

  @IsDateString()
  @IsOptional()
  startDate?: string;

  @IsDateString()
  @IsOptional()
  dueDate?: string;

  @IsDateString()
  @IsOptional()
  completedAt?: string;

  @IsNumber()
  @Min(0)
  @IsOptional()
  estimateHours?: number;

  @IsNumber()
  @Min(0)
  @IsOptional()
  loggedHours?: number;

  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  tags?: string[];

  @IsString()
  @IsOptional()
  taskType?: string;
}
