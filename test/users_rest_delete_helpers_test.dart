import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../bin/users/users_rest.dart';

void main() {
  test('resolveDeleteTargetUserId uses the user id from the request path', () {
    final request = Request(
      'DELETE',
      Uri.parse('http://localhost/api/users/target-user-id'),
    );

    expect(resolveDeleteTargetUserId(request), 'target-user-id');
  });

  test(
      'buildDeleteVerificationChecks includes employee tables when employee exists',
      () {
    final checks = buildDeleteVerificationChecks(
      'target-user-id',
      employeeId: 'employee-123',
    );

    expect(
      checks.any(
        (check) =>
            check['table'] == 'users' &&
            (check['where'] as Map<String, dynamic>)['user_id'] ==
                'target-user-id',
      ),
      isTrue,
    );
    expect(
      checks.any(
        (check) =>
            check['table'] == 'employee_documents' &&
            (check['where'] as Map<String, dynamic>)['employee_id'] ==
                'employee-123',
      ),
      isTrue,
    );
    expect(
      checks.any(
        (check) =>
            check['table'] == 'contract_approval_steps' &&
            (check['where'] as Map<String, dynamic>)['approver_employee_id'] ==
                'employee-123',
      ),
      isTrue,
    );
  });
}
