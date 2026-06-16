import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Roles extends Model {
  @override
  String get table => 'roles';

  @override
  Map<String, Column> get schema => {
        'role_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'name': Column.string(length: 100, unique: true, nullable: false),
        'description': Column.text(),
        'level': Column.integer(nullable: false ,),
      };

  @override
  List<Relation> get relations => [
        Relation.hasMany(
          model: 'user_roles',
          foreignKey: 'role_id',
          as: 'user_roles',
        ),
        Relation.hasMany(
          model: 'role_permissions',
          foreignKey: 'role_id',
          as: 'role_permissions',
        ),
      ];
}
