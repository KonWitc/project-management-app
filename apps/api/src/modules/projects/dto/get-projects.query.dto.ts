// src/modules/projects/dto/get-projects.query.dto.ts
import {
  IsArray,
  IsDateString,
  IsIn,
  IsInt,
  IsOptional,
  IsString,
  Min,
  Max,
} from "class-validator";
import { Type } from "class-transformer";

const PROJECT_STATUSES = ["draft", "active", "completed", "archived"] as const;

export type ProjectStatus = (typeof PROJECT_STATUSES)[number];

export class GetProjectsQueryDto {
  @IsOptional()
  @IsString()
  search?: string;

  @IsOptional()
  @IsIn(PROJECT_STATUSES, { each: true })
  status?: ProjectStatus | ProjectStatus[];

  @IsOptional()
  @IsString()
  ownerId?: string;

  @IsOptional()
  @IsString()
  memberId?: string;

  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  tags?: string[];

  @IsOptional()
  @IsDateString()
  startFrom?: string;

  @IsOptional()
  @IsDateString()
  startTo?: string;

  @IsOptional()
  @IsDateString()
  deadlineFrom?: string;

  @IsOptional()
  @IsDateString()
  deadlineTo?: string;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page = 1;

  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit = 20;

  @IsOptional()
  @IsString()
  sortBy?: "createdAt" | "startDate" | "deadline" | "name" | "status";

  @IsOptional()
  @IsIn(["asc", "desc"])
  sortDir: "asc" | "desc" = "desc";
}
