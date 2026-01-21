// src/milestones/milestones.module.ts
import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { Milestone, MilestoneSchema } from "./milestone.schema";
import { Task, TaskSchema } from "../../tasks/task.schema";
import { MilestonesController } from "./milestone.controller";
import { MilestonesService } from "./milestone.service";

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Milestone.name, schema: MilestoneSchema },
      { name: Task.name, schema: TaskSchema },
    ]),
  ],
  controllers: [MilestonesController],
  providers: [MilestonesService],
  exports: [MongooseModule, MilestonesService],
})
export class MilestonesModule {}
