import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class ContractApprovalSteps extends Model {
  @override
  String get table => 'contract_approval_steps';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'contract_id': Column.string(length: 50, nullable: false),
        'step_order': Column.integer(nullable: false),
        'step_code': Column.string(length: 50, nullable: false),
        'step_name': Column.string(length: 100, nullable: false),
        'approver_role': Column.string(length: 50, nullable: false),
        'approver_user_id': Column.string(length: 50),
        'approver_employee_id': Column.string(length: 50),
        'required_action': Column.string(length: 50, nullable: false),
        'status': Column.string(length: 50, nullable: false),
        'note': Column.text(),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'contracts',
          foreignKey: 'contract_id',
          as: 'contract',
        ),
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'approver_user_id',
          as: 'approver_user',
        ),
        Relation.belongsTo(
          model: 'employees',
          foreignKey: 'approver_employee_id',
          as: 'approver_employee',
        ),
      ];
}
