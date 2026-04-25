import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tracking_training_flutter/features/auth/application/auth_controller.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  group('AuthController', () {
    test('initial state is SignedOut', () {
      final container = makeContainer();
      expect(container.read(authControllerProvider), isA<SignedOut>());
    });

    group('signIn', () {
      test('transitions to SignedIn with the provided email', () async {
        final container = makeContainer();

        final ok = await container
            .read(authControllerProvider.notifier)
            .signIn(email: 'user@example.com', password: 'secret1');

        expect(ok, isTrue);
        final state = container.read(authControllerProvider);
        expect(state, isA<SignedIn>());
        expect((state as SignedIn).email, 'user@example.com');
      });

      test('returns false and keeps SignedOut when email is empty', () async {
        final container = makeContainer();

        final ok = await container
            .read(authControllerProvider.notifier)
            .signIn(email: '', password: 'secret1');

        expect(ok, isFalse);
        expect(container.read(authControllerProvider), isA<SignedOut>());
      });

      test(
        'returns false and keeps SignedOut when password is empty',
        () async {
          final container = makeContainer();

          final ok = await container
              .read(authControllerProvider.notifier)
              .signIn(email: 'user@example.com', password: '');

          expect(ok, isFalse);
          expect(container.read(authControllerProvider), isA<SignedOut>());
        },
      );
    });

    group('register', () {
      test('transitions to SignedIn with the provided email', () async {
        final container = makeContainer();

        final ok = await container
            .read(authControllerProvider.notifier)
            .register(email: 'new@example.com', password: 'pass123');

        expect(ok, isTrue);
        final state = container.read(authControllerProvider);
        expect(state, isA<SignedIn>());
        expect((state as SignedIn).email, 'new@example.com');
      });

      test('returns false when email is empty', () async {
        final container = makeContainer();

        final ok = await container
            .read(authControllerProvider.notifier)
            .register(email: '', password: 'pass123');

        expect(ok, isFalse);
        expect(container.read(authControllerProvider), isA<SignedOut>());
      });
    });

    group('signOut', () {
      test('transitions from SignedIn back to SignedOut', () async {
        final container = makeContainer();

        await container
            .read(authControllerProvider.notifier)
            .signIn(email: 'user@example.com', password: 'pass123');
        expect(container.read(authControllerProvider), isA<SignedIn>());

        await container.read(authControllerProvider.notifier).signOut();
        expect(container.read(authControllerProvider), isA<SignedOut>());
      });
    });

    group('session persistence', () {
      test('build restores a persisted session on startup', () async {
        SharedPreferences.setMockInitialValues({
          'fake_auth_email_v1': 'persisted@example.com',
        });

        final container = makeContainer();
        // Allow the async loadSession() future to complete.
        await Future<void>.delayed(Duration.zero);

        expect(container.read(authControllerProvider), isA<SignedIn>());
        expect(
          (container.read(authControllerProvider) as SignedIn).email,
          'persisted@example.com',
        );
      });

      test('signIn persists email so a new container can restore it', () async {
        final container = makeContainer();
        await container
            .read(authControllerProvider.notifier)
            .signIn(email: 'save@example.com', password: 'abc123');

        // Simulate app restart with a fresh container.
        final container2 = makeContainer();
        await Future<void>.delayed(Duration.zero);

        expect(container2.read(authControllerProvider), isA<SignedIn>());
        expect(
          (container2.read(authControllerProvider) as SignedIn).email,
          'save@example.com',
        );
      });

      test('signOut clears the persisted session', () async {
        final container = makeContainer();
        await container
            .read(authControllerProvider.notifier)
            .signIn(email: 'user@example.com', password: 'abc123');
        await container.read(authControllerProvider.notifier).signOut();

        final container2 = makeContainer();
        await Future<void>.delayed(Duration.zero);

        expect(container2.read(authControllerProvider), isA<SignedOut>());
      });
    });
  });

  group('authLabel', () {
    test('returns "Sign in" for SignedOut', () {
      expect(authLabel(const SignedOut()), 'Sign in');
    });

    test('returns email for SignedIn', () {
      expect(authLabel(const SignedIn('me@example.com')), 'me@example.com');
    });
  });

  group('validateEmail', () {
    test('returns error when value is null', () {
      expect(validateEmail(null), isNotNull);
    });

    test('returns error when value is empty', () {
      expect(validateEmail(''), isNotNull);
    });

    test('returns error for an invalid email format', () {
      expect(validateEmail('notanemail'), isNotNull);
      expect(validateEmail('missing@tld'), isNotNull);
    });

    test('returns null for a valid email', () {
      expect(validateEmail('user@example.com'), isNull);
    });
  });

  group('validatePassword', () {
    test('returns error when value is null', () {
      expect(validatePassword(null), isNotNull);
    });

    test('returns error when value is empty', () {
      expect(validatePassword(''), isNotNull);
    });

    test('returns error when password is shorter than 6 characters', () {
      expect(validatePassword('hi'), isNotNull);
    });

    test('returns null for a password of exactly 6 characters', () {
      expect(validatePassword('abc123'), isNull);
    });

    test('returns null for a password longer than 6 characters', () {
      expect(validatePassword('supersecret'), isNull);
    });
  });
}
