import 'dart:convert';
import 'package:shelf/shelf.dart';

class SqlInjectionGuard {
  static final _patterns = [
    RegExp(r"(\%27)|(\')|(\-\-)|(\%23)|(#)", caseSensitive: false),
    RegExp(r"\b(select|update|delete|insert|drop|union|exec|sleep)\b",
        caseSensitive: false),
    RegExp(r"(\bor\b|\band\b)\s+\d+=\d+", caseSensitive: false),
  ];

  Middleware call() {
    return (Handler innerHandler) {
      return (Request request) async {
        // 1️⃣ Check query params
        for (final value in request.url.queryParameters.values) {
          if (_isMalicious(value)) {
            return _blocked();
          }
        }

        // 2️⃣ Check body (JSON only)
        if (request.headers['content-type']?.contains('application/json') ==
            true) {
          final body = await request.readAsString();
          if (_isMalicious(body)) {
            return _blocked();
          }

          // Re-inject body supaya handler tetap bisa baca
          request = request.change(
            body: Stream.value(utf8.encode(body)),
          );
        }

        return innerHandler(request);
      };
    };
  }

  bool _isMalicious(String input) {
    return _patterns.any((p) => p.hasMatch(input));
  }

  Response _blocked() {
    return Response(
      400,
      body: {'error': 'Malicious input detected'},
      headers: {'content-type': 'application/json'},
    );
  }
}
