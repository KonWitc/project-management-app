import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEnum,
  IsNumber,
  IsDateString,
  IsArray,
  IsMongoId,
  Min,
} from "class-validator";
import { TaskStatus, TaskPriority } from "../task.schema";

export class CreateTaskDto {
  @IsString()
  @IsNotEmpty()
  title!: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsMongoId()
  @IsNotEmpty()
  projectId!: string;

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
