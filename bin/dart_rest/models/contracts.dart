import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Contracts extends Model {
  @override
  String get table => 'contracts';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'employee_id': Column.string(length: 50, nullable: false),
        'contract_number': Column.string(length: 100, nullable: false),
        'contract_type': Column.string(length: 50, nullable: false),
        'start_date': Column.date(nullable: false),
        'end_date': Column.date(nullable: false),
        'position_id': Column.string(length: 50),
        'department_id': Column.string(length: 50),
        'basic_salary': Column.integer(),
        'allowance': Column.integer(),
        'contract_file': Column.string(length: 255),
        'status': Column.string(length: 50, nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'employees',
          foreignKey: 'employee_id',
          as: 'employee',
        ),
        Relation.belongsTo(
          model: 'positions',
          foreignKey: 'position_id',
          as: 'position',
        ),
        Relation.belongsTo(
          model: 'departments',
          foreignKey: 'department_id',
          as: 'department',
        ),
        Relation.hasMany(
          model: 'contract_versions',
          foreignKey: 'contract_id',
          as: 'versions',
        ),
        Relation.hasMany(
          model: 'contract_approval_steps',
          foreignKey: 'contract_id',
          as: 'approval_steps',
        ),
        Relation.hasMany(
          model: 'contract_signatures',
          foreignKey: 'contract_id',
          as: 'signatures',
        ),
        Relation.hasMany(
          model: 'contract_renewals',
          foreignKey: 'old_contract_id',
          as: 'renewals',
        ),
      ];
}
