import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Fake local auth controller.  A real provider such as Firebase Auth can
/// be swapped in by replacing this implementation.
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() => const SignedOut();

  /// Signs in with any non-empty [email] and [password].
  ///
  /// Returns `true` on success, `false` when either field is empty.
  bool signIn({required String email, required String password}) {
    if (email.isEmpty || password.isEmpty) return false;
    state = SignedIn(email);
    return true;
  }

  /// Registers a new account with any non-empty [email] and [password].
  ///
  /// Returns `true` on success, `false` when either field is empty.
  bool register({required String email, required String password}) {
    if (email.isEmpty || password.isEmpty) return false;
    state = SignedIn(email);
    return true;
  }

  /// Signs the current user out.
  void signOut() => state = const SignedOut();
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
