import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class UserRoles extends Model {
  @override
  String get table => 'user_roles';

  @override
  Map<String, Column> get schema => {
        'user_role_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'user_id': Column.string(length: 50, nullable: false),
        'role_id': Column.string(length: 50, nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'user_id',
          as: 'user',
        ),
        Relation.belongsTo(
          model: 'roles',
          foreignKey: 'role_id',
          as: 'role',
        ),
      ];
}
