import 'package:test/test.dart';

import '../bin/dart_rest/migrator/column.dart';
import '../bin/dart_rest/migrator/migrator.dart';

void main() {
  group('Migrator.buildColumnDefinition', () {
    test('quotes string defaults for defined values', () {
      final sql = Migrator.buildColumnDefinition(
        'nama_bank',
        Column.string(length: 100, nullable: false, defaultValue: 'BCA'),
      );

      expect(sql, "`nama_bank` VARCHAR(100) NOT NULL DEFAULT 'BCA'");
    });

    test('keeps NULL as SQL literal', () {
      final sql = Migrator.buildColumnDefinition(
        'deleted_at',
        Column.dateTime(defaultValue: 'NULL'),
      );

      expect(sql, '`deleted_at` DATETIME DEFAULT NULL');
    });

    test('keeps CURRENT_TIMESTAMP as SQL expression', () {
      final sql = Migrator.buildColumnDefinition(
        'created_at',
        Column.timestamp(),
      );

      expect(
        sql,
        '`created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP',
      );
    });

    test('builds FLOAT columns', () {
      final sql = Migrator.buildColumnDefinition(
        'score',
        Column.float(nullable: false, defaultValue: 1.5),
      );

      expect(sql, '`score` FLOAT NOT NULL DEFAULT 1.5');
    });

    test('builds DOUBLE columns', () {
      final sql = Migrator.buildColumnDefinition(
        'amount',
        Column.double(nullable: false, defaultValue: 99.99),
      );

      expect(sql, '`amount` DOUBLE NOT NULL DEFAULT 99.99');
    });

    test('builds TINYINT columns', () {
      final sql = Migrator.buildColumnDefinition(
        'is_active',
        Column.tinyInt(nullable: false, defaultValue: 1),
      );

      expect(sql, '`is_active` TINYINT NOT NULL DEFAULT 1');
    });
  });
}
