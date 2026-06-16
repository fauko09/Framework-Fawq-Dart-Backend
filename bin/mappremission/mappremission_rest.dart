import 'package:server/src/auth/auth_service.dart';

import '../dart_rest/dart_rest_service.dart';
import '../dart_rest/mysql/mysql_service.dart';
import '../verify_premission.dart';
import '../auth_guard.dart';
import 'package:uuid/uuid.dart';

class MappremissionRest extends DartRestService<Map<String, dynamic>> {
  final model = MySqlInitService();
  MappremissionRest() : super('role_permissions', customService: false) {
    enablePagination = true;
    primaryKey = 'role_permission_id';
    // get all
    beforeGetAll = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      print('permissions: ${jsonEncodeSafe(permissions)}');
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_roles');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
    };
    afterGetAll = (ctx) async {};

    // get by id
    beforeGetOne = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      print('permissions: ${jsonEncodeSafe(permissions)}');
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_roles');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
    };
    afterGetOne = (ctx) async {};

    // post
    beforeCreate = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      print('permissions: ${jsonEncodeSafe(permissions)}');
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_roles');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }

      ctx.payload['role_permission_id'] = Uuid().v4();
      var ischecked = await model.findOne('role_permissions', where: {
        'role_id': ctx.req.url.queryParameters['role_id'],
        'permission_id': ctx.req.url.queryParameters['permission_id'],
      });
      if (ischecked != null) {
        throw Exception('Role already has this permission');
      }
      print('ischecked: ${jsonEncodeSafe(ischecked)}');
    };
    afterCreate = (data, ctx) async {
      return ctx.result;
    };

    // patch/id or put/id
    beforeUpdate = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      print('permissions: ${jsonEncodeSafe(permissions)}');
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_roles');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
    };
    afterUpdate = (data, ctx) async {
      return ctx.result;
    };

    // delete/id
    beforeDelete = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      print('permissions: ${jsonEncodeSafe(permissions)}');
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_roles');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
    };
    afterDelete = (ctx) async {
      return ctx.result;
    };
  }

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return Map<String, dynamic>.from(json);
  }

  @override
  Map<String, dynamic> toJson(item) {
    return Map<String, dynamic>.from(item);
  }
}
