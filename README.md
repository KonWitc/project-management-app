# Project Management App

## Dev quickstart
- Backend: `cd apps && cd api && cp .env.example .env && pnpm i && pnpm start:dev`
- Frontend: `cd apps && cd app && dart pub get && flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000`

## Environments
- dev: lokalnie
- staging / prod: patrz `/deploy` i `docker-compose.*.yml`