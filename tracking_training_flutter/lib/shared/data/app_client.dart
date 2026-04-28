import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:tracking_training_client/tracking_training_client.dart';

/// Provides the [FlutterAuthSessionManager] instance.
///
/// Overridden in `main.dart` with the production instance.
final authSessionManagerProvider = Provider<FlutterAuthSessionManager>(
  (_) => throw StateError(
    'authSessionManagerProvider must be overridden before use.',
  ),
);

/// Provides the Serverpod [Client] instance.
///
/// Overridden in `main.dart` with the production instance.
final clientProvider = Provider<Client>(
  (_) => throw StateError('clientProvider must be overridden before use.'),
);
