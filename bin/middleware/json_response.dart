import 'dart:convert';

import 'package:shelf/shelf.dart';

Response jsonOk(Map<String, dynamic> body, {int statusCode = 200}) {
  return Response(
    statusCode,
    body: jsonEncode(body),
    headers: const {'content-type': 'application/json'},
  );
}

Response jsonError(String message, {int statusCode = 400}) {
  return Response(
    statusCode,
    body: jsonEncode({'message': message}),
    headers: const {'content-type': 'application/json'},
  );
}
