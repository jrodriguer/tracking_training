import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:tracking_training_client/tracking_training_client.dart';

import 'app/app.dart';
import 'features/auth/application/auth_controller.dart';
import 'features/auth/data/serverpod_auth_service.dart';
import 'features/routines/application/routine_controller.dart';
import 'features/routines/data/serverpod_routine_repository.dart';
import 'features/workouts/application/workout_controller.dart';
import 'features/workouts/data/serverpod_workout_repository.dart';
import 'shared/data/app_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the API URL from the bundled config asset.
  final configJson = await rootBundle.loadString('assets/config.json');
  final config = jsonDecode(configJson) as Map<String, dynamic>;
  final apiUrl = config['apiUrl'] as String? ?? 'http://localhost:8080';

  final sessionManager = FlutterAuthSessionManager();
  final client = Client(apiUrl);
  client.authSessionManager = sessionManager;

  runApp(
    ProviderScope(
      overrides: [
        authSessionManagerProvider.overrideWithValue(sessionManager),
        clientProvider.overrideWithValue(client),
        authServiceProvider.overrideWith(
          (_) => ServerpodAuthService(
            client: client,
            sessionManager: sessionManager,
          ),
        ),
        routineRepositoryProvider.overrideWith(
          (_) => ServerpodRoutineRepository(client),
        ),
        workoutRepositoryProvider.overrideWith(
          (_) => ServerpodWorkoutRepository(client),
        ),
      ],
      child: const TrackingTrainingApp(),
    ),
  );
}
