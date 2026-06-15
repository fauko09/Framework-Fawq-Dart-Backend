import 'package:test/test.dart';

import '../bin/dart_rest/mysql/mysql.dart';

void main() {
  test('normalizeEnvAssignmentValue strips duplicated key prefix', () {
    expect(
      normalizeEnvAssignmentValue('DB_NAME', 'DB_NAME=hris_fga'),
      'hris_fga',
    );
  });

  test('normalizeEnvAssignmentValue leaves valid values unchanged', () {
    expect(
      normalizeEnvAssignmentValue('DB_NAME', 'hris_fga'),
      'hris_fga',
    );
  });
}
