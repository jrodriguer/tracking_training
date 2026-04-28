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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/app_auth_endpoint.dart' as _i2;
import '../auth/email_idp_endpoint.dart' as _i3;
import '../auth/jwt_refresh_endpoint.dart' as _i4;
import '../routines/routine_endpoint.dart' as _i5;
import '../workouts/workout_endpoint.dart' as _i6;
import 'package:tracking_training_server/src/generated/workouts/workout_session.dart'
    as _i7;
import 'package:tracking_training_server/src/generated/workouts/workout_set.dart'
    as _i8;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i9;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i10;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'appAuth': _i2.AppAuthEndpoint()
        ..initialize(
          server,
          'appAuth',
          null,
        ),
      'emailIdp': _i3.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i4.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'routine': _i5.RoutineEndpoint()
        ..initialize(
          server,
          'routine',
          null,
        ),
      'workout': _i6.WorkoutEndpoint()
        ..initialize(
          server,
          'workout',
          null,
        ),
    };
    connectors['appAuth'] = _i1.EndpointConnector(
      name: 'appAuth',
      endpoint: endpoints['appAuth']!,
      methodConnectors: {
        'seedDefaultRoutine': _i1.MethodConnector(
          name: 'seedDefaultRoutine',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['appAuth'] as _i2.AppAuthEndpoint)
                  .seedDefaultRoutine(session),
        ),
      },
    );
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i3.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i4.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['routine'] = _i1.EndpointConnector(
      name: 'routine',
      endpoint: endpoints['routine']!,
      methodConnectors: {
        'getRoutineDays': _i1.MethodConnector(
          name: 'getRoutineDays',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['routine'] as _i5.RoutineEndpoint)
                  .getRoutineDays(session),
        ),
        'updateRoutineDay': _i1.MethodConnector(
          name: 'updateRoutineDay',
          params: {
            'dayId': _i1.ParameterDescription(
              name: 'dayId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'title': _i1.ParameterDescription(
              name: 'title',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'focusAreas': _i1.ParameterDescription(
              name: 'focusAreas',
              type: _i1.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['routine'] as _i5.RoutineEndpoint)
                  .updateRoutineDay(
                    session,
                    dayId: params['dayId'],
                    title: params['title'],
                    focusAreas: params['focusAreas'],
                  ),
        ),
        'getExercises': _i1.MethodConnector(
          name: 'getExercises',
          params: {
            'dayId': _i1.ParameterDescription(
              name: 'dayId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['routine'] as _i5.RoutineEndpoint).getExercises(
                    session,
                    dayId: params['dayId'],
                  ),
        ),
        'addExercise': _i1.MethodConnector(
          name: 'addExercise',
          params: {
            'dayId': _i1.ParameterDescription(
              name: 'dayId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['routine'] as _i5.RoutineEndpoint).addExercise(
                    session,
                    dayId: params['dayId'],
                    name: params['name'],
                    note: params['note'],
                  ),
        ),
        'updateExercise': _i1.MethodConnector(
          name: 'updateExercise',
          params: {
            'exerciseId': _i1.ParameterDescription(
              name: 'exerciseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['routine'] as _i5.RoutineEndpoint).updateExercise(
                    session,
                    exerciseId: params['exerciseId'],
                    name: params['name'],
                    note: params['note'],
                  ),
        ),
        'removeExercise': _i1.MethodConnector(
          name: 'removeExercise',
          params: {
            'exerciseId': _i1.ParameterDescription(
              name: 'exerciseId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['routine'] as _i5.RoutineEndpoint).removeExercise(
                    session,
                    exerciseId: params['exerciseId'],
                  ),
        ),
        'reorderExercises': _i1.MethodConnector(
          name: 'reorderExercises',
          params: {
            'dayId': _i1.ParameterDescription(
              name: 'dayId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'exerciseIdsInOrder': _i1.ParameterDescription(
              name: 'exerciseIdsInOrder',
              type: _i1.getType<List<int>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['routine'] as _i5.RoutineEndpoint)
                  .reorderExercises(
                    session,
                    dayId: params['dayId'],
                    exerciseIdsInOrder: params['exerciseIdsInOrder'],
                  ),
        ),
      },
    );
    connectors['workout'] = _i1.EndpointConnector(
      name: 'workout',
      endpoint: endpoints['workout']!,
      methodConnectors: {
        'listSessions': _i1.MethodConnector(
          name: 'listSessions',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workout'] as _i6.WorkoutEndpoint)
                  .listSessions(session),
        ),
        'getSession': _i1.MethodConnector(
          name: 'getSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['workout'] as _i6.WorkoutEndpoint).getSession(
                    session,
                    sessionId: params['sessionId'],
                  ),
        ),
        'createSessionFromRoutineDay': _i1.MethodConnector(
          name: 'createSessionFromRoutineDay',
          params: {
            'routineDayId': _i1.ParameterDescription(
              name: 'routineDayId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'workoutDate': _i1.ParameterDescription(
              name: 'workoutDate',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workout'] as _i6.WorkoutEndpoint)
                  .createSessionFromRoutineDay(
                    session,
                    routineDayId: params['routineDayId'],
                    workoutDate: params['workoutDate'],
                  ),
        ),
        'updateSessionMetadata': _i1.MethodConnector(
          name: 'updateSessionMetadata',
          params: {
            'workoutSession': _i1.ParameterDescription(
              name: 'workoutSession',
              type: _i1.getType<_i7.WorkoutSession>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workout'] as _i6.WorkoutEndpoint)
                  .updateSessionMetadata(
                    session,
                    workoutSession: params['workoutSession'],
                  ),
        ),
        'deleteSession': _i1.MethodConnector(
          name: 'deleteSession',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['workout'] as _i6.WorkoutEndpoint).deleteSession(
                    session,
                    sessionId: params['sessionId'],
                  ),
        ),
        'getEntries': _i1.MethodConnector(
          name: 'getEntries',
          params: {
            'sessionId': _i1.ParameterDescription(
              name: 'sessionId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['workout'] as _i6.WorkoutEndpoint).getEntries(
                    session,
                    sessionId: params['sessionId'],
                  ),
        ),
        'getSets': _i1.MethodConnector(
          name: 'getSets',
          params: {
            'entryId': _i1.ParameterDescription(
              name: 'entryId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workout'] as _i6.WorkoutEndpoint).getSets(
                session,
                entryId: params['entryId'],
              ),
        ),
        'saveSet': _i1.MethodConnector(
          name: 'saveSet',
          params: {
            'workoutSet': _i1.ParameterDescription(
              name: 'workoutSet',
              type: _i1.getType<_i8.WorkoutSet>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workout'] as _i6.WorkoutEndpoint).saveSet(
                session,
                workoutSet: params['workoutSet'],
              ),
        ),
        'deleteSet': _i1.MethodConnector(
          name: 'deleteSet',
          params: {
            'setId': _i1.ParameterDescription(
              name: 'setId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['workout'] as _i6.WorkoutEndpoint).deleteSet(
                    session,
                    setId: params['setId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _i9.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _i10.Endpoints()
      ..initializeEndpoints(server);
  }
}
