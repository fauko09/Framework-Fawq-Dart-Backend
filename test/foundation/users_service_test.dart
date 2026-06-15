import 'dart:convert';

import 'package:server/src/auth/auth_service.dart';
import 'package:server/src/foundation/repositories.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../bin/foundation/foundation_rest.dart';
import '../../bin/users/users_rest.dart';

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
  test('users rest functions as a dedicated standalone service', () async {
    final repository = FoundationRepository.seeded();
    final authService = AuthService(repository: repository);
    final service = UsersRest(
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

  test('users service lists and mutates users through mounted foundation routes',
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

    final index = await _request(app, 'GET', '/api/users', headers: authHeaders);
    expect(index.statusCode, 200);
    expect((await _json(index))['data'], isList);

    final create = await _request(
      app,
      'POST',
      '/api/users',
      headers: authHeaders,
      body: {
        'name': 'Finance User',
        'email': 'finance@fga.local',
        'password': 'finance123',
        'roleIds': <String>[],
      },
    );

    expect(create.statusCode, 201);
    final createdUser = (await _json(create))['data'] as Map<String, dynamic>;

    final update = await _request(
      app,
      'PATCH',
      '/api/users/${createdUser['id']}',
      headers: authHeaders,
      body: {'name': 'Finance Lead'},
    );

    expect(update.statusCode, 200);
    expect((await _json(update))['data']['name'], 'Finance Lead');

    final delete = await _request(
      app,
      'DELETE',
      '/api/users/${createdUser['id']}',
      headers: {'authorization': 'Bearer $accessToken'},
    );

    expect(delete.statusCode, 200);
    expect((await _json(delete))['message'], 'User deleted');
  });
}
