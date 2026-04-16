import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tracking_training_flutter/features/auth/application/auth_controller.dart';

void main() {
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
      test('transitions to SignedIn with the provided email', () {
        final container = makeContainer();

        final ok = container
            .read(authControllerProvider.notifier)
            .signIn(email: 'user@example.com', password: 'secret1');

        expect(ok, isTrue);
        final state = container.read(authControllerProvider);
        expect(state, isA<SignedIn>());
        expect((state as SignedIn).email, 'user@example.com');
      });

      test('returns false and keeps SignedOut when email is empty', () {
        final container = makeContainer();

        final ok = container
            .read(authControllerProvider.notifier)
            .signIn(email: '', password: 'secret1');

        expect(ok, isFalse);
        expect(container.read(authControllerProvider), isA<SignedOut>());
      });

      test('returns false and keeps SignedOut when password is empty', () {
        final container = makeContainer();

        final ok = container
            .read(authControllerProvider.notifier)
            .signIn(email: 'user@example.com', password: '');

        expect(ok, isFalse);
        expect(container.read(authControllerProvider), isA<SignedOut>());
      });
    });

    group('register', () {
      test('transitions to SignedIn with the provided email', () {
        final container = makeContainer();

        final ok = container
            .read(authControllerProvider.notifier)
            .register(email: 'new@example.com', password: 'pass123');

        expect(ok, isTrue);
        final state = container.read(authControllerProvider);
        expect(state, isA<SignedIn>());
        expect((state as SignedIn).email, 'new@example.com');
      });

      test('returns false when email is empty', () {
        final container = makeContainer();

        final ok = container
            .read(authControllerProvider.notifier)
            .register(email: '', password: 'pass123');

        expect(ok, isFalse);
        expect(container.read(authControllerProvider), isA<SignedOut>());
      });
    });

    group('signOut', () {
      test('transitions from SignedIn back to SignedOut', () {
        final container = makeContainer();

        container
            .read(authControllerProvider.notifier)
            .signIn(email: 'user@example.com', password: 'pass123');
        expect(container.read(authControllerProvider), isA<SignedIn>());

        container.read(authControllerProvider.notifier).signOut();
        expect(container.read(authControllerProvider), isA<SignedOut>());
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
