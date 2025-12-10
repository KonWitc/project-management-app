import 'dart:async';
import 'package:app/features/auth/data/auth_repository.dart';
import 'package:app/features/auth/domain/auth_state.dart';
import 'package:app/network/dio_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthController extends AsyncNotifier<AuthState> {
  @override
  FutureOr<AuthState> build() async {
    final repo = ref.read(authRepositoryProvider);

    try {
      final user = await repo.me();
      return AuthState.authenticated(user);
    } catch (_) {
      return const AuthState.unauthenticated();
    }
  }
  
  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();

    final repo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repo.signIn(email, password);
      final user = await repo.me();
      return AuthState.authenticated(user);
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    final repo = ref.read(authRepositoryProvider);

    state = await AsyncValue.guard(() async {
      await repo.signUp(email, password);
      final user = await repo.me();
      return AuthState.authenticated(user);
    });
  }

  Future<void> logout() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.logout();
    state = const AsyncData(AuthState.unauthenticated());
  }
}

final authProvider = AsyncNotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
