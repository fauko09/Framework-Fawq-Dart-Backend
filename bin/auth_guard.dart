import 'dart:convert';

import 'package:server/src/auth/auth_service.dart';
import 'package:shelf/shelf.dart';
import 'dart_rest/mysql/mysql_service.dart';
import 'package:crypto/crypto.dart';

class AuthGuard {
  var model = MySqlInitService();
  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  dynamic authorizedUser(Request request) {
    final header = request.headers['authorization'];
    if (header == null || !header.startsWith('Bearer ')) return null;

    final token = header.substring(7);
    try {
      print('token: $token');
      return model.findOne('session', where: {
        'access_token_jti': token,
      }).then((session) {
        if (session == null) {
          throw AuthException('Session not found');
        }
        final userId = session['user_id'];
        final user = model.findOne('users', where: {
          'user_id': userId,
        }).catchError((error) {
          throw AuthException(error.toString());
        });
        return user;
      });
    } on AuthException {
      return null;
    }
  }
}
