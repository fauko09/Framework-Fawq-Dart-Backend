import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class RolePermissions extends Model {
  @override
  String get table => 'role_permissions';

  @override
  Map<String, Column> get schema => {
        'role_permission_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'role_id': Column.string(length: 50, nullable: false),
        'permission_id': Column.string(length: 50, nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'roles',
          foreignKey: 'role_id',
          as: 'role',
        ),
        Relation.belongsTo(
          model: 'permissions',
          foreignKey: 'permission_id',
          as: 'permission',
        ),
      ];
}
