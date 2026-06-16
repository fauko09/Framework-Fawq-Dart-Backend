import 'package:server/src/auth/auth_service.dart';

import '../dart_rest/dart_rest_service.dart';
import '../dart_rest/mysql/mysql_service.dart';
import '../verify_premission.dart';
import '../auth_guard.dart';
import 'package:uuid/uuid.dart';

class PremissionRest extends DartRestService<Map<String, dynamic>> {
  final model = MySqlInitService();

  PremissionRest() : super('permissions', customService: false) {
    enablePagination = true;

    primaryKey = 'permission_id';

    // get all
    beforeGetAll = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
      print('Authorized user: ${jsonEncodeSafe(user)}');
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_users');
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
      print('Authorized user: ${jsonEncodeSafe(user)}');
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_users');
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
      print('Authorized user: ${jsonEncodeSafe(user)}');
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_users');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
      ctx.payload['permission_id'] = Uuid().v4();
      var isChecked = await model.findOne('permissions', where: {
        'code': ctx.payload['code'],
      });

      if (isChecked != null) {
        throw Exception('Permission code already exists');
      }
    };
    afterCreate = (data, ctx) async {
      return data;
    };

    // patch/id or put/id
    beforeUpdate = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
      print('Authorized user: ${jsonEncodeSafe(user)}');
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_users');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
    };
    afterUpdate = (data, ctx) async {
      return data;
    };

    // delete/id
    beforeDelete = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
      print('Authorized user: ${jsonEncodeSafe(user)}');
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_users');
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
