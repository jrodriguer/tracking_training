import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

/// Returns the authenticated user ID from [session].
///
/// Throws when the session carries no valid authentication token.
/// Only call this from endpoint methods where
/// [Endpoint.requireLogin] is `true` — in that case Serverpod already
/// blocks unauthenticated requests before this helper is reached, so the
/// guard here is a belt-and-suspenders safety check.
Future<UuidValue> requireUserId(Session session) async {
  final info = session.authenticated;
  if (info == null) throw Exception('Authentication required.');
  return info.authUserId;
}
