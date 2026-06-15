import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class EmployeeChangeRequests extends Model {
  @override
  String get table => 'employee_change_requests';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'employee_id': Column.string(length: 50, nullable: false),
        'field_changed': Column.string(length: 100, nullable: false),
        'old_value': Column.text(),
        'new_value': Column.text(),
        'document_file': Column.string(length: 255),
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
