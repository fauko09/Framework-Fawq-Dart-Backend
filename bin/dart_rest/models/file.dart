import '../migrator/model.dart';
import '../migrator/column.dart';
// ignore: unused_import
import '../migrator/relation.dart';

class File extends Model {
  @override
  String get table => 'file';

  @override
  Map<String, Column> get schema => {
    'file_id': Column.string(length: 50, primaryKey: true),
    'file_name': Column.string(length: 50),
    'file_path': Column.string(length: 250),
    'file_type': Column.string(length: 50),
  };
}
