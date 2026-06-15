import 'package:mysql_utils/mysql_utils.dart';

import '../mysql/mysql.dart';
import 'bootstrap_seed_catalog.dart';

class BootstrapSeeder {
  static Future<void> init() async {
    final db = await MySqlInit.connect(forceNew: true);

    for (final role in BootstrapSeedCatalog.roles) {
      await _upsert(
        db,
        table: 'roles',
        columns: ['role_id', 'name', 'description'],
        values: [
          _sql(role.id),
          _sql(role.name),
          _sql(role.description),
        ],
        updateColumns: ['name', 'description'],
      );
    }

    for (final permission in BootstrapSeedCatalog.permissions) {
      await _upsert(
        db,
        table: 'permissions',
        columns: ['permission_id', 'code', 'description'],
        values: [
          _sql(permission.id),
          _sql(permission.code),
          _sql(permission.description),
        ],
        updateColumns: ['code', 'description'],
      );
    }

    for (final department in BootstrapSeedCatalog.departments) {
      await _upsert(
        db,
        table: 'departments',
        columns: ['department_id', 'name'],
        values: [
          _sql(department.id),
          _sql(department.name),
        ],
        updateColumns: ['name'],
      );
    }

    for (final user in BootstrapSeedCatalog.users) {
      await _upsert(
        db,
        table: 'users',
        columns: [
          'user_id',
          'name',
          'email',
          'password',
          'is_active',
          'created_at',
        ],
        values: [
          _sql(user.id),
          _sql(user.name),
          _sql(user.email),
          _sql(user.password),
          _sql(user.isActive ? 'true' : 'false'),
          _sql(_nowSql()),
        ],
        updateColumns: ['name', 'password', 'is_active'],
      );
    }

    for (final detail in BootstrapSeedCatalog.userDetails) {
      await _upsert(
        db,
        table: 'users_detail',
        columns: [
          'users_detail_id',
          'user_id',
          'address',
          'phone',
          'phone2',
          'nik',
          'nik_ktp',
          'no_bank',
          'nama_bank',
          'created_at',
        ],
        values: [
          _sql(detail.id),
          _sql(detail.userId),
          _sql(detail.address),
          _sql(detail.phone),
          _nullableSql(detail.phone2),
          _sql(detail.nik),
          _sql(detail.nikKtp),
          _sql(detail.noBank),
          _sql(detail.namaBank),
          _sql(_nowSql()),
        ],
        updateColumns: [
          'user_id',
          'address',
          'phone',
          'phone2',
          'nik',
          'nik_ktp',
          'no_bank',
          'nama_bank',
        ],
      );
    }

    for (final link in BootstrapSeedCatalog.rolePermissions) {
      await _upsert(
        db,
        table: 'role_permissions',
        columns: ['role_permission_id', 'role_id', 'permission_id'],
        values: [
          _sql(_rolePermissionId(link.roleName, link.permissionCode)),
          _sql(BootstrapSeedCatalog.roleId(link.roleName)),
          _sql(BootstrapSeedCatalog.permissionId(link.permissionCode)),
        ],
        updateColumns: ['role_id', 'permission_id'],
      );
    }

    for (final link in BootstrapSeedCatalog.userRoles) {
      await _upsert(
        db,
        table: 'user_roles',
        columns: ['user_role_id', 'user_id', 'role_id'],
        values: [
          _sql(_userRoleId(link.userEmail, link.roleName)),
          _sql(BootstrapSeedCatalog.userId(link.userEmail)),
          _sql(BootstrapSeedCatalog.roleId(link.roleName)),
        ],
        updateColumns: ['user_id', 'role_id'],
      );
    }

    for (final employee in BootstrapSeedCatalog.employees) {
      await _upsert(
        db,
        table: 'employees',
        columns: [
          'employee_id',
          'user_id',
          'full_name',
          'department_id',
          'position_id',
          'employee_status',
          'contract_type',
          'basic_salary',
        ],
        values: [
          _sql(employee.id),
          _sql(employee.userId),
          _sql(employee.fullName),
          _sql(employee.departmentId),
          _nullableSql(employee.positionId),
          _sql(employee.employeeStatus),
          _nullableSql(employee.contractType),
          _nullableIntSql(employee.basicSalary),
        ],
        updateColumns: [
          'user_id',
          'full_name',
          'department_id',
          'position_id',
          'employee_status',
          'contract_type',
          'basic_salary',
        ],
      );
    }

    print('🌱 [Seeder] Bootstrap seed complete');
  }

  static Future<void> _upsert(
    MysqlUtils db, {
    required String table,
    required List<String> columns,
    required List<String> values,
    required List<String> updateColumns,
  }) async {
    final insertColumns = columns.map((column) => '`$column`').join(', ');
    final updateSql = updateColumns
        .map((column) => '`$column` = VALUES(`$column`)')
        .join(', ');

    final sql = '''
INSERT INTO `$table` ($insertColumns)
VALUES (${values.join(', ')})
ON DUPLICATE KEY UPDATE $updateSql
''';

    await db.query(sql, debug: true);
  }

  static String _sql(String value) {
    final escaped = value.replaceAll('\\', '\\\\').replaceAll("'", "''");
    return "'$escaped'";
  }

  static String _nullableSql(String? value) {
    if (value == null) {
      return 'NULL';
    }

    return _sql(value);
  }

  static String _nullableIntSql(int? value) {
    if (value == null) {
      return 'NULL';
    }

    return value.toString();
  }

  static String _nowSql() {
    final now = DateTime.now().toLocal();
    final iso = now.toIso8601String();
    return iso.substring(0, 19).replaceFirst('T', ' ');
  }

  static String _rolePermissionId(String roleName, String permissionCode) {
    return 'rp-$roleName-$permissionCode';
  }

  static String _userRoleId(String email, String roleName) {
    final normalizedEmail = email.replaceAll('@', '-').replaceAll('.', '-');
    return 'ur-$normalizedEmail-$roleName';
  }
}
