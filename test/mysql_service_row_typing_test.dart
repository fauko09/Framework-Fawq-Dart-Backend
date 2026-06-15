import 'package:test/test.dart';

import '../bin/dart_rest/mysql/mysql_service.dart';

class _FakeTypedRow {
  _FakeTypedRow(this._typed, this._raw);

  final Map<String, dynamic> _typed;
  final Map<String, dynamic> _raw;

  Map<String, dynamic> typedAssoc() => _typed;
  Map<String, dynamic> assoc() => _raw;
}

void main() {
  test('decodeMySqlRow prefers typed values over raw assoc strings', () {
    final row = _FakeTypedRow(
      {
        'user_id': 'user-super-admin',
        'basic_salary': 15000000.0,
        'is_active': true,
      },
      {
        'user_id': 'user-super-admin',
        'basic_salary': '15000000',
        'is_active': '1',
      },
    );

    final decoded = decodeMySqlRow(row);

    expect(decoded['user_id'], 'user-super-admin');
    expect(decoded['basic_salary'], 15000000.0);
    expect(decoded['basic_salary'], isA<double>());
    expect(decoded['is_active'], true);
    expect(decoded['is_active'], isA<bool>());
  });
}
