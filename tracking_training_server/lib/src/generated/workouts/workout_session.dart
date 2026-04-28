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

abstract class WorkoutSession
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WorkoutSession._({
    this.id,
    required this.userId,
    required this.routineDayId,
    required this.routineDayTitle,
    required this.startedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WorkoutSession({
    int? id,
    required _i1.UuidValue userId,
    required int routineDayId,
    required String routineDayTitle,
    required DateTime startedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WorkoutSessionImpl;

  factory WorkoutSession.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkoutSession(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
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

  static final t = WorkoutSessionTable();

  static const db = WorkoutSessionRepository._();

  @override
  int? id;

  /// Auth user that owns this session.
  _i1.UuidValue userId;

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

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WorkoutSession]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkoutSession copyWith({
    int? id,
    _i1.UuidValue? userId,
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
      'userId': userId.toJson(),
      'routineDayId': routineDayId,
      'routineDayTitle': routineDayTitle,
      'startedAt': startedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkoutSession',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'routineDayId': routineDayId,
      'routineDayTitle': routineDayTitle,
      'startedAt': startedAt.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static WorkoutSessionInclude include() {
    return WorkoutSessionInclude._();
  }

  static WorkoutSessionIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkoutSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutSessionTable>? orderByList,
    WorkoutSessionInclude? include,
  }) {
    return WorkoutSessionIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkoutSession.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WorkoutSession.t),
      include: include,
    );
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
    required _i1.UuidValue userId,
    required int routineDayId,
    required String routineDayTitle,
    required DateTime startedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
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
    _i1.UuidValue? userId,
    int? routineDayId,
    String? routineDayTitle,
    DateTime? startedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkoutSession(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      routineDayId: routineDayId ?? this.routineDayId,
      routineDayTitle: routineDayTitle ?? this.routineDayTitle,
      startedAt: startedAt ?? this.startedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class WorkoutSessionUpdateTable extends _i1.UpdateTable<WorkoutSessionTable> {
  WorkoutSessionUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<int, int> routineDayId(int value) => _i1.ColumnValue(
    table.routineDayId,
    value,
  );

  _i1.ColumnValue<String, String> routineDayTitle(String value) =>
      _i1.ColumnValue(
        table.routineDayTitle,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> startedAt(DateTime value) =>
      _i1.ColumnValue(
        table.startedAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(
        table.createdAt,
        value,
      );

  _i1.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _i1.ColumnValue(
        table.updatedAt,
        value,
      );
}

class WorkoutSessionTable extends _i1.Table<int?> {
  WorkoutSessionTable({super.tableRelation})
    : super(tableName: 'workout_sessions') {
    updateTable = WorkoutSessionUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    routineDayId = _i1.ColumnInt(
      'routineDayId',
      this,
    );
    routineDayTitle = _i1.ColumnString(
      'routineDayTitle',
      this,
    );
    startedAt = _i1.ColumnDateTime(
      'startedAt',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final WorkoutSessionUpdateTable updateTable;

  /// Auth user that owns this session.
  late final _i1.ColumnUuid userId;

  /// The routine day this session was started from.
  late final _i1.ColumnInt routineDayId;

  /// Snapshot of the routine day title at the time the session was created.
  /// Kept separate so routine renames do not mutate historical records.
  late final _i1.ColumnString routineDayTitle;

  /// User-selected workout date (may be earlier than [createdAt]).
  late final _i1.ColumnDateTime startedAt;

  /// Wall-clock time when this record was first saved.
  late final _i1.ColumnDateTime createdAt;

  /// Wall-clock time when this record was last modified.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    routineDayId,
    routineDayTitle,
    startedAt,
    createdAt,
    updatedAt,
  ];
}

class WorkoutSessionInclude extends _i1.IncludeObject {
  WorkoutSessionInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WorkoutSession.t;
}

class WorkoutSessionIncludeList extends _i1.IncludeList {
  WorkoutSessionIncludeList._({
    _i1.WhereExpressionBuilder<WorkoutSessionTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkoutSession.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WorkoutSession.t;
}

class WorkoutSessionRepository {
  const WorkoutSessionRepository._();

  /// Returns a list of [WorkoutSession]s matching the given query parameters.
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
  Future<List<WorkoutSession>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutSessionTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutSessionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<WorkoutSession>(
      where: where?.call(WorkoutSession.t),
      orderBy: orderBy?.call(WorkoutSession.t),
      orderByList: orderByList?.call(WorkoutSession.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [WorkoutSession] matching the given query parameters.
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
  Future<WorkoutSession?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutSessionTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkoutSessionTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkoutSessionTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<WorkoutSession>(
      where: where?.call(WorkoutSession.t),
      orderBy: orderBy?.call(WorkoutSession.t),
      orderByList: orderByList?.call(WorkoutSession.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [WorkoutSession] by its [id] or null if no such row exists.
  Future<WorkoutSession?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<WorkoutSession>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [WorkoutSession]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkoutSession]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<WorkoutSession>> insert(
    _i1.DatabaseSession session,
    List<WorkoutSession> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<WorkoutSession>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [WorkoutSession] and returns the inserted row.
  ///
  /// The returned [WorkoutSession] will have its `id` field set.
  Future<WorkoutSession> insertRow(
    _i1.DatabaseSession session,
    WorkoutSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkoutSession>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WorkoutSession]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WorkoutSession>> update(
    _i1.DatabaseSession session,
    List<WorkoutSession> rows, {
    _i1.ColumnSelections<WorkoutSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WorkoutSession>(
      rows,
      columns: columns?.call(WorkoutSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkoutSession]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkoutSession> updateRow(
    _i1.DatabaseSession session,
    WorkoutSession row, {
    _i1.ColumnSelections<WorkoutSessionTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkoutSession>(
      row,
      columns: columns?.call(WorkoutSession.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkoutSession] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<WorkoutSession?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<WorkoutSessionUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<WorkoutSession>(
      id,
      columnValues: columnValues(WorkoutSession.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [WorkoutSession]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<WorkoutSession>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<WorkoutSessionUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<WorkoutSessionTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkoutSessionTable>? orderBy,
    _i1.OrderByListBuilder<WorkoutSessionTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<WorkoutSession>(
      columnValues: columnValues(WorkoutSession.t.updateTable),
      where: where(WorkoutSession.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkoutSession.t),
      orderByList: orderByList?.call(WorkoutSession.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [WorkoutSession]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WorkoutSession>> delete(
    _i1.DatabaseSession session,
    List<WorkoutSession> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WorkoutSession>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WorkoutSession].
  Future<WorkoutSession> deleteRow(
    _i1.DatabaseSession session,
    WorkoutSession row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkoutSession>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WorkoutSession>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<WorkoutSessionTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WorkoutSession>(
      where: where(WorkoutSession.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<WorkoutSessionTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WorkoutSession>(
      where: where?.call(WorkoutSession.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [WorkoutSession] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<WorkoutSessionTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<WorkoutSession>(
      where: where(WorkoutSession.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
