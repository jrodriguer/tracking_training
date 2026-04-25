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

abstract class WorkoutSet
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = WorkoutSetTable();

  static const db = WorkoutSetRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static WorkoutSetInclude include() {
    return WorkoutSetInclude._();
  }

  static WorkoutSetIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkoutSetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutSetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutSetTable>? orderByList,
    WorkoutSetInclude? include,
  }) {
    return WorkoutSetIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkoutSet.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WorkoutSet.t),
      include: include,
    );
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

class WorkoutSetUpdateTable extends _i1.UpdateTable<WorkoutSetTable> {
  WorkoutSetUpdateTable(super.table);

  _i1.ColumnValue<int, int> entryId(int value) => _i1.ColumnValue(
    table.entryId,
    value,
  );

  _i1.ColumnValue<int, int> setNumber(int value) => _i1.ColumnValue(
    table.setNumber,
    value,
  );

  _i1.ColumnValue<int, int> reps(int value) => _i1.ColumnValue(
    table.reps,
    value,
  );

  _i1.ColumnValue<double, double> weight(double value) => _i1.ColumnValue(
    table.weight,
    value,
  );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );
}

class WorkoutSetTable extends _i1.Table<int?> {
  WorkoutSetTable({super.tableRelation}) : super(tableName: 'workout_sets') {
    updateTable = WorkoutSetUpdateTable(this);
    entryId = _i1.ColumnInt(
      'entryId',
      this,
    );
    setNumber = _i1.ColumnInt(
      'setNumber',
      this,
    );
    reps = _i1.ColumnInt(
      'reps',
      this,
    );
    weight = _i1.ColumnDouble(
      'weight',
      this,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
  }

  late final WorkoutSetUpdateTable updateTable;

  /// Foreign key to the owning [WorkoutEntry].
  late final _i1.ColumnInt entryId;

  /// 1-based set number within the entry.
  late final _i1.ColumnInt setNumber;

  /// Repetition count for this set.
  late final _i1.ColumnInt reps;

  /// Load lifted in kilograms.
  late final _i1.ColumnDouble weight;

  /// Optional freeform note for this set.
  late final _i1.ColumnString note;

  @override
  List<_i1.Column> get columns => [
    id,
    entryId,
    setNumber,
    reps,
    weight,
    note,
  ];
}

class WorkoutSetInclude extends _i1.IncludeObject {
  WorkoutSetInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WorkoutSet.t;
}

class WorkoutSetIncludeList extends _i1.IncludeList {
  WorkoutSetIncludeList._({
    _i1.WhereExpressionBuilder<WorkoutSetTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkoutSet.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WorkoutSet.t;
}

class WorkoutSetRepository {
  const WorkoutSetRepository._();

  /// Returns a list of [WorkoutSet]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<WorkoutSet>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutSetTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutSetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutSetTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WorkoutSet>(
      where: where?.call(WorkoutSet.t),
      orderBy: orderBy?.call(WorkoutSet.t),
      orderByList: orderByList?.call(WorkoutSet.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WorkoutSet] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<WorkoutSet?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutSetTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkoutSetTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutSetTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WorkoutSet>(
      where: where?.call(WorkoutSet.t),
      orderBy: orderBy?.call(WorkoutSet.t),
      orderByList: orderByList?.call(WorkoutSet.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WorkoutSet] by its [id] or null if no such row exists.
  Future<WorkoutSet?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WorkoutSet>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WorkoutSet]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkoutSet]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<WorkoutSet>> insert(
    _i1.DatabaseSession session,
    List<WorkoutSet> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<WorkoutSet>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [WorkoutSet] and returns the inserted row.
  ///
  /// The returned [WorkoutSet] will have its `id` field set.
  Future<WorkoutSet> insertRow(
    _i1.DatabaseSession session,
    WorkoutSet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkoutSet>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WorkoutSet]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WorkoutSet>> update(
    _i1.DatabaseSession session,
    List<WorkoutSet> rows, {
    _i1.ColumnSelections<WorkoutSetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WorkoutSet>(
      rows,
      columns: columns?.call(WorkoutSet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkoutSet]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkoutSet> updateRow(
    _i1.DatabaseSession session,
    WorkoutSet row, {
    _i1.ColumnSelections<WorkoutSetTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkoutSet>(
      row,
      columns: columns?.call(WorkoutSet.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkoutSet] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WorkoutSet?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<WorkoutSetUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<WorkoutSet>(
      id,
      columnValues: columnValues(WorkoutSet.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WorkoutSet]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<WorkoutSet>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<WorkoutSetUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<WorkoutSetTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutSetTable>? orderBy,
    _i1.OrderByListBuilder<WorkoutSetTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<WorkoutSet>(
      columnValues: columnValues(WorkoutSet.t.updateTable),
      where: where(WorkoutSet.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkoutSet.t),
      orderByList: orderByList?.call(WorkoutSet.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [WorkoutSet]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WorkoutSet>> delete(
    _i1.DatabaseSession session,
    List<WorkoutSet> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WorkoutSet>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WorkoutSet].
  Future<WorkoutSet> deleteRow(
    _i1.DatabaseSession session,
    WorkoutSet row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkoutSet>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WorkoutSet>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<WorkoutSetTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WorkoutSet>(
      where: where(WorkoutSet.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutSetTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WorkoutSet>(
      where: where?.call(WorkoutSet.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WorkoutSet] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<WorkoutSetTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WorkoutSet>(
      where: where(WorkoutSet.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
