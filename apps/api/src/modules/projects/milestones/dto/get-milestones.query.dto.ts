import { ApiPropertyOptional } from "@nestjs/swagger";
import { IsEnum, IsOptional, IsString, IsInt, Min, IsIn } from "class-validator";
import { Type } from "class-transformer";
import { MilestoneStatus } from "../milestone.schema";

export class GetMilestonesQueryDto {
  @ApiPropertyOptional({ description: "Filter by milestone status" })
  @IsEnum(MilestoneStatus)
  @IsOptional()
  declare status?: MilestoneStatus;

  @ApiPropertyOptional({ description: "Search term for name or description" })
  @IsString()
  @IsOptional()
  declare search?: string;

  @ApiPropertyOptional({
    description: "Page number",
    default: 1,
    minimum: 1,
  })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @IsOptional()
  declare page?: number;

  @ApiPropertyOptional({
    description: "Items per page",
    default: 10,
    minimum: 1,
  })
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @IsOptional()
  declare limit?: number;

  @ApiPropertyOptional({
    description: "Sort field",
    enum: ["name", "dueDate", "progress", "status", "createdAt"],
    default: "dueDate",
  })
  @IsString()
  @IsIn(["name", "dueDate", "progress", "status", "createdAt"])
  @IsOptional()
  declare sortBy?: string;

  @ApiPropertyOptional({
    description: "Sort direction",
    enum: ["asc", "desc"],
    default: "asc",
  })
  @IsString()
  @IsIn(["asc", "desc"])
  @IsOptional()
  declare sortDir?: "asc" | "desc";
}
