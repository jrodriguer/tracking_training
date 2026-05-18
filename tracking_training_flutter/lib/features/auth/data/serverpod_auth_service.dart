import 'dart:async';
import 'dart:io';

import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:tracking_training_client/tracking_training_client.dart';

import 'auth_service.dart';
import '../domain/sign_in_result.dart';

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

  String _normalizeEmail(String email) => email.trim().toLowerCase();

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
  Future<SignInResult> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    try {
      final auth = await _client.emailIdp.login(
        email: normalizedEmail,
        password: password,
      );
      await _sessionManager.updateSignedInUser(auth);
      await _storage.write(key: _emailKey, value: normalizedEmail);
      final session = AuthSession(
        email: normalizedEmail,
        signedInAt: DateTime.now(),
      );
      _session = session;
      await _seedDefaultRoutineBestEffort();
      return const SignInSuccess();
    } on EmailAccountLoginException catch (e) {
      return SignInFailure(
        switch (e.reason) {
          EmailAccountLoginExceptionReason.invalidCredentials =>
            SignInFailureReason.invalidCredentials,
          EmailAccountLoginExceptionReason.tooManyAttempts =>
            SignInFailureReason.tooManyAttempts,
          _ => SignInFailureReason.unknown,
        },
      );
    } on AuthUserBlockedException {
      return const SignInFailure(SignInFailureReason.userBlocked);
    } on TimeoutException {
      return const SignInFailure(SignInFailureReason.networkError);
    } on SocketException {
      return const SignInFailure(SignInFailureReason.networkError);
    } on IOException {
      return const SignInFailure(SignInFailureReason.networkError);
    } catch (_) {
      return const SignInFailure(SignInFailureReason.unknown);
    }
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
    final normalizedEmail = _normalizeEmail(email);
    if (normalizedEmail.isEmpty) {
      throw ArgumentError('Email is required.');
    }
    final uuid = await _client.emailIdp.startRegistration(
      email: normalizedEmail,
    );
    return uuid.toString();
  }

  @override
  Future<String> verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
  }) {
    final trimmedRequestId = accountRequestId.trim();
    final trimmedCode = verificationCode.trim();
    if (trimmedRequestId.isEmpty || trimmedCode.isEmpty) {
      throw ArgumentError('Account request ID and verification code are required.');
    }
    return _client.emailIdp.verifyRegistrationCode(
      accountRequestId: UuidValue.fromString(trimmedRequestId),
      verificationCode: trimmedCode,
    );
  }

  @override
  Future<AuthSession> finishRegistration({
    required String registrationToken,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    final trimmedToken = registrationToken.trim();
    if (trimmedToken.isEmpty || normalizedEmail.isEmpty) {
      throw ArgumentError('Registration token and email are required.');
    }
    final auth = await _client.emailIdp.finishRegistration(
      registrationToken: trimmedToken,
      password: password,
    );
    await _sessionManager.updateSignedInUser(auth);
    await _storage.write(key: _emailKey, value: normalizedEmail);
    final session = AuthSession(
      email: normalizedEmail,
      signedInAt: DateTime.now(),
    );
    _session = session;
    await _seedDefaultRoutineBestEffort();
    return session;
  }
}
