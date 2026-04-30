import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given EmailIdpEndpoint',
    (sessionBuilder, endpoints) {
    late String email;
    late Completer<String> verificationCodeCompleter;

    const password = 'Password123!';

    setUp(() {
      email = 'email-auth-${const Uuid().v4()}@example.com';
      verificationCodeCompleter = Completer<String>();

      AuthServices.set(
        tokenManagerBuilders: [
          JwtConfigFromPasswords(),
        ],
        identityProviderBuilders: [
          EmailIdpConfigFromPasswords(
            sendRegistrationVerificationCode:
                (
                  session, {
                  required email,
                  required accountRequestId,
                  required verificationCode,
                  required transaction,
                }) {
                  if (!verificationCodeCompleter.isCompleted) {
                    verificationCodeCompleter.complete(verificationCode);
                  }
                },
          ),
        ],
      );
    });

    Future<AuthSuccess> registerAccount() async {
      final accountRequestId = await endpoints.emailIdp.startRegistration(
        sessionBuilder,
        email: email,
      );

      final verificationCode = await verificationCodeCompleter.future.timeout(
        const Duration(seconds: 5),
      );

      final registrationToken = await endpoints.emailIdp.verifyRegistrationCode(
        sessionBuilder,
        accountRequestId: accountRequestId,
        verificationCode: verificationCode,
      );

      return endpoints.emailIdp.finishRegistration(
        sessionBuilder,
        registrationToken: registrationToken,
        password: password,
      );
    }

    test('startRegistration to login succeeds for a new account', () async {
      final registrationResult = await registerAccount();
      final loginResult = await endpoints.emailIdp.login(
        sessionBuilder,
        email: email,
        password: password,
      );

      expect(registrationResult.authUserId, equals(loginResult.authUserId));
      expect(registrationResult.token, isNotEmpty);
      expect(loginResult.token, isNotEmpty);
    });

    test('login rejects wrong password for a registered account', () async {
      await registerAccount();

      final loginAttempt = endpoints.emailIdp.login(
        sessionBuilder,
        email: email,
        password: '$password-wrong',
      );

      await expectLater(
        loginAttempt,
        throwsA(
          isA<EmailAccountLoginException>().having(
            (e) => e.reason,
            'reason',
            EmailAccountLoginExceptionReason.invalidCredentials,
          ),
        ),
      );
    });
    },
    rollbackDatabase: RollbackDatabase.disabled,
  );
}
