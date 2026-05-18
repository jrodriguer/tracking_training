import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_service.dart';
import '../domain/sign_in_result.dart';

/// Represents the current authentication state of the app.
sealed class AuthState {
  const AuthState({this.lastSignInResult, this.isSigningIn = false});

  final SignInResult? lastSignInResult;
  final bool isSigningIn;
}

/// The app is restoring a persisted session on startup.
final class AuthRestoring extends AuthState {
  const AuthRestoring();
}

/// The user is not authenticated.
final class SignedOut extends AuthState {
  const SignedOut({super.lastSignInResult, super.isSigningIn});
}

/// The user has successfully authenticated.
final class SignedIn extends AuthState {
  const SignedIn(this.email, {super.lastSignInResult});

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
  String _normalizeEmail(String email) => email.trim().toLowerCase();

  bool _isValidEmail(String email) => validateEmail(email) == null;

  @override
  AuthState build() {
    _restoreSession();
    return const AuthRestoring();
  }

  Future<void> _restoreSession({SignInResult? result}) async {
    final session = await ref.read(authServiceProvider).loadSession();
    if (!ref.mounted) return;
    state = session != null
        ? SignedIn(session.email, lastSignInResult: result)
        : SignedOut(lastSignInResult: result);
  }

  /// Signs in with [email] and [password].
  ///
  /// Returns `true` on success, `false` when credentials are invalid or
  /// authentication fails.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    if (!_isValidEmail(normalizedEmail) || password.isEmpty) return false;
    final service = ref.read(authServiceProvider);
    state = const SignedOut(isSigningIn: true);
    final result = await service.signIn(
      email: normalizedEmail,
      password: password,
    );
    if (!ref.mounted) return false;
    switch (result) {
      case SignInSuccess():
        final currentSession = service.currentSession;
        if (currentSession != null) {
          state = SignedIn(
            currentSession.email,
            lastSignInResult: result,
          );
        } else {
          await _restoreSession(result: result);
        }
        return true;
      case SignInFailure():
        state = SignedOut(lastSignInResult: result);
        return false;
    }
  }

  /// Registers a new account with [email] and [password] (single-step fake).
  ///
  /// Returns `true` on success, `false` when either field is empty.
  Future<bool> register({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    if (!_isValidEmail(normalizedEmail) || password.isEmpty) return false;
    final session = await ref
        .read(authServiceProvider)
        .register(email: normalizedEmail, password: password);
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
    final normalizedEmail = _normalizeEmail(email);
    if (!_isValidEmail(normalizedEmail)) return null;
    final service = ref.read(authServiceProvider);
    final requestId = await service.startRegistration(normalizedEmail);
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
    final trimmedRequestId = accountRequestId.trim();
    final trimmedCode = verificationCode.trim();
    if (trimmedRequestId.isEmpty || trimmedCode.isEmpty) {
      throw ArgumentError('Account request ID and verification code are required.');
    }
    return ref
        .read(authServiceProvider)
        .verifyRegistrationCode(
          accountRequestId: trimmedRequestId,
          verificationCode: trimmedCode,
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
    final normalizedEmail = _normalizeEmail(email);
    final trimmedToken = registrationToken.trim();
    if (
        trimmedToken.isEmpty ||
        !_isValidEmail(normalizedEmail) ||
        password.isEmpty
    ) {
      return false;
    }
    final session = await ref
        .read(authServiceProvider)
        .finishRegistration(
          registrationToken: trimmedToken,
          email: normalizedEmail,
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

String signInFailureMessage(SignInFailureReason reason) => switch (reason) {
  SignInFailureReason.invalidCredentials =>
    'Email or password is incorrect.',
  SignInFailureReason.tooManyAttempts =>
    'Too many attempts. Please try again later.',
  SignInFailureReason.userBlocked =>
    'This account is temporarily blocked.',
  SignInFailureReason.networkError =>
    'Network error. Check your connection and try again.',
  SignInFailureReason.unknown =>
    'Unable to sign in right now. Please try again.',
};
