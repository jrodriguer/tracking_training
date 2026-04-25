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

abstract class ExerciseTemplate implements _i1.SerializableModel {
  ExerciseTemplate._({
    this.id,
    required this.routineDayId,
    required this.name,
    this.note,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExerciseTemplate({
    int? id,
    required int routineDayId,
    required String name,
    String? note,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ExerciseTemplateImpl;

  factory ExerciseTemplate.fromJson(Map<String, dynamic> jsonSerialization) {
    return ExerciseTemplate(
      id: jsonSerialization['id'] as int?,
      routineDayId: jsonSerialization['routineDayId'] as int,
      name: jsonSerialization['name'] as String,
      note: jsonSerialization['note'] as String?,
      sortOrder: jsonSerialization['sortOrder'] as int,
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

  /// Foreign key to the owning [RoutineDay].
  int routineDayId;

  /// Display name of the exercise.
  String name;

  /// Optional coaching note or cue shown during logging.
  String? note;

  /// Position within the day's exercise list, starting at 0.
  int sortOrder;

  /// When this record was first created.
  DateTime createdAt;

  /// When this record was last modified.
  DateTime updatedAt;

  /// Returns a shallow copy of this [ExerciseTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ExerciseTemplate copyWith({
    int? id,
    int? routineDayId,
    String? name,
    String? note,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ExerciseTemplate',
      if (id != null) 'id': id,
      'routineDayId': routineDayId,
      'name': name,
      if (note != null) 'note': note,
      'sortOrder': sortOrder,
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

class _ExerciseTemplateImpl extends ExerciseTemplate {
  _ExerciseTemplateImpl({
    int? id,
    required int routineDayId,
    required String name,
    String? note,
    required int sortOrder,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         routineDayId: routineDayId,
         name: name,
         note: note,
         sortOrder: sortOrder,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ExerciseTemplate]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ExerciseTemplate copyWith({
    Object? id = _Undefined,
    int? routineDayId,
    String? name,
    Object? note = _Undefined,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExerciseTemplate(
      id: id is int? ? id : this.id,
      routineDayId: routineDayId ?? this.routineDayId,
      name: name ?? this.name,
      note: note is String? ? note : this.note,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
