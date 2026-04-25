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

abstract class ExerciseTemplate
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ExerciseTemplateTable();

  static const db = ExerciseTemplateRepository._();

  @override
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

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ExerciseTemplateInclude include() {
    return ExerciseTemplateInclude._();
  }

  static ExerciseTemplateIncludeList includeList({
    _i1.WhereExpressionBuilder<ExerciseTemplateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseTemplateTable>? orderByList,
    ExerciseTemplateInclude? include,
  }) {
    return ExerciseTemplateIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseTemplate.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(ExerciseTemplate.t),
      include: include,
    );
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

class ExerciseTemplateUpdateTable
    extends _i1.UpdateTable<ExerciseTemplateTable> {
  ExerciseTemplateUpdateTable(super.table);

  _i1.ColumnValue<int, int> routineDayId(int value) => _i1.ColumnValue(
    table.routineDayId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> note(String? value) => _i1.ColumnValue(
    table.note,
    value,
  );

  _i1.ColumnValue<int, int> sortOrder(int value) => _i1.ColumnValue(
    table.sortOrder,
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

class ExerciseTemplateTable extends _i1.Table<int?> {
  ExerciseTemplateTable({super.tableRelation})
    : super(tableName: 'exercise_templates') {
    updateTable = ExerciseTemplateUpdateTable(this);
    routineDayId = _i1.ColumnInt(
      'routineDayId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    note = _i1.ColumnString(
      'note',
      this,
    );
    sortOrder = _i1.ColumnInt(
      'sortOrder',
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

  late final ExerciseTemplateUpdateTable updateTable;

  /// Foreign key to the owning [RoutineDay].
  late final _i1.ColumnInt routineDayId;

  /// Display name of the exercise.
  late final _i1.ColumnString name;

  /// Optional coaching note or cue shown during logging.
  late final _i1.ColumnString note;

  /// Position within the day's exercise list, starting at 0.
  late final _i1.ColumnInt sortOrder;

  /// When this record was first created.
  late final _i1.ColumnDateTime createdAt;

  /// When this record was last modified.
  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    routineDayId,
    name,
    note,
    sortOrder,
    createdAt,
    updatedAt,
  ];
}

class ExerciseTemplateInclude extends _i1.IncludeObject {
  ExerciseTemplateInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => ExerciseTemplate.t;
}

class ExerciseTemplateIncludeList extends _i1.IncludeList {
  ExerciseTemplateIncludeList._({
    _i1.WhereExpressionBuilder<ExerciseTemplateTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ExerciseTemplate.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => ExerciseTemplate.t;
}

class ExerciseTemplateRepository {
  const ExerciseTemplateRepository._();

  /// Returns a list of [ExerciseTemplate]s matching the given query parameters.
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
  Future<List<ExerciseTemplate>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseTemplateTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseTemplateTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ExerciseTemplate>(
      where: where?.call(ExerciseTemplate.t),
      orderBy: orderBy?.call(ExerciseTemplate.t),
      orderByList: orderByList?.call(ExerciseTemplate.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [ExerciseTemplate] matching the given query parameters.
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
  Future<ExerciseTemplate?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseTemplateTable>? where,
    int? offset,
    _i1.OrderByBuilder<ExerciseTemplateTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ExerciseTemplateTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ExerciseTemplate>(
      where: where?.call(ExerciseTemplate.t),
      orderBy: orderBy?.call(ExerciseTemplate.t),
      orderByList: orderByList?.call(ExerciseTemplate.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ExerciseTemplate] by its [id] or null if no such row exists.
  Future<ExerciseTemplate?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ExerciseTemplate>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ExerciseTemplate]s in the list and returns the inserted rows.
  ///
  /// The returned [ExerciseTemplate]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<ExerciseTemplate>> insert(
    _i1.DatabaseSession session,
    List<ExerciseTemplate> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<ExerciseTemplate>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [ExerciseTemplate] and returns the inserted row.
  ///
  /// The returned [ExerciseTemplate] will have its `id` field set.
  Future<ExerciseTemplate> insertRow(
    _i1.DatabaseSession session,
    ExerciseTemplate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<ExerciseTemplate>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseTemplate]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<ExerciseTemplate>> update(
    _i1.DatabaseSession session,
    List<ExerciseTemplate> rows, {
    _i1.ColumnSelections<ExerciseTemplateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<ExerciseTemplate>(
      rows,
      columns: columns?.call(ExerciseTemplate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExerciseTemplate]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ExerciseTemplate> updateRow(
    _i1.DatabaseSession session,
    ExerciseTemplate row, {
    _i1.ColumnSelections<ExerciseTemplateTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<ExerciseTemplate>(
      row,
      columns: columns?.call(ExerciseTemplate.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ExerciseTemplate] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ExerciseTemplate?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ExerciseTemplateUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<ExerciseTemplate>(
      id,
      columnValues: columnValues(ExerciseTemplate.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ExerciseTemplate]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<ExerciseTemplate>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ExerciseTemplateUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<ExerciseTemplateTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ExerciseTemplateTable>? orderBy,
    _i1.OrderByListBuilder<ExerciseTemplateTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<ExerciseTemplate>(
      columnValues: columnValues(ExerciseTemplate.t.updateTable),
      where: where(ExerciseTemplate.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ExerciseTemplate.t),
      orderByList: orderByList?.call(ExerciseTemplate.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [ExerciseTemplate]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<ExerciseTemplate>> delete(
    _i1.DatabaseSession session,
    List<ExerciseTemplate> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<ExerciseTemplate>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [ExerciseTemplate].
  Future<ExerciseTemplate> deleteRow(
    _i1.DatabaseSession session,
    ExerciseTemplate row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ExerciseTemplate>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<ExerciseTemplate>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ExerciseTemplateTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<ExerciseTemplate>(
      where: where(ExerciseTemplate.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ExerciseTemplateTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<ExerciseTemplate>(
      where: where?.call(ExerciseTemplate.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ExerciseTemplate] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ExerciseTemplateTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ExerciseTemplate>(
      where: where(ExerciseTemplate.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
