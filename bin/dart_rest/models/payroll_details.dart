import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class PayrollDetails extends Model {
  @override
  String get table => 'payroll_details';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'payroll_id': Column.string(length: 50, nullable: false),
        'employee_id': Column.string(length: 50, nullable: false),
        'basic_salary': Column.integer(),
        'total_allowance': Column.integer(),
        'total_deduction': Column.integer(),
        'bonus': Column.integer(),
        'adjustment': Column.integer(),
        'gross_salary': Column.integer(),
        'net_salary': Column.integer(),
        'status': Column.string(length: 50, nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'payrolls',
          foreignKey: 'payroll_id',
          as: 'payroll',
        ),
        Relation.belongsTo(
          model: 'employees',
          foreignKey: 'employee_id',
          as: 'employee',
        ),
      ];
}
