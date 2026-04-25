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

abstract class WorkoutSession implements _i1.SerializableModel {
  WorkoutSession._({
    this.id,
    required this.routineDayId,
    required this.routineDayTitle,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutSession({
    int? id,
    required int routineDayId,
    required String routineDayTitle,
    required DateTime startedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkoutSessionImpl;

  factory WorkoutSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkoutSession(
      id: jsonSerialization['id'] as int?,
      routineDayId: jsonSerialization['routineDayId'] as int,
      routineDayTitle: jsonSerialization['routineDayTitle'] as String,
      startedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startedAt'],
      ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The routine day this session was started from.
  int routineDayId;

  /// Snapshot of the routine day title at the time the session was created.
  /// Kept separate so routine renames do not mutate historical records.
  String routineDayTitle;

  /// User-selected workout date (may be earlier than [createdAt]).
  DateTime startedAt;

  /// Wall-clock time when this record was first saved.
  DateTime createdAt;

  /// Wall-clock time when this record was last modified.
  DateTime updatedAt;

  /// Returns a shallow copy of this [WorkoutSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkoutSession copyWith({
    int? id,
    int? routineDayId,
    String? routineDayTitle,
    DateTime? startedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkoutSession',
      if (id != null) 'id': id,
      'routineDayId': routineDayId,
      'routineDayTitle': routineDayTitle,
      'startedAt': startedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkoutSessionImpl extends WorkoutSession {
  _WorkoutSessionImpl({
    int? id,
    required int routineDayId,
    required String routineDayTitle,
    required DateTime startedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         routineDayId: routineDayId,
         routineDayTitle: routineDayTitle,
         startedAt: startedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [WorkoutSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkoutSession copyWith({
    Object? id = _Undefined,
    int? routineDayId,
    String? routineDayTitle,
    DateTime? startedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutSession(
      id: id is int? ? id : this.id,
      routineDayId: routineDayId ?? this.routineDayId,
      routineDayTitle: routineDayTitle ?? this.routineDayTitle,
      startedAt: startedAt ?? this.startedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
