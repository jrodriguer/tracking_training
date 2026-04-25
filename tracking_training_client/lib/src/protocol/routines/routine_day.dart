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
import 'package:tracking_training_client/src/protocol/protocol.dart' as _i2;

abstract class RoutineDay implements _i1.SerializableModel {
  RoutineDay._({
    this.id,
    required this.title,
    required this.sortOrder,
    required this.focusAreas,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoutineDay({
    int? id,
    required String title,
    required int sortOrder,
    required List<String> focusAreas,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RoutineDayImpl;

  factory RoutineDay.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoutineDay(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      sortOrder: jsonSerialization['sortOrder'] as int,
      focusAreas: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['focusAreas'],
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

  /// Display title (e.g. "Day 1" or a user-chosen name).
  String title;

  /// Position in the weekly split, starting at 0.
  int sortOrder;

  /// Muscle-group labels for this day (e.g. ["Chest", "Shoulders"]).
  List<String> focusAreas;

  /// When this record was first created.
  DateTime createdAt;

  /// When this record was last modified.
  DateTime updatedAt;

  /// Returns a shallow copy of this [RoutineDay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RoutineDay copyWith({
    int? id,
    String? title,
    int? sortOrder,
    List<String>? focusAreas,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RoutineDay',
      if (id != null) 'id': id,
      'title': title,
      'sortOrder': sortOrder,
      'focusAreas': focusAreas.toJson(),
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

class _RoutineDayImpl extends RoutineDay {
  _RoutineDayImpl({
    int? id,
    required String title,
    required int sortOrder,
    required List<String> focusAreas,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         title: title,
         sortOrder: sortOrder,
         focusAreas: focusAreas,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RoutineDay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RoutineDay copyWith({
    Object? id = _Undefined,
    String? title,
    int? sortOrder,
    List<String>? focusAreas,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoutineDay(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      focusAreas: focusAreas ?? this.focusAreas.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
