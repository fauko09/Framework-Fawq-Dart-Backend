import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Departments extends Model {
  @override
  String get table => 'departments';

  @override
  Map<String, Column> get schema => {
        'department_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'name': Column.string(length: 120, unique: true, nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.hasMany(
          model: 'employees',
          foreignKey: 'department_id',
          as: 'employees',
        ),
        Relation.hasMany(
          model: 'contracts',
          foreignKey: 'department_id',
          as: 'contracts',
        ),
      ];
}
