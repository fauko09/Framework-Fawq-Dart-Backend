import 'swagger/swagger_ui.dart';

Future<void> main(List<String> args) async {
  final server = await serveSwaggerUi();
  print(
    '📘 Swagger UI listening on http://${server.address.host}:${server.port}',
  );
}
