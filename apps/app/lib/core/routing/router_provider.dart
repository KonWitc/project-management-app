import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/routing/router_notifier.dart';
import 'package:app/core/widgets/app_shell.dart';
import 'package:app/features/auth/auth_providers.dart';
import 'package:app/features/auth/pages/login_screen.dart';
import 'package:app/features/my_work/presentation/pages/my_work_screen.dart';
import 'package:app/features/projects/presentation/pages/milestone_screen.dart';
import 'package:app/features/projects/presentation/pages/project_details_screen.dart';
import 'package:app/features/projects/presentation/pages/projects_screen.dart';
import 'package:app/features/tasks/presentation/pages/task_details_screen.dart';
import 'package:app/features/tasks/presentation/pages/tasks_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: routerNotifier,

    routes: [
      GoRoute(
        path: AppRoutePaths.login,
        name: AppRouteNames.login,
        builder: (_, __) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutePaths.projects,
            name: AppRouteNames.projects,
            builder: (_, __) => const ProjectsScreen(),
            routes: [
              GoRoute(
                path: AppRoutePaths.projectDetails, // /projects/:id
                name: AppRouteNames.projectDetails,
                builder: (_, state) {
                  final id = state.pathParameters['id']!;
                  return ProjectDetailsScreen(projectId: id);
                },
              ),
              // GoRoute(
              //   path: AppRoutePaths.themePreview,
              //   name: AppRouteNames.themePreview,
              //   builder: (_, __) => const ThemePreviewPage(),
              // ),
            ],
          ),
          GoRoute(
            path: AppRoutePaths.projectMilestones,
            name: AppRouteNames.projectMilestones,
            builder: (_, state) {
              final id = state.pathParameters['id']!;
              return MilestonesPage(projectId: id);
            },
          ),
          GoRoute(
            path: AppRoutePaths.projectTasks,
            name: AppRouteNames.projectTasks,
            builder: (_, state) {
              final projectId = state.pathParameters['id']!;
              return TasksScreen(projectId: projectId);
              // final id = state.pathParameters['id']!;
              // return MilestonesPage(projectId: id);
            },
          ),
          GoRoute(
            path: AppRoutePaths.myWork,
            name: AppRouteNames.myWork,
            builder: (_, __) => const MyWorkScreen(),
          ),
          GoRoute(
            path: AppRoutePaths.taskDetails,
            name: AppRouteNames.taskDetails,
            builder: (_, state) {
              final taskId = state.pathParameters['taskId']!;
              return TaskDetailsScreen(taskId: taskId);
            },
          ),
        ],
      ),
    ],

    redirect: (context, state) {
      final authState = ref.read(authProvider).value;
      final loggedIn = authState?.isAuthenticated ?? false;
      final isLoggingIn = state.matchedLocation == AppRoutePaths.login;

      if (!loggedIn && !isLoggingIn) return AppRoutePaths.login;
      if (loggedIn && isLoggingIn) return AppRoutePaths.projects;

      return null;
    },
  );
});
