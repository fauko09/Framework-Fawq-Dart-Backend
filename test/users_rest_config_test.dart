import 'package:test/test.dart';

import '../bin/users/users_rest.dart';

void main() {
  test('UsersRest uses user_id as the primary key', () {
    final service = UsersRest();

    expect(service.primaryKey, 'user_id');
  });
}
