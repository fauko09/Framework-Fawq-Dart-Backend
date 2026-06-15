import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Positions extends Model {
  @override
  String get table => 'positions';

  @override
  Map<String, Column> get schema => {
        'position_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'name': Column.string(length: 120, unique: true, nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.hasMany(
          model: 'employees',
          foreignKey: 'position_id',
          as: 'employees',
        ),
        Relation.hasMany(
          model: 'contracts',
          foreignKey: 'position_id',
          as: 'contracts',
        ),
      ];
}
