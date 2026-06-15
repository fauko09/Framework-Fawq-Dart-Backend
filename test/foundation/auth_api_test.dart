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

void main() {
  test('cors preflight for auth login returns success headers', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;

    final preflight = await _request(
      app,
      'OPTIONS',
      '/api/auth/login',
      headers: {
        'origin': 'http://localhost:59766',
        'access-control-request-method': 'POST',
        'access-control-request-headers': 'content-type,authorization',
      },
    );

    expect(preflight.statusCode, 204);
    expect(
      preflight.headers['access-control-allow-origin'],
      'http://localhost:59766',
    );
    expect(
      preflight.headers['access-control-allow-methods'],
      contains('POST'),
    );
  });

  test('auth flow supports login me refresh and logout', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;

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

    expect(login.statusCode, 200);
    final loginPayload = await _json(login);
    expect(loginPayload['accessToken'], isNotEmpty);
    expect(loginPayload['refreshToken'], isNotEmpty);

    final me = await _request(
      app,
      'GET',
      '/api/auth/me',
      headers: {'authorization': 'Bearer ${loginPayload['accessToken']}'},
    );
    expect(me.statusCode, 200);
    expect((await _json(me))['user']['email'], 'superadmin@fga.local');

    final refresh = await _request(
      app,
      'POST',
      '/api/auth/refresh-token',
      headers: {'content-type': 'application/json'},
      body: {'refreshToken': loginPayload['refreshToken']},
    );
    expect(refresh.statusCode, 200);
    expect((await _json(refresh))['accessToken'], isNotEmpty);

    final logout = await _request(
      app,
      'POST',
      '/api/auth/logout',
      headers: {'authorization': 'Bearer ${loginPayload['accessToken']}'},
    );
    expect(logout.statusCode, 200);

    final meAfterLogout = await _request(
      app,
      'GET',
      '/api/auth/me',
      headers: {'authorization': 'Bearer ${loginPayload['accessToken']}'},
    );
    expect(meAfterLogout.statusCode, 401);
  });

  test('super admin can manage users roles permissions and role assignments', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;

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
    final accessToken = (await _json(login))['accessToken'] as String;
    final authHeaders = {'authorization': 'Bearer $accessToken'};

    final users = await _request(app, 'GET', '/api/users', headers: authHeaders);
    expect(users.statusCode, 200);
    expect((await _json(users))['data'], isList);

    final createRole = await _request(
      app,
      'POST',
      '/api/roles',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'name': 'finance',
        'description': 'Finance',
      },
    );
    expect(createRole.statusCode, 201);
    final rolePayload = await _json(createRole);

    final createUser = await _request(
      app,
      'POST',
      '/api/users',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'name': 'Finance User',
        'email': 'finance@fga.local',
        'password': 'finance123',
        'roleIds': [rolePayload['data']['id']],
      },
    );
    expect(createUser.statusCode, 201);
    final userPayload = await _json(createUser);

    final updateUser = await _request(
      app,
      'PATCH',
      '/api/users/${userPayload['data']['id']}',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'name': 'Finance Lead',
      },
    );
    expect(updateUser.statusCode, 200);
    expect((await _json(updateUser))['data']['name'], 'Finance Lead');

    final permissions = await _request(app, 'GET', '/api/permissions', headers: authHeaders);
    expect(permissions.statusCode, 200);
    final permissionPayload = await _json(permissions);
    final permissionId = (permissionPayload['data'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((item) => item['code'] == 'manage_users')['id'] as String;

    final assignPermission = await _request(
      app,
      'POST',
      '/api/role-permissions',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'roleId': rolePayload['data']['id'],
        'permissionIds': [permissionId],
      },
    );
    expect(assignPermission.statusCode, 200);

    final deleteUser = await _request(
      app,
      'DELETE',
      '/api/users/${userPayload['data']['id']}',
      headers: authHeaders,
    );
    expect(deleteUser.statusCode, 200);
  });

  test('admin hris can manage users roles permissions and role assignments', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;

    final login = await _request(
      app,
      'POST',
      '/api/auth/login',
      headers: {'content-type': 'application/json'},
      body: {
        'email': 'admin-hris@fga.local',
        'password': 'adminhris123',
      },
    );
    expect(login.statusCode, 200);
    final accessToken = (await _json(login))['accessToken'] as String;
    final authHeaders = {'authorization': 'Bearer $accessToken'};

    final createRole = await _request(
      app,
      'POST',
      '/api/roles',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'name': 'people_ops',
        'description': 'People Operations',
      },
    );
    expect(createRole.statusCode, 201);
    final rolePayload = await _json(createRole);

    final createUser = await _request(
      app,
      'POST',
      '/api/users',
      headers: {
        ...authHeaders,
        'content-type': 'application/json',
      },
      body: {
        'name': 'People Ops User',
        'email': 'people.ops@fga.local',
        'password': 'peopleops123',
        'roleIds': [rolePayload['data']['id']],
      },
    );
    expect(createUser.statusCode, 201);
    final userPayload = await _json(createUser);

    final deleteUser = await _request(
      app,
      'DELETE',
      '/api/users/${userPayload['data']['id']}',
      headers: authHeaders,
    );
    expect(deleteUser.statusCode, 200);
  });
}
