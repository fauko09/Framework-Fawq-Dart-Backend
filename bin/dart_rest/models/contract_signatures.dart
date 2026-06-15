import '../migrator/column.dart';
import '../migrator/model.dart';
import '../migrator/relation.dart';

class ContractSignatures extends Model {
  @override
  String get table => 'contract_signatures';

  @override
  Map<String, Column> get schema => {
        'id': Column.string(length: 50, primaryKey: true, nullable: false),
        'contract_id': Column.string(length: 50, nullable: false),
        'contract_version_id': Column.string(length: 50, nullable: false),
        'employee_id': Column.string(length: 50),
        'user_id': Column.string(length: 50),
        'signature_role': Column.string(length: 50, nullable: false),
        'signature_type': Column.string(length: 50, nullable: false),
        'signature_image': Column.string(length: 255),
      };

  @override
  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'contracts',
          foreignKey: 'contract_id',
          as: 'contract',
        ),
        Relation.belongsTo(
          model: 'contract_versions',
          foreignKey: 'contract_version_id',
          as: 'contract_version',
        ),
        Relation.belongsTo(
          model: 'employees',
          foreignKey: 'employee_id',
          as: 'employee',
        ),
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'user_id',
          as: 'user',
        ),
      ];
}
