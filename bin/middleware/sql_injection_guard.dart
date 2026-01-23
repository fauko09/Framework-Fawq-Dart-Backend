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

        final contentType = request.headers['content-type'] ?? '';

        // 2️⃣ HANYA JSON
        if (!contentType.contains('application/json')) {
          return innerHandler(request);
        }

        final body = await request.readAsString();

        if (body.isNotEmpty && _isMalicious(body)) {
          return _blocked();
        }

        // 3️⃣ Rebuild request DENGAN HEADER UTUH
        final rebuiltRequest = request.change(
          body: Stream.value(utf8.encode(body)),
          headers: {
            ...request.headers,
            'content-length': utf8.encode(body).length.toString(),
          },
        );

        return innerHandler(rebuiltRequest);
      };
    };
  }

  bool _isMalicious(String input) {
    return _patterns.any((p) => p.hasMatch(input));
  }

  Response _blocked() {
    return Response(
      400,
      body: jsonEncode({'error': 'Malicious input detected'}),
      headers: {'content-type': 'application/json'},
    );
  }
}
