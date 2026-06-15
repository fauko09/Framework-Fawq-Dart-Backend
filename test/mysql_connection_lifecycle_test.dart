import 'package:test/test.dart';

import '../bin/dart_rest/mysql/mysql.dart';

class _FakeClosableClient {
  bool closed = false;

  Future<void> close() async {
    closed = true;
  }
}

void main() {
  test('disposeCachedClient closes existing cached client and clears it', () async {
    final client = _FakeClosableClient();

    final cleared = await disposeCachedClient<_FakeClosableClient>(
      client,
      (value) => value.close(),
    );

    expect(client.closed, isTrue);
    expect(cleared, isNull);
  });
}
