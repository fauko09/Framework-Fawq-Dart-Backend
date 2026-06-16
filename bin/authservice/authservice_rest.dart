import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';

import '../dart_rest/dart_rest_service.dart';
import '../dart_rest/mysql/mysql_service.dart';
import '../env_loader.dart';
import '../auth_guard.dart';

class _AuthSession {
  final String accessTokenJti;
  final String refreshTokenJti;
  final String userId;
  final DateTime expiresAt;

  const _AuthSession({
    required this.accessTokenJti,
    required this.refreshTokenJti,
    required this.userId,
    required this.expiresAt,
  });
}

final env = EnvLoader.load();

final String _secret = env['scret'] ?? "";
var model = MySqlInitService();
// final Map<String, _AuthSession> _accessSessions = {};
// final Map<String, _AuthSession> _refreshSessions = {};

class AuthserviceRest extends DartRestService<Map<String, dynamic>> {
  AuthserviceRest() : super('authservice', customService: true) {
    enablePagination = true;

    // get by id
// get by id / refresh token
    beforeGetAll = (ctx) async {
      print('header authorization: ${ctx.req.headers['authorization']}');
      final refreshToken =
          ctx.req.headers['authorization'].toString().replaceAll('Bearer ', '');

      if (refreshToken.isEmpty) {
        throw AuthException('refreshToken is required');
      }

      // Verify JWT refresh token
      final payload = _verifyToken(
        refreshToken,
        expectedType: 'refresh',
      );

      final refreshJti = payload['jti']?.toString();
      final userId = payload['sub']?.toString();

      if (refreshJti == null || userId == null) {
        throw AuthException('Invalid refresh token payload');
      }
      print('value refreshJti: $refreshJti');
      // Cek session refresh token
      final session = await model.findOne('session', where: {
        'user_id': userId,
      }).then((session) {
        if (session == null) {
          throw AuthException('Refresh session not found');
        }
        final decodedJWt =
            JWT.verify(session['refresh_token_jti'], SecretKey(_secret));

        if (DateTime.parse(session['expires_at'].toString())
            .isBefore(DateTime.now())) {
          model.destroy('session',
              where: {'refresh_token_jti': decodedJWt.payload['jti']});
          throw AuthException('Refresh token expired');
        }

        if (session['user_id'] != userId) {
          throw AuthException('Invalid refresh token owner');
        }

        return session;
      }).catchError((error) {
        throw AuthException(error.toString());
      });

      final user = await model.findOne(
        'users',
        where: {'user_id': userId},
      );

      if (user == null) {
        throw AuthException('User not found');
      }

      if (user['is_active'] == 0) {
        throw AuthException('User is inactive');
      }

      // Simpan data sementara ke context untuk afterGetOne
      ctx.result = {
        'user': user,
        'userId': userId,
        'refreshJti': session['refresh_token_jti'].toString(),
      };
    };

    afterGetAll = (ctx) async {
      final user = ctx.result['user'];
      final userId = ctx.result['userId'].toString();
      final refreshJti = ctx.result['refreshJti'].toString();

      final newAccessJti = const Uuid().v4();

      final accessSession = _AuthSession(
        accessTokenJti: newAccessJti,
        refreshTokenJti: refreshJti,
        userId: userId,
        expiresAt: DateTime.now().add(const Duration(hours: 8)),
      );
      final newRefreshJti = const Uuid().v4();

      final refreshSession = _AuthSession(
        accessTokenJti: newAccessJti,
        refreshTokenJti: newRefreshJti,
        userId: userId,
        expiresAt: DateTime.now().add(const Duration(hours: 8)),
      );
      var getSession = await model.findOne('session', where: {
        'user_id': userId,
      }).then((data) async {
        await model.update(
          'session',
          {
            'access_token_jti': _signToken(
              userId: userId,
              jti: accessSession.accessTokenJti,
              type: 'access',
              expiresIn: const Duration(hours: 8),
            ),
            'refresh_token_jti': _signToken(
              userId: userId,
              jti: refreshSession.refreshTokenJti,
              type: 'refresh',
              expiresIn: const Duration(hours: 9),
            ),
            'expires_at': refreshSession.expiresAt,
          },
          where: {'user_id': userId},
        );
        var getSessionB = await model.findOne('session', where: {
          'user_id': userId,
        });
        data = getSessionB;
        return data;
      });

      final expiresAt = DateTime.now().add(const Duration(hours: 8));
      if (getSession == null) {
        throw AuthException('Session not found');
      }
      ctx.result = {
        'accessToken': getSession['access_token_jti'].toString(),
        'refreshToken': getSession['refresh_token_jti'].toString(),
        'expiresAt': expiresAt,
        'user': user,
      };
      return ctx.result;
    };
    // post
    beforeCreate = (ctx) async {
      final body = ctx.payload;
      print('Received login request: ${ctx.payload}');

      final data = fromJson(body);
      final email = data['email'] as String?;
      final password = data['password'] as String?;
   
      if (email == null || password == null) {
        throw Exception('Email and password are required');
      }
      final user = await model.findOne('users', where: {'email': email});
      final encryptedPassword = AuthGuard().encryptPassword(password);
      if (user == null ||
          user['password'] != encryptedPassword ||
          user['is_active'] == 'false') {
        throw Exception('Invalid email or password');
      }

      ctx.result = Map<String, dynamic>.from(user);
      print('before user: ${ctx.result}');
    };
    afterCreate = (data, ctx) async {
      print('Login successful for user: $data');
      final expiresAt = DateTime.now().add(const Duration(hours: 8));
      // Buat session baru
      final session = _AuthSession(
        accessTokenJti: Uuid().v4(),
        refreshTokenJti: Uuid().v4(),
        userId: ctx.result['user_id'].toString(),
        expiresAt: expiresAt,
      );

      final dataSession = await model.findOne('session', where: {
        'user_id': ctx.result['user_id'].toString(),
      }).then((sessionData) async {
        if (sessionData == null) {
          await model.create('session', {
            'session_id': const Uuid().v4(),
            'user_id': session.userId,
            'access_token_jti': _signToken(
              userId: ctx.result['user_id'].toString(),
              jti: session.accessTokenJti,
              type: 'access',
              expiresIn: Duration(hours: 8),
            ),
            'refresh_token_jti': _signToken(
              userId: ctx.result['user_id'].toString(),
              jti: session.refreshTokenJti,
              type: 'refresh',
              expiresIn: Duration(hours: 9),
            ),
            'expires_at': session.expiresAt,
          });
          var getSession = await model.findOne('session', where: {
            'user_id': ctx.result['user_id'].toString(),
          });
          sessionData = getSession;
        } else {
          await model.update(
            'session',
            {
              'access_token_jti': _signToken(
                userId: ctx.result['user_id'].toString(),
                jti: session.accessTokenJti,
                type: 'access',
                expiresIn: Duration(hours: 8),
              ),
              'refresh_token_jti': _signToken(
                userId: ctx.result['user_id'].toString(),
                jti: session.refreshTokenJti,
                type: 'refresh',
                expiresIn: Duration(hours: 9),
              ),
              'expires_at': session.expiresAt,
            },
            where: {'user_id': session.userId},
          );
          var getSession = await model.findOne('session', where: {
            'user_id': ctx.result['user_id'].toString(),
          });
          sessionData = getSession;
        }
        return sessionData;
      });

      if (dataSession == null) {
        return {};
      }

      return {
        'accessToken': dataSession['access_token_jti'].toString(),
        'refreshToken': dataSession['refresh_token_jti'].toString(),
        'expiresAt': expiresAt,
        'user': ctx.result,
      };
    };
  }

  String _signToken({
    required String userId,
    required String jti,
    required String type,
    required Duration expiresIn,
  }) {
    final jwt = JWT({
      'sub': userId,
      'jti': jti,
      'typ': type,
    });
    return jwt.sign(
      SecretKey(_secret),
      expiresIn: expiresIn,
    );
  }

  Map<String, dynamic> _verifyToken(
    String token, {
    required String expectedType,
  }) {
    try {
      final decoded = JWT.verify(token, SecretKey(_secret));
      final payload = decoded.payload as Map<String, dynamic>;
      print('Type token: ${payload['typ']}');
      if (payload['typ'] != expectedType) {
        throw AuthException('Invalid token type');
      }
      return payload;
    } on JWTException catch (error) {
      throw AuthException(error.message);
    }
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

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
