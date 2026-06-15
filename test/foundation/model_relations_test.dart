import 'package:test/test.dart';

import '../../bin/dart_rest/model_registry.dart';
import '../../bin/dart_rest/migrator/migrator.dart';
import '../../bin/dart_rest/migrator/relation.dart';
import '../../bin/dart_rest/models/users.dart';
import '../../bin/dart_rest/models/users_detail.dart';

void main() {
  test('users and users_detail expose consistent relation metadata', () {
    final users = Users();
    final usersDetail = UsersDetail();

    expect(users.relations, hasLength(greaterThanOrEqualTo(2)));
    expect(
      users.relations.first,
      predicate<Relation>(
        (relation) =>
            relation.type == RelationType.hasOne &&
            relation.model == 'users_detail' &&
            relation.foreignKey == 'user_id' &&
            relation.as == 'detail',
      ),
    );
    expect(
      users.relations,
      contains(
        predicate<Relation>(
          (relation) =>
              relation.type == RelationType.hasMany &&
              relation.model == 'user_roles' &&
              relation.foreignKey == 'user_id' &&
              relation.as == 'user_roles',
        ),
      ),
    );

    expect(usersDetail.relations, hasLength(1));
    expect(
      usersDetail.relations.first,
      predicate<Relation>(
        (relation) =>
            relation.type == RelationType.belongsTo &&
            relation.model == 'users' &&
            relation.foreignKey == 'user_id' &&
            relation.as == 'user',
      ),
    );
  });

  test('migrator builds foreign key statements from belongsTo relations', () {
    final statements = Migrator.buildRelationStatements(
      UsersDetail(),
      [Users(), UsersDetail()],
    );

    expect(
      statements,
      contains(
        'ALTER TABLE `users_detail` ADD CONSTRAINT `fk_users_detail_user_id_users` '
        'FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)',
      ),
    );
  });

  test('registered models expose all expected foreign key relations', () {
    final statements = [
      for (final model in registeredModels)
        ...Migrator.buildRelationStatements(model, registeredModels),
    ];

    expect(statements, hasLength(33));
    expect(
      statements,
      containsAll([
        'ALTER TABLE `session` ADD CONSTRAINT `fk_session_user_id_users` '
            'FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `user_roles` ADD CONSTRAINT `fk_user_roles_user_id_users` '
            'FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `user_roles` ADD CONSTRAINT `fk_user_roles_role_id_roles` '
            'FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)',
        'ALTER TABLE `role_permissions` ADD CONSTRAINT `fk_role_permissions_role_id_roles` '
            'FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`)',
        'ALTER TABLE `role_permissions` ADD CONSTRAINT `fk_role_permissions_permission_id_permissions` '
            'FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`permission_id`)',
        'ALTER TABLE `audit_logs` ADD CONSTRAINT `fk_audit_logs_actor_user_id_users` '
            'FOREIGN KEY (`actor_user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `employees` ADD CONSTRAINT `fk_employees_user_id_users` '
            'FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `employees` ADD CONSTRAINT `fk_employees_department_id_departments` '
            'FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`)',
        'ALTER TABLE `employees` ADD CONSTRAINT `fk_employees_position_id_positions` '
            'FOREIGN KEY (`position_id`) REFERENCES `positions` (`position_id`)',
        'ALTER TABLE `employee_documents` ADD CONSTRAINT `fk_employee_documents_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `employee_change_requests` ADD CONSTRAINT `fk_employee_change_requests_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `notifications` ADD CONSTRAINT `fk_notifications_user_id_users` '
            'FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `contracts` ADD CONSTRAINT `fk_contracts_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `contracts` ADD CONSTRAINT `fk_contracts_position_id_positions` '
            'FOREIGN KEY (`position_id`) REFERENCES `positions` (`position_id`)',
        'ALTER TABLE `contracts` ADD CONSTRAINT `fk_contracts_department_id_departments` '
            'FOREIGN KEY (`department_id`) REFERENCES `departments` (`department_id`)',
        'ALTER TABLE `contract_versions` ADD CONSTRAINT `fk_contract_versions_contract_id_contracts` '
            'FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`)',
        'ALTER TABLE `contract_approval_steps` ADD CONSTRAINT `fk_contract_approval_steps_contract_id_contracts` '
            'FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`)',
        'ALTER TABLE `contract_approval_steps` ADD CONSTRAINT `fk_contract_approval_steps_approver_user_id_users` '
            'FOREIGN KEY (`approver_user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `contract_approval_steps` ADD CONSTRAINT `fk_contract_approval_steps_approver_employee_id_employees` '
            'FOREIGN KEY (`approver_employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `contract_signatures` ADD CONSTRAINT `fk_contract_signatures_contract_id_contracts` '
            'FOREIGN KEY (`contract_id`) REFERENCES `contracts` (`id`)',
        'ALTER TABLE `contract_signatures` ADD CONSTRAINT `fk_contract_signatures_contract_version_id_contract_versions` '
            'FOREIGN KEY (`contract_version_id`) REFERENCES `contract_versions` (`id`)',
        'ALTER TABLE `contract_signatures` ADD CONSTRAINT `fk_contract_signatures_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `contract_signatures` ADD CONSTRAINT `fk_contract_signatures_user_id_users` '
            'FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `contract_renewals` ADD CONSTRAINT `fk_contract_renewals_old_contract_id_contracts` '
            'FOREIGN KEY (`old_contract_id`) REFERENCES `contracts` (`id`)',
        'ALTER TABLE `contract_renewals` ADD CONSTRAINT `fk_contract_renewals_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `salary_masters` ADD CONSTRAINT `fk_salary_masters_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `salary_histories` ADD CONSTRAINT `fk_salary_histories_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `approvals` ADD CONSTRAINT `fk_approvals_requester_user_id_users` '
            'FOREIGN KEY (`requester_user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `approvals` ADD CONSTRAINT `fk_approvals_approver_user_id_users` '
            'FOREIGN KEY (`approver_user_id`) REFERENCES `users` (`user_id`)',
        'ALTER TABLE `payroll_details` ADD CONSTRAINT `fk_payroll_details_payroll_id_payrolls` '
            'FOREIGN KEY (`payroll_id`) REFERENCES `payrolls` (`id`)',
        'ALTER TABLE `payroll_details` ADD CONSTRAINT `fk_payroll_details_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `payslips` ADD CONSTRAINT `fk_payslips_employee_id_employees` '
            'FOREIGN KEY (`employee_id`) REFERENCES `employees` (`employee_id`)',
        'ALTER TABLE `users_detail` ADD CONSTRAINT `fk_users_detail_user_id_users` '
            'FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)',
      ]),
    );
  });
}
