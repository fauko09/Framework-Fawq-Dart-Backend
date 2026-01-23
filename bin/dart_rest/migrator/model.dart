import '../mysql/mysql.dart';
import 'column.dart';
import 'relation.dart';
abstract class Model {
  String get table;
  Map<String, Column> get schema;
  List<Relation> get relations => [];

  Future<void> sync() async {
    final conn = await MySqlInit.connect();

    final columnsSql = <String>[];

    schema.forEach((name, col) {
      final buffer = StringBuffer('`$name` ${col.type}');
      if (!col.nullable) buffer.write(' NOT NULL');
      if (col.autoIncrement) buffer.write(' AUTO_INCREMENT');
      if (col.unique) buffer.write(' UNIQUE');
      if (col.defaultValue != null) {
        buffer.write(' DEFAULT ${col.defaultValue}');
      }
      columnsSql.add(buffer.toString());
    });

    // primary key
    final pk = schema.entries
        .where((e) => e.value.primaryKey)
        .map((e) => '`$e.key`')
        .toList();

    if (pk.isNotEmpty) {
      columnsSql.add('PRIMARY KEY (${pk.join(',')})');
    }

    final sql = '''
    CREATE TABLE IF NOT EXISTS `$table` (
      ${columnsSql.join(',\n')}
    ) ENGINE=InnoDB;
    ''';

    await conn.query(sql);
  }
}
