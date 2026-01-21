import { ApiProperty, ApiPropertyOptional } from "@nestjs/swagger";
import {
  IsString,
  IsNotEmpty,
  IsOptional,
  IsEnum,
  IsDateString,
  IsArray,
  IsMongoId,
} from "class-validator";
import { MilestoneStatus } from "../milestone.schema";

export class CreateMilestoneDto {
  @ApiProperty({ description: "Milestone name" })
  @IsString()
  @IsNotEmpty()
  declare name: string;

  @ApiPropertyOptional({ description: "Milestone description" })
  @IsString()
  @IsOptional()
  declare description?: string;

  @ApiPropertyOptional({
    description: "Milestone status",
    enum: MilestoneStatus,
    default: MilestoneStatus.NOT_STARTED,
  })
  @IsEnum(MilestoneStatus)
  @IsOptional()
  declare status?: MilestoneStatus;

  @ApiPropertyOptional({ description: "Due date (ISO 8601 format)" })
  @IsDateString()
  @IsOptional()
  declare dueDate?: string;

  @ApiPropertyOptional({ description: "Tags for the milestone" })
  @IsArray()
  @IsString({ each: true })
  @IsOptional()
  declare tags?: string[];

  @ApiPropertyOptional({ description: "Owner user ID" })
  @IsMongoId()
  @IsOptional()
  declare ownerId?: string;
}
