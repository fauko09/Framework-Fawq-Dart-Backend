import 'package:test/test.dart';

import '../bin/dart_rest/seeder/bootstrap_seed_catalog.dart';

void main() {
  test('bootstrap seed catalog only keeps super admin as seeded user', () {
    expect(BootstrapSeedCatalog.users, hasLength(1));
    expect(
      BootstrapSeedCatalog.users.single.email,
      'superadmin@fga.local',
    );
    expect(
      BootstrapSeedCatalog.userRoles.map((item) => item.userEmail).toSet(),
      {'superadmin@fga.local'},
    );
    expect(
      BootstrapSeedCatalog.userRoles.map((item) => item.roleName).toSet(),
      {'super_admin'},
    );
  });

  test('bootstrap seed catalog provides linked detail and employee example', () {
    final superAdminUser = BootstrapSeedCatalog.users.single;
    final detail = BootstrapSeedCatalog.userDetails.single;
    final employee = BootstrapSeedCatalog.employees.single;

    expect(
      detail.userId,
      superAdminUser.id,
    );
    expect(employee.userId, superAdminUser.id);
    expect(
      BootstrapSeedCatalog.departments
          .map((department) => department.id)
          .contains(employee.departmentId),
      isTrue,
    );
  });

  test('bootstrap seed catalog includes retail gold departments', () {
    expect(
      BootstrapSeedCatalog.departments.map((department) => department.name),
      containsAll(<String>[
        'Operasional Toko',
        'Penjualan',
        'Purchasing Emas',
        'Gudang dan Inventori',
        'Keuangan',
        'Human Capital',
        'Marketing',
        'Customer Service',
        'Security',
        'Compliance',
      ]),
    );
  });
}
