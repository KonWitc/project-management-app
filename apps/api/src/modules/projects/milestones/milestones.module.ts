// src/milestones/milestones.module.ts
import { Module } from "@nestjs/common";
import { MongooseModule } from "@nestjs/mongoose";
import { Milestone, MilestoneSchema } from "./milestone.schema";

@Module({
  imports: [MongooseModule.forFeature([{ name: Milestone.name, schema: MilestoneSchema }])],
  exports: [MongooseModule],
})
export class MilestonesModule {}
