import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:app/network/dio.dart';
import 'package:app/features/auth/auth_repository.dart';

final dioProvider = Provider<Dio>((ref) => createDio());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthState {
  final bool isAuthenticated;
  final bool busy;
  final String? lastError;
  const AuthState({
    this.isAuthenticated = false,
    this.busy = false,
    this.lastError,
  });

  AuthState copy({bool? isAuthenticated, bool? busy, String? lastError}) =>
      AuthState(
        isAuthenticated: isAuthenticated ?? this.isAuthenticated,
        busy: busy ?? this.busy,
        lastError: lastError,
      );
}

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _repo;

  @override
  AuthState build() {
    _repo = ref.read(authRepositoryProvider);
    return AuthState(isAuthenticated: _repo.isAuthenticated);
  }

  Future<void> signIn(String email, String password) async {
    state = state.copy(busy: true, lastError: null);
    try {
      await _repo.signIn(email, password);
      state = state.copy(isAuthenticated: true);
      print(state);
    } catch (e) {
      state = state.copy(lastError: 'SingIn error: $e');
    } finally {
      state = state.copy(busy: false);
    }
  }

  Future<void> signUp(String email, String password) async {
    state = state.copy(busy: true, lastError: null);
    try {
      await _repo.signUp(email, password);
      state = state.copy(isAuthenticated: true);
    } catch (e) {
      state = state.copy(lastError: 'Błąd rejestracji: $e');
    } finally {
      state = state.copy(busy: false);
    }
  }

  Future<void> logout() async {
    state = state.copy(busy: true, lastError: null);
    try {
      await _repo.logout();
      state = state.copy(isAuthenticated: false);
    } finally {
      state = state.copy(busy: false);
    }
  }

  Future<Map<String, dynamic>> me() => _repo.me();
}

final authProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);
