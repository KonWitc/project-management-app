class AuthState {
  final bool isAuthenticated;
  final Map<String, dynamic>? user;
  final String? errorMessage;

  const AuthState._({
    required this.isAuthenticated,
    this.user,
    this.errorMessage,
  });

  const AuthState.unauthenticated()
      : this._(isAuthenticated: false);

  const AuthState.authenticated(Map<String, dynamic> user)
      : this._(isAuthenticated: true, user: user);

  AuthState copyWith({
    bool? isAuthenticated,
    Map<String, dynamic>? user,
    String? errorMessage,
  }) {
    return AuthState._(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}