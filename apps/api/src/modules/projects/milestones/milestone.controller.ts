import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";
import { ApiTags, ApiOperation, ApiBearerAuth } from "@nestjs/swagger";
import { MilestonesService } from "./milestone.service";
import { CreateMilestoneDto } from "./dto/create-milestone.dto";
import { UpdateMilestoneDto } from "./dto/update-milestone.dto";
import { GetMilestonesQueryDto } from "./dto/get-milestones.query.dto";
import { AuthUser } from "@/common/auth.types";
import { User } from "@/common/decorators/user.decorator";

@ApiTags("milestones")
@Controller("projects/:projectId/milestones")
@UseGuards(AuthGuard("jwt"))
@ApiBearerAuth()
export class MilestonesController {
  constructor(private readonly milestonesService: MilestonesService) {}

  @Post()
  @ApiOperation({ summary: "Create a new milestone" })
  async create(
    @Param("projectId") projectId: string,
    @Body() createMilestoneDto: CreateMilestoneDto,
    @User() user: AuthUser,
  ) {
    return this.milestonesService.create(projectId, createMilestoneDto, user.userId);
  }

  @Get()
  @ApiOperation({ summary: "Get all milestones for a project" })
  async findAll(@Param("projectId") projectId: string, @Query() query: GetMilestonesQueryDto) {
    return this.milestonesService.findAll(projectId, query);
  }

  @Get(":id")
  @ApiOperation({ summary: "Get a single milestone by ID" })
  async findOne(@Param("projectId") projectId: string, @Param("id") id: string) {
    return this.milestonesService.findOne(projectId, id);
  }

  @Patch(":id")
  @ApiOperation({ summary: "Update a milestone" })
  async update(
    @Param("projectId") projectId: string,
    @Param("id") id: string,
    @Body() updateMilestoneDto: UpdateMilestoneDto,
    @User() user: AuthUser,
  ) {
    return this.milestonesService.update(projectId, id, updateMilestoneDto, user.userId);
  }

  @Delete(":id")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Delete a milestone (soft delete)" })
  async remove(@Param("projectId") projectId: string, @Param("id") id: string) {
    return this.milestonesService.remove(projectId, id);
  }

  @Post(":id/calculate-progress")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Recalculate milestone progress based on tasks" })
  async calculateProgress(@Param("id") id: string) {
    const progress = await this.milestonesService.calculateProgress(id);
    return { progress };
  }

  @Post(":id/tasks/:taskId/link")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Link a task to this milestone" })
  async linkTask(@Param("id") id: string, @Param("taskId") taskId: string) {
    await this.milestonesService.linkTask(id, taskId);
    return { message: "Task linked successfully" };
  }

  @Delete(":id/tasks/:taskId/unlink")
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: "Unlink a task from this milestone" })
  async unlinkTask(@Param("id") id: string, @Param("taskId") taskId: string) {
    await this.milestonesService.unlinkTask(id, taskId);
    return { message: "Task unlinked successfully" };
  }

  @Get(":id/tasks")
  @ApiOperation({ summary: "Get all tasks for a milestone" })
  async getTasks(@Param("projectId") projectId: string, @Param("id") id: string) {
    return this.milestonesService.getTasks(projectId, id);
  }
}
