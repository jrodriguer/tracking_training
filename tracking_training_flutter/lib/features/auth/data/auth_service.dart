import 'package:shared_preferences/shared_preferences.dart';

class AuthSession {
  const AuthSession({required this.email, required this.signedInAt});

  final String email;
  final DateTime signedInAt;
}

abstract class AuthService {
  /// Loads any session persisted from a previous run.
  /// Returns `null` when the user is not signed in.
  Future<AuthSession?> loadSession();

  AuthSession? get currentSession;

  Future<AuthSession> signIn({required String email, required String password});

  Future<AuthSession> register({
    required String email,
    required String password,
  });

  Future<void> signOut();

  /// Step 1 of multi-step registration: sends a verification email.
  ///
  /// Returns the account request ID to pass to [verifyRegistrationCode], or
  /// `null` when the service handled registration inline (e.g. [FakeAuthService]).
  Future<String?> startRegistration(String email);

  /// Step 2: verifies the email code and returns a registration token.
  Future<String> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  });

  /// Step 3: sets a password and completes account creation.
  Future<AuthSession> finishRegistration({
    required String registrationToken,
    required String email,
    required String password,
  });
}

/// Local fake implementation.  Swap [FakeAuthService] with a real provider
/// (e.g. [ServerpodAuthService]) by replacing the [authServiceProvider] binding.
class FakeAuthService implements AuthService {
  static const _emailKey = 'fake_auth_email_v1';

  AuthSession? _session;

  @override
  AuthSession? get currentSession => _session;

  @override
  Future<AuthSession?> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    if (email == null) return null;
    final session = AuthSession(email: email, signedInAt: DateTime.now());
    _session = session;
    return session;
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final session = AuthSession(
      email: email.trim().toLowerCase(),
      signedInAt: DateTime.now(),
    );
    _session = session;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, session.email);
    return session;
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
  }) async {
    return signIn(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    _session = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
  }

  @override
  Future<String?> startRegistration(String email) async {
    // Fake: sign in immediately so [loadSession] returns a valid session.
    await signIn(email: email, password: 'fake-registration');
    return null; // null signals "registration completed inline"
  }

  @override
  Future<String> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  }) async {
    return 'fake-registration-token';
  }

  @override
  Future<AuthSession> finishRegistration({
    required String registrationToken,
    required String email,
    required String password,
  }) async {
    return signIn(email: email, password: password);
  }
}
