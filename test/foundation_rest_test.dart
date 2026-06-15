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
  test('foundation rest serves the root payload from bin', () async {
    final rest = FoundationRest();
    final response = await _request(rest.handler, 'GET', '/');

    expect(response.statusCode, 200);
    final payload =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    expect(payload['message'], 'HRIS FGA backend is running');
    expect(payload['module'], 'foundation');
  });
}
