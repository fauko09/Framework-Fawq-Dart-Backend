import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:mysql_utils/mysql_utils.dart';
import '../../env_loader.dart';

class MySqlInit {
  static MysqlUtils? _db;
  static DotEnv? _env;

  static Future<MysqlUtils> connect({bool forceNew = false}) async {
    if (!forceNew && _db != null) return _db!;

    _env ??= EnvLoader.load();

    final host = _env?['DB_HOST'] ?? '127.0.0.1';
    final port = int.parse(_env!['DB_PORT'] ?? '3306');
    final user = _env?['DB_USER'] ?? 'root';
    final password = _env?['DB_PASSWORD'] ?? '';
    final dbName = _env?['DB_NAME'] ?? '';

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
    final db = await connect(forceNew: true);
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

      final result = await db.query(sql, whereValues: params, debug: false);

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
}
