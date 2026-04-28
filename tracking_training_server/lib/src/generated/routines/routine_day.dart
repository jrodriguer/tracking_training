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
import 'package:tracking_training_server/src/generated/protocol.dart' as _i2;

abstract class RoutineDay
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  RoutineDay._({
    this.id,
    required this.userId,
    required this.title,
    required this.sortOrder,
    required this.focusAreas,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RoutineDay({
    int? id,
    required _i1.UuidValue userId,
    required String title,
    required int sortOrder,
    required List<String> focusAreas,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RoutineDayImpl;

  factory RoutineDay.fromJson(Map<String, dynamic> jsonSerialization) {
    return RoutineDay(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
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

  static final t = RoutineDayTable();

  static const db = RoutineDayRepository._();

  @override
  int? id;

  /// Auth user that owns this routine day.
  _i1.UuidValue userId;

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

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [RoutineDay]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RoutineDay copyWith({
    int? id,
    _i1.UuidValue? userId,
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
      'userId': userId.toJson(),
      'title': title,
      'sortOrder': sortOrder,
      'focusAreas': focusAreas.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RoutineDay',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'title': title,
      'sortOrder': sortOrder,
      'focusAreas': focusAreas.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static RoutineDayInclude include() {
    return RoutineDayInclude._();
  }

  static RoutineDayIncludeList includeList({
    _i1.WhereExpressionBuilder<RoutineDayTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoutineDayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoutineDayTable>? orderByList,
    RoutineDayInclude? include,
  }) {
    return RoutineDayIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RoutineDay.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(RoutineDay.t),
      include: include,
    );
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
    required _i1.UuidValue userId,
    required String title,
    required int sortOrder,
    required List<String> focusAreas,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         userId: userId,
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
    _i1.UuidValue? userId,
    String? title,
    int? sortOrder,
    List<String>? focusAreas,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RoutineDay(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      focusAreas: focusAreas ?? this.focusAreas.map((e0) => e0).toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class RoutineDayUpdateTable extends _i1.UpdateTable<RoutineDayTable> {
  RoutineDayUpdateTable(super.table);

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> userId(_i1.UuidValue value) =>
      _i1.ColumnValue(
        table.userId,
        value,
      );

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<int, int> sortOrder(int value) => _i1.ColumnValue(
    table.sortOrder,
    value,
  );

  _i1.ColumnValue<List<String>, List<String>> focusAreas(List<String> value) =>
      _i1.ColumnValue(
        table.focusAreas,
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

class RoutineDayTable extends _i1.Table<int?> {
  RoutineDayTable({super.tableRelation}) : super(tableName: 'routine_days') {
    updateTable = RoutineDayUpdateTable(this);
    userId = _i1.ColumnUuid(
      'userId',
      this,
    );
    title = _i1.ColumnString(
      'title',
      this,
    );
    sortOrder = _i1.ColumnInt(
      'sortOrder',
      this,
    );
    focusAreas = _i1.ColumnSerializable<List<String>>(
      'focusAreas',
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

  late final RoutineDayUpdateTable updateTable;

  /// Auth user that owns this routine day.
  late final _i1.ColumnUuid userId;

  /// Display title (e.g. "Day 1" or a user-chosen name).
  late final _i1.ColumnString title;

  /// Position in the weekly split, starting at 0.
  late final _i1.ColumnInt sortOrder;

  /// Muscle-group labels for this day (e.g. ["Chest", "Shoulders"]).
  late final _i1.ColumnSerializable<List<String>> focusAreas;

  /// When this record was first created.
  late final _i1.ColumnDateTime createdAt;

  /// When this record was last modified.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    userId,
    title,
    sortOrder,
    focusAreas,
    createdAt,
    updatedAt,
  ];
}

class RoutineDayInclude extends _i1.IncludeObject {
  RoutineDayInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => RoutineDay.t;
}

class RoutineDayIncludeList extends _i1.IncludeList {
  RoutineDayIncludeList._({
    _i1.WhereExpressionBuilder<RoutineDayTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(RoutineDay.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => RoutineDay.t;
}

class RoutineDayRepository {
  const RoutineDayRepository._();

  /// Returns a list of [RoutineDay]s matching the given query parameters.
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
  Future<List<RoutineDay>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RoutineDayTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoutineDayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoutineDayTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<RoutineDay>(
      where: where?.call(RoutineDay.t),
      orderBy: orderBy?.call(RoutineDay.t),
      orderByList: orderByList?.call(RoutineDay.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [RoutineDay] matching the given query parameters.
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
  Future<RoutineDay?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RoutineDayTable>? where,
    int? offset,
    _i1.OrderByBuilder<RoutineDayTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<RoutineDayTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<RoutineDay>(
      where: where?.call(RoutineDay.t),
      orderBy: orderBy?.call(RoutineDay.t),
      orderByList: orderByList?.call(RoutineDay.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [RoutineDay] by its [id] or null if no such row exists.
  Future<RoutineDay?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<RoutineDay>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [RoutineDay]s in the list and returns the inserted rows.
  ///
  /// The returned [RoutineDay]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<RoutineDay>> insert(
    _i1.DatabaseSession session,
    List<RoutineDay> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<RoutineDay>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [RoutineDay] and returns the inserted row.
  ///
  /// The returned [RoutineDay] will have its `id` field set.
  Future<RoutineDay> insertRow(
    _i1.DatabaseSession session,
    RoutineDay row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<RoutineDay>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [RoutineDay]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<RoutineDay>> update(
    _i1.DatabaseSession session,
    List<RoutineDay> rows, {
    _i1.ColumnSelections<RoutineDayTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<RoutineDay>(
      rows,
      columns: columns?.call(RoutineDay.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RoutineDay]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<RoutineDay> updateRow(
    _i1.DatabaseSession session,
    RoutineDay row, {
    _i1.ColumnSelections<RoutineDayTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<RoutineDay>(
      row,
      columns: columns?.call(RoutineDay.t),
      transaction: transaction,
    );
  }

  /// Updates a single [RoutineDay] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<RoutineDay?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<RoutineDayUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<RoutineDay>(
      id,
      columnValues: columnValues(RoutineDay.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [RoutineDay]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<RoutineDay>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<RoutineDayUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<RoutineDayTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<RoutineDayTable>? orderBy,
    _i1.OrderByListBuilder<RoutineDayTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<RoutineDay>(
      columnValues: columnValues(RoutineDay.t.updateTable),
      where: where(RoutineDay.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(RoutineDay.t),
      orderByList: orderByList?.call(RoutineDay.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [RoutineDay]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<RoutineDay>> delete(
    _i1.DatabaseSession session,
    List<RoutineDay> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<RoutineDay>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [RoutineDay].
  Future<RoutineDay> deleteRow(
    _i1.DatabaseSession session,
    RoutineDay row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<RoutineDay>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<RoutineDay>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RoutineDayTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<RoutineDay>(
      where: where(RoutineDay.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<RoutineDayTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<RoutineDay>(
      where: where?.call(RoutineDay.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [RoutineDay] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<RoutineDayTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<RoutineDay>(
      where: where(RoutineDay.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
