import 'package:server/src/foundation/repositories.dart';
import 'package:test/test.dart';

void main() {
  test('foundation repository seeds default roles permissions and admin user', () {
    final repository = FoundationRepository.seeded();

    expect(
      repository.roles.map((role) => role.name).toSet(),
      containsAll({
        'super_admin',
        'admin_hris',
        'hrd',
        'legal',
        'direktur',
        'upliner_langsung',
        'employee',
      }),
    );
    expect(
      repository.permissions.map((permission) => permission.code).toSet(),
      contains('manage_users'),
    );
    expect(repository.users.length, greaterThanOrEqualTo(1));
    expect(
      repository.users.map((user) => user.email),
      contains('superadmin@fga.local'),
    );
    expect(
      repository.users.map((user) => user.email),
      contains('admin-hris@fga.local'),
    );
    expect(
      repository.userRoles.any((link) => link.roleId == repository.roles.first.id),
      isTrue,
    );
  });

  test('foundation repository seeds company settings and master data', () {
    final repository = FoundationRepository.seeded();

    expect(repository.companySettings.companyName, 'FGA');
    expect(repository.departments, isNotEmpty);
    expect(repository.positions, isNotEmpty);
  });
}
