import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_service.dart';

/// Represents the current authentication state of the app.
sealed class AuthState {
  const AuthState();
}

/// The user is not authenticated.
final class SignedOut extends AuthState {
  const SignedOut();
}

/// The user has successfully authenticated.
final class SignedIn extends AuthState {
  const SignedIn(this.email);

  final String email;
}

/// Exposes the [AuthService] implementation.  Replace [FakeAuthService] here
/// to swap in a real provider such as Firebase Auth.
final authServiceProvider = Provider<AuthService>((_) => FakeAuthService());

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Local auth controller.  A real provider can be swapped in by replacing
/// [authServiceProvider].
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Kick off async session restore; initial state is SignedOut.
    ref.read(authServiceProvider).loadSession().then((session) {
      if (session != null) state = SignedIn(session.email);
    });
    return const SignedOut();
  }

  /// Signs in with [email] and [password].
  ///
  /// Returns `true` on success, `false` when either field is empty.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) return false;
    final session = await ref
        .read(authServiceProvider)
        .signIn(
          email: email,
          password: password,
        );
    state = SignedIn(session.email);
    return true;
  }

  /// Registers a new account with [email] and [password].
  ///
  /// Returns `true` on success, `false` when either field is empty.
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) return false;
    final session = await ref
        .read(authServiceProvider)
        .register(
          email: email,
          password: password,
        );
    state = SignedIn(session.email);
    return true;
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    state = const SignedOut();
  }
}

/// Convenience helper to derive a display label from [AuthState].
String authLabel(AuthState state) => switch (state) {
  SignedOut() => 'Sign in',
  SignedIn(:final email) => email,
};

/// Validates an email address field for all auth forms.
///
/// Returns an error message, or `null` when the value is valid.
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required.';
  final emailRe = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  if (!emailRe.hasMatch(value.trim())) return 'Enter a valid email address.';
  return null;
}

/// Validates a password field for all auth forms.
///
/// Returns an error message, or `null` when the value is valid.
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required.';
  if (value.length < 6) return 'Password must be at least 6 characters.';
  return null;
}
