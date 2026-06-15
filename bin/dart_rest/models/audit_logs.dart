import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class AuditLogs extends Model {
  @override
  String get table => 'audit_logs';

  @override
  Map<String, Column> get schema => {
        'audit_log_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'actor_user_id': Column.string(length: 50, nullable: false),
        'action': Column.string(length: 50, nullable: false),
        'entity_type': Column.string(length: 100, nullable: false),
        'entity_id': Column.string(length: 50, nullable: false),
        'old_values': Column.json(),
        'new_values': Column.json(),
        'note': Column.text(),
        'created_at': Column.dateTime(nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'actor_user_id',
          as: 'actor',
        ),
      ];
}
