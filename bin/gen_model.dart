import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ Model name required');
    exit(1);
  }

  final name = args[0].toLowerCase();
  final className = _pascal(name);
  final modelFile = File('bin/dart_rest/models/$name.dart');
  final registryFile = File('bin/dart_rest/model_registry.dart');

  modelFile.parent.createSync(recursive: true);
  registryFile.parent.createSync(recursive: true);

  if (!modelFile.existsSync()) {
    modelFile.writeAsStringSync(_modelTemplate(className, name));
  }

  _updateRegistry(registryFile, className, name);

  print('✅ Model $className generated & registered');
}

void _updateRegistry(File file, String className, String fileName) {
  final models = <String>{};

  // Ambil model lama dari registry (parse Class())
  if (file.existsSync()) {
    final content = file.readAsStringSync();
    final regex = RegExp(r'(\w+)\(\),');
    for (final m in regex.allMatches(content)) {
      models.add(m.group(1)!);
    }
  }

  // Tambah model baru
  models.add(className);

  final buffer = StringBuffer()..writeln("import 'migrator/model.dart';");

  for (final m in models) {
    buffer.writeln(
      "import '../dart_rest/models/${_snake(m)}.dart';",
    );
  }

  buffer
    ..writeln('\n// AUTO GENERATED – DO NOT EDIT')
    ..writeln('final List<Model> registeredModels = [');

  for (final m in models) {
    buffer.writeln('  $m(),');
  }

  buffer.writeln('];');

  file.writeAsStringSync(buffer.toString());
}

String _modelTemplate(String className, String table) => '''
import '../migrator/model.dart';
import '../migrator/column.dart';
import '../migrator/relation.dart';

class $className extends Model {
  @override
  String get table => '$table';

  @override
  Map<String, Column> get schema => {
    '${table}_id': Column.string(length: 50, primaryKey: true),
  };
}
''';

String _pascal(String t) =>
    t.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();

String _snake(String input) {
  final buffer = StringBuffer();
  for (int i = 0; i < input.length; i++) {
    final char = input[i];
    if (_isUpper(char) && i != 0) {
      buffer.write('_');
    }
    buffer.write(char.toLowerCase());
  }
  return buffer.toString();
}

bool _isUpper(String c) => c.codeUnitAt(0) >= 65 && c.codeUnitAt(0) <= 90;
