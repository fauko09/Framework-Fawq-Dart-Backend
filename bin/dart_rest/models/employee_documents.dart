import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class EmployeeDocuments extends Model {
  @override
  String get table => 'employee_documents';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'employee_id': Column.string(length: 50, nullable: false),
        'document_type': Column.string(length: 100, nullable: false),
        'file_path': Column.string(length: 255, nullable: false),
        'status': Column.string(length: 50, nullable: false),
        'review_note': Column.text(),
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
