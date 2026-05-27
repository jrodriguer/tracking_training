sealed class SignInResult {
  const SignInResult();
}

final class SignInSuccess extends SignInResult {
  const SignInSuccess();
}

final class SignInFailure extends SignInResult {
  const SignInFailure(this.reason);

  final SignInFailureReason reason;
}

enum SignInFailureReason {
  invalidCredentials,
  tooManyAttempts,
  userBlocked,
  networkError,
  unknown,
}