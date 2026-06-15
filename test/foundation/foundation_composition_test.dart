import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../bin/foundation/foundation_rest.dart';

Future<Response> _request(Handler handler, String method, String path) async {
  return await Future<Response>.value(
    handler(Request(method, Uri.parse('http://localhost$path'))),
  );
}

Future<Response> _jsonRequest(
  Handler handler,
  String method,
  String path, {
  Map<String, String>? headers,
  Object? body,
}) async {
  return await Future<Response>.value(
    handler(
      Request(
        method,
        Uri.parse('http://localhost$path'),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
    ),
  );
}

void main() {
  test('foundation composition exposes root health endpoint', () async {
    final response = await _request(FoundationRest().handler, 'GET', '/');

    expect(response.statusCode, 200);
    final payload =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    expect(payload['module'], 'foundation');
  });

  test('foundation composition keeps users route reachable through the current stack', () async {
    final handler = FoundationRest().handler;
    final login = await _jsonRequest(
      handler,
      'POST',
      '/api/auth/login',
      headers: {'content-type': 'application/json'},
      body: {
        'email': 'superadmin@fga.local',
        'password': 'superadmin123',
      },
    );

    expect(login.statusCode, 200);
    final loginPayload = jsonDecode(await login.readAsString()) as Map<String, dynamic>;

    final response = await _jsonRequest(
      handler,
      'GET',
      '/api/users',
      headers: {'authorization': 'Bearer ${loginPayload['accessToken']}'},
    );

    expect(response.statusCode, 200);
    final payload =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    expect(payload['data'], isList);
  });

  test('foundation composition still exposes legacy routes not yet extracted', () async {
    final handler = FoundationRest().handler;
    final login = await _jsonRequest(
      handler,
      'POST',
      '/api/auth/login',
      headers: {'content-type': 'application/json'},
      body: {
        'email': 'superadmin@fga.local',
        'password': 'superadmin123',
      },
    );

    expect(login.statusCode, 200);
    final loginPayload = jsonDecode(await login.readAsString()) as Map<String, dynamic>;

    final response = await _jsonRequest(
      handler,
      'GET',
      '/api/company-settings',
      headers: {'authorization': 'Bearer ${loginPayload['accessToken']}'},
    );

    expect(response.statusCode, 200);
    final payload =
        jsonDecode(await response.readAsString()) as Map<String, dynamic>;
    expect(payload['data'], isMap);
  });
}
