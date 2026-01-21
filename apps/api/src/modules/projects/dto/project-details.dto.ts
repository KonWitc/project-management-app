import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import { IsArray, IsDateString, IsEnum, IsNumber, IsOptional, IsString } from "class-validator";
import { MilestoneStatus } from "../milestones/milestone.schema";
import { TaskPriority, TaskStatus } from "@/modules/tasks/task.schema";

// ============================================
// Milestone DTO
// ============================================
export class MilestoneDto {
  @ApiProperty()
  @IsString()
  id!: string;

  @ApiProperty()
  @IsString()
  name!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty({ enum: MilestoneStatus })
  @IsEnum(MilestoneStatus)
  status!: MilestoneStatus;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  dueDate?: Date;

  @ApiProperty()
  @IsNumber()
  progress!: number; //0-100
}

// ============================================
// Task Preview DTO
// ============================================
export class TaskPreviewDto {
  @ApiProperty()
  @IsString()
  id!: string;

  @ApiProperty()
  @IsString()
  projectId!: string;

  @ApiProperty()
  @IsString()
  title!: string;

  @ApiProperty({ enum: TaskStatus })
  @IsEnum(TaskStatus)
  status!: TaskStatus;

  @ApiProperty({ enum: TaskPriority })
  @IsEnum(TaskPriority)
  priority!: TaskPriority;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  dueDate?: Date;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  milestoneId?: string | null;
}

// ============================================
// Project Details DTO
// ============================================
export class ProjectDetailsDto {
  @ApiProperty()
  @IsString()
  id!: string;

  @ApiProperty()
  @IsString()
  name!: string;

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  description?: string;

  @ApiProperty()
  @IsString()
  status!: string;

  @ApiPropertyOptional()
  @IsString()
  organizationId?: string;

  @ApiProperty()
  @IsString()
  ownerId!: string;

  @ApiProperty({ type: [String] })
  @IsArray()
  memberIds!: string[];

  // --- DATES ---
  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  startDate?: Date;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  endDate?: Date;

  @ApiPropertyOptional()
  @IsOptional()
  @IsDateString()
  deadline?: Date;

  // --- TAGS / CATEGORY ---
  @ApiProperty({ type: [String] })
  @IsArray()
  tags!: string[];

  @ApiPropertyOptional()
  @IsOptional()
  @IsString()
  category?: string;

  // --- STATISTICS ---
  @ApiProperty()
  @IsNumber()
  milestonesCount!: number;

  @ApiProperty()
  @IsNumber()
  completedMilestonesCount!: number;

  @ApiProperty()
  @IsNumber()
  tasksCount!: number;

  @ApiProperty()
  @IsNumber()
  openTasksCount!: number;

  @ApiProperty()
  @IsNumber()
  completedTasksCount!: number;

  // --- MILESTONE LIST ---
  @ApiProperty({ type: [MilestoneDto] })
  @IsArray()
  milestones!: MilestoneDto[];

  // --- UPCOMING TASKS ---
  @ApiProperty({ type: [TaskPreviewDto] })
  @IsArray()
  upcomingTasks!: TaskPreviewDto[];
}
