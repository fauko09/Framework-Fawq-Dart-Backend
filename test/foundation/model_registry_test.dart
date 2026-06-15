import 'package:test/test.dart';

import '../../bin/dart_rest/model_registry.dart';

void main() {
  test('model registry contains foundation task 01 tables', () {
    final tables = registeredModels.map((model) => model.table).toSet();

    expect(
      tables,
      containsAll({
        'users',
        'roles',
        'permissions',
        'role_permissions',
        'user_roles',
        'departments',
        'positions',
        'company_settings',
        'audit_logs',
        'employees',
        'employee_documents',
        'employee_change_requests',
        'notifications',
        'contract_templates',
        'contract_assets',
        'contracts',
        'contract_versions',
        'contract_approval_steps',
        'contract_signatures',
        'contract_renewals',
        'salary_masters',
        'salary_histories',
        'approvals',
        'payrolls',
        'payroll_details',
        'payslips',
      }),
    );
  });
}
