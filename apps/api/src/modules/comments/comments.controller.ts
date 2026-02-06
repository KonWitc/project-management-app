import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
} from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";
import { CommentsService } from "./comments.service";
import { CreateCommentDto } from "./dto/create-comment.dto";
import { UpdateCommentDto } from "./dto/update-comment.dto";
import { AuthUser } from "@/common/auth.types";
import { User } from "@/common/decorators/user.decorator";

@Controller("tasks/:taskId/comments")
@UseGuards(AuthGuard("jwt"))
export class CommentsController {
  constructor(private readonly commentsService: CommentsService) {}

  @Post()
  async create(
    @Param("taskId") taskId: string,
    @User() user: AuthUser,
    @Body() createCommentDto: CreateCommentDto,
  ) {
    return this.commentsService.create(taskId, createCommentDto, user.userId);
  }

  @Get()
  async findByTaskId(@Param("taskId") taskId: string) {
    return this.commentsService.findByTaskId(taskId);
  }

  @Put(":id")
  async update(
    @Param("id") id: string,
    @User() user: AuthUser,
    @Body() updateCommentDto: UpdateCommentDto,
  ) {
    return this.commentsService.update(id, updateCommentDto, user.userId);
  }

  @Delete(":id")
  @HttpCode(HttpStatus.NO_CONTENT)
  async remove(@Param("id") id: string, @User() user: AuthUser) {
    return this.commentsService.remove(id, user.userId);
  }
}
