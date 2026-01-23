import 'package:dotenv/dotenv.dart';
import '../mysql/mysql.dart';
import 'model.dart';
import '../model_registry.dart';

class Migrator {
  static final DotEnv _env =
      DotEnv(includePlatformEnvironment: true)..load();

  static bool get _force =>
      _env['DB_SYNC_FORCE']?.toLowerCase() == 'true';

  static bool get _alter =>
      _env['DB_SYNC_ALTER']?.toLowerCase() == 'true';

  static Future<void> init() async {
    _validateFlags();

    print('🚀 [Migrator] Starting migration');
    print('⚙️  Mode => force=$_force | alter=$_alter');
    print('📦 Models => ${registeredModels.length}');
    print('---------------------------------------');

    for (final model in registeredModels) {
      await sync(model);
    }

    print('🎉 [Migrator] Migration finished');
  }

  static Future<void> sync(Model model) async {
    final table = model.table;
    print('\n📄 [Migrator] Sync model: $table');

    if (_force) {
      print('🔥 [Migrator:$table] FORCE DROP');
      await MySqlInit.safeDDL('DROP TABLE IF EXISTS `$table`');
    }

    await _createTable(model);

    if (_alter) {
      await _alterTable(model);
    }

    print('✅ [Migrator:$table] Sync complete');
  }

  static Future<void> _createTable(Model model) async {
    final schema = model.schema;
    final columnSql = <String>[];
    final primaryKeys = <String>[];

    print('🧱 [Migrator:${model.table}] Preparing CREATE TABLE');

    schema.forEach((name, column) {
      final buffer = StringBuffer('`$name` ${column.type}');
      if (!column.nullable) buffer.write(' NOT NULL');
      if (column.unique) buffer.write(' UNIQUE');
      if (column.defaultValue != null) {
        buffer.write(' DEFAULT ${column.defaultValue}');
      }

      print('   ➕ column: $name (${column.type})');
      columnSql.add(buffer.toString());

      if (column.primaryKey) {
        primaryKeys.add('`$name`');
        print('   🔑 primary key: $name');
      }
    });

    if (primaryKeys.isNotEmpty) {
      columnSql.add('PRIMARY KEY (${primaryKeys.join(', ')})');
    }

    final sql = '''
CREATE TABLE IF NOT EXISTS `${model.table}` (
  ${columnSql.join(',\n  ')}
) ENGINE=InnoDB;
''';

    print('🧱 [Migrator:${model.table}] Executing CREATE TABLE');
    await MySqlInit.safeDDL(sql);
  }

  static Future<void> _alterTable(Model model) async {
  print('🛠 [Migrator:${model.table}] Checking ALTER');

  final existing = await MySqlInit.getExistingColumns(model.table);

  bool changed = false;

  for (final entry in model.schema.entries) {
    if (existing.contains(entry.key)) {
      print('   ⏭  SKIP ${entry.key} (already exists)');
      continue;
    }

    print('   ➕ ADD COLUMN ${entry.key}');
    await MySqlInit.safeDDL(
      'ALTER TABLE `${model.table}` ADD COLUMN `${entry.key}` ${entry.value.type}',
    );
    changed = true;
  }

  if (!changed) {
    print('   ℹ️  No schema change needed');
  }
}


//   static Future<void> _alterTable(Model model) async {
//     print('🛠 [Migrator:${model.table}] Checking ALTER');

//     final rows = await MySqlInit.safeSchemaSelect(
//       '''
// SELECT COLUMN_NAME
// FROM INFORMATION_SCHEMA.COLUMNS
// WHERE TABLE_SCHEMA = DATABASE()
// AND TABLE_NAME = ?
// ''',
//       [model.table],
//     );

//     if (rows == null) {
//       print('   ⚠️ Schema inspection skipped (failed)');
//       return;
//     }

//     final existing = rows.map((r) => r['COLUMN_NAME']).toSet();
//     bool changed = false;

//     for (final entry in model.schema.entries) {
//       if (!existing.contains(entry.key)) {
//         print('   ➕ ADD COLUMN ${entry.key}');
//         await MySqlInit.safeDDL(
//           'ALTER TABLE `${model.table}` ADD COLUMN `${entry.key}` ${entry.value.type}',
//         );
//         changed = true;
//       }
//     }

//     if (!changed) {
//       print('   ℹ️  No schema change needed');
//     }
//   }

  static void _validateFlags() {
    if (_force && _alter) {
      throw Exception('❌ DB_SYNC_FORCE & DB_SYNC_ALTER cannot both true');
    }

    if ((_env['APP_ENV'] ?? 'development') == 'production' &&
        (_force || _alter)) {
      throw Exception('❌ Migration forbidden in production');
    }
  }
}
