import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';

class RateLimiter {
  final int maxRequests;
  final Duration window;

  final _hits = HashMap<String, List<DateTime>>();

  RateLimiter({
    required this.maxRequests,
    required this.window,
  });

  Middleware call() {
    return (Handler innerHandler) {
      return (Request request) async {
        final connectionInfo =
            request.context['shelf.io.connection_info'] as HttpConnectionInfo?;

        final ip = connectionInfo?.remoteAddress.address ?? 'unknown';

        final now = DateTime.now();
        final hits = _hits.putIfAbsent(ip, () => []);

        // Bersihkan request lama
        hits.removeWhere((t) => now.difference(t) > window);

        if (hits.length >= maxRequests) {
          return Response(
            429,
            body: jsonEncode({'error': 'Too many requests'}),
            headers: {'content-type': 'application/json'},
          );
        }

        hits.add(now);
        return innerHandler(request);
      };
    };
  }
}
