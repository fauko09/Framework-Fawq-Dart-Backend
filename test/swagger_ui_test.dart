import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../bin/swagger/swagger_ui.dart';

Future<Response> _request(Handler handler, String method, String path) async {
  return await Future<Response>.value(
    handler(Request(method, Uri.parse('http://localhost$path'))),
  );
}

void main() {
  test('swagger spec file exists at the default location', () {
    final specFile = resolveSwaggerSpecFile();

    expect(specFile.existsSync(), isTrue);
    expect(specFile.path, endsWith('swagger-ui/swagger.json'));
  });

  test('swagger ui handler serves the configured OpenAPI document', () async {
    final handler = buildSwaggerUiHandler();

    final response = await _request(handler, 'GET', '/');

    expect(response.statusCode, 200);
    expect(response.headers['content-type'], contains('text/html'));
    expect(await response.readAsString(), contains('HRIS FGA API'));
  });
}
