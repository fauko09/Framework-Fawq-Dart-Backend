import '../migrator/model.dart';
import '../migrator/column.dart';
import '../migrator/relation.dart';

class UsersDetail extends Model {
  @override
  String get table => 'users_detail';

  @override
  Map<String, Column> get schema => {
        'users_detail_id': Column.string(length: 50, primaryKey: true),
        'user_id': Column.string(length: 50, nullable: false, unique: true),
        'address': Column.string(length: 255, nullable: false),
        'phone': Column.string(length: 20, nullable: false),
        'phone2': Column.string(length: 20, nullable: true),
        'nik': Column.string(length: 50, nullable: false),
        'nik_ktp': Column.string(length: 50, nullable: false),
        'no_bank': Column.string(length: 50, nullable: false),
        'nama_bank': Column.string(length: 100,defaultValue: 'bca'),
        'created_at': Column.dateTime(nullable: false),
      };

  List<Relation> get relations => [
        Relation.belongsTo(
          model: 'users',
          foreignKey: 'user_id',
          as: 'user',
        ),
      ];
}
