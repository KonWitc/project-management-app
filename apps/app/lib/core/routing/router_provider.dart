import 'package:app/core/routing/app_routes.dart';
import 'package:app/core/routing/router_notifier.dart';
import 'package:app/core/widgets/app_shell.dart';
import 'package:app/features/auth/auth_providers.dart';
import 'package:app/features/auth/pages/login_screen.dart';
import 'package:app/features/projects/presentation/pages/project_details_screen.dart';
import 'package:app/features/projects/presentation/pages/projects_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider).value;
  final loggedIn = authState?.isAuthenticated ?? false;

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
          ),
          GoRoute(
            path: AppRoutePaths.projectDetails,
            name: AppRouteNames.projectDetails,
            builder: (_, state) {
              print(state.pathParameters);
              final id = state.pathParameters['id']!;
              return ProjectDetailsScreen(projectId: id);
            },
          ),
        ],
      ),
    ],

    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == AppRoutePaths.login;

      if (!loggedIn && !isLoggingIn) return AppRoutePaths.login;
      if (loggedIn && isLoggingIn) return AppRoutePaths.projects;

      return null;
    },
  );
});
