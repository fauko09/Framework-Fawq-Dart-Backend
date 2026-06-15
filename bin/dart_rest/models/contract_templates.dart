import '../migrator/column.dart';
import '../migrator/model.dart';

class ContractTemplates extends Model {
  @override
  String get table => 'contract_templates';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'template_name': Column.string(length: 150, nullable: false),
        'contract_type': Column.string(length: 50, nullable: false),
        'template_file': Column.string(length: 255, nullable: false),
        'description': Column.text(),
        'is_active': Column.string(length: 10, nullable: false),
      };
}
