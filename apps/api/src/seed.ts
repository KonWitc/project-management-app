// src/seed.ts

import "dotenv/config";
import { NestFactory } from "@nestjs/core";
import { AppModule } from "./app.module";
import * as argon2 from "argon2";

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

  // Generate fresh password hash for "Password123!"
  const passwordHash = await argon2.hash("Password123!");

  const [admin, manager, worker, testUser] = await userModel.insertMany([
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
    {
      email: "test@example.com",
      passwordHash,
      emailVerified: true,
      roles: [AppRole.USER],
      profile: {
        displayName: "Test User",
        username: "test.user",
        jobTitle: "Developer",
      },
    },
  ]);

  console.log("🌱 Seeding projects...");

  const [windProject, solarProject, mobileApp, dataProject, infraProject, securityProject, apiProject, documentationProject] = await projectModel.insertMany([
    {
      name: "Wind Farm Alpha",
      description: "Development of a 50MW onshore wind farm.",
      status: "active",
      ownerId: manager._id,
      memberIds: [manager._id, worker._id, testUser._id],
      tags: ["wind", "energy"],
      startDate: new Date("2024-01-10"),
      deadline: new Date("2025-06-30"),
    },
    {
      name: "Solar Plant Beta",
      description: "Utility-scale solar power plant.",
      status: "draft",
      ownerId: admin._id,
      memberIds: [admin._id, worker._id, testUser._id],
      tags: ["solar", "pv"],
      startDate: new Date("2024-04-15"),
    },
    {
      name: "Mobile App Redesign",
      description: "Complete redesign of the mobile application with new UI/UX.",
      status: "active",
      ownerId: testUser._id,
      memberIds: [testUser._id, manager._id, worker._id],
      tags: ["mobile", "ui", "redesign"],
      startDate: new Date("2024-06-01"),
      deadline: new Date("2025-03-15"),
    },
    {
      name: "Data Analytics Dashboard",
      description: "Build a comprehensive analytics dashboard for energy metrics.",
      status: "active",
      ownerId: manager._id,
      memberIds: [manager._id, testUser._id, worker._id],
      tags: ["analytics", "dashboard"],
      startDate: new Date("2024-08-01"),
      deadline: new Date("2025-04-30"),
    },
    {
      name: "Infrastructure Modernization",
      description: "Upgrade legacy infrastructure to cloud-native architecture.",
      status: "active",
      ownerId: admin._id,
      memberIds: [admin._id, manager._id, worker._id],
      tags: ["infrastructure", "cloud", "devops"],
      startDate: new Date("2024-03-01"),
      deadline: new Date("2025-09-30"),
    },
    {
      name: "Security Audit & Compliance",
      description: "Comprehensive security review and compliance certification.",
      status: "active",
      ownerId: admin._id,
      memberIds: [admin._id, manager._id],
      tags: ["security", "compliance", "audit"],
      startDate: new Date("2024-07-01"),
      deadline: new Date("2025-01-31"),
    },
    {
      name: "API Gateway Implementation",
      description: "Design and implement centralized API gateway for microservices.",
      status: "active",
      ownerId: worker._id,
      memberIds: [worker._id, manager._id, testUser._id],
      tags: ["api", "backend", "microservices"],
      startDate: new Date("2024-09-01"),
      deadline: new Date("2025-05-15"),
    },
    {
      name: "Documentation Portal",
      description: "Create comprehensive documentation portal for all projects.",
      status: "completed",
      ownerId: manager._id,
      memberIds: [manager._id, worker._id, testUser._id],
      tags: ["documentation", "knowledge-base"],
      startDate: new Date("2024-02-01"),
      deadline: new Date("2024-12-31"),
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

  const now = new Date();
  const yesterday = new Date(now.getTime() - 24 * 60 * 60 * 1000);
  const tomorrow = new Date(now.getTime() + 24 * 60 * 60 * 1000);
  const nextWeek = new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000);
  const lastWeek = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

  await taskModel.insertMany([
    // Original tasks
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

    // Tasks for test user - Mobile App project
    {
      title: "Design new navigation flow",
      description: "Create wireframes for the new navigation structure.",
      projectId: mobileApp._id,
      assigneeId: testUser._id,
      reporterId: manager._id,
      status: TaskStatus.COMPLETED,
      priority: TaskPriority.HIGH,
      tags: ["design", "ux"],
      estimateHours: 8,
      loggedHours: 10,
      dueDate: lastWeek,
    },
    {
      title: "Implement home screen redesign",
      description: "Build the new home screen based on approved designs.",
      projectId: mobileApp._id,
      assigneeId: testUser._id,
      reporterId: manager._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.HIGH,
      tags: ["development", "ui"],
      estimateHours: 16,
      loggedHours: 6,
      dueDate: nextWeek,
    },
    {
      title: "Fix login screen animation",
      description: "The loading animation stutters on older devices.",
      projectId: mobileApp._id,
      assigneeId: testUser._id,
      reporterId: worker._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.MEDIUM,
      tags: ["bug", "animation"],
      estimateHours: 4,
      loggedHours: 0,
      dueDate: tomorrow,
    },
    {
      title: "Update onboarding flow",
      description: "Simplify the user onboarding experience.",
      projectId: mobileApp._id,
      assigneeId: testUser._id,
      reporterId: manager._id,
      status: TaskStatus.BLOCKED,
      priority: TaskPriority.MEDIUM,
      tags: ["ux", "onboarding"],
      estimateHours: 12,
      loggedHours: 2,
      dueDate: nextWeek,
    },

    // Tasks for test user - Data Analytics project
    {
      title: "Setup chart library",
      description: "Integrate and configure the charting library.",
      projectId: dataProject._id,
      assigneeId: testUser._id,
      reporterId: manager._id,
      status: TaskStatus.COMPLETED,
      priority: TaskPriority.HIGH,
      tags: ["setup", "charts"],
      estimateHours: 6,
      loggedHours: 5,
    },
    {
      title: "Build energy consumption chart",
      description: "Create interactive chart for energy consumption data.",
      projectId: dataProject._id,
      assigneeId: testUser._id,
      reporterId: manager._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.HIGH,
      tags: ["charts", "development"],
      estimateHours: 10,
      loggedHours: 4,
      dueDate: tomorrow,
    },
    {
      title: "Implement data export feature",
      description: "Allow users to export dashboard data to CSV/PDF.",
      projectId: dataProject._id,
      assigneeId: testUser._id,
      reporterId: admin._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.LOW,
      tags: ["export", "feature"],
      estimateHours: 8,
      loggedHours: 0,
      dueDate: nextWeek,
    },

    // Tasks for test user - Wind Farm project
    {
      title: "Review wind speed data",
      description: "Analyze historical wind speed measurements for site.",
      projectId: windProject._id,
      assigneeId: testUser._id,
      reporterId: manager._id,
      milestoneId: permitsMs._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.CRITICAL,
      tags: ["analysis", "data"],
      estimateHours: 20,
      loggedHours: 12,
      dueDate: yesterday, // Overdue!
    },
    {
      title: "Prepare investor presentation",
      description: "Create slides for upcoming investor meeting.",
      projectId: windProject._id,
      assigneeId: testUser._id,
      reporterId: manager._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.CRITICAL,
      tags: ["presentation"],
      estimateHours: 6,
      loggedHours: 0,
      dueDate: tomorrow,
    },

    // General task for test user
    {
      title: "Complete timesheet",
      description: "Fill in missing hours from last week.",
      projectId: mobileApp._id,
      assigneeId: testUser._id,
      reporterId: admin._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.LOW,
      tags: ["admin"],
      dueDate: tomorrow,
    },

    // =====================================================
    // Tasks for Admin user
    // =====================================================
    {
      title: "Review system architecture",
      description: "Comprehensive review of current system architecture and propose improvements.",
      projectId: infraProject._id,
      assigneeId: admin._id,
      reporterId: admin._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.CRITICAL,
      tags: ["architecture", "review"],
      estimateHours: 40,
      loggedHours: 25,
      dueDate: nextWeek,
    },
    {
      title: "Setup monitoring dashboards",
      description: "Configure Grafana dashboards for infrastructure monitoring.",
      projectId: infraProject._id,
      assigneeId: admin._id,
      reporterId: manager._id,
      status: TaskStatus.COMPLETED,
      priority: TaskPriority.HIGH,
      tags: ["monitoring", "grafana"],
      estimateHours: 16,
      loggedHours: 14,
    },
    {
      title: "Kubernetes cluster upgrade",
      description: "Upgrade production Kubernetes cluster to latest stable version.",
      projectId: infraProject._id,
      assigneeId: admin._id,
      reporterId: admin._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.HIGH,
      tags: ["kubernetes", "upgrade"],
      estimateHours: 24,
      loggedHours: 0,
      dueDate: nextWeek,
    },
    {
      title: "Security vulnerability assessment",
      description: "Run comprehensive security scans and document findings.",
      projectId: securityProject._id,
      assigneeId: admin._id,
      reporterId: admin._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.CRITICAL,
      tags: ["security", "scanning"],
      estimateHours: 32,
      loggedHours: 20,
      dueDate: tomorrow,
    },
    {
      title: "Implement SSO integration",
      description: "Setup Single Sign-On with corporate identity provider.",
      projectId: securityProject._id,
      assigneeId: admin._id,
      reporterId: manager._id,
      status: TaskStatus.BLOCKED,
      priority: TaskPriority.HIGH,
      tags: ["sso", "authentication"],
      estimateHours: 20,
      loggedHours: 8,
      dueDate: nextWeek,
    },
    {
      title: "Backup strategy review",
      description: "Review and update disaster recovery and backup procedures.",
      projectId: infraProject._id,
      assigneeId: admin._id,
      reporterId: admin._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.MEDIUM,
      tags: ["backup", "disaster-recovery"],
      estimateHours: 12,
      loggedHours: 0,
    },
    {
      title: "Solar plant network design",
      description: "Design network infrastructure for new solar plant facility.",
      projectId: solarProject._id,
      assigneeId: admin._id,
      reporterId: manager._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.HIGH,
      tags: ["network", "infrastructure"],
      estimateHours: 16,
      loggedHours: 6,
      dueDate: nextWeek,
    },

    // =====================================================
    // Tasks for Manager user
    // =====================================================
    {
      title: "Q1 budget planning",
      description: "Prepare budget proposals for all Q1 projects.",
      projectId: windProject._id,
      assigneeId: manager._id,
      reporterId: admin._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.CRITICAL,
      tags: ["budget", "planning"],
      estimateHours: 24,
      loggedHours: 18,
      dueDate: yesterday, // Overdue!
    },
    {
      title: "Stakeholder meeting preparation",
      description: "Prepare presentation and agenda for monthly stakeholder meeting.",
      projectId: windProject._id,
      assigneeId: manager._id,
      reporterId: admin._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.HIGH,
      tags: ["meeting", "stakeholders"],
      estimateHours: 8,
      loggedHours: 0,
      dueDate: tomorrow,
    },
    {
      title: "Team performance reviews",
      description: "Complete quarterly performance reviews for team members.",
      projectId: dataProject._id,
      assigneeId: manager._id,
      reporterId: admin._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.MEDIUM,
      tags: ["hr", "reviews"],
      estimateHours: 16,
      loggedHours: 10,
      dueDate: nextWeek,
    },
    {
      title: "Resource allocation optimization",
      description: "Review and optimize resource allocation across projects.",
      projectId: dataProject._id,
      assigneeId: manager._id,
      reporterId: admin._id,
      status: TaskStatus.COMPLETED,
      priority: TaskPriority.HIGH,
      tags: ["resources", "optimization"],
      estimateHours: 12,
      loggedHours: 14,
    },
    {
      title: "Vendor contract negotiations",
      description: "Negotiate contracts with key technology vendors.",
      projectId: infraProject._id,
      assigneeId: manager._id,
      reporterId: admin._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.HIGH,
      tags: ["vendor", "contracts"],
      estimateHours: 20,
      loggedHours: 8,
      dueDate: nextWeek,
    },
    {
      title: "Security compliance documentation",
      description: "Prepare documentation for ISO 27001 compliance audit.",
      projectId: securityProject._id,
      assigneeId: manager._id,
      reporterId: admin._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.CRITICAL,
      tags: ["compliance", "iso27001"],
      estimateHours: 40,
      loggedHours: 0,
      dueDate: nextWeek,
    },
    {
      title: "Mobile app sprint planning",
      description: "Plan next sprint for mobile app development team.",
      projectId: mobileApp._id,
      assigneeId: manager._id,
      reporterId: testUser._id,
      status: TaskStatus.COMPLETED,
      priority: TaskPriority.HIGH,
      tags: ["sprint", "planning"],
      estimateHours: 4,
      loggedHours: 3,
    },
    {
      title: "Risk assessment update",
      description: "Update project risk register and mitigation strategies.",
      projectId: windProject._id,
      assigneeId: manager._id,
      reporterId: admin._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.MEDIUM,
      tags: ["risk", "assessment"],
      estimateHours: 8,
      loggedHours: 0,
    },

    // =====================================================
    // Tasks for Worker user
    // =====================================================
    {
      title: "Implement authentication middleware",
      description: "Build JWT authentication middleware for API gateway.",
      projectId: apiProject._id,
      assigneeId: worker._id,
      reporterId: manager._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.CRITICAL,
      tags: ["authentication", "jwt", "middleware"],
      estimateHours: 24,
      loggedHours: 16,
      dueDate: tomorrow,
    },
    {
      title: "Rate limiting implementation",
      description: "Implement rate limiting for API endpoints.",
      projectId: apiProject._id,
      assigneeId: worker._id,
      reporterId: manager._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.HIGH,
      tags: ["rate-limiting", "api"],
      estimateHours: 12,
      loggedHours: 0,
      dueDate: nextWeek,
    },
    {
      title: "API documentation",
      description: "Create OpenAPI/Swagger documentation for all endpoints.",
      projectId: apiProject._id,
      assigneeId: worker._id,
      reporterId: manager._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.MEDIUM,
      tags: ["documentation", "swagger"],
      estimateHours: 16,
      loggedHours: 8,
      dueDate: nextWeek,
    },
    {
      title: "Database optimization",
      description: "Optimize database queries and add missing indexes.",
      projectId: dataProject._id,
      assigneeId: worker._id,
      reporterId: manager._id,
      status: TaskStatus.COMPLETED,
      priority: TaskPriority.HIGH,
      tags: ["database", "optimization"],
      estimateHours: 20,
      loggedHours: 18,
    },
    {
      title: "Unit test coverage improvement",
      description: "Increase unit test coverage to 80% for core modules.",
      projectId: apiProject._id,
      assigneeId: worker._id,
      reporterId: testUser._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.MEDIUM,
      tags: ["testing", "coverage"],
      estimateHours: 32,
      loggedHours: 12,
      dueDate: nextWeek,
    },
    {
      title: "CI/CD pipeline setup",
      description: "Configure automated deployment pipeline for API services.",
      projectId: infraProject._id,
      assigneeId: worker._id,
      reporterId: admin._id,
      status: TaskStatus.COMPLETED,
      priority: TaskPriority.HIGH,
      tags: ["cicd", "devops"],
      estimateHours: 16,
      loggedHours: 20,
    },
    {
      title: "Performance benchmarking",
      description: "Run performance benchmarks and identify bottlenecks.",
      projectId: apiProject._id,
      assigneeId: worker._id,
      reporterId: manager._id,
      status: TaskStatus.NOT_STARTED,
      priority: TaskPriority.MEDIUM,
      tags: ["performance", "benchmarking"],
      estimateHours: 12,
      loggedHours: 0,
    },
    {
      title: "Mobile app API integration",
      description: "Integrate new API endpoints with mobile application.",
      projectId: mobileApp._id,
      assigneeId: worker._id,
      reporterId: testUser._id,
      status: TaskStatus.IN_PROGRESS,
      priority: TaskPriority.HIGH,
      tags: ["integration", "mobile"],
      estimateHours: 20,
      loggedHours: 14,
      dueDate: nextWeek,
    },
    {
      title: "Documentation portal styling",
      description: "Apply corporate branding to documentation portal.",
      projectId: documentationProject._id,
      assigneeId: worker._id,
      reporterId: manager._id,
      status: TaskStatus.COMPLETED,
      priority: TaskPriority.LOW,
      tags: ["styling", "branding"],
      estimateHours: 8,
      loggedHours: 6,
    },
    {
      title: "Solar monitoring integration",
      description: "Integrate solar panel monitoring sensors with data platform.",
      projectId: solarProject._id,
      assigneeId: worker._id,
      reporterId: admin._id,
      status: TaskStatus.BLOCKED,
      priority: TaskPriority.HIGH,
      tags: ["integration", "sensors"],
      estimateHours: 24,
      loggedHours: 4,
      dueDate: yesterday, // Overdue!
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
