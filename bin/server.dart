import 'dart:convert';
import 'dart:io';
import 'package:shelf_router/shelf_router.dart';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'dart_rest/migrator/migrator.dart';
import 'upload_service/upload_service_rest.dart';
import 'env_loader.dart';
import 'middleware/middleware.dart';
import 'authservice/authservice_rest.dart';
import 'middleware/cors.dart';
import 'swagger/swagger_ui.dart';
import 'users/users_rest.dart';
import 'roles/roles_rest.dart';
import 'dart_rest/seeder/bootstrap_seeder.dart';
import 'premission/premission_rest.dart';
String formatPortInUseMessage({
  required String serviceName,
  required int port,
}) {
  return '❌ $serviceName port $port is already in use. '
      'Stop the existing process or change the configured port.';
}

Future<HttpServer> startBoundServer({
  required String serviceName,
  required int port,
  required Future<HttpServer> Function() bind,
}) async {
  try {
    return await bind();
  } on SocketException catch (error) {
    if (error.osError?.errorCode == 48) {
      throw StateError(
        formatPortInUseMessage(serviceName: serviceName, port: port),
      );
    }

    rethrow;
  }
}

Future<void> main(List<String> args) async {
  // Load environment
  final env = EnvLoader.load();

  // Jalankan migrasi dulu
  await Migrator.init();

  // await BootstrapSeeder.init();

  // Setup router utama
  final router = Router();

  // Mount modular route seperti `/example` (kamu bisa tambah lagi)

  final uploadRest = UploadServiceRest();
  router.mount('/upload', uploadRest.router.call);
  final authRest = AuthserviceRest();
  router.mount('/auth', authRest.router.call);
  final userRest = UsersRest();
  router.mount('/users', userRest.router.call);
  final rolesRest = RolesRest();
  router.mount('/roles', rolesRest.router.call);
  final premissionRest = PremissionRest();
  router.mount('/premission', premissionRest.router.call);
  // Route default /root

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
      .addMiddleware(corsMiddleware.call())
      .addHandler(router.call);

  // Start server
  final ip = InternetAddress.anyIPv4;
  final port = int.tryParse(env['PORT_SERVER'].toString()) ?? 8080;
  // final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;

  try {
    final server = await startBoundServer(
      serviceName: 'API server',
      port: port,
      bind: () => serve(handler, ip, port),
    );

    try {
      final swaggerServer = await startBoundServer(
        serviceName: 'Swagger UI',
        port: swaggerUiPort,
        bind: () => serveSwaggerUi(address: ip),
      );

      print(
        '📘 Swagger UI listening on http://${swaggerServer.address.host}:${swaggerServer.port}',
      );
      print(
          '🚀 Server listening on http://${server.address.host}:${server.port}');
    } on StateError {
      await server.close(force: true);
      rethrow;
    }
  } on StateError catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
    return;
  } on SocketException {
    rethrow;
  }
}
