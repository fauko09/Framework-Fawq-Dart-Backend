import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class SalaryHistories extends Model {
  @override
  String get table => 'salary_histories';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'employee_id': Column.string(length: 50, nullable: false),
        'old_basic_salary': Column.integer(),
        'new_basic_salary': Column.integer(),
        'old_allowance': Column.integer(),
        'new_allowance': Column.integer(),
        'effective_date': Column.date(nullable: false),
        'reason': Column.text(),
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
