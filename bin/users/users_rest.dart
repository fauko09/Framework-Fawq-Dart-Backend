import 'package:server/src/auth/auth_service.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../dart_rest/dart_rest_service.dart';
import '../dart_rest/mysql/mysql_service.dart';
import '../verify_premission.dart';
import '../auth_guard.dart';

class UsersRest extends DartRestService<Map<String, dynamic>> {
  var model = MySqlInitService();
  final _uuid = Uuid();

  String generateUid() {
    return _uuid.v4();
  }

  UsersRest() : super('users', customService: false) {
    enablePagination = true;

    primaryKey = 'user_id';

    // get all
    beforeGetAll = (ctx) async {
      final user = await AuthGuard().authorizedUser(ctx.req);
      if (user == null) {
        throw AuthException('Unauthorized');
      }
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
      var permissions =
          await VerifyPremission().verifyPremission(user['user_id']);
      if (permissions.isEmpty) {
        throw AuthException('Un Premission null');
      }
      final hasPermission = permissions.any((perm) =>
          perm['code'] == 'manage_users' || perm['code'] == 'view_users');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
      final requestUserId = ctx.req.url.pathSegments.isNotEmpty
          ? ctx.req.url.pathSegments.last
          : null;
      var detail = await model.leftJoin(
        'users_detail',
        joins: [
          {
            'table': 'employees',
            'sourceTable': 'users_detail',
            'sourceKey': 'user_id',
            'targetKey': 'user_id',
          },
          {
            'table': 'departments',
            'sourceTable': 'employees',
            'sourceKey': 'department_id',
            'targetKey': 'department_id',
          },
          {
            'table': 'positions',
            'sourceTable': 'employees',
            'sourceKey': 'position_id',
            'targetKey': 'position_id',
          },
          {
            'table': 'employee_documents',
            'sourceTable': 'employees',
            'sourceKey': 'employee_id',
            'targetKey': 'employee_id',
          },
        ],
        fields: [
          'users_detail.user_id',
          'users_detail.address',
          'users_detail.phone AS phone_number',
          'users_detail.nik',
          'users_detail.nik_ktp',
          'users_detail.no_bank',
          'users_detail.nama_bank',
          'employees.employee_id',
          'employees.photo_card',
          'employees.contract_type',
          'employees.basic_salary',
          'departments.name AS department_name',
          'positions.name AS position_name',
          'employee_documents.document_type',
          'employee_documents.file_path',
        ],
        where: {
          'users_detail.user_id': requestUserId,
        },
      ).catchError((error) {
        print('Error fetching user detail: $error');
        return null;
      }).then((result) {
        if (result == null || result.isEmpty) {
          return null;
        }
        return result.first;
      });

      print('detail: ${jsonEncodeSafe(detail)}');
      ctx.result = detail;
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
          permissions.any((perm) => perm['code'] == 'manage_users');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
     ctx.payload['user_id'] = generateUid();
     ctx.payload['is_active'] = 'true';
     ctx.payload['created_at'] = DateTime.now();
      ctx.payload['password'] = AuthGuard().encryptPassword(ctx.payload['password']);
    };
    afterCreate = (data, ctx) async {
      return {
        'message': 'User created successfully',
        'data': data,
      };
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
          permissions.any((perm) => perm['code'] == 'manage_users');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
    };
    afterUpdate = (data, ctx) async {
      return {
        'message': 'User updated successfully',
        'data': data,
      };
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
          permissions.any((perm) => perm['code'] == 'manage_users');
      if (!hasPermission) {
        throw AuthException('Forbidden');
      }
    };
    afterDelete = (ctx) async {};
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
