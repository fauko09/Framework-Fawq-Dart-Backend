import '../migrator/column.dart';
import '../migrator/model.dart';

class ContractAssets extends Model {
  @override
  String get table => 'contract_assets';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'asset_type': Column.string(length: 50, nullable: false),
        'asset_name': Column.string(length: 150, nullable: false),
        'file_path': Column.string(length: 255, nullable: false),
        'is_default': Column.string(length: 10, nullable: false),
        'is_active': Column.string(length: 10, nullable: false),
      };
}
