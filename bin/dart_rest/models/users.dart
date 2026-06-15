import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Users extends Model {
  @override
  String get table => 'users';

  @override
  Map<String, Column> get schema => {
        'user_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'name': Column.string(length: 150, nullable: false),
        'email': Column.string(length: 150, unique: true, nullable: false),
        'password': Column.string(length: 255, nullable: false),
        'is_active': Column.string(length: 10, nullable: false),
        'created_at': Column.dateTime(nullable: false),
      };

  List<Relation> get relations => [
        Relation.hasOne(
          model: 'users_detail',
          foreignKey: 'user_id',
          as: 'detail',
        ),
        Relation.hasMany(
          model: 'user_roles',
          foreignKey: 'user_id',
          as: 'user_roles',
        ),
        Relation.hasMany(
          model: 'session',
          foreignKey: 'user_id',
          as: 'sessions',
        ),
        Relation.hasMany(
          model: 'employees',
          foreignKey: 'user_id',
          as: 'employees',
        ),
        Relation.hasMany(
          model: 'notifications',
          foreignKey: 'user_id',
          as: 'notifications',
        ),
        Relation.hasMany(
          model: 'audit_logs',
          foreignKey: 'actor_user_id',
          as: 'audit_logs',
        ),
        Relation.hasMany(
          model: 'approvals',
          foreignKey: 'requester_user_id',
          as: 'requested_approvals',
        ),
        Relation.hasMany(
          model: 'approvals',
          foreignKey: 'approver_user_id',
          as: 'approvals_to_review',
        ),
        Relation.hasMany(
          model: 'contract_approval_steps',
          foreignKey: 'approver_user_id',
          as: 'contract_approval_steps',
        ),
        Relation.hasMany(
          model: 'contract_signatures',
          foreignKey: 'user_id',
          as: 'contract_signatures',
        )
      ];
}
