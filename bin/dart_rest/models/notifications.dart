import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Notifications extends Model {
  @override
  String get table => 'notifications';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'user_id': Column.string(length: 50, nullable: false),
        'role': Column.string(length: 50, nullable: false),
        'title': Column.string(length: 150, nullable: false),
        'message': Column.text(),
        'is_read': Column.string(length: 10, nullable: false),
        'created_at': Column.dateTime(nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'user_id',
          as: 'user',
        ),
      ];
}
