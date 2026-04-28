import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_service.dart';

/// Represents the current authentication state of the app.
sealed class AuthState {
  const AuthState();
}

/// The app is restoring a persisted session on startup.
final class AuthRestoring extends AuthState {
  const AuthRestoring();
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
/// to swap in a real provider such as [ServerpodAuthService].
final authServiceProvider = Provider<AuthService>((_) => FakeAuthService());

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// Auth controller.  The service implementation can be swapped by replacing
/// [authServiceProvider].
class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    _restoreSession();
    return const AuthRestoring();
  }

  Future<void> _restoreSession() async {
    final session = await ref.read(authServiceProvider).loadSession();
    state = session != null ? SignedIn(session.email) : const SignedOut();
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
        .signIn(email: email, password: password);
    state = SignedIn(session.email);
    return true;
  }

  /// Registers a new account with [email] and [password] (single-step fake).
  ///
  /// Returns `true` on success, `false` when either field is empty.
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) return false;
    final session = await ref
        .read(authServiceProvider)
        .register(email: email, password: password);
    state = SignedIn(session.email);
    return true;
  }

  /// Signs the current user out.
  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
    state = const SignedOut();
  }

  // ── Multi-step registration ──────────────────────────────────────────────

  /// Step 1: sends a verification email.
  ///
  /// Returns the account request ID UUID string (real service), or `null` when
  /// the service completed registration inline ([FakeAuthService]).  When `null`
  /// is returned the state has already transitioned to [SignedIn].
  Future<String?> startRegistration(String email) async {
    if (email.isEmpty) return null;
    final service = ref.read(authServiceProvider);
    final requestId = await service.startRegistration(email);
    if (requestId == null) {
      // Fake flow: session stored inline – load it to transition state.
      final session = await service.loadSession();
      if (session != null) state = SignedIn(session.email);
    }
    return requestId;
  }

  /// Step 2: verifies the email code and returns a registration token.
  Future<String> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  }) {
    return ref
        .read(authServiceProvider)
        .verifyRegistrationCode(
          accountRequestId: accountRequestId,
          verificationCode: verificationCode,
        );
  }

  /// Step 3: sets a password and completes account creation.
  ///
  /// Returns `true` on success, `false` when [password] is empty.
  Future<bool> finishRegistration({
    required String registrationToken,
    required String email,
    required String password,
  }) async {
    if (password.isEmpty) return false;
    final session = await ref
        .read(authServiceProvider)
        .finishRegistration(
          registrationToken: registrationToken,
          email: email,
          password: password,
        );
    state = SignedIn(session.email);
    return true;
  }
}

/// Convenience helper to derive a display label from [AuthState].
String authLabel(AuthState state) => switch (state) {
  AuthRestoring() => '',
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
