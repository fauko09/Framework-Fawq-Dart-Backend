import '../migrator/model.dart';
import '../migrator/column.dart';
import '../migrator/relation.dart';

class Session extends Model {
  @override
  String get table => 'session';

  @override
  Map<String, Column> get schema => {
    'session_id': Column.string(length: 50, primaryKey: true),
    'user_id': Column.string(length: 50),
    'access_token_jti': Column.text(),
    'refresh_token_jti': Column.text(),
    'expires_at': Column.dateTime(),
  };

  @override
  List<Relation> get relations => [
    Relation.belongsTo(
      model: 'users',
      foreignKey: 'user_id',
      as: 'user',
    ),
  ];
}
