import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_training_flutter/app/app.dart';
import 'package:tracking_training_flutter/features/auth/application/auth_controller.dart';

void main() {
  testWidgets('App boots to seeded routine list when signed in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(() => _SignedInAuthController()),
        ],
        child: const TrackingTrainingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Day 4'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
  });
}

/// A fake [AuthController] that starts in the [SignedIn] state for tests
/// that need to bypass the auth redirect.
class _SignedInAuthController extends AuthController {
  @override
  AuthState build() => const SignedIn('test@example.com');
}
