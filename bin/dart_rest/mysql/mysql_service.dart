import 'mysql.dart';
import 'package:synchronized/synchronized.dart';

enum JoinType {
  inner,
  left,
  right,
  full,
}

Map<String, dynamic> decodeMySqlRow(dynamic row) {
  if (row is Map<String, dynamic>) {
    return Map<String, dynamic>.from(row);
  }

  if (row is Map) {
    return Map<String, dynamic>.from(row);
  }

  try {
    final typed = (row as dynamic).typedAssoc();
    if (typed is Map<String, dynamic>) {
      return Map<String, dynamic>.from(typed);
    }
    if (typed is Map) {
      return Map<String, dynamic>.from(typed);
    }
  } catch (_) {}

  try {
    final assoc = (row as dynamic).assoc();
    if (assoc is Map<String, dynamic>) {
      return Map<String, dynamic>.from(assoc);
    }
    if (assoc is Map) {
      return Map<String, dynamic>.from(assoc);
    }
  } catch (_) {}

  throw StateError('Unsupported MySQL row type: ${row.runtimeType}');
}

class MySqlInitService {
  static final Lock _lock = Lock();

  /// 🔍 GET ALL
  Future<List<Map<String, dynamic>>> findAll(
    String table, {
    Map<String, dynamic>? where,
    int? limit,
    int? offset,
  }) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();

      final result = await conn.getAll(
        table: table,
        fields: '*',
        where: _mapToWhere(where),
        limit: limit,
        debug: false,
      );

      return List<Map<String, dynamic>>.from(result);
    });
  }

  /// 🔍 GET ONE
  Future<Map<String, dynamic>?> findOne(
    String table, {
    required Map<String, dynamic> where,
  }) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();

      final result = await conn.getOne(
        table: table,
        fields: '*',
        where: _mapToWhere(where),
        debug: false,
      );

      if (result.isEmpty) return null;
      return Map<String, dynamic>.from(result);
    });
  }

  /// 🔗 JOIN dinamis untuk kebutuhan SELECT/GET.
  ///
  /// Contoh relasi:
  /// {
  ///   'table': 'roles',
  ///   'sourceTable': 'user_roles',
  ///   'sourceKey': 'role_id',
  ///   'targetKey': 'role_id',
  ///   'type': 'INNER',
  /// }
  ///
  /// Catatan:
  /// - `fields` adalah fragmen SQL SELECT yang dipakai apa adanya.
  /// - `FULL OUTER JOIN` di MySQL diemulasikan dengan UNION dan saat ini
  ///   hanya didukung untuk satu relasi join.
  Future<List<Map<String, dynamic>>> join(
    String table, {
    required List<Map<String, dynamic>> joins,
    List<String>? fields,
    Map<String, dynamic>? where,
    JoinType joinType = JoinType.inner,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    return _lock.synchronized(() async {
      if (joins.isEmpty) {
        throw ArgumentError('joins must not be empty');
      }

      final conn = await MySqlInit.connect();
      final params = <Object?>[];
      final sql = _buildJoinQuery(
        table: table,
        joins: joins,
        fields: fields,
        where: where,
        defaultJoinType: joinType,
        orderBy: orderBy,
        limit: limit,
        offset: offset,
        params: params,
      );

      final result = await conn.query(
        sql,
        whereValues: params,
        debug: false,
        isStmt: true,
      );

      return result.rowsAssoc.map(decodeMySqlRow).toList();
    });
  }

  Future<List<Map<String, dynamic>>> innerJoin(
    String table, {
    required List<Map<String, dynamic>> joins,
    List<String>? fields,
    Map<String, dynamic>? where,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return join(
      table,
      joins: joins,
      fields: fields,
      where: where,
      joinType: JoinType.inner,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Map<String, dynamic>>> leftJoin(
    String table, {
    required List<Map<String, dynamic>> joins,
    List<String>? fields,
    Map<String, dynamic>? where,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return join(
      table,
      joins: joins,
      fields: fields,
      where: where,
      joinType: JoinType.left,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Map<String, dynamic>>> rightJoin(
    String table, {
    required List<Map<String, dynamic>> joins,
    List<String>? fields,
    Map<String, dynamic>? where,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return join(
      table,
      joins: joins,
      fields: fields,
      where: where,
      joinType: JoinType.right,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  Future<List<Map<String, dynamic>>> fullOuterJoin(
    String table, {
    required List<Map<String, dynamic>> joins,
    List<String>? fields,
    Map<String, dynamic>? where,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    return join(
      table,
      joins: joins,
      fields: fields,
      where: where,
      joinType: JoinType.full,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }

  /// ➕ CREATE
  Future<void> create(
    String table,
    Map<String, dynamic> data,
  ) async {
    await _lock.synchronized(() async {
      final conn = await MySqlInit.connect();
      await conn.insert(
        table: table,
        insertData: data,
        debug: true,
      );
    });
  }

  /// 🔁 UPDATE
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required Map<String, dynamic> where,
  }) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();
      final res = await conn.update(
        table: table,
        updateData: data,
        where: _mapToWhere(where),
        debug: true,
      );
      return res.toInt();
    });
  }

  /// 🗑 DELETE
  Future<int> destroy(
    String table, {
    required Map<String, dynamic> where,
  }) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();
      final res = await conn.delete(
        table: table,
        where: _mapToWhere(where),
        debug: true,
      );
      return res.toInt();
    });
  }

  /// Helper: convert where to valid format
  Map<String, dynamic> _mapToWhere(Map<String, dynamic>? where) {
    if (where == null || where.isEmpty) return {};

    final formatted = <String, dynamic>{};

    where.forEach((key, value) {
      if (value is Map) {
        value.forEach((op, val) {
          switch (op) {
            case r'$gt':
              formatted[key] = ['>', val];
              break;
            case r'$lt':
              formatted[key] = ['<', val];
              break;
            case r'$eq':
              formatted[key] = val;
              break;
            case r'$ne':
              formatted[key] = ['!=', val];
              break;
            case r'$like':
              formatted[key] = ['like', '%$val%'];
              break;
            case r'$in':
              formatted[key] = ['in', val];
              break;
          }
        });
      } else {
        formatted[key] = value;
      }
    });

    return formatted;
  }

  /// 🔢 COUNT
  Future<int> count(String table, {Map<String, dynamic>? where}) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();
      final res = await conn.count(
        table: table,
        where: _mapToWhere(where),
        debug: false,
      );
      return res;
    });
  }

  String _buildJoinQuery({
    required String table,
    required List<Map<String, dynamic>> joins,
    required List<Object?> params,
    List<String>? fields,
    Map<String, dynamic>? where,
    JoinType defaultJoinType = JoinType.inner,
    String? orderBy,
    int? limit,
    int? offset,
  }) {
    final baseTable = _escapeIdentifier(table);
    final selectFields =
        fields != null && fields.isNotEmpty ? fields.join(', ') : '$baseTable.*';

    final hasFullJoin = joins.any(
      (join) => _resolveJoinType(join['type'], defaultJoinType) == JoinType.full,
    );

    if (hasFullJoin) {
      if (joins.length != 1) {
        throw UnsupportedError(
          'FULL OUTER JOIN hanya didukung untuk satu relasi join',
        );
      }

      final join = joins.first;
      final sourceTable = _escapeIdentifier(
        (join['sourceTable'] as String?) ?? table,
      );
      final targetTable = _escapeIdentifier(join['table'] as String);
      final sourceKey = _escapeIdentifier(join['sourceKey'] as String);
      final targetKey = _escapeIdentifier(join['targetKey'] as String);
      final leftParams = <Object?>[];
      final rightParams = <Object?>[];
      final leftWhereClause = _buildWhereClause(where, leftParams);
      final rightWhereClause = _buildWhereClause(where, rightParams);
      final orderClause = _buildOrderBy(orderBy);
      final paginationClause = _buildPagination(limit: limit, offset: offset);

      final leftSql = '''
SELECT $selectFields
FROM $baseTable
LEFT JOIN $targetTable
  ON $sourceTable.$sourceKey = $targetTable.$targetKey
$leftWhereClause
''';

      final rightSql = '''
SELECT $selectFields
FROM $baseTable
RIGHT JOIN $targetTable
  ON $sourceTable.$sourceKey = $targetTable.$targetKey
$rightWhereClause
''';

      params
        ..addAll(leftParams)
        ..addAll(rightParams);

      return '''
$leftSql
UNION
$rightSql
$orderClause
$paginationClause
''';
    }

    final joinClauses = joins.map((join) {
      final joinTable = _escapeIdentifier(join['table'] as String);
      final sourceTable = _escapeIdentifier(
        (join['sourceTable'] as String?) ?? table,
      );
      final sourceKey = _escapeIdentifier(join['sourceKey'] as String);
      final targetKey = _escapeIdentifier(join['targetKey'] as String);
      final resolvedJoinType = _resolveJoinType(join['type'], defaultJoinType);

      return '''
${_joinTypeSql(resolvedJoinType)} JOIN $joinTable
  ON $sourceTable.$sourceKey = $joinTable.$targetKey''';
    }).join('\n');

    final whereClause = _buildWhereClause(where, params);
    final orderClause = _buildOrderBy(orderBy);
    final paginationClause = _buildPagination(limit: limit, offset: offset);

    return '''
SELECT $selectFields
FROM $baseTable
$joinClauses
$whereClause
$orderClause
$paginationClause
''';
  }

  JoinType _resolveJoinType(dynamic rawType, JoinType fallback) {
    if (rawType == null) return fallback;
    if (rawType is JoinType) return rawType;

    final normalized = rawType.toString().trim().toUpperCase();
    switch (normalized) {
      case 'INNER':
        return JoinType.inner;
      case 'LEFT':
      case 'LEFT OUTER':
        return JoinType.left;
      case 'RIGHT':
      case 'RIGHT OUTER':
        return JoinType.right;
      case 'FULL':
      case 'FULL OUTER':
      case 'FULL OUTER JOIN':
        return JoinType.full;
      default:
        throw ArgumentError('Unsupported join type: $rawType');
    }
  }

  String _joinTypeSql(JoinType type) {
    switch (type) {
      case JoinType.inner:
        return 'INNER';
      case JoinType.left:
        return 'LEFT';
      case JoinType.right:
        return 'RIGHT';
      case JoinType.full:
        return 'FULL OUTER';
    }
  }

  String _buildWhereClause(
    Map<String, dynamic>? where,
    List<Object?> params,
  ) {
    if (where == null || where.isEmpty) return '';

    final clauses = <String>[];

    where.forEach((key, value) {
      final field = _escapeFieldReference(key);

      if (value is Map) {
        value.forEach((op, rawVal) {
          switch (op) {
            case r'$gt':
              clauses.add('$field > ?');
              params.add(rawVal);
              break;
            case r'$lt':
              clauses.add('$field < ?');
              params.add(rawVal);
              break;
            case r'$eq':
              if (rawVal == null) {
                clauses.add('$field IS NULL');
              } else {
                clauses.add('$field = ?');
                params.add(rawVal);
              }
              break;
            case r'$ne':
              if (rawVal == null) {
                clauses.add('$field IS NOT NULL');
              } else {
                clauses.add('$field != ?');
                params.add(rawVal);
              }
              break;
            case r'$like':
              clauses.add('$field LIKE ?');
              params.add('%$rawVal%');
              break;
            case r'$in':
              final values = rawVal is Iterable ? rawVal.toList() : [rawVal];
              if (values.isEmpty) {
                clauses.add('1 = 0');
              } else {
                final placeholders = List.filled(values.length, '?').join(', ');
                clauses.add('$field IN ($placeholders)');
                params.addAll(values);
              }
              break;
            default:
              throw ArgumentError('Unsupported operator: $op');
          }
        });
      } else if (value == null) {
        clauses.add('$field IS NULL');
      } else {
        clauses.add('$field = ?');
        params.add(value);
      }
    });

    if (clauses.isEmpty) return '';
    return 'WHERE ${clauses.join(' AND ')}';
  }

  String _buildOrderBy(String? orderBy) {
    if (orderBy == null || orderBy.trim().isEmpty) return '';
    return 'ORDER BY ${_sanitizeOrderBy(orderBy)}';
  }

  String _buildPagination({
    int? limit,
    int? offset,
  }) {
    if (limit == null && offset == null) return '';
    if (limit != null && limit < 0) {
      throw ArgumentError('limit must be >= 0');
    }
    if (offset != null && offset < 0) {
      throw ArgumentError('offset must be >= 0');
    }
    if (limit == null) {
      return 'LIMIT 18446744073709551615 OFFSET $offset';
    }
    if (offset == null) {
      return 'LIMIT $limit';
    }
    return 'LIMIT $limit OFFSET $offset';
  }

  String _escapeIdentifier(String value) {
    final trimmed = value.trim();
    if (!RegExp(r'^[A-Za-z_][A-Za-z0-9_]*$').hasMatch(trimmed)) {
      throw ArgumentError('Invalid SQL identifier: $value');
    }
    return trimmed;
  }

  String _escapeFieldReference(String value) {
    final trimmed = value.trim();
    if (!RegExp(r'^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?$')
        .hasMatch(trimmed)) {
      throw ArgumentError('Invalid SQL field reference: $value');
    }

    final parts = trimmed.split('.');
    if (parts.length == 1) {
      return _escapeIdentifier(parts.first);
    }
    return '${_escapeIdentifier(parts.first)}.${_escapeIdentifier(parts.last)}';
  }

  String _sanitizeOrderBy(String value) {
    final trimmed = value.trim();
    if (!RegExp(
      r'^[A-Za-z_][A-Za-z0-9_]*(\.[A-Za-z_][A-Za-z0-9_]*)?(\s+(ASC|DESC))?$',
      caseSensitive: false,
    ).hasMatch(trimmed)) {
      throw ArgumentError('Invalid ORDER BY clause: $value');
    }
    return trimmed;
  }
}
