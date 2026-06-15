import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_swagger_ui/shelf_swagger_ui.dart';

const int swaggerUiPort = 2001;
const String swaggerUiTitle = 'HRIS FGA API';

File resolveSwaggerSpecFile() {
  var dir = Directory.current;

  while (true) {
    final candidate = File('${dir.path}/swagger-ui/swagger.json');
    if (candidate.existsSync()) {
      return candidate;
    }

    if (dir.parent.path == dir.path) {
      throw StateError('Swagger spec not found at swagger-ui/swagger.json');
    }

    dir = dir.parent;
  }
}

Handler buildSwaggerUiHandler({File? specFile}) {
  final file = specFile ?? resolveSwaggerSpecFile();
  return SwaggerUI.fromFile(file, title: swaggerUiTitle);
}

Future<HttpServer> serveSwaggerUi({
  InternetAddress? address,
  int port = swaggerUiPort,
  File? specFile,
}) async {
  final handler = Pipeline().addHandler(
    buildSwaggerUiHandler(specFile: specFile),
  );

  return shelf_io.serve(
    handler,
    address ?? InternetAddress.anyIPv4,
    port,
  );
}
