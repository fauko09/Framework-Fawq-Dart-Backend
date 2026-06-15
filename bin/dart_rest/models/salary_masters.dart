import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class SalaryMasters extends Model {
  @override
  String get table => 'salary_masters';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'employee_id': Column.string(length: 50, nullable: false),
        'basic_salary': Column.integer(),
        'position_allowance': Column.integer(),
        'transport_allowance': Column.integer(),
        'meal_allowance': Column.integer(),
        'communication_allowance': Column.integer(),
        'other_allowance': Column.integer(),
        'fixed_deduction': Column.integer(),
        'tax_deduction': Column.integer(),
        'bpjs_kesehatan_deduction': Column.integer(),
        'bpjs_ketenagakerjaan_deduction': Column.integer(),
        'effective_date': Column.date(nullable: false),
        'status': Column.string(length: 50, nullable: false),
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
