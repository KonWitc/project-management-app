import 'package:app/core/routing/router_notifier.dart';
import 'package:app/core/widgets/app_shell.dart';
import 'package:app/features/auth/auth_providers.dart';
import 'package:app/features/auth/pages/login_screen.dart';
import 'package:app/features/projects/presentation/pages/projects_screen/projects_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider).value;

  final loggedIn = authState?.isAuthenticated ?? false;

  return GoRouter(
    debugLogDiagnostics: true,

    refreshListenable: ref.watch(routerNotifierProvider),

    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/projects',
            name: 'projects',
            builder: (_, __) => const ProjectsScreen(),
          ),
        ],
      ),
    ],

    redirect: (context, state) {
      final isLoggingIn = state.matchedLocation == '/login';

      if (!loggedIn && !isLoggingIn) return '/login';
      if (loggedIn) return '/projects';

      return null;
    },
  );
});
