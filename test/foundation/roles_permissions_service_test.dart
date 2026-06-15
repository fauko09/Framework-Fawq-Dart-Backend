import 'dart:convert';

import 'package:server/src/auth/auth_service.dart';
import 'package:server/src/foundation/repositories.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../bin/foundation/foundation_rest.dart';
import '../../bin/permissions/permissions_rest.dart';
import '../../bin/roles/roles_rest.dart';

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
  test('roles rest functions as a dedicated standalone service', () async {
    final repository = FoundationRepository.seeded();
    final authService = AuthService(repository: repository);
    final service = RolesRest(
      repository: repository,
      authService: authService,
    );
    final token = authService.login(
      'superadmin@fga.local',
      'superadmin123',
    )['accessToken'] as String;

    final response = await _request(
      service.router.call,
      'GET',
      '/',
      headers: {'authorization': 'Bearer $token'},
    );

    expect(response.statusCode, 200);
    expect((await _json(response))['data'], isList);
  });

  test('permissions rest functions as a dedicated standalone service', () async {
    final repository = FoundationRepository.seeded();
    final authService = AuthService(repository: repository);
    final service = PermissionsRest(
      repository: repository,
      authService: authService,
    );
    final token = authService.login(
      'superadmin@fga.local',
      'superadmin123',
    )['accessToken'] as String;

    final response = await _request(
      service.router.call,
      'GET',
      '/',
      headers: {'authorization': 'Bearer $token'},
    );

    expect(response.statusCode, 200);
    expect((await _json(response))['data'], isList);
  });

  test('roles and permissions services work through mounted foundation routes',
      () async {
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
    final accessToken = (await _json(login))['accessToken'] as String;
    final authHeaders = {
      'authorization': 'Bearer $accessToken',
      'content-type': 'application/json',
    };

    final createRole = await _request(
      app,
      'POST',
      '/api/roles',
      headers: authHeaders,
      body: {
        'name': 'finance',
        'description': 'Finance',
      },
    );

    expect(createRole.statusCode, 201);
    final rolePayload = await _json(createRole);

    final permissions = await _request(
      app,
      'GET',
      '/api/permissions',
      headers: {'authorization': 'Bearer $accessToken'},
    );

    expect(permissions.statusCode, 200);
    final permissionPayload = await _json(permissions);
    final permissionId = (permissionPayload['data'] as List)
        .cast<Map<String, dynamic>>()
        .firstWhere((item) => item['code'] == 'manage_users')['id'] as String;

    final assignPermission = await _request(
      app,
      'POST',
      '/api/role-permissions',
      headers: authHeaders,
      body: {
        'roleId': rolePayload['data']['id'],
        'permissionIds': [permissionId],
      },
    );

    expect(assignPermission.statusCode, 200);
    expect((await _json(assignPermission))['message'], 'Permissions assigned');

    final unexpectedCreatePermission = await _request(
      app,
      'POST',
      '/api/permissions',
      headers: authHeaders,
      body: {
        'roleId': rolePayload['data']['id'],
        'permissionIds': [permissionId],
      },
    );
    expect(unexpectedCreatePermission.statusCode, 404);

    final invalidAssignment = await _request(
      app,
      'POST',
      '/api/role-permissions',
      headers: authHeaders,
      body: {
        'roleId': 'missing-role',
        'permissionIds': ['missing-permission'],
      },
    );
    expect(invalidAssignment.statusCode, 404);
  });
}
