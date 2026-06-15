import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Employees extends Model {
  @override
  String get table => 'employees';

  @override
  Map<String, Column> get schema => {
        'employee_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'user_id': Column.string(length: 50),
        'full_name': Column.string(length: 150, nullable: false),
        'photo_card': Column.blob(nullable: true),
        'department_id': Column.string(length: 50),
        'position_id': Column.string(length: 50),
        'employee_status': Column.string(length: 50, nullable: false),
        'contract_type': Column.string(length: 50),
        'basic_salary': Column.float(),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'user_id',
          as: 'user',
        ),
        Relation.belongsTo(
          model: 'departments',
          foreignKey: 'department_id',
          as: 'department',
        ),
        Relation.belongsTo(
          model: 'positions',
          foreignKey: 'position_id',
          as: 'position',
        ),
        Relation.hasMany(
          model: 'employee_documents',
          foreignKey: 'employee_id',
          as: 'documents',
        ),
        Relation.hasMany(
          model: 'employee_change_requests',
          foreignKey: 'employee_id',
          as: 'change_requests',
        ),
        Relation.hasMany(
          model: 'contracts',
          foreignKey: 'employee_id',
          as: 'contracts',
        ),
        Relation.hasMany(
          model: 'contract_approval_steps',
          foreignKey: 'approver_employee_id',
          as: 'approval_steps',
        ),
        Relation.hasMany(
          model: 'contract_signatures',
          foreignKey: 'employee_id',
          as: 'signatures',
        ),
        Relation.hasMany(
          model: 'contract_renewals',
          foreignKey: 'employee_id',
          as: 'renewals',
        ),
        Relation.hasMany(
          model: 'salary_masters',
          foreignKey: 'employee_id',
          as: 'salary_masters',
        ),
        Relation.hasMany(
          model: 'salary_histories',
          foreignKey: 'employee_id',
          as: 'salary_histories',
        ),
        Relation.hasMany(
          model: 'payroll_details',
          foreignKey: 'employee_id',
          as: 'payroll_details',
        ),
        Relation.hasMany(
          model: 'payslips',
          foreignKey: 'employee_id',
          as: 'payslips',
        ),
      ];
}
