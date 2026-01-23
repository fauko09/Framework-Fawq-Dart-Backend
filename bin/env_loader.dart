import 'dart:io';
import 'package:dotenv/dotenv.dart';

class EnvLoader {
  static final DotEnv _env = DotEnv(includePlatformEnvironment: false);
  static bool _loaded = false;

  static DotEnv load() {
    if (_loaded) return _env;

    final envPath = _resolveEnvPath();

    if (envPath != null && File(envPath).existsSync()) {
      _env.load([envPath]);
      print('🌱 ENV loaded from: $envPath');
    } else {
      throw Exception(
        '❌ .env NOT FOUND.\n'
        'Expected at:\n'
        '  - Project root (debug)\n'
        '  - Same folder as binary (production)\n'
      );
    }

    _loaded = true;
    return _env;
  }

  /// 🔍 Tentukan lokasi .env berdasarkan runtime
  static String? _resolveEnvPath() {
    // 1️⃣ Kalau binary native
    final exe = Platform.resolvedExecutable;
    if (!exe.endsWith('dart') && !exe.endsWith('dart.exe')) {
      final exeDir = File(exe).parent.path;
      final env = '$exeDir/.env';
      return env;
    }

    // 2️⃣ Kalau dart run → cari di project root
    var dir = Directory.current;
    while (true) {
      final candidate = File('${dir.path}/.env');
      if (candidate.existsSync()) {
        return candidate.path;
      }
      if (dir.parent.path == dir.path) break;
      dir = dir.parent;
    }

    return null;
  }
}
