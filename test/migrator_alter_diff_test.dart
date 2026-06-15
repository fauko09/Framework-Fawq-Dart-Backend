import 'package:test/test.dart';

import '../bin/dart_rest/migrator/column.dart';
import '../bin/dart_rest/migrator/migrator.dart';

void main() {
  group('Migrator column diffing', () {
    test('detects type changes for existing columns', () {
      final shouldAlter = Migrator.needsColumnAlter(
        Column.float(),
        const {
          'COLUMN_TYPE': 'int',
          'IS_NULLABLE': 'YES',
          'COLUMN_DEFAULT': null,
          'EXTRA': '',
        },
      );

      expect(shouldAlter, isTrue);
    });

    test('does not alter when type nullable and default already match', () {
      final shouldAlter = Migrator.needsColumnAlter(
        Column.float(nullable: false, defaultValue: 0),
        const {
          'COLUMN_TYPE': 'float',
          'IS_NULLABLE': 'NO',
          'COLUMN_DEFAULT': '0',
          'EXTRA': '',
        },
      );

      expect(shouldAlter, isFalse);
    });

    test('builds modify column sql for changed schema', () {
      final sql = Migrator.buildModifyColumnSql(
        'employees',
        'basic_salary',
        Column.float(),
      );

      expect(
        sql,
        'ALTER TABLE `employees` MODIFY COLUMN `basic_salary` FLOAT',
      );
    });
  });
}
