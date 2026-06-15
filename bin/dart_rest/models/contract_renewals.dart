import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class ContractRenewals extends Model {
  @override
  String get table => 'contract_renewals';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'old_contract_id': Column.string(length: 50, nullable: false),
        'employee_id': Column.string(length: 50, nullable: false),
        'new_start_date': Column.date(nullable: false),
        'new_end_date': Column.date(nullable: false),
        'old_salary': Column.integer(),
        'new_salary': Column.integer(),
        'renewal_reason': Column.text(),
        'hrd_note': Column.text(),
        'director_note': Column.text(),
        'status': Column.string(length: 50, nullable: false),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'contracts',
          foreignKey: 'old_contract_id',
          as: 'old_contract',
        ),
        Relation.belongsTo(
          model: 'employees',
          foreignKey: 'employee_id',
          as: 'employee',
        ),
      ];
}
