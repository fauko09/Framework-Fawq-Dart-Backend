import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class Payrolls extends Model {
  @override
  String get table => 'payrolls';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'payroll_period': Column.string(length: 20, nullable: false),
        'status': Column.string(length: 50, nullable: false),
        'total_employee': Column.integer(),
        'total_gross_salary': Column.integer(),
        'total_deduction': Column.integer(),
        'total_net_salary': Column.integer(),
      };

  @override
  List<Relation> get relations => [
        Relation.hasMany(
          model: 'payroll_details',
          foreignKey: 'payroll_id',
          as: 'details',
        ),
      ];
}
