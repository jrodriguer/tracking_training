import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_training_flutter/app/app.dart';
import 'package:tracking_training_flutter/features/auth/application/auth_controller.dart';

void main() {
  testWidgets('routines route is protected when user is signed out', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TrackingTrainingApp()));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Day 1'), findsNothing);
  });

  testWidgets('signed-in users are redirected away from auth routes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(_SignedInAuthController.new),
        ],
        child: const TrackingTrainingApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Welcome back'), findsNothing);
  });

  testWidgets('login validates credentials and allows access when valid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TrackingTrainingApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Day 1'), findsNothing);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.enterText(
      find.byType(TextFormField).first,
      'member@example.com',
    );
    await tester.enterText(find.byType(TextFormField).last, 'password123');

    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Day 1'), findsOneWidget);
    expect(find.text('Routines'), findsNWidgets(2));
  });
}

class _SignedInAuthController extends AuthController {
  @override
  AuthState build() => const SignedIn('member@example.com');
}
