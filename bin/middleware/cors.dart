import 'package:shelf/shelf.dart';

Middleware corsMiddleware() {
  return (Handler innerHandler) {
    return (Request request) async {
      final origin = request.headers['origin'] ?? '*';
      const allowMethods = 'GET, POST, PATCH, DELETE, OPTIONS';
      const allowHeaders = 'Origin, Content-Type, Accept, Authorization';

      if (request.method.toUpperCase() == 'OPTIONS') {
        return Response(
          204,
          headers: {
            'access-control-allow-origin': origin,
            'access-control-allow-methods': allowMethods,
            'access-control-allow-headers': allowHeaders,
            'access-control-allow-credentials': 'true',
            'vary': 'Origin',
          },
        );
      }

      final response = await innerHandler(request);
      return response.change(
        headers: {
          ...response.headers,
          'access-control-allow-origin': origin,
          'access-control-allow-methods': allowMethods,
          'access-control-allow-headers': allowHeaders,
          'access-control-allow-credentials': 'true',
          'vary': 'Origin',
        },
      );
    };
  };
}
