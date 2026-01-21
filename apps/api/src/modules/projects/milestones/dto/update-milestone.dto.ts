import { ApiPropertyOptional, PartialType } from "@nestjs/swagger";
import { IsNumber, IsOptional, Min, Max } from "class-validator";
import { CreateMilestoneDto } from "./create-milestone.dto";

export class UpdateMilestoneDto extends PartialType(CreateMilestoneDto) {
  @ApiPropertyOptional({
    description: "Progress percentage (0-100)",
    minimum: 0,
    maximum: 100,
  })
  @IsNumber()
  @Min(0)
  @Max(100)
  @IsOptional()
  declare progress?: number;
}
