import 'package:server/src/auth/auth_service.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../dart_rest/dart_rest_service.dart';
import '../dart_rest/mysql/mysql_service.dart';
import '../verify_premission.dart';
import '../auth_guard.dart';
import '../gen_nik.dart';

String? resolveDeleteTargetUserId(Request req) {
  if (req.url.pathSegments.isEmpty) {
    return null;
  }

  return req.url.pathSegments.last;
}

List<Map<String, dynamic>> buildDeleteVerificationChecks(
  String userId, {
  String? employeeId,
}) {
  final checks = <Map<String, dynamic>>[
    {
      'table': 'users',
      'where': {'user_id': userId},
    },
    {
      'table': 'users_detail',
      'where': {'user_id': userId},
    },
    {
      'table': 'employees',
      'where': {'user_id': userId},
    },
    {
      'table': 'user_roles',
      'where': {'user_id': userId},
    },
    {
      'table': 'sessions',
      'where': {'user_id': userId},
    },
  ];

  if (employeeId != null) {
    checks.addAll([
      {
        'table': 'employee_change_requests',
        'where': {'employee_id': employeeId},
      },
      {
        'table': 'employee_documents',
        'where': {'employee_id': employeeId},
      },
      {
        'table': 'contracts',
        'where': {'employee_id': employeeId},
      },
      {
        'table': 'contract_approval_steps',
        'where': {'approver_employee_id': employeeId},
      },
      {
        'table': 'contract_signatures',
        'where': {'employee_id': employeeId},
      },
      {
        'table': 'contract_renewals',
        'where': {'employee_id': employeeId},
      },
    ]);
  }

  return checks;
}

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
      print(
          'Fetching all users with permissions: ${jsonEncodeSafe(permissions)}');
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
      try {
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
        ctx.payload['password'] =
            AuthGuard().encryptPassword(ctx.payload['password']);
        // ctx.result['type'] = ctx.payload['type'];
        // ctx.result['nik_ktp'] = ctx.payload['nik_ktp'];
        ctx['rawPayload'] = Map<String, dynamic>.from(ctx.payload);

        ctx.payload.remove('type');
        ctx.payload.remove('nik_ktp');
      } catch (e) {
        ctx.result = {
          'message': 'Error creating user: ${e.toString()}',
        };
      }
    };
    afterCreate = (data, ctx) async {
      if (ctx.result['message'] != null) {
        return ctx.result;
      }
      try {
        print('afterCreate payload: ${jsonEncodeSafe(ctx['rawPayload'])}');
        late String nik;
        switch (ctx['rawPayload']['type']) {
          case 'pkwtt':
            nik = generateEmployeeUid(EmployeeType.pkwtt);
            break;
          case 'pkwt':
            nik = generateEmployeeUid(EmployeeType.pkwt);
            break;
          case 'magang':
            nik = generateEmployeeUid(EmployeeType.magang);
            break;
          default:
            nik = generateEmployeeUid(EmployeeType.pkwt);
        }
        await model.create(
          'users_detail',
          {
            'users_detail_id': const Uuid().v4(),
            'nik': nik,
            'nik_ktp': ctx['rawPayload']['nik_ktp'],
            'user_id': ctx['rawPayload']['user_id'],
            'created_at': DateTime.now(),
          },
        );
        await model.create(
          'employees',
          {
            'employee_id': const Uuid().v4(),
            'full_name': ctx.result['name'],
            'user_id': ctx.result['user_id'],
            'contract_type': ctx['rawPayload']['type'],
            'employee_status': 'aktif',
          },
        );

        return {
          'message': 'User created successfully',
          'data': data,
        };
      } catch (e) {
        return {
          'message': 'Error after creating user: ${e.toString()}',
        };
      }
    };

    // patch/id or put/id
    beforeUpdate = (ctx) async {
      if (ctx.payload.isEmpty) {
        ctx.result = {
          'message': 'No data provided for update',
        };
        return;
      }
      if (ctx.req.url.queryParameters['nonaktif'] == 'true') {
        await Future.wait([
          model.update('users', {
            'is_active': ctx.data['is_active'] == 'true' ? 'false' : 'true',
          }, where: {
            'user_id': ctx.req.url.pathSegments.last,
          }),
          model.update('employees', {
            'employee_status':
                ctx.data['is_active'] == 'true' ? 'nonaktif' : 'aktif',
          }, where: {
            'user_id': ctx.req.url.pathSegments.last,
          }),
        ]);

        return;
      }
      ctx['data'] = Map<String, dynamic>.from(ctx.payload);
      ctx.payload.remove('address');
      ctx.payload.remove('phone');
      ctx.payload.remove('nik_ktp');
      ctx.payload.remove('phone2');
      ctx.payload.remove('no_bank');
      ctx.payload.remove('department_id');
      ctx.payload.remove('position_id');
      ctx.payload.remove('role_id');
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
      var userId = ctx.req.url.pathSegments.isNotEmpty
          ? ctx.req.url.pathSegments.last
          : null;
      await Future.wait(
        [
          model.update('users_detail', {
            'address': ctx['data']['address'],
            'phone': ctx['data']['phone'],
            'nik_ktp': ctx['data']['nik_ktp'],
            'phone2': ctx['data']['phone2'],
            'no_bank': ctx['data']['no_bank'],
          }, where: {
            'user_id': userId,
          }),
          model.update('employees', {
            'full_name': ctx['data']['name'],
            'department_id': ctx['data']['department_id'],
            'position_id': ctx['data']['position_id'],
          }, where: {
            'user_id': userId,
          }),
          model.findOne('user_roles', where: {
            'user_id': userId,
          }).then((userRole) async {
            if (userRole != null && ctx['data']['role_id'] != null) {
              await model.update('user_roles', {
                'role_id': ctx['data']['role_id'],
              }, where: {
                'user_id': userId,
              });
            } else if (ctx['data']['role_id'] != null) {
              await model.create('user_roles', {
                'user_role_id': const Uuid().v4(),
                'user_id': userId,
                'role_id': ctx['data']['role_id'],
              });
            }
          }),
        ],
      );

      var result = await model.leftJoin('users', joins: [
        {
          'table': 'users_detail',
          'sourceTable': 'users',
          'sourceKey': 'user_id',
          'targetKey': 'user_id',
        },
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
          "table": 'user_roles',
          "sourceTable": 'users',
          "sourceKey": 'user_id',
          "targetKey": 'user_id',
        },
        {
          "table": 'roles',
          "sourceTable": 'user_roles',
          "sourceKey": 'role_id',
          "targetKey": 'role_id',
        }
      ], fields: [
        'users.user_id',
        'users.name',
        'users.is_active',
        'users_detail.address',
        'users_detail.phone AS phone_number',
        'users_detail.nik',
        'users_detail.nik_ktp',
        'users_detail.no_bank',
        'users_detail.nama_bank',
        'employees.contract_type',
        'employees.employee_status',
        'departments.name AS department_name',
        'positions.name AS position_name',
        'roles.name AS role_name',
      ], where: {
        'users.user_id': userId,
      }).then((data) => data.isNotEmpty ? data.first : null);
      ctx.result = result;
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
      final targetUserId = resolveDeleteTargetUserId(ctx.req);
      if (targetUserId == null) {
        throw ArgumentError('Missing target user_id for delete');
      }

      ctx['deleteTargetUserId'] = targetUserId;

      final employee = await model.findOne('employees', where: {
        'user_id': targetUserId,
      });
      final employeeId = employee?['employee_id']?.toString();
      ctx['deleteEmployeeId'] = employeeId;

      if (employeeId != null) {
        await model.destroy('employee_change_requests', where: {
          'employee_id': employeeId,
        });
        await model.destroy('employee_documents', where: {
          'employee_id': employeeId,
        });
        await model.destroy('contracts', where: {
          'employee_id': employeeId,
        });
        await model.destroy('contract_approval_steps', where: {
          'approver_employee_id': employeeId,
        });
        await model.destroy('contract_signatures', where: {
          'employee_id': employeeId,
        });
        await model.destroy('contract_renewals', where: {
          'employee_id': employeeId,
        });
      }

      await Future.wait([
        model.destroy('users_detail', where: {
          'user_id': targetUserId,
        }),
        model.destroy('session', where: {
          'user_id': targetUserId,
        }),
        model.destroy('user_roles', where: {
          'user_id': targetUserId,
        }),
      ]);

      await model.destroy('employees', where: {
        'user_id': targetUserId,
      });
    };
    afterDelete = (ctx) async {
      final targetUserId = (ctx['deleteTargetUserId'] as String?) ??
          resolveDeleteTargetUserId(ctx.req);
      if (targetUserId == null) {
        ctx.result = {
          'message': 'Error deleting user: Missing target user_id',
        };
        return ctx.result;
      }

      final employeeId = ctx['deleteEmployeeId'] as String?;
      final verificationChecks = buildDeleteVerificationChecks(
        targetUserId,
        employeeId: employeeId,
      );

      final remainingRecords = await Future.wait(
        verificationChecks.map(
          (check) => model.findOne(
            check['table'] as String,
            where: Map<String, dynamic>.from(check['where'] as Map),
          ),
        ),
      );

      final hasRemainingData = remainingRecords.any((record) => record != null);
      if (hasRemainingData) {
        ctx.result = {
          'message': 'Error deleting user: User still has related data',
        };
        return ctx.result;
      }
      ctx.result = {
        'message': 'User deleted successfully',
      };

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
