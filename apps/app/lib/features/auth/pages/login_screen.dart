import 'package:app/core/routing/navigation_service_provider.dart';
import 'package:app/core/widgets/app_scaffold.dart';
import 'package:app/features/auth/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // final _formKey = GlobalKey<FormState>();
  // final _email = TextEditingController(text: 'test@example.com');
  // final _pass = TextEditingController(text: 'password123');

  // bool _obscurePassword = true;

  // @override
  // void dispose() {
  //   _email.dispose();
  //   _pass.dispose();
  //   super.dispose();
  // }

  // Future<void> _handleSignIn() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   await ref
  //       .read(authProvider.notifier)
  //       .signIn(_email.text.trim(), _pass.text);
  // }

  // Future<void> _handleSignUp() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   await ref
  //       .read(authProvider.notifier)
  //       .signUp(_email.text.trim(), _pass.text);
  //   // GoRouter will redirect
  // }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authProvider);

    ref.listen(authProvider, (prev, next) {
      final prevLoggedIn = prev?.value?.isAuthenticated ?? false;
      final nextLoggedIn = next.value?.isAuthenticated ?? false;

      if (!prevLoggedIn && nextLoggedIn) {
        ref.read(navigationServiceProvider).goToProjects();
      }
    });

    final isLoading = authAsync.isLoading;
    final hasError = authAsync.hasError;
    final error = authAsync.error;

    final emailController = TextEditingController(text: 'test@example.com');
    final passwordController = TextEditingController(text: 'Password123!');

    return AppScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  const SizedBox(height: 16),
                  if (hasError)
                    Text(
                      'Login error $error',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();
                              ref
                                  .read(authProvider.notifier)
                                  .signIn(email, password);
                            },
                      child: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Sign in'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
