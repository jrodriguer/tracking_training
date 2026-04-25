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
}

/// Local fake implementation.  Swap [FakeAuthService] with a real provider
/// (e.g. Firebase Auth) by replacing the [authServiceProvider] binding.
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
}
