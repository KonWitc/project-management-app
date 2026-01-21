import 'package:app/core/routing/app_routes.dart';
import 'package:go_router/go_router.dart';

class NavigationService {
  NavigationService(this._router);

  final GoRouter _router;

  // ── General Methods ──────────────────────────────────────────────

  void go(String location) => _router.go(location);

  Future<T?> push<T>(String location) => _router.push<T>(location);

  void replace(String location) => _router.replace(location);

  void pop<T extends Object?>([T? result]) => _router.pop(result);

  // ── Methods for specific routes ────────────────────────────────

  void goToLogin() => _router.pushNamed(AppRouteNames.login);

  void goToProjects() => _router.pushNamed(AppRouteNames.projects);
  
  void goToProjectDetails(String id) =>
      _router.pushNamed(AppRouteNames.projectDetails, pathParameters: {'id': id});
}
