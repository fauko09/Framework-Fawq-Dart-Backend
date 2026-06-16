import 'dart:convert';

import 'dart_rest/mysql/mysql_service.dart';

class VerifyPremission {
  var model = MySqlInitService();

  Future<List<Map<String, dynamic>>> verifyPremission(
    String userId,
  ) async {
    print('verifyPremission userId: $userId');

    var data = await model.innerJoin(
      'user_roles',
      joins: [
        {
          'table': 'roles',
          'sourceTable': 'user_roles',
          'sourceKey': 'role_id',
          'targetKey': 'role_id',
        },
        {
          'table': 'role_permissions',
          'sourceTable': 'roles',
          'sourceKey': 'role_id',
          'targetKey': 'role_id',
        },
        {
          'table': 'permissions',
          'sourceTable': 'role_permissions',
          'sourceKey': 'permission_id ',
          'targetKey': 'permission_id ',
        }
      ],
      fields: [
        'user_roles.user_id',
        'roles.name AS role_name',
        'permissions.code AS code',
      ],
      where: {
        'user_roles.user_id': userId,
      },
    );
    if (data.isEmpty) {
      return [];
    }
    return data;
  }
}
