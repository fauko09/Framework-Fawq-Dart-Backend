import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('❌ Nama service wajib diisi');
    print('Contoh: dart run gen_rest.dart exampleService');
    exit(1);
  }

  final name = args[0].toLowerCase();
  final hasDb = args.length < 2 || args[1] != '--no-db';
  final className = '${_pascalCase(name)}Rest';
  final fileName = '${name}_rest.dart';
  final dir = Directory('bin/$name/');

  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  final file = File('${dir.path}/$fileName');

  if (file.existsSync()) {
    print('⚠️ File sudah ada: ${file.path}');
    exit(1);
  }

  file.writeAsStringSync(_template(className, name , hasDb));

  print('✅ Generated: ${file.path}');
}

String _template(String className, String resource , bool hasDb) {
  return '''
import '../dart_rest/dart_rest_service.dart';

class $className extends DartRestService<Map<String, dynamic>>{
  $className() : super('$resource', customService: ${!hasDb}) {
    enablePagination = true;

    ${hasDb ? "primaryKey = '${resource}_id';" : ''}

    // get all
    beforeGetAll = (ctx) async {};
    afterGetAll = (ctx) async {};

    // get by id
    beforeGetOne = (ctx) async {};
    afterGetOne = (ctx) async {};

    // post
    beforeCreate = (ctx) async {};
    afterCreate = (data, ctx) async {};

    // patch/id or put/id
    beforeUpdate = (ctx) async {};
    afterUpdate = (data, ctx) async {};

    // delete/id
    beforeDelete = (ctx) async {};
    afterDelete = (ctx) async {};
  }


  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return Map<String, dynamic>.from(json);
  }

  @override
  Map<String, dynamic> toJson(item) {
    return Map<String, dynamic>.from(item);
  }
}
''';
}

String _pascalCase(String text) {
  return text.split('_').map((e) => e[0].toUpperCase() + e.substring(1)).join();
}
