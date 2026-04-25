import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tracking_training_flutter/app/app.dart';
import 'package:tracking_training_flutter/features/auth/application/auth_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('Auth routing', () {
    testWidgets(
      'user with a persisted session is routed to the routines page on boot',
      (tester) async {
        // Simulate an email that was persisted from a previous run.
        SharedPreferences.setMockInitialValues({
          'fake_auth_email_v1': 'persisted@example.com',
        });

        await tester.pumpWidget(
          const ProviderScope(child: TrackingTrainingApp()),
        );
        await tester.pumpAndSettle();

        // Should land on the main app, not the login page.
        expect(find.text('Routines'), findsWidgets);
        expect(find.text('Sign in'), findsNothing);
      },
    );

    testWidgets('unauthenticated user is redirected to login page', (
      tester,
    ) async {
      // Default auth state is SignedOut.
      await tester.pumpWidget(
        const ProviderScope(child: TrackingTrainingApp()),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sign in'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      // Protected content should not be visible.
      expect(find.text('Day 1'), findsNothing);
    });

    testWidgets('authenticated user sees the main app', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authControllerProvider.overrideWith(
              () => _SignedInAuthController(),
            ),
          ],
          child: const TrackingTrainingApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Login page should not be visible.
      expect(find.text('Sign in'), findsNothing);
      // Protected content is accessible.
      expect(find.text('Routines'), findsWidgets);
    });

    testWidgets('signing in navigates to the routines page', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: TrackingTrainingApp()),
      );
      await tester.pumpAndSettle();

      // Fill in the login form.
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'secret1',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pumpAndSettle();

      // Should now be on the routines page.
      expect(find.text('Routines'), findsWidgets);
      expect(find.text('Sign in'), findsNothing);
    });

    testWidgets('signing in with empty email shows validation error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: TrackingTrainingApp()),
      );
      await tester.pumpAndSettle();

      // Tap submit without filling any field.
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump();

      expect(find.text('Email is required.'), findsOneWidget);
      expect(find.text('Password is required.'), findsOneWidget);
    });

    testWidgets('signing in with invalid email format shows validation error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: TrackingTrainingApp()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'notanemail',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'pass12',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump();

      expect(find.text('Enter a valid email address.'), findsOneWidget);
    });

    testWidgets('password shorter than 6 characters shows validation error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: TrackingTrainingApp()),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'user@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'hi',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
      await tester.pump();

      expect(
        find.text('Password must be at least 6 characters.'),
        findsOneWidget,
      );
    });
  });

  group('Register routing', () {
    testWidgets('tapping "Create account" on login goes to register page', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: TrackingTrainingApp()),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      expect(find.text('New account'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
    });

    testWidgets('mismatched confirm password shows validation error', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: TrackingTrainingApp()),
      );
      await tester.pumpAndSettle();

      // Navigate to register.
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'new@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'pass123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        'different',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await tester.pump();

      expect(find.text('Passwords do not match.'), findsOneWidget);
    });

    testWidgets('valid registration navigates to routines page', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: TrackingTrainingApp()),
      );
      await tester.pumpAndSettle();

      // Navigate to register.
      await tester.tap(find.text('Create account'));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'new@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'pass123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm password'),
        'pass123',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Create account'));
      await tester.pumpAndSettle();

      expect(find.text('Routines'), findsWidgets);
    });
  });
}

/// A fake [AuthController] that starts in the [SignedIn] state.
class _SignedInAuthController extends AuthController {
  @override
  AuthState build() => const SignedIn('test@example.com');
}
