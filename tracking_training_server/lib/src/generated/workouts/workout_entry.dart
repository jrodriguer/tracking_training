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

abstract class WorkoutEntry
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = WorkoutEntryTable();

  static const db = WorkoutEntryRepository._();

  @override
  int? id;

  /// Foreign key to the owning [WorkoutSession].
  int sessionId;

  /// Stable reference to the exercise definition.  Preserved even if the
  /// template is later renamed or removed.
  int exerciseTemplateId;

  /// Snapshot of the exercise name at logging time.
  String exerciseName;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkoutEntry',
      if (id != null) 'id': id,
      'sessionId': sessionId,
      'exerciseTemplateId': exerciseTemplateId,
      'exerciseName': exerciseName,
    };
  }

  static WorkoutEntryInclude include() {
    return WorkoutEntryInclude._();
  }

  static WorkoutEntryIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkoutEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutEntryTable>? orderByList,
    WorkoutEntryInclude? include,
  }) {
    return WorkoutEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkoutEntry.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WorkoutEntry.t),
      include: include,
    );
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

class WorkoutEntryUpdateTable extends _i1.UpdateTable<WorkoutEntryTable> {
  WorkoutEntryUpdateTable(super.table);

  _i1.ColumnValue<int, int> sessionId(int value) => _i1.ColumnValue(
    table.sessionId,
    value,
  );

  _i1.ColumnValue<int, int> exerciseTemplateId(int value) => _i1.ColumnValue(
    table.exerciseTemplateId,
    value,
  );

  _i1.ColumnValue<String, String> exerciseName(String value) => _i1.ColumnValue(
    table.exerciseName,
    value,
  );
}

class WorkoutEntryTable extends _i1.Table<int?> {
  WorkoutEntryTable({super.tableRelation})
    : super(tableName: 'workout_entries') {
    updateTable = WorkoutEntryUpdateTable(this);
    sessionId = _i1.ColumnInt(
      'sessionId',
      this,
    );
    exerciseTemplateId = _i1.ColumnInt(
      'exerciseTemplateId',
      this,
    );
    exerciseName = _i1.ColumnString(
      'exerciseName',
      this,
    );
  }

  late final WorkoutEntryUpdateTable updateTable;

  /// Foreign key to the owning [WorkoutSession].
  late final _i1.ColumnInt sessionId;

  /// Stable reference to the exercise definition.  Preserved even if the
  /// template is later renamed or removed.
  late final _i1.ColumnInt exerciseTemplateId;

  /// Snapshot of the exercise name at logging time.
  late final _i1.ColumnString exerciseName;

  @override
  List<_i1.Column> get columns => [
    id,
    sessionId,
    exerciseTemplateId,
    exerciseName,
  ];
}

class WorkoutEntryInclude extends _i1.IncludeObject {
  WorkoutEntryInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WorkoutEntry.t;
}

class WorkoutEntryIncludeList extends _i1.IncludeList {
  WorkoutEntryIncludeList._({
    _i1.WhereExpressionBuilder<WorkoutEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkoutEntry.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WorkoutEntry.t;
}

class WorkoutEntryRepository {
  const WorkoutEntryRepository._();

  /// Returns a list of [WorkoutEntry]s matching the given query parameters.
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
  Future<List<WorkoutEntry>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutEntryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WorkoutEntry>(
      where: where?.call(WorkoutEntry.t),
      orderBy: orderBy?.call(WorkoutEntry.t),
      orderByList: orderByList?.call(WorkoutEntry.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WorkoutEntry] matching the given query parameters.
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
  Future<WorkoutEntry?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutEntryTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkoutEntryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutEntryTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WorkoutEntry>(
      where: where?.call(WorkoutEntry.t),
      orderBy: orderBy?.call(WorkoutEntry.t),
      orderByList: orderByList?.call(WorkoutEntry.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WorkoutEntry] by its [id] or null if no such row exists.
  Future<WorkoutEntry?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WorkoutEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WorkoutEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkoutEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<WorkoutEntry>> insert(
    _i1.DatabaseSession session,
    List<WorkoutEntry> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<WorkoutEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [WorkoutEntry] and returns the inserted row.
  ///
  /// The returned [WorkoutEntry] will have its `id` field set.
  Future<WorkoutEntry> insertRow(
    _i1.DatabaseSession session,
    WorkoutEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkoutEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WorkoutEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WorkoutEntry>> update(
    _i1.DatabaseSession session,
    List<WorkoutEntry> rows, {
    _i1.ColumnSelections<WorkoutEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WorkoutEntry>(
      rows,
      columns: columns?.call(WorkoutEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkoutEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkoutEntry> updateRow(
    _i1.DatabaseSession session,
    WorkoutEntry row, {
    _i1.ColumnSelections<WorkoutEntryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkoutEntry>(
      row,
      columns: columns?.call(WorkoutEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkoutEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WorkoutEntry?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<WorkoutEntryUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<WorkoutEntry>(
      id,
      columnValues: columnValues(WorkoutEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WorkoutEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<WorkoutEntry>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<WorkoutEntryUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<WorkoutEntryTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutEntryTable>? orderBy,
    _i1.OrderByListBuilder<WorkoutEntryTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<WorkoutEntry>(
      columnValues: columnValues(WorkoutEntry.t.updateTable),
      where: where(WorkoutEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkoutEntry.t),
      orderByList: orderByList?.call(WorkoutEntry.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [WorkoutEntry]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WorkoutEntry>> delete(
    _i1.DatabaseSession session,
    List<WorkoutEntry> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WorkoutEntry>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WorkoutEntry].
  Future<WorkoutEntry> deleteRow(
    _i1.DatabaseSession session,
    WorkoutEntry row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkoutEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WorkoutEntry>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<WorkoutEntryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WorkoutEntry>(
      where: where(WorkoutEntry.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutEntryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WorkoutEntry>(
      where: where?.call(WorkoutEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WorkoutEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<WorkoutEntryTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WorkoutEntry>(
      where: where(WorkoutEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
