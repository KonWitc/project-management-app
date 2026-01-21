import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";
import { TasksService } from "./tasks.service";
import { CreateTaskDto } from "./dto/create-task.dto";
import { UpdateTaskDto } from "./dto/update-task.dto";
import { GetTasksQueryDto } from "./dto/get-tasks-query.dto";
import { AuthUser } from "@/common/auth.types";
import { User } from "@/common/decorators/user.decorator";

@Controller("tasks")
@UseGuards(AuthGuard("jwt"))
export class TasksController {
  constructor(private readonly tasksService: TasksService) {}

  @Post()
  async create(@User() user: AuthUser, @Body() createTaskDto: CreateTaskDto) {
    return this.tasksService.create(createTaskDto, user.userId);
  }

  @Get()
  async findAll(@Query() query: GetTasksQueryDto) {
    return this.tasksService.findAll(query);
  }

  @Get("tags")
  async getTags(@Query("projectId") projectId?: string) {
    return this.tasksService.getTags(projectId);
  }

  @Get("types")
  async getTaskTypes(@Query("projectId") projectId?: string) {
    return this.tasksService.getTaskTypes(projectId);
  }

  @Get(":id")
  async findOne(@Param("id") id: string) {
    return this.tasksService.findOne(id);
  }

  @Put(":id")
  async update(
    @Param("id") id: string,
    @User() user: AuthUser,
    @Body() updateTaskDto: UpdateTaskDto,
  ) {
    return this.tasksService.update(id, updateTaskDto, user.userId);
  }

  @Delete(":id")
  @HttpCode(HttpStatus.NO_CONTENT)
  async remove(@Param("id") id: string) {
    return this.tasksService.remove(id);
  }
}
