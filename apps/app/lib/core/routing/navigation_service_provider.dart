import 'package:app/core/routing/navigation_service.dart';
import 'package:app/core/routing/router_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigationServiceProvider = Provider<NavigationService>((ref) {
  final router = ref.watch(routerProvider);
  return NavigationService(router);
});
