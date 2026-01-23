import 'dart:io';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf_multipart/shelf_multipart.dart';

import '../dart_rest/dart_rest_service.dart';

class UploadServiceRest extends DartRestService <Map<String, dynamic>>{
  UploadServiceRest() : super('file') {
    enablePagination = true;
    primaryKey = 'file_id';

    beforeCreate = _beforeCreateUpload;
    afterCreate = _afterCreateUpload;
    afterGetOne = _afterGetOneServeFile;

    afterGetAll = (ctx) async {
      if (ctx.result is Map && ctx.result['data'] is List) {
        final list = List<Map<String, dynamic>>.from(ctx.result['data']);

        final cleaned = list.where((row) {
          return row.values.any((v) => v != null);
        }).toList();

        ctx.result['data'] = cleaned;
        ctx.result['total'] = cleaned.length;
      }
    };
  }

  @override
  Map<String, dynamic> fromJson(Map<String, dynamic> json) =>
      Map<String, dynamic>.from(json);

  @override
  Map<String, dynamic> toJson(item) => Map<String, dynamic>.from(item);

  // =========================
  // BEFORE CREATE (UPLOAD)
  // =========================
  Future<void> _beforeCreateUpload(HookContext ctx) async {
    final Request req = ctx.req;

    final multipart = req.multipart();
    if (multipart == null) {
      throw 'Request must be multipart/form-data';
    }

    String? originalName;
    File? savedFile;

    // 📁 assets/uploads
    final uploadDir = Directory('assets/uploads');
    await uploadDir.create(recursive: true);

    await for (final part in multipart.parts) {
      final disp = part.headers['content-disposition'];

      if (disp != null && disp.contains('filename=')) {
        originalName =
            RegExp(r'filename="([^"]*)"').firstMatch(disp)?.group(1);

        final fileId = DateTime.now().millisecondsSinceEpoch.toString();
        final ext = p.extension(originalName ?? '');
        final savedPath = p.join(uploadDir.path, '$fileId$ext');

        final file = File(savedPath);
        final sink = file.openWrite();
        await part.pipe(sink);
        await sink.close();

        savedFile = file;
      } else {
        // penting: drain supaya stream lanjut
        await part.drain();
      }
    }

    if (savedFile == null) {
      throw 'File not found in multipart';
    }

    final mime = lookupMimeType(savedFile.path) ??
        'application/octet-stream';

    ctx.payload.addAll({
      'file_id': p.basenameWithoutExtension(savedFile.path),
      'file_name': p.basename(savedFile.path),
      'file_path': savedFile.path,
      'file_type': mime,
    });
  }

  // =========================
  // AFTER CREATE
  // =========================
  Future<Map<String, dynamic>> _afterCreateUpload(
      Map<String, dynamic> data, HookContext ctx) async {
    ctx.result = {
      'file_id': data['file_id'],
      'file_name': data['file_name'],
      'file_type': data['file_type'],
      'file_path': data['file_path'],
    };
    return ctx.result;
  }

  // =========================
  // GET /file/:id → STREAM FILE
  // =========================
  Future<void> _afterGetOneServeFile(HookContext ctx) async {
    final record = ctx['record'];
    if (record == null) return;

    final path = record['file_path'];
    if (path == null) return;

    final file = File(path);
    if (!await file.exists()) {
      ctx.result = Response.notFound('File not found');
      return;
    }

    final bytes = await file.readAsBytes();
    final mime = lookupMimeType(path) ??
        'application/octet-stream';

    ctx.result = Response.ok(
      bytes,
      headers: {
        'Content-Type': mime,
        'Content-Disposition':
            'inline; filename="${record['file_name']}"',
      },
    );
  }
}
