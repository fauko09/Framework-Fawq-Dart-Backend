import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart_rest/migrator/migrator.dart';
import 'upload_service/upload_service_rest.dart';
import 'env_loader.dart';
import 'middleware/middleware.dart';
import 'ping/ping_rest.dart';

Future<void> main(List<String> args) async {
  // Load environment
  final env = EnvLoader.load();

  // Jalankan migrasi dulu
  await Migrator.init();

  // Setup router utama
  final router = Router();

  // Mount modular route seperti `/example` (kamu bisa tambah lagi)

  final uploadRest = UploadServiceRest();
  router.mount('/upload', uploadRest.router.call);
  // Route default /root
  final customServiceExample = PingRest();
  router.mount('/example', customServiceExample.router.call);

  router.get('/', (Request req) {
    return Response.ok(
      jsonEncode({'message': '✅ Backend REST API is running'}),
      headers: {'content-type': 'application/json'},
    );
  });

  // Global middleware (logger, dll)
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(
        RateLimiter(
          maxRequests: 100,
          window: Duration(minutes: 1),
        ).call(),
      )
      .addMiddleware(
        SqlInjectionGuard().call(),
      )
      .addHandler(router.call);

  // Start server
  final ip = InternetAddress.anyIPv4;
  final port = int.tryParse(env['PORT_SERVER'].toString()) ?? 8080;
  // final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;

  final server = await serve(handler, ip, port);
  print('🚀 Server listening on http://${server.address.host}:${server.port}');
}
