import 'package:server/src/auth/auth_service.dart';

import '../dart_rest/dart_rest_service.dart';
import '../dart_rest/mysql/mysql_service.dart';
import '../verify_premission.dart';
import '../auth_guard.dart';
import 'package:uuid/uuid.dart';

class DepartmentRest extends DartRestService<Map<String, dynamic>> {
  final model = MySqlInitService();
  DepartmentRest() : super('departments', customService: false) {
    enablePagination = true;

    primaryKey = 'department_id';

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
          permissions.any((perm) => perm['code'] == 'manage_departments');
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
          permissions.any((perm) => perm['code'] == 'manage_departments');
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
          permissions.any((perm) => perm['code'] == 'manage_departments');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
      ctx.payload['department_id'] = Uuid()
          .v4(); // Generate new UUID for department_id when fetching by ID
      var isChecked = await model.findOne('departments', where: {
        'name': ctx.payload['name'],
      });

      if (isChecked != null) {
        throw AuthException('Department name already exists');
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
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      print('permissions: ${jsonEncodeSafe(permissions)}');
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_departments');
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
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      print('permissions: ${jsonEncodeSafe(permissions)}');
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission =
          permissions.any((perm) => perm['code'] == 'manage_departments');
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
