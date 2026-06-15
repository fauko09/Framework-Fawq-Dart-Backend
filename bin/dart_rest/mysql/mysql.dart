import 'package:dotenv/dotenv.dart';
import 'package:mysql_utils/mysql_utils.dart';
import '../../env_loader.dart';

Future<T?> disposeCachedClient<T>(
  T? client,
  Future<void> Function(T client) closeClient,
) async {
  if (client == null) return null;
  await closeClient(client);
  return null;
}

String? normalizeEnvAssignmentValue(String key, String? value) {
  if (value == null) return null;

  final prefix = '$key=';
  if (value.startsWith(prefix)) {
    final normalized = value.substring(prefix.length);
    print(
      '⚠️ [ENV] Malformed value for $key detected. '
      'Using normalized value "$normalized".',
    );
    return normalized;
  }

  return value;
}

class MySqlInit {
  static MysqlUtils? _db;
  static DotEnv? _env;

  static Future<MysqlUtils> connect({bool forceNew = false}) async {
    if (forceNew) {
      _db = await disposeCachedClient<MysqlUtils>(
        _db,
        (db) => db.close(),
      );
    } else if (_db != null) {
      return _db!;
    }

    _env ??= EnvLoader.load();

    final host = normalizeEnvAssignmentValue(
          'DB_HOST',
          _env?['DB_HOST'],
        ) ??
        '127.0.0.1';
    final port = int.parse(
      normalizeEnvAssignmentValue('DB_PORT', _env!['DB_PORT']) ?? '3306',
    );
    final user =
        normalizeEnvAssignmentValue('DB_USER', _env?['DB_USER']) ?? 'root';
    final password =
        normalizeEnvAssignmentValue('DB_PASSWORD', _env?['DB_PASSWORD']) ?? '';
    final dbName =
        normalizeEnvAssignmentValue('DB_NAME', _env?['DB_NAME']) ?? '';

    print('🔌 [MySQL] Connecting via mysql_utils ($host:$port/$dbName)');

    _db = MysqlUtils(
      settings: MysqlUtilsSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: dbName,
        secure: false,
        pool: true,
        timeoutMs: 10000,
        sqlEscape: true,
        collation: 'utf8mb4_general_ci',
      ),
      errorLog: (e) => print('❌ [MySQL] ERROR: $e'),
      sqlLog: (s) => print('📥 [MySQL] SQL: $s'),
    );

    return _db!;
  }

  static Future<void> close() async {
    _db = await disposeCachedClient<MysqlUtils>(
      _db,
      (db) => db.close(),
    );
  }

  /// 🔥 Eksekusi DDL (CREATE, ALTER, DROP) lewat query mentah
  // static Future<void> safeDDL(String sql) async {
  //   final db = await connect(forceNew: true);
  //   try {
  //     await db.query(sql, debug: true);
  //     print('✅ [MySQL] DDL executed successfully');
  //   } catch (e) {
  //     print('❌ [MySQL] DDL ERROR');
  //     print('SQL: $sql');
  //     print('Message: $e');
  //     rethrow;
  //   }
  // }
  static Future<void> safeDDL(String sql) async {
    final db = await connect();
    try {
      await db.query(sql, debug: true);
      print('✅ [MySQL] DDL executed successfully');
    } catch (e) {
      final errStr = e.toString();

      if (errStr.contains('Duplicate column name')) {
        print('⚠️ [MySQL] Column already exists, skipping...');
      } else {
        print('❌ [MySQL] DDL ERROR');
        print('SQL: $sql');
        print('Message: $e');
        rethrow;
      }
    }
  }

  /// 🔥 Select schema info dari INFORMATION_SCHEMA

  static Future<List<Map<String, dynamic>>?> safeSchemaSelect(
    String sql,
    List<Object?> params,
  ) async {
    try {
      final db = await connect();

      final result = await db.query(
        sql,
        whereValues: params,
        debug: false,
        isStmt: true,
      );

      // result.rowsAssoc is List<MySQLResultRowAssoc>
      // each has .assoc() → Map<String, dynamic>
      return result.rowsAssoc
          .map((r) => r.assoc())
          .toList()
          .cast<Map<String, dynamic>>();
    } catch (e) {
      print('⚠️ [MySQL] Schema select failed: $e');
      return null;
    }
  }

  static Future<Set<String>> getExistingColumns(String table) async {
    final db = await connect();

    final sql = '''
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = '$table'
''';

    final result = await db.query(sql, debug: false);

    return result.rowsAssoc
        .map((r) => r.assoc()['COLUMN_NAME'] as String)
        .toSet();
  }

  static Future<Map<String, Map<String, dynamic>>> getExistingColumnDetails(
    String table,
  ) async {
    final rows = await safeSchemaSelect(
      '''
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, EXTRA
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = ?
''',
      [table],
    );

    if (rows == null) return {};

    final result = <String, Map<String, dynamic>>{};
    for (final row in rows) {
      final name = row['COLUMN_NAME'] as String?;
      if (name == null) continue;
      result[name] = Map<String, dynamic>.from(row);
    }
    return result;
  }

  static Future<Set<String>> getExistingUniqueColumns(String table) async {
    final rows = await safeSchemaSelect(
      '''
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.STATISTICS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = ?
AND NON_UNIQUE = 0
''',
      [table],
    );

    if (rows == null) return {};

    return rows
        .map((r) => r['COLUMN_NAME'] as String?)
        .whereType<String>()
        .toSet();
  }

  static Future<Set<String>> getExistingForeignKeys(String table) async {
    final rows = await safeSchemaSelect(
      '''
SELECT CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE_NAME = ?
AND CONSTRAINT_TYPE = 'FOREIGN KEY'
''',
      [table],
    );

    if (rows == null) return {};

    return rows
        .map((r) => r['CONSTRAINT_NAME'] as String?)
        .whereType<String>()
        .toSet();
  }
}
