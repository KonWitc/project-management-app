import { Controller, Get, Query, UseGuards } from "@nestjs/common";
import { AuthGuard } from "@nestjs/passport";
import { ProjectsService } from "./projects.service";
import { GetProjectsQueryDto } from "./dto/get-projects.query.dto";
import { AuthUser } from "@/common/auth.types";
import { User } from "@/common/decorators/user.decorator";

@Controller("projects")
@UseGuards(AuthGuard("jwt"))
export class ProjectsController {
  constructor(private readonly projectsService: ProjectsService) {}

  @Get()
  async getProjects(@User() user: AuthUser, @Query() query: GetProjectsQueryDto) {
    return this.projectsService.getProjects(user.userId, query);
  }

  @Get("tags")
  async getTags() {
    return this.projectsService.getTags();
  }
}
