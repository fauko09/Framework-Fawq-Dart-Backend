enum RelationType { belongsTo, hasOne, hasMany }

class Relation {
  final RelationType type;
  final String model;
  final String foreignKey;
  final String as;

  Relation({
    required this.type,
    required this.model,
    required this.foreignKey,
    required this.as,
  });

  static Relation belongsTo({
    required String model,
    required String foreignKey,
    required String as,
  }) {
    return Relation(
      type: RelationType.belongsTo,
      model: model,
      foreignKey: foreignKey,
      as: as,
    );
  }

  static Relation hasMany({
    required String model,
    required String foreignKey,
    required String as,
  }) {
    return Relation(
      type: RelationType.hasMany,
      model: model,
      foreignKey: foreignKey,
      as: as,
    );
  }

  static Relation hasOne({
    required String model,
    required String foreignKey,
    required String as,
  }) {
    return Relation(
      type: RelationType.hasOne,
      model: model,
      foreignKey: foreignKey,
      as: as,
    );
  }
}
