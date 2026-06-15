import 'package:dotenv/dotenv.dart';
import '../mysql/mysql.dart';
import 'model.dart';
import '../model_registry.dart';
import 'column.dart';
import 'relation.dart';

class Migrator {
  static final DotEnv _env = DotEnv(includePlatformEnvironment: true)..load();

  static bool get _force => _env['DB_SYNC_FORCE']?.toLowerCase() == 'true';

  static bool get _alter => _env['DB_SYNC_ALTER']?.toLowerCase() == 'true';

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

    await _syncUniqueConstraints(model);
    await _syncForeignKeys(model);

    print('✅ [Migrator:$table] Sync complete');
  }

  static Future<void> _createTable(Model model) async {
    final schema = model.schema;
    final columnSql = <String>[];
    final primaryKeys = <String>[];

    print('🧱 [Migrator:${model.table}] Preparing CREATE TABLE');

    schema.forEach((name, column) {
      print('   ➕ column: $name (${column.type})');
      columnSql.add(buildColumnDefinition(name, column));

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

    final existing = await MySqlInit.getExistingColumnDetails(model.table);

    bool changed = false;

    for (final entry in model.schema.entries) {
      final existingColumn = existing[entry.key];
      if (existingColumn == null) {
        print('   ➕ ADD COLUMN ${entry.key}');
        await MySqlInit.safeDDL(
          'ALTER TABLE `${model.table}` ADD COLUMN ${buildColumnDefinition(entry.key, entry.value)}',
        );
        changed = true;
        continue;
      }

      if (needsColumnAlter(entry.value, existingColumn)) {
        print('   🔁 MODIFY COLUMN ${entry.key}');
        await MySqlInit.safeDDL(
          buildModifyColumnSql(model.table, entry.key, entry.value),
        );
        changed = true;
      } else {
        print('   ⏭  SKIP ${entry.key} (already matches)');
      }
    }

    if (!changed) {
      print('   ℹ️  No schema change needed');
    }
  }

  static String buildColumnDefinition(
    String name,
    Column column, {
    bool includeUnique = true,
  }) {
    final buffer = StringBuffer('`$name` ${column.type}');
    if (!column.nullable) buffer.write(' NOT NULL');
    if (column.autoIncrement) buffer.write(' AUTO_INCREMENT');
    if (includeUnique && column.unique) buffer.write(' UNIQUE');
    final formattedDefaultValue =
        Column.formatDefaultValue(column.defaultValue);
    if (formattedDefaultValue != null) {
      buffer.write(' DEFAULT $formattedDefaultValue');
    }
    return buffer.toString();
  }

  static String buildModifyColumnSql(
    String table,
    String name,
    Column column,
  ) {
    return 'ALTER TABLE `$table` MODIFY COLUMN '
        '${buildColumnDefinition(name, column, includeUnique: false)}';
  }

  static bool needsColumnAlter(
    Column desired,
    Map<String, dynamic> existing,
  ) {
    final desiredType = _normalizeType(desired.type);
    final existingType = _normalizeType(existing['COLUMN_TYPE']?.toString());
    if (desiredType != existingType) {
      return true;
    }

    final desiredNullable = desired.nullable;
    final existingNullable =
        (existing['IS_NULLABLE']?.toString().toUpperCase() == 'YES');
    if (desiredNullable != existingNullable) {
      return true;
    }

    final desiredDefault =
        _normalizeDefaultForComparison(Column.formatDefaultValue(desired.defaultValue));
    final existingDefault =
        _normalizeDefaultForComparison(existing['COLUMN_DEFAULT']);
    if (desiredDefault != existingDefault) {
      return true;
    }

    final desiredAutoIncrement = desired.autoIncrement;
    final existingAutoIncrement = existing['EXTRA']
            ?.toString()
            .toLowerCase()
            .contains('auto_increment') ==
        true;
    if (desiredAutoIncrement != existingAutoIncrement) {
      return true;
    }

    return false;
  }

  static String _normalizeType(String? value) {
    return (value ?? '').trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
  }

  static String? _normalizeDefaultForComparison(dynamic value) {
    if (value == null) return null;

    var normalized = value.toString().trim();
    if (normalized.isEmpty) return '';

    if (normalized.startsWith("'") && normalized.endsWith("'")) {
      normalized = normalized.substring(1, normalized.length - 1);
    }

    final upper = normalized.toUpperCase();
    if (upper == 'NULL') return null;
    if (upper == 'CURRENT_TIMESTAMP()') return 'CURRENT_TIMESTAMP';
    if (upper == 'CURRENT_TIMESTAMP') return 'CURRENT_TIMESTAMP';

    final numeric = num.tryParse(normalized);
    if (numeric != null) {
      return numeric.toString();
    }

    return normalized;
  }

  static List<String> buildRelationStatements(
    Model model,
    Iterable<Model> models,
  ) {
    final statements = <String>[];

    for (final relation in model.relations) {
      if (relation.type != RelationType.belongsTo) continue;

      final relatedModel = _findModel(models, relation.model);
      if (relatedModel == null) continue;

      final referencedPrimaryKeys = relatedModel.schema.entries
          .where((entry) => entry.value.primaryKey)
          .map((entry) => entry.key)
          .toList();

      if (referencedPrimaryKeys.length != 1) continue;

      final referencedColumn = referencedPrimaryKeys.single;
      final constraintName =
          'fk_${model.table}_${relation.foreignKey}_${relatedModel.table}';

      statements.add(
        'ALTER TABLE `${model.table}` ADD CONSTRAINT `$constraintName` '
        'FOREIGN KEY (`${relation.foreignKey}`) REFERENCES '
        '`${relatedModel.table}` (`$referencedColumn`)',
      );
    }

    return statements;
  }

  static Future<void> _syncUniqueConstraints(Model model) async {
    print('🔐 [Migrator:${model.table}] Checking UNIQUE constraints');

    final existingUniqueColumns =
        await MySqlInit.getExistingUniqueColumns(model.table);

    for (final entry in model.schema.entries) {
      if (!entry.value.unique) continue;
      if (existingUniqueColumns.contains(entry.key)) {
        print('   ⏭  SKIP UNIQUE ${entry.key} (already exists)');
        continue;
      }

      final constraintName = 'uk_${model.table}_${entry.key}';
      print('   ➕ ADD UNIQUE ${entry.key}');
      await MySqlInit.safeDDL(
        'ALTER TABLE `${model.table}` '
        'ADD CONSTRAINT `$constraintName` UNIQUE (`${entry.key}`)',
      );
    }
  }

  static Future<void> _syncForeignKeys(Model model) async {
    final statements = buildRelationStatements(model, registeredModels);
    if (statements.isEmpty) {
      return;
    }

    print('🔗 [Migrator:${model.table}] Checking FOREIGN KEY constraints');
    final existingForeignKeys =
        await MySqlInit.getExistingForeignKeys(model.table);

    for (final statement in statements) {
      final constraintName = _extractConstraintName(statement);
      if (constraintName != null &&
          existingForeignKeys.contains(constraintName)) {
        print('   ⏭  SKIP FOREIGN KEY $constraintName (already exists)');
        continue;
      }

      print('   ➕ ADD FOREIGN KEY ${constraintName ?? '(unnamed)'}');
      await MySqlInit.safeDDL(statement);
    }
  }

  static Model? _findModel(Iterable<Model> models, String table) {
    for (final model in models) {
      if (model.table == table) return model;
    }
    return null;
  }

  static String? _extractConstraintName(String statement) {
    final match = RegExp(r'ADD CONSTRAINT `([^`]+)`').firstMatch(statement);
    return match?.group(1);
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
