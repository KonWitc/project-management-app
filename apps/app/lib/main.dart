import 'package:app/features/auth/auth_providers.dart';
import 'package:app/network/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return MaterialApp(
      title: 'Web-first Auth Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (_) => const LoginScreen(),
        '/home': (_) => const HomeScreen(),
      },
      initialRoute: auth.isAuthenticated ? '/home' : '/',
    );
  }
}

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _email = TextEditingController(text: 'test@example.com');
  final _pass = TextEditingController(text: 'password123');

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final authCtrl = ref.read(authProvider.notifier);

    ref.listen(authProvider, (prev, next) {
      if (prev?.isAuthenticated == false && next.isAuthenticated) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Web-first Auth Demo')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Hasło'),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: auth.busy
                          ? null
                          : () =>
                                authCtrl.signUp(_email.text.trim(), _pass.text),
                      child: const Text('Sign up'),
                    ),
                    ElevatedButton(
                      onPressed: auth.busy
                          ? null
                          : () =>
                                authCtrl.signIn(_email.text.trim(), _pass.text),
                      child: const Text('Sign in'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          final r = await createDio().get('/ping');
                          setState(() => print('Ping: ${r.data}'));
                        } catch (e) {
                          setState(() => print('Ping error: $e'));
                        }
                      },
                      child: const Text('Ping API'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (auth.busy) const CircularProgressIndicator(),
                if (auth.lastError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      auth.lastError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _me = '';
  bool _loading = false;

  Future<void> _loadMe() async {
    setState(() => _loading = true);
    try {
      final data = await ref.read(authProvider.notifier).me();
      setState(() => _me = data.toString());
    } catch (e) {
      setState(() => _me = 'Error /me: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton(
            onPressed: _loading ? null : _logout,
            child: const Text('Logout'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _loading ? null : _loadMe,
                  child: const Text('Call /me'),
                ),
                const SizedBox(height: 12),
                if (_loading) const CircularProgressIndicator(),
                if (_me.isNotEmpty)
                  Text(
                    _me,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
