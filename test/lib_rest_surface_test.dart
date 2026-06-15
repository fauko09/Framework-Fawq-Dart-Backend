import 'dart:io';

import 'package:test/test.dart';

void main() {
  test('rest api surface is not defined under lib/src anymore', () {
    expect(File('lib/src/app.dart').existsSync(), isFalse);
    expect(File('lib/src/foundation/foundation_api.dart').existsSync(), isFalse);
    expect(File('lib/src/http/cors.dart').existsSync(), isFalse);
    expect(File('lib/src/http/json_response.dart').existsSync(), isFalse);
    expect(File('lib/src/swagger/swagger_ui.dart').existsSync(), isFalse);
  });
}
