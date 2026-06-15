import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class ContractVersions extends Model {
  @override
  String get table => 'contract_versions';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'contract_id': Column.string(length: 50, nullable: false),
        'version_number': Column.integer(nullable: false),
        'file_path': Column.string(length: 255, nullable: false),
        'source_type': Column.string(length: 50, nullable: false),
        'revision_note': Column.text(),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'contracts',
          foreignKey: 'contract_id',
          as: 'contract',
        ),
        Relation.hasMany(
          model: 'contract_signatures',
          foreignKey: 'contract_version_id',
          as: 'signatures',
        ),
      ];
}
