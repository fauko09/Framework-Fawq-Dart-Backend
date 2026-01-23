class Column {
  final String type;
  final bool primaryKey;
  final bool autoIncrement;
  final bool unique;
  final bool nullable;
  final dynamic defaultValue;

  Column({
    required this.type,
    this.primaryKey = false,
    this.autoIncrement = false,
    this.unique = false,
    this.nullable = true,
    this.defaultValue,
  });

  static Column id(dynamic type) => Column(
        type: type,
        primaryKey: true,
        autoIncrement: false,
        nullable: false,
      );

  static Column string({
    int length = 255,
    bool unique = false,
    bool nullable = true,
    bool primaryKey = false,
  }) =>
      Column(
        type: 'VARCHAR($length)',
        unique: unique,
        nullable: nullable,
        primaryKey: primaryKey,
      );

  static Column text({bool nullable = true}) =>
      Column(type: 'TEXT', nullable: nullable);

  static Column integer({bool nullable = true}) =>
      Column(type: 'INT', nullable: nullable);

   // ================= DATE / TIME =================

  /// DATE only (YYYY-MM-DD)
  static Column date({bool nullable = true}) =>
      Column(type: 'DATE', nullable: nullable);

  /// DATETIME
  static Column dateTime({bool nullable = true}) =>
      Column(type: 'DATETIME', nullable: nullable);

  static Column timestamp({
    bool nullable = false,
    dynamic defaultValue = 'CURRENT_TIMESTAMP',
  }) =>
      Column(
        type: 'TIMESTAMP',
        nullable: nullable,
        defaultValue: defaultValue,
      );

  // ================= SPECIAL TYPES =================

  /// MySQL JSON
  static Column json({bool nullable = true}) =>
      Column(type: 'JSON', nullable: nullable);

  /// Binary large object
  static Column blob({bool nullable = true}) =>
      Column(type: 'BLOB', nullable: nullable);

}
