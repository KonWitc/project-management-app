// src/seed.ts

import "dotenv/config";
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";

import { Connection, Model, Schema } from "mongoose";

// Schemas
import { User, UserSchema, AppRole, UserDocument } from "./users/user.schema";
import { Project, ProjectSchema } from "./modules/projects/project.schema";
import { Task, TaskSchema, TaskPriority, TaskStatus } from "./modules/tasks/task.schema";
import {
  Milestone,
  MilestoneSchema,
  MilestoneStatus,
} from "./modules/projects/milestones/milestone.schema";
import { getConnectionToken } from "@nestjs/mongoose";

function getTypedModel<T>(connection: Connection, name: string, schema: Schema): Model<T> {
  return connection.model(name, schema) as Model<T>;
}

async function bootstrap() {
  const app = await NestFactory.createApplicationContext(AppModule);

  const connection = app.get<Connection>(getConnectionToken());

  const userModel = getTypedModel<UserDocument>(connection, User.name, UserSchema);
  const projectModel = getTypedModel<Project>(connection, Project.name, ProjectSchema);
  const taskModel = getTypedModel<Task>(connection, Task.name, TaskSchema);
  const milestoneModel = getTypedModel<Milestone>(connection, Milestone.name, MilestoneSchema);

  console.log("🔄 Clearing collections...");
  await userModel.deleteMany({});
  await projectModel.deleteMany({});
  await taskModel.deleteMany({});
  await milestoneModel.deleteMany({});

  console.log("🌱 Seeding users...");

  // "Password123!"
  const passwordHash =
    "$argon2id$v=19$m=65536,t=3,p=4$P0Z1m0bZA4P1Tq8yL4Jk0g$KZk6oJpd6r5rOpV+0S4x5p62UpLhB6hJgHn3qkNLZiA";

  const [admin, manager, worker] = await userModel.insertMany([
    {
      email: "admin@example.com",
      passwordHash,
      emailVerified: true,
      roles: [AppRole.ADMIN],
      profile: {
        displayName: "System Admin",
        username: "admin",
        jobTitle: "Administrator",
      },
    },
    {
      email: "manager@example.com",
      passwordHash,
      emailVerified: true,
      roles: [AppRole.MANAGER],
      profile: {
        displayName: "Anna Manager",
        username: "anna.manager",
        jobTitle: "Project Manager",
      },
    },
    {
      email: "user@example.com",
      passwordHash,
      emailVerified: true,
      roles: [AppRole.USER],
      profile: {
        displayName: "John Worker",
        username: "john.worker",
        jobTitle: "Engineer",
      },
    },
  ]);

  console.log("🌱 Seeding projects...");

  const [windProject, solarProject] = await projectModel.insertMany([
    {
      name: "Wind Farm Alpha",
      description: "Development of a 50MW onshore wind farm.",
      status: "active",
      ownerId: manager._id,
      memberIds: [manager._id, worker._id],
      tags: ["wind", "energy"],
      startDate: new Date("2024-01-10"),
      deadline: new Date("2025-06-30"),
    },
    {
      name: "Solar Plant Beta",
      description: "Utility-scale solar power plant.",
      status: "draft",
      ownerId: admin._id,
      memberIds: [worker._id],
      tags: ["solar", "pv"],
      startDate: new Date("2024-04-15"),
    },
  ]);

  console.log("🌱 Seeding milestones...");

  const [permitsMs, constructionMs, designMs] = await milestoneModel.insertMany([
    {
      projectId: windProject._id,
      name: "Permits & site approvals",
      description: "All environmental and construction permits submitted.",
      status: MilestoneStatus.IN_PROGRESS,
      dueDate: new Date("2025-02-28"),
      progress: 40,
      tags: ["permits", "environment"],
    },
    {
      projectId: windProject._id,
      name: "Construction ready",
      description: "Site prepared and contractor procured.",
      status: MilestoneStatus.NOT_STARTED,
      dueDate: new Date("2025-06-01"),
      progress: 0,
      tags: ["construction"],
    },
    {
      projectId: solarProject._id,
      name: "Design & procurement completed",
      description: "Technical design frozen and main equipment ordered.",
      status: MilestoneStatus.NOT_STARTED,
      dueDate: new Date("2025-03-31"),
      progress: 0,
      tags: ["design", "procurement"],
    },
  ]);

  console.log("🌱 Seeding tasks...");

  await taskModel.insertMany([
    {
      title: "Site analysis",
      description: "Initial feasibility study for wind farm location.",
      projectId: windProject._id,
      assigneeId: worker._id,
      reporterId: manager._id,
      milestoneId: permitsMs._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.HIGH,
      tags: ["analysis"],
      startDate: new Date("2024-01-15"),
    },
    {
      title: "Environmental permit application",
      description: "Prepare and submit environmental impact assessment.",
      projectId: windProject._id,
      assigneeId: manager._id,
      reporterId: manager._id,
      milestoneId: permitsMs._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.CRITICAL,
      tags: ["permits"],
      dueDate: new Date("2024-12-20"),
    },
    {
      title: "Tender for EPC contractor",
      description: "Run tender and select EPC contractor for wind farm.",
      projectId: windProject._id,
      assigneeId: manager._id,
      reporterId: admin._id,
      milestoneId: constructionMs._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.HIGH,
      tags: ["tender", "contracts"],
    },
    {
      title: "Order solar panels",
      description: "Place order for main PV modules.",
      projectId: solarProject._id,
      assigneeId: worker._id,
      reporterId: admin._id,
      milestoneId: designMs._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.MEDIUM,
      tags: ["procurement"],
    },
    {
      title: "Technical documentation",
      description: "Prepare single-line diagrams and technical drawings.",
      projectId: solarProject._id,
      assigneeId: worker._id,
      reporterId: manager._id,
      milestoneId: designMs._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.HIGH,
      tags: ["design"],
    },
  ]);

  console.log("✅ Seeding completed successfully!");
  await app.close();
  process.exit(0);
}

bootstrap().catch((err) => {
  console.error("❌ Seeding error:", err);
  process.exit(1);
});
