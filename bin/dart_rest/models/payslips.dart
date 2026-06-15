import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Payslips extends Model {
  @override
  String get table => 'payslips';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'employee_id': Column.string(length: 50, nullable: false),
        'payroll_period': Column.string(length: 20, nullable: false),
        'basic_salary': Column.integer(),
        'total_allowance': Column.integer(),
        'total_deduction': Column.integer(),
        'bonus': Column.integer(),
        'net_salary': Column.integer(),
        'status': Column.string(length: 50, nullable: false),
        'pdf_path': Column.string(length: 255),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'employees',
          foreignKey: 'employee_id',
          as: 'employee',
        ),
      ];
}
