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
    dynamic defaultValue,
  }) =>
      Column(
        type: 'VARCHAR($length)',
        unique: unique,
        nullable: nullable,
        primaryKey: primaryKey,
        defaultValue: defaultValue,
      );

  static Column text({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'TEXT', nullable: nullable, defaultValue: defaultValue);

  static Column integer({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'INT', nullable: nullable, defaultValue: defaultValue);


  static Column float({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'FLOAT', nullable: nullable, defaultValue: defaultValue);

  static Column double({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'DOUBLE', nullable: nullable, defaultValue: defaultValue);

  static Column tinyInt({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'TINYINT', nullable: nullable, defaultValue: defaultValue);

  // ================= DATE / TIME =================

  /// DATE only (YYYY-MM-DD)
  static Column date({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'DATE', nullable: nullable, defaultValue: defaultValue);

  /// DATETIME
  static Column dateTime({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'DATETIME', nullable: nullable, defaultValue: defaultValue);

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
  static Column json({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'JSON', nullable: nullable, defaultValue: defaultValue);

  /// Binary large object
  static Column blob({bool nullable = true, dynamic defaultValue}) =>
      Column(type: 'BLOB', nullable: nullable, defaultValue: defaultValue);

  static String? formatDefaultValue(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      final normalized = value.trim().toUpperCase();
      if (normalized == 'NULL' || normalized == 'CURRENT_TIMESTAMP') {
        return normalized;
      }

      final escaped = value.replaceAll("'", r"\'");
      return "'$escaped'";
    }

    if (value is bool) {
      return value ? '1' : '0';
    }

    return '$value';
  }
}
