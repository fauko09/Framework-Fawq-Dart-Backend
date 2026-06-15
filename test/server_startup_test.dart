import 'dart:io';

import 'package:test/test.dart';

import '../bin/server.dart';

void main() {
  test('startBoundServer reports the correct service and port on conflict',
      () async {
    await expectLater(
      () => startBoundServer(
        serviceName: 'Swagger UI',
        port: 2001,
        bind: () async => throw const SocketException(
          'Failed to create server socket',
          osError: OSError('Address already in use', 48),
        ),
      ),
      throwsA(
        isA<StateError>().having(
          (error) => error.message,
          'message',
          '❌ Swagger UI port 2001 is already in use. Stop the existing process or change the configured port.',
        ),
      ),
    );
  });
}
