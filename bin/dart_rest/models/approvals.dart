import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Approvals extends Model {
  @override
  String get table => 'approvals';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'approval_type': Column.string(length: 50, nullable: false),
        'reference_id': Column.string(length: 50, nullable: false),
        'requester_user_id': Column.string(length: 50),
        'approver_user_id': Column.string(length: 50),
        'approver_role': Column.string(length: 50),
        'status': Column.string(length: 50, nullable: false),
        'note': Column.text(),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'requester_user_id',
          as: 'requester',
        ),
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'approver_user_id',
          as: 'approver',
        ),
      ];
}
