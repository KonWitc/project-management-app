import { Module } from "@nestjs/common";
import { ProjectsService } from "./projects.service";
import { ProjectsController } from "./projects.controller";
import { JwtAccessStrategy } from "../../common/strategies/jwt-access.strategy";
import { JwtRefreshStrategy } from "../../common/strategies/jwt-refresh.strategy";
import { MongooseModule } from "@nestjs/mongoose";
import { Milestone, MilestoneSchema } from "./milestones/milestone.schema";
import { Task, TaskSchema } from "../tasks/task.schema";
import { Project, ProjectSchema } from "./project.schema";

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Project.name, schema: ProjectSchema },
      { name: Task.name, schema: TaskSchema },
      { name: Milestone.name, schema: MilestoneSchema },
    ]),
  ],
  providers: [ProjectsService, JwtAccessStrategy, JwtRefreshStrategy],
  controllers: [ProjectsController],
  exports: [ProjectsService],
})
export class ProjectsModule {}
