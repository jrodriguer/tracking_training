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

abstract class WorkoutEntry implements _i1.SerializableModel {
  WorkoutEntry._({
    this.id,
    required this.sessionId,
    required this.exerciseTemplateId,
    required this.exerciseName,
  });

  factory WorkoutEntry({
    int? id,
    required int sessionId,
    required int exerciseTemplateId,
    required String exerciseName,
  }) = _WorkoutEntryImpl;

  factory WorkoutEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkoutEntry(
      id: jsonSerialization['id'] as int?,
      sessionId: jsonSerialization['sessionId'] as int,
      exerciseTemplateId: jsonSerialization['exerciseTemplateId'] as int,
      exerciseName: jsonSerialization['exerciseName'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Foreign key to the owning [WorkoutSession].
  int sessionId;

  /// Stable reference to the exercise definition.  Preserved even if the
  /// template is later renamed or removed.
  int exerciseTemplateId;

  /// Snapshot of the exercise name at logging time.
  String exerciseName;

  /// Returns a shallow copy of this [WorkoutEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkoutEntry copyWith({
    int? id,
    int? sessionId,
    int? exerciseTemplateId,
    String? exerciseName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkoutEntry',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'exerciseTemplateId': exerciseTemplateId,
      'exerciseName': exerciseName,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkoutEntryImpl extends WorkoutEntry {
  _WorkoutEntryImpl({
    int? id,
    required int sessionId,
    required int exerciseTemplateId,
    required String exerciseName,
  }) : super._(
         id: id,
         sessionId: sessionId,
         exerciseTemplateId: exerciseTemplateId,
         exerciseName: exerciseName,
       );

  /// Returns a shallow copy of this [WorkoutEntry]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkoutEntry copyWith({
    Object? id = _Undefined,
    int? sessionId,
    int? exerciseTemplateId,
    String? exerciseName,
  }) {
    return WorkoutEntry(
      id: id is int? ? id : this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseTemplateId: exerciseTemplateId ?? this.exerciseTemplateId,
      exerciseName: exerciseName ?? this.exerciseName,
    );
  }
}
