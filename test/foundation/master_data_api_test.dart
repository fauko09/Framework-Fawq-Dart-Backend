import 'dart:convert';

import 'package:server/src/foundation/repositories.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../bin/foundation/foundation_rest.dart';

Future<Response> _request(
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

Future<Map<String, dynamic>> _json(Response response) async {
  return jsonDecode(await response.readAsString()) as Map<String, dynamic>;
}

Future<Map<String, String>> _authHeaders(Handler app) async {
  final login = await _request(
    app,
    'POST',
    '/api/auth/login',
    headers: {'content-type': 'application/json'},
    body: {
      'email': 'superadmin@fga.local',
      'password': 'superadmin123',
    },
  );
  final payload = await _json(login);
  return {'authorization': 'Bearer ${payload['accessToken']}'};
}

Future<Map<String, String>> _authHeadersFor(
  Handler app, {
  required String email,
  required String password,
}) async {
  final login = await _request(
    app,
    'POST',
    '/api/auth/login',
    headers: {'content-type': 'application/json'},
    body: {
      'email': email,
      'password': password,
    },
  );
  final payload = await _json(login);
  return {'authorization': 'Bearer ${payload['accessToken']}'};
}

void main() {
  test(
      'super admin can manage company settings departments positions and audit logs',
      () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;
    final authHeaders = await _authHeaders(app);

    final getSettings = await _request(
      app,
      'GET',
      '/api/company-settings',
      headers: authHeaders,
    );
    expect(getSettings.statusCode, 200);
    expect((await _json(getSettings))['data']['companyName'], 'FGA');

    final updateSettings = await _request(
      app,
      'PATCH',
      '/api/company-settings',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'companyName': 'FGA Corp',
      },
    );
    expect(updateSettings.statusCode, 200);
    expect((await _json(updateSettings))['data']['companyName'], 'FGA Corp');

    final departments = await _request(
      app,
      'GET',
      '/api/departments',
      headers: authHeaders,
    );
    expect(departments.statusCode, 200);
    final departmentPayload = await _json(departments);
    expect(departmentPayload['data'], isList);

    final createDepartment = await _request(
      app,
      'POST',
      '/api/departments',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'name': 'Finance',
      },
    );
    expect(createDepartment.statusCode, 201);

    final positions = await _request(
      app,
      'GET',
      '/api/positions',
      headers: authHeaders,
    );
    expect(positions.statusCode, 200);

    final createPosition = await _request(
      app,
      'POST',
      '/api/positions',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'name': 'Finance Manager',
      },
    );
    expect(createPosition.statusCode, 201);

    final auditLogs = await _request(
      app,
      'GET',
      '/api/audit-logs',
      headers: authHeaders,
    );
    expect(auditLogs.statusCode, 200);
    expect((await _json(auditLogs))['data'], isNotEmpty);
  });

  test('hrd can read departments and positions but cannot manage them',
      () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;
    final authHeaders = await _authHeadersFor(
      app,
      email: 'hrd@fga.local',
      password: 'hrd123',
    );

    final departments = await _request(
      app,
      'GET',
      '/api/departments',
      headers: authHeaders,
    );
    expect(departments.statusCode, 200);
    expect((await _json(departments))['data'], isList);

    final positions = await _request(
      app,
      'GET',
      '/api/positions',
      headers: authHeaders,
    );
    expect(positions.statusCode, 200);
    expect((await _json(positions))['data'], isList);

    final createDepartment = await _request(
      app,
      'POST',
      '/api/departments',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {'name': 'Finance'},
    );
    expect(createDepartment.statusCode, 403);
  });
}
