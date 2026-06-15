import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../bin/foundation/foundation_rest.dart';

Future<Response> _request(Handler handler, String method, String path) async {
  return await Future<Response>.value(
    handler(Request(method, Uri.parse('http://localhost$path'))),
  );
}

void main() {
  test('root endpoint returns migrated HRIS payload', () async {
    final response = await _request(FoundationRest().handler, 'GET', '/');

    expect(response.statusCode, 200);
    final payload =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    expect(payload['message'], 'HRIS FGA backend is running');
    expect(payload['module'], 'foundation');
  });

  test('unknown endpoint still returns 404', () async {
    final response = await _request(FoundationRest().handler, 'GET', '/foobar');

    expect(response.statusCode, 404);
  });
}
