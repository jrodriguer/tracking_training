import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:tracking_training_client/tracking_training_client.dart';

import 'auth_service.dart';

/// Real [AuthService] backed by the Serverpod email identity provider.
class ServerpodAuthService implements AuthService {
  ServerpodAuthService({
    required Client client,
    required FlutterAuthSessionManager sessionManager,
  }) : _client = client,
       _sessionManager = sessionManager;

  final Client _client;
  final FlutterAuthSessionManager _sessionManager;
  final _storage = const FlutterSecureStorage();

  static const _emailKey = 'sp_user_email_v1';

  AuthSession? _session;

  Future<void> _seedDefaultRoutineBestEffort() async {
    try {
      await _client.appAuth.seedDefaultRoutine();
    } catch (_) {
      // seeding is best-effort; auth success is not blocked
    }
  }

  @override
  AuthSession? get currentSession => _session;

  @override
  Future<AuthSession?> loadSession() async {
    try {
      await _sessionManager.initialize();
      if (!_sessionManager.isAuthenticated) return null;
      final email = await _storage.read(key: _emailKey) ?? '';
      _session = AuthSession(email: email, signedInAt: DateTime.now());
      await _seedDefaultRoutineBestEffort();
      return _session;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AuthSession> signIn({
    required String email,
    required String password,
  }) async {
    final auth = await _client.emailIdp.login(
      email: email,
      password: password,
    );
    await _sessionManager.updateSignedInUser(auth);
    await _storage.write(key: _emailKey, value: email);
    final session = AuthSession(email: email, signedInAt: DateTime.now());
    _session = session;
    await _seedDefaultRoutineBestEffort();
    return session;
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
  }) {
    throw UnsupportedError(
      'Use startRegistration / verifyRegistrationCode / finishRegistration '
      'for account creation.',
    );
  }

  @override
  Future<void> signOut() async {
    _session = null;
    await _sessionManager.updateSignedInUser(null);
    await _storage.delete(key: _emailKey);
  }

  @override
  Future<String?> startRegistration(String email) async {
    final uuid = await _client.emailIdp.startRegistration(email: email);
    return uuid.toString();
  }

  @override
  Future<String> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  }) {
    return _client.emailIdp.verifyRegistrationCode(
      accountRequestId: UuidValue.fromString(accountRequestId),
      verificationCode: verificationCode,
    );
  }

  @override
  Future<AuthSession> finishRegistration({
    required String registrationToken,
    required String email,
    required String password,
  }) async {
    final auth = await _client.emailIdp.finishRegistration(
      registrationToken: registrationToken,
      password: password,
    );
    await _sessionManager.updateSignedInUser(auth);
    await _storage.write(key: _emailKey, value: email);
    final session = AuthSession(email: email, signedInAt: DateTime.now());
    _session = session;
    await _seedDefaultRoutineBestEffort();
    return session;
  }
}
