A full-stack project management application with a **NestJS** backend API and a **Flutter** multi-platform frontend. Manage projects, tasks, and milestones with role-based access control and JWT authentication.

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend | NestJS, TypeScript, MongoDB (Mongoose) |
| Frontend | Flutter (Dart), Riverpod, go_router |
| Auth | JWT (access + refresh tokens), Argon2, Passport.js |
| DevOps | Docker, pnpm, Turbo |

## Features

- **Authentication** -- Sign up, sign in, JWT access/refresh token flow, role-based access (User, Manager, Admin)
- **Projects** -- Create and browse projects with filtering by status, tags, and deadlines; statuses: draft, active, completed, archived
- **Tasks** -- Full CRUD with priority levels (low/medium/high/critical), status tracking, assignees, due dates, time estimates, and kanban ordering
- **Milestones** -- Track project milestones with progress percentage, status, and task linking
- **Comments** -- Add, edit, and delete comments on tasks
- **My Work** -- Personal dashboard showing tasks assigned to you (grouped by project) and your projects with summary statistics
- **Multi-platform** -- Flutter frontend runs on Web, iOS, Android, macOS, Linux, and Windows

## Project Structure

```
.
├── apps/
│   ├── api/             # NestJS backend
│   │   ├── src/
│   │   │   ├── common/      # Guards, decorators, strategies
│   │   │   ├── config/      # App configuration & validation
│   │   │   ├── modules/
│   │   │   │   ├── auth/        # Authentication module
│   │   │   │   ├── comments/    # Task comments
│   │   │   │   ├── projects/    # Projects + milestones
│   │   │   │   └── tasks/       # Task management
│   │   │   └── users/       # User schema & service
│   │   ├── test/            # E2E tests
│   │   ├── docker-compose.yml
│   │   └── .env.example
│   └── app/             # Flutter frontend
│       ├── lib/
│       │   ├── core/        # Theme, routing, shared widgets
│       │   ├── features/
│       │   │   ├── auth/        # Login / signup screens
│       │   │   ├── comments/    # Task comments
│       │   │   ├── my_work/     # Personal dashboard
│       │   │   ├── projects/    # Project list & details
│       │   │   └── tasks/       # Task views
│       │   └── network/     # Dio HTTP client setup
│       └── pubspec.yaml
├── tools/
│   └── dev.mjs          # Dev environment orchestration
└── package.json         # Root workspace scripts
```

## Prerequisites

- **Node.js** >= 18
- **pnpm** >= 9.15.4
- **Docker** (for MongoDB)
- **Flutter SDK** >= 3.8 (Dart >= 3.8.1)

## Getting Started

### 1. Clone and install dependencies

```bash
git clone <repository-url>
cd project-management-app
pnpm install
```

### 2. Start MongoDB

```bash
cd apps/api
docker-compose up -d
```

This starts a MongoDB 7 instance on port `27017`.

### 3. Configure environment variables

```bash
cp apps/api/.env.example apps/api/.env
```

Edit `apps/api/.env` and set your JWT secrets:

```env
# Server
PORT=4000
GLOBAL_PREFIX=api
API_VERSION=1
CLIENT_ORIGIN=http://localhost:3000
CORS_ORIGINS=http://localhost:5173,http://localhost:5500,http://localhost:8080
COOKIE_DOMAIN=localhost
NODE_ENV=development

# Database
MONGO_URI=mongodb://localhost:27017/project_management

# JWT (tokens)
JWT_ACCESS_SECRET=your_access_secret_here
JWT_REFRESH_SECRET=your_refresh_secret_here
ACCESS_EXPIRES=900          # 15 minutes (in seconds)
REFRESH_EXPIRES=604800      # 7 days (in seconds)
```

> **Note:** When using `npm run dev`, the dev script overrides `PORT` to **3000** regardless of what is set in `.env`.

### 4. Run the full dev environment

From the project root:

```bash
npm run dev
```

This starts both the API and Flutter web app concurrently:

| Service | URL |
|---------|-----|
| API | http://localhost:3000 |
| Flutter Web | http://localhost:5173 |

#### Or start services individually

**Backend only:**

```bash
cd apps/api
pnpm start:dev
```

**Frontend only:**

```bash
cd apps/app
dart pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

### 5. Seed the database (optional)

```bash
cd apps/api
pnpm seed
```

## API Reference

All endpoints are prefixed with `/api`. Authentication is required unless noted otherwise.

### Auth

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Register a new user |
| POST | `/api/auth/signin` | Log in and receive tokens |
| GET | `/api/auth/me` | Get current user profile |
| POST | `/api/auth/refresh` | Refresh access token |
| POST | `/api/auth/logout` | Log out and clear tokens |
| GET | `/api/auth/ping` | Health check (no auth) |

### Projects

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/projects` | List projects (paginated, filterable) |
| GET | `/api/projects/:id` | Get project details |
| GET | `/api/projects/tags` | Get available project tags |

**Query params for listing:** `page`, `limit`, `sortBy`, `sortDir`, `search`, `status`, `tags`, `deadlineFrom`, `deadlineTo`

### Tasks

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/tasks` | Create a task |
| GET | `/api/tasks` | List tasks (paginated, filterable) |
| GET | `/api/tasks/:id` | Get task details |
| PUT | `/api/tasks/:id` | Update a task |
| DELETE | `/api/tasks/:id` | Delete a task |
| GET | `/api/tasks/tags` | Get available task tags |
| GET | `/api/tasks/types` | Get available task types |

**Query params for listing:** `page`, `limit`, `sortBy`, `sortOrder`, `search`, `projectId`, `milestoneId`, `assigneeId`, `reporterId`, `status`, `priority`, `tags`, `taskType`

### Milestones

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/projects/:projectId/milestones` | Create a milestone |
| GET | `/api/projects/:projectId/milestones` | List milestones for a project |
| GET | `/api/projects/:projectId/milestones/:id` | Get milestone details |
| PATCH | `/api/projects/:projectId/milestones/:id` | Update a milestone |
| DELETE | `/api/projects/:projectId/milestones/:id` | Delete a milestone (soft delete) |
| POST | `/api/projects/:projectId/milestones/:id/calculate-progress` | Recalculate progress from tasks |
| POST | `/api/projects/:projectId/milestones/:id/tasks/:taskId/link` | Link a task to a milestone |
| DELETE | `/api/projects/:projectId/milestones/:id/tasks/:taskId/unlink` | Unlink a task from a milestone |
| GET | `/api/projects/:projectId/milestones/:id/tasks` | Get tasks for a milestone |

### Comments

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/tasks/:taskId/comments` | Add a comment to a task |
| GET | `/api/tasks/:taskId/comments` | List comments for a task |
| PUT | `/api/tasks/:taskId/comments/:id` | Update a comment |
| DELETE | `/api/tasks/:taskId/comments/:id` | Delete a comment |

## Testing

### Backend

```bash
cd apps/api

pnpm test              # Unit tests
pnpm test:watch        # Watch mode
pnpm test:cov          # With coverage report
pnpm test:e2e          # End-to-end tests
```

### Frontend

```bash
cd apps/app
flutter test
```

## Code Quality

```bash
cd apps/api

pnpm lint              # ESLint with auto-fix
pnpm format            # Prettier formatting
```

The project has **Husky** and **lint-staged** configured in `apps/api/package.json` for pre-commit hooks. Run `pnpm prepare` inside `apps/api` to initialize the git hooks.

## License

This project is private and not licensed for public distribution.