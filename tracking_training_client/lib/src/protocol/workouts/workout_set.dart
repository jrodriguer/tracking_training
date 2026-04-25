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

abstract class WorkoutSet implements _i1.SerializableModel {
  WorkoutSet._({
    this.id,
    required this.entryId,
    required this.setNumber,
    required this.reps,
    required this.weight,
    this.note,
  });

  factory WorkoutSet({
    int? id,
    required int entryId,
    required int setNumber,
    required int reps,
    required double weight,
    String? note,
  }) = _WorkoutSetImpl;

  factory WorkoutSet.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkoutSet(
      id: jsonSerialization['id'] as int?,
      entryId: jsonSerialization['entryId'] as int,
      setNumber: jsonSerialization['setNumber'] as int,
      reps: jsonSerialization['reps'] as int,
      weight: (jsonSerialization['weight'] as num).toDouble(),
      note: jsonSerialization['note'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Foreign key to the owning [WorkoutEntry].
  int entryId;

  /// 1-based set number within the entry.
  int setNumber;

  /// Repetition count for this set.
  int reps;

  /// Load lifted in kilograms.
  double weight;

  /// Optional freeform note for this set.
  String? note;

  /// Returns a shallow copy of this [WorkoutSet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkoutSet copyWith({
    int? id,
    int? entryId,
    int? setNumber,
    int? reps,
    double? weight,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkoutSet',
      if (id != null) 'id': id,
      'entryId': entryId,
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkoutSetImpl extends WorkoutSet {
  _WorkoutSetImpl({
    int? id,
    required int entryId,
    required int setNumber,
    required int reps,
    required double weight,
    String? note,
  }) : super._(
         id: id,
         entryId: entryId,
         setNumber: setNumber,
         reps: reps,
         weight: weight,
         note: note,
       );

  /// Returns a shallow copy of this [WorkoutSet]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkoutSet copyWith({
    Object? id = _Undefined,
    int? entryId,
    int? setNumber,
    int? reps,
    double? weight,
    Object? note = _Undefined,
  }) {
    return WorkoutSet(
      id: id is int? ? id : this.id,
      entryId: entryId ?? this.entryId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      note: note is String? ? note : this.note,
    );
  }
}
