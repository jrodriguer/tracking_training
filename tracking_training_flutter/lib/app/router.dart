import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/progress/presentation/progress_page.dart';
import '../features/routines/presentation/routines_page.dart';
import '../features/workouts/presentation/workouts_page.dart';
import '../shared/widgets/app_shell_scaffold.dart';

GoRouter buildRouter(Ref ref) {
  final notifier = _RouterNotifier(ref);
  ref.onDispose(notifier.dispose);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isOnSplash = state.uri.path == '/splash';
      final isOnAuthRoute = state.uri.path.startsWith('/auth/');

      return switch (authState) {
        AuthRestoring() => isOnSplash ? null : '/splash',
        SignedOut() => isOnAuthRoute ? null : '/auth/login',
        SignedIn() => (isOnAuthRoute || isOnSplash) ? '/routines' : null,
      };
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, _) => const _SplashPage()),
      GoRoute(path: '/', redirect: (_, _) => '/routines'),
      GoRoute(
        path: '/routines',
        pageBuilder: (context, state) => _shellPage(
          context,
          state.pageKey,
          _ShellTab.routines,
          const RoutinesPage(),
        ),
      ),
      GoRoute(
        path: '/workouts',
        pageBuilder: (context, state) => _shellPage(
          context,
          state.pageKey,
          _ShellTab.workouts,
          const WorkoutsPage(),
        ),
      ),
      GoRoute(
        path: '/progress',
        pageBuilder: (context, state) => _shellPage(
          context,
          state.pageKey,
          _ShellTab.progress,
          const ProgressPage(),
        ),
      ),
      GoRoute(path: '/auth/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/auth/register', builder: (_, _) => const RegisterPage()),
    ],
  );
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

Page<void> _shellPage(
  BuildContext context,
  LocalKey key,
  _ShellTab tab,
  Widget child,
) {
  return NoTransitionPage(
    key: key,
    child: AppShellScaffold(
      title: tab.title,
      currentIndex: tab.index,
      onDestinationSelected: (index) {
        switch (_ShellTab.values[index]) {
          case _ShellTab.routines:
            context.go('/routines');
          case _ShellTab.workouts:
            context.go('/workouts');
          case _ShellTab.progress:
            context.go('/progress');
        }
      },
      child: child,
    ),
  );
}

enum _ShellTab {
  routines(title: 'Routines'),
  workouts(title: 'Workouts'),
  progress(title: 'Progress');

  const _ShellTab({required this.title});

  final String title;
}

/// Triggers a router refresh whenever [authControllerProvider] changes.
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authControllerProvider, (_, _) => notifyListeners());
  }
}
