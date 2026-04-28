/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:tracking_training_client/src/protocol/routines/routine_day.dart'
    as _i5;
import 'package:tracking_training_client/src/protocol/routines/exercise_template.dart'
    as _i6;
import 'package:tracking_training_client/src/protocol/workouts/workout_session.dart'
    as _i7;
import 'package:tracking_training_client/src/protocol/workouts/workout_entry.dart'
    as _i8;
import 'package:tracking_training_client/src/protocol/workouts/workout_set.dart'
    as _i9;
import 'protocol.dart' as _i10;

/// App-level authentication endpoint.
///
/// The Flutter client calls [seedDefaultRoutine] immediately after every
/// successful
/// sign-in and after restoring a persisted session.  It seeds the default
/// four-day routine for new users and returns `false` for returning users.
/// {@category Endpoint}
class EndpointAppAuth extends _i1.EndpointRef {
  EndpointAppAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'appAuth';

  /// Seeds the default four-day routine for first-time users.
  ///
  /// Returns `true` when data was seeded, `false` for returning users.
  _i2.Future<bool> seedDefaultRoutine() => caller.callServerEndpoint<bool>(
    'appAuth',
    'seedDefaultRoutine',
    {},
  );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i3.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i2.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i2.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i2.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i2.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Manages the weekly routine split: days, focus areas, and exercises.
/// {@category Endpoint}
class EndpointRoutine extends _i1.EndpointRef {
  EndpointRoutine(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'routine';

  /// Returns all routine days for the signed-in user ordered by sortOrder.
  _i2.Future<List<_i5.RoutineDay>> getRoutineDays() =>
      caller.callServerEndpoint<List<_i5.RoutineDay>>(
        'routine',
        'getRoutineDays',
        {},
      );

  /// Updates a routine day's display title and focus-area labels.
  _i2.Future<void> updateRoutineDay({
    required int dayId,
    required String title,
    required List<String> focusAreas,
  }) => caller.callServerEndpoint<void>(
    'routine',
    'updateRoutineDay',
    {
      'dayId': dayId,
      'title': title,
      'focusAreas': focusAreas,
    },
  );

  /// Returns all exercises for [dayId] ordered by [ExerciseTemplate.sortOrder].
  _i2.Future<List<_i6.ExerciseTemplate>> getExercises({required int dayId}) =>
      caller.callServerEndpoint<List<_i6.ExerciseTemplate>>(
        'routine',
        'getExercises',
        {'dayId': dayId},
      );

  /// Appends a new exercise to [dayId] and returns the persisted record.
  _i2.Future<_i6.ExerciseTemplate> addExercise({
    required int dayId,
    required String name,
    String? note,
  }) => caller.callServerEndpoint<_i6.ExerciseTemplate>(
    'routine',
    'addExercise',
    {
      'dayId': dayId,
      'name': name,
      'note': note,
    },
  );

  /// Updates the name and optional note for an exercise.
  _i2.Future<void> updateExercise({
    required int exerciseId,
    required String name,
    String? note,
  }) => caller.callServerEndpoint<void>(
    'routine',
    'updateExercise',
    {
      'exerciseId': exerciseId,
      'name': name,
      'note': note,
    },
  );

  /// Removes an exercise.
  _i2.Future<void> removeExercise({required int exerciseId}) =>
      caller.callServerEndpoint<void>(
        'routine',
        'removeExercise',
        {'exerciseId': exerciseId},
      );

  /// Reorders exercises within [dayId] to match [exerciseIdsInOrder].
  ///
  /// Each element of [exerciseIdsInOrder] is assigned a [sortOrder] equal to
  /// its list index.
  _i2.Future<void> reorderExercises({
    required int dayId,
    required List<int> exerciseIdsInOrder,
  }) => caller.callServerEndpoint<void>(
    'routine',
    'reorderExercises',
    {
      'dayId': dayId,
      'exerciseIdsInOrder': exerciseIdsInOrder,
    },
  );
}

/// Manages dated workout sessions and their set-level history.
///
/// Session data is stored independently of routine templates so that editing
/// or removing a routine day never mutates historical workout records.
/// {@category Endpoint}
class EndpointWorkout extends _i1.EndpointRef {
  EndpointWorkout(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workout';

  /// Returns all sessions ordered newest first.
  _i2.Future<List<_i7.WorkoutSession>> listSessions() =>
      caller.callServerEndpoint<List<_i7.WorkoutSession>>(
        'workout',
        'listSessions',
        {},
      );

  /// Returns a single session by ID, or `null` when not found.
  _i2.Future<_i7.WorkoutSession?> getSession({required int sessionId}) =>
      caller.callServerEndpoint<_i7.WorkoutSession?>(
        'workout',
        'getSession',
        {'sessionId': sessionId},
      );

  /// Creates a new workout session from a routine day.
  ///
  /// Snapshots the routine day title and exercise names at creation time so
  /// subsequent routine edits do not affect this historical record.  One
  /// default set is created for each exercise entry.
  _i2.Future<_i7.WorkoutSession> createSessionFromRoutineDay({
    required int routineDayId,
    required DateTime workoutDate,
  }) => caller.callServerEndpoint<_i7.WorkoutSession>(
    'workout',
    'createSessionFromRoutineDay',
    {
      'routineDayId': routineDayId,
      'workoutDate': workoutDate,
    },
  );

  /// Updates the metadata for an existing session row (title, startedAt).
  ///
  /// This only updates the [WorkoutSession] row. To modify entries and sets
  /// use [saveSet] and [deleteSet].
  _i2.Future<void> updateSessionMetadata({
    required _i7.WorkoutSession workoutSession,
  }) => caller.callServerEndpoint<void>(
    'workout',
    'updateSessionMetadata',
    {'workoutSession': workoutSession},
  );

  /// Deletes a session and all its entries and sets.
  _i2.Future<void> deleteSession({required int sessionId}) =>
      caller.callServerEndpoint<void>(
        'workout',
        'deleteSession',
        {'sessionId': sessionId},
      );

  /// Returns all entries for [sessionId].
  _i2.Future<List<_i8.WorkoutEntry>> getEntries({required int sessionId}) =>
      caller.callServerEndpoint<List<_i8.WorkoutEntry>>(
        'workout',
        'getEntries',
        {'sessionId': sessionId},
      );

  /// Returns all sets for [entryId].
  _i2.Future<List<_i9.WorkoutSet>> getSets({required int entryId}) =>
      caller.callServerEndpoint<List<_i9.WorkoutSet>>(
        'workout',
        'getSets',
        {'entryId': entryId},
      );

  /// Upserts a single set.
  _i2.Future<_i9.WorkoutSet> saveSet({required _i9.WorkoutSet workoutSet}) =>
      caller.callServerEndpoint<_i9.WorkoutSet>(
        'workout',
        'saveSet',
        {'workoutSet': workoutSet},
      );

  /// Removes a set by ID.
  _i2.Future<void> deleteSet({required int setId}) =>
      caller.callServerEndpoint<void>(
        'workout',
        'deleteSet',
        {'setId': setId},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i3.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i3.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i10.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    appAuth = EndpointAppAuth(this);
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    routine = EndpointRoutine(this);
    workout = EndpointWorkout(this);
    modules = Modules(this);
  }

  late final EndpointAppAuth appAuth;

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointRoutine routine;

  late final EndpointWorkout workout;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'appAuth': appAuth,
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'routine': routine,
    'workout': workout,
  };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
