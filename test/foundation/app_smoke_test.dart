import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../bin/foundation/foundation_rest.dart';

Future<Response> _request(Handler handler, String method, String path) async {
  return await Future<Response>.value(
    handler(Request(method, Uri.parse('http://localhost$path'))),
  );
}

void main() {
  test('root endpoint returns backend status payload', () async {
    final response = await _request(FoundationRest().handler, 'GET', '/');

    expect(response.statusCode, 200);
    expect(response.headers['content-type'], contains('application/json'));

    final payload = jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    expect(payload['message'], 'HRIS FGA backend is running');
    expect(payload['module'], 'foundation');
  });
}
