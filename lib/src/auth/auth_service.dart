import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';

import '../foundation/models.dart';
import '../foundation/repositories.dart';

class AuthSession {
  final String accessTokenJti;
  final String refreshTokenJti;
  final String userId;

  const AuthSession({
    required this.accessTokenJti,
    required this.refreshTokenJti,
    required this.userId,
  });
}

class AuthService {
  AuthService({
    required this.repository,
    String? secret,
  }) : _secret = secret ?? 'hris-fga-dev-secret';

  final FoundationRepository repository;
  final String _secret;
  final Uuid _uuid = const Uuid();
  final Map<String, AuthSession> _accessSessions = {};
  final Map<String, AuthSession> _refreshSessions = {};

  Map<String, dynamic> login(String email, String password) {
    final user = repository.findUserByEmail(email);
    if (user == null || user.password != password || !user.isActive) {
      throw AuthException('Invalid email or password');
    }

    final session = AuthSession(
      accessTokenJti: _uuid.v4(),
      refreshTokenJti: _uuid.v4(),
      userId: user.id,
    );

    _accessSessions[session.accessTokenJti] = session;
    _refreshSessions[session.refreshTokenJti] = session;

    return {
      'accessToken': _signToken(
        userId: user.id,
        jti: session.accessTokenJti,
        type: 'access',
        expiresIn: const Duration(hours: 8),
      ),
      'refreshToken': _signToken(
        userId: user.id,
        jti: session.refreshTokenJti,
        type: 'refresh',
        expiresIn: const Duration(days: 7),
      ),
      'user': repository.userToMap(user),
    };
  }

  User currentUser(String token) {
    final payload = _verifyToken(token, expectedType: 'access');
    final session = _accessSessions[payload['jti']];
    if (session == null) {
      throw AuthException('Session expired');
    }

    final user = repository.findUserById(payload['sub'] as String);
    if (user == null) {
      throw AuthException('User not found');
    }
    return user;
  }

  Map<String, dynamic> refresh(String refreshToken) {
    final payload = _verifyToken(refreshToken, expectedType: 'refresh');
    final session = _refreshSessions[payload['jti']];
    if (session == null) {
      throw AuthException('Refresh session expired');
    }

    final accessJti = _uuid.v4();
    final newSession = AuthSession(
      accessTokenJti: accessJti,
      refreshTokenJti: session.refreshTokenJti,
      userId: session.userId,
    );
    _accessSessions[accessJti] = newSession;
    _refreshSessions[session.refreshTokenJti] = newSession;

    return {
      'accessToken': _signToken(
        userId: session.userId,
        jti: accessJti,
        type: 'access',
        expiresIn: const Duration(hours: 8),
      ),
    };
  }

  void logout(String token) {
    final payload = _verifyToken(token, expectedType: 'access');
    final session = _accessSessions.remove(payload['jti']);
    if (session != null) {
      _refreshSessions.remove(session.refreshTokenJti);
    }
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
      if (payload['typ'] != expectedType) {
        throw AuthException('Invalid token type');
      }
      return payload;
    } on JWTException catch (error) {
      throw AuthException(error.message);
    }
  }

}

class AuthException implements Exception {
  final String message;

  const AuthException(this.message);

  @override
  String toString() => message;
}
