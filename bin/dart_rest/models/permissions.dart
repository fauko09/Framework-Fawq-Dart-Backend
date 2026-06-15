import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Permissions extends Model {
  @override
  String get table => 'permissions';

  @override
  Map<String, Column> get schema => {
        'permission_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'code': Column.string(length: 120, unique: true, nullable: false),
        'description': Column.text(),
      };

  @override
  List<Relation> get relations => [
        Relation.hasMany(
          model: 'role_permissions',
          foreignKey: 'permission_id',
          as: 'role_permissions',
        ),
      ];
}
