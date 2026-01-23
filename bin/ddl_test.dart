import 'package:mysql_utils/mysql_utils.dart';
import 'package:dotenv/dotenv.dart';

Future<void> main() async {
  final env = DotEnv(includePlatformEnvironment: true)..load();

  final db = MysqlUtils(
    settings: MysqlUtilsSettings(
      host: env['DB_HOST'] ?? '127.0.0.1',
      port: int.parse(env['DB_PORT'] ?? '3306'),
      user: env['DB_USER'].toString(),
      password: env['DB_PASSWORD'] ?? '',
      db: env['DB_NAME'].toString(),
      secure: false,
      prefix: '',
      pool: true,
      timeoutMs: 10000,
      sqlEscape: true,
    ),
    errorLog: (e) => print('DB ERROR: $e'),
    sqlLog: (s) => print('SQL EXEC: $s'),
  );

  // 🔹 DDL: Create table
  final createSql = '''
    CREATE TABLE IF NOT EXISTS example_model (
      example_model_id VARCHAR(50) PRIMARY KEY,
      name VARCHAR(30)
    );
  ''';

  try {
    final result = await db.query(
      createSql,
      debug: true,  // true akan print sql + params
    );
    print('CREATE TABLE successful: $result');
  } catch (e) {
    print('CREATE TABLE ERROR: $e');
  } finally {
    await db.close();
  }
}
