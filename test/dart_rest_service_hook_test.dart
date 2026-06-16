import 'dart:convert';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../bin/dart_rest/dart_rest_service.dart';

class _TestHookService extends DartRestService<Map<String, dynamic>> {
  _TestHookService() : super('hook-test', customService: true);

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) =>
      Map<String, dynamic>.from(json);

  @override
  Map<String, dynamic> toJson(item) => Map<String, dynamic>.from(item);
}

Future<Map<String, dynamic>> _readJson(Response response) async {
  return jsonDecode(await response.readAsString()) as Map<String, dynamic>;
}

void main() {
  group('DartRestService hooks', () {
    test('jsonEncodeSafe serializes nested DateTime values', () {
      expect(
        jsonDecode(
          jsonEncodeSafe({
            'created_at': DateTime.utc(2026, 6, 15, 9, 45, 0),
            'profile': {
              'last_login_at': DateTime.utc(2026, 6, 15, 10, 0, 0),
            },
            'history': [
              DateTime.utc(2026, 6, 14, 8, 30, 0),
            ],
          }),
        ),
        {
          'created_at': '2026-06-15T09:45:00.000Z',
          'profile': {
            'last_login_at': '2026-06-15T10:00:00.000Z',
          },
          'history': [
            '2026-06-14T08:30:00.000Z',
          ],
        },
      );
    });

    test('create passes ctx.result from beforeCreate into afterCreate',
        () async {
      final service = _TestHookService();

      service.beforeCreate = (ctx) async {
        ctx.result = {
          'user_id': 42,
          'email': 'hook@example.com',
        };
      };

      service.afterCreate = (data, ctx) async {
        expect(data, {
          'user_id': 42,
          'email': 'hook@example.com',
        });

        return {
          ...data,
          'phase': 'after-create',
        };
      };

      final response = await service.create(
        Request(
          'POST',
          Uri.parse('http://localhost/'),
          body: jsonEncode({'email': 'payload@example.com'}),
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(response.statusCode, 200);
      expect(await _readJson(response), {
        'user_id': 42,
        'email': 'hook@example.com',
        'phase': 'after-create',
      });
    });

    test('update passes ctx.result from beforeUpdate into afterUpdate',
        () async {
      final service = _TestHookService();

      service.beforeUpdate = (ctx) async {
        ctx.result = {
          'user_id': 7,
          'name': 'before-result',
        };
      };

      service.afterUpdate = (data, ctx) async {
        expect(data, {
          'user_id': 7,
          'name': 'before-result',
        });

        return {
          ...data,
          'phase': 'after-update',
        };
      };

      final response = await service.update(
        Request(
          'PATCH',
          Uri.parse('http://localhost/7'),
          body: jsonEncode({'name': 'payload-name'}),
          headers: {'content-type': 'application/json'},
        ),
        '7',
      );

      expect(response.statusCode, 200);
      expect(await _readJson(response), {
        'user_id': 7,
        'name': 'before-result',
        'phase': 'after-update',
      });
    });

    test('update uses mutated ctx.payload after beforeUpdate', () async {
      final service = _TestHookService();

      service.beforeUpdate = (ctx) async {
        ctx.payload.remove('address');
        ctx.payload['name'] = 'mutated-name';
        ctx.payload['is_active'] = false;
      };

      service.afterUpdate = (data, ctx) async {
        expect(ctx.payload, {
          'name': 'mutated-name',
          'is_active': false,
        });

        return data;
      };

      final response = await service.update(
        Request(
          'PATCH',
          Uri.parse('http://localhost/7'),
          body: jsonEncode({
            'name': 'payload-name',
            'address': 'Depok',
          }),
          headers: {'content-type': 'application/json'},
        ),
        '7',
      );

      expect(response.statusCode, 200);
      expect(await _readJson(response), {
        'name': 'mutated-name',
        'is_active': false,
      });
    });

    test('update supports multipart payloads through ctx.payload', () async {
      final service = _TestHookService();

      service.beforeUpdate = (ctx) async {
        ctx.payload['attachment'] = 'stored-file.png';
        ctx.payload['description'] = 'multipart-update';
      };

      service.afterUpdate = (data, ctx) async {
        expect(ctx.payload['attachment'], 'stored-file.png');
        expect(ctx.payload['description'], 'multipart-update');
        return data;
      };

      const boundary = 'test-boundary';
      final multipartBody = [
        '--$boundary\r\n'
            'Content-Disposition: form-data; name="attachment"; filename="avatar.png"\r\n'
            'Content-Type: image/png\r\n\r\n'
            'fake-png\r\n',
        '--$boundary--\r\n',
      ].join();

      final response = await service.update(
        Request(
          'PATCH',
          Uri.parse('http://localhost/7'),
          body: Uint8List.fromList(utf8.encode(multipartBody)),
          headers: {
            'content-type': 'multipart/form-data; boundary=$boundary',
          },
        ),
        '7',
      );

      expect(response.statusCode, 200);
      expect(await _readJson(response), {
        'attachment': 'stored-file.png',
        'description': 'multipart-update',
      });
    });

    test('delete preserves ctx.result from beforeDelete for afterDelete',
        () async {
      final service = _TestHookService();

      service.beforeDelete = (ctx) async {
        ctx.result = {
          'user_id': 9,
          'name': 'deleted-record',
        };
      };

      service.afterDelete = (ctx) async {
        expect(ctx.result, {
          'user_id': 9,
          'name': 'deleted-record',
        });

        ctx.result = {
          ...(ctx.result as Map<String, dynamic>),
          'phase': 'after-delete',
        };
      };

      final response = await service.delete(
        Request('DELETE', Uri.parse('http://localhost/9')),
        '9',
      );

      expect(response.statusCode, 200);
      expect(await _readJson(response), {
        'user_id': 9,
        'name': 'deleted-record',
        'phase': 'after-delete',
      });
    });

    test('response serializes nested DateTime values from ctx.result',
        () async {
      final service = _TestHookService();

      service.beforeCreate = (ctx) async {
        ctx.result = {
          'user_id': 11,
          'created_at': DateTime.utc(2026, 6, 9, 10, 30, 0),
          'profile': {
            'last_login_at': DateTime.utc(2026, 6, 9, 12, 0, 0),
          },
          'history': [
            DateTime.utc(2026, 6, 8, 9, 0, 0),
          ],
        };
      };

      final response = await service.create(
        Request(
          'POST',
          Uri.parse('http://localhost/'),
          body: jsonEncode({'email': 'payload@example.com'}),
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(response.statusCode, 200);
      expect(await _readJson(response), {
        'user_id': 11,
        'created_at': '2026-06-09T10:30:00.000Z',
        'profile': {
          'last_login_at': '2026-06-09T12:00:00.000Z',
        },
        'history': [
          '2026-06-08T09:00:00.000Z',
        ],
      });
    });

    test('getAll serializes DateTime values from custom service result',
        () async {
      final service = _TestHookService();

      service.afterGetAll = (ctx) async {
        ctx.result = {
          'items': [
            {
              'user_id': 1,
              'created_at': DateTime.utc(2026, 6, 9, 15, 9, 14),
            }
          ]
        };
      };

      final response = await service.getAll(
        Request('GET', Uri.parse('http://localhost/auth')),
      );

      expect(response.statusCode, 200);
      expect(await _readJson(response), {
        'items': [
          {
            'user_id': 1,
            'created_at': '2026-06-09T15:09:14.000Z',
          }
        ]
      });
    });
  });
}
