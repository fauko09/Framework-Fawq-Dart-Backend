import '../migrator/column.dart';
import '../migrator/model.dart';

class CompanySettings extends Model {
  @override
  String get table => 'company_settings';

  @override
  Map<String, Column> get schema => {
        'company_setting_id': Column.string(length: 50, primaryKey: true, nullable: false),
        'company_name': Column.string(length: 150, nullable: false),
        'company_code': Column.string(length: 50, nullable: false),
        'timezone': Column.string(length: 50, nullable: false),
      };
}
