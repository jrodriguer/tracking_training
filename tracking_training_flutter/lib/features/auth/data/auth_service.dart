class AuthSession {
  const AuthSession({required this.email, required this.signedInAt});

  final String email;
  final DateTime signedInAt;
}

abstract class AuthService {
  AuthSession? get currentSession;

  Future<AuthSession> signIn({required String email, required String password});

  Future<AuthSession> register({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

class FakeAuthService implements AuthService {
  FakeAuthService({AuthSession? initialSession}) : _session = initialSession;

  AuthSession? _session;

  @override
  AuthSession? get currentSession => _session;

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
  }
}
