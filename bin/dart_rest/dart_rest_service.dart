import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'mysql/mysql_service.dart';

/// 🔹 Context data class
class HookContext {
  final Request req;
  final Map<String, dynamic> data = {};
  final Map<String, dynamic> payload = {};
  dynamic result;
  HookContext(this.req, {Map<String, dynamic>? initial}) {
    if (initial != null) data.addAll(initial);
  }

  dynamic operator [](String key) => data[key];
  void operator []=(String key, dynamic value) => data[key] = value;
}

/// 🔹 Type definition for hooks
typedef Hook<T> = Future<void> Function(HookContext ctx);
typedef ModifyHook<T> = Future<T> Function(T data, HookContext ctx);

/// 🔹 Global hook registry
class HiveRestFramework {
  static final List<Hook> beforeAll = [];
  static final List<Hook> afterAll = [];
  static final List<Function(HookContext ctx, Object error)> onError = [];

  static void useBeforeAll(Hook hook) => beforeAll.add(hook);
  static void useAfterAll(Hook hook) => afterAll.add(hook);
  static void useOnError(Function(HookContext ctx, Object error) handler) =>
      onError.add(handler);

  static Future<void> runBeforeAll(HookContext ctx) async {
    for (final hook in beforeAll) {
      await hook(ctx);
    }
  }

  static Future<void> runAfterAll(HookContext ctx) async {
    for (final hook in afterAll) {
      await hook(ctx);
    }
  }

  static Future<void> runOnError(HookContext ctx, Object error) async {
    for (final handler in onError) {
      await handler(ctx, error);
    }
  }
}

class QueryFilter {
  static bool match(Map<String, dynamic> record, Map<String, dynamic> filters) {
    for (final key in filters.keys) {
      final value = filters[key];
      final recordValue = record[key];

      // Operator support
      if (value is Map) {
        for (final op in value.keys) {
          final target = value[op];
          switch (op) {
            case r'$eq':
              if (recordValue != target) return false;
              break;
            case r'$ne':
              if (recordValue == target) return false;
              break;
            case r'$gt':
              if ((recordValue is num) && (recordValue <= target)) return false;
              break;
            case r'$lt':
              if ((recordValue is num) && (recordValue >= target)) return false;
              break;
            case r'$like':
              if (recordValue is String &&
                  !recordValue
                      .toLowerCase()
                      .contains('$target'.toLowerCase())) {
                return false;
              }
              break;
            case r'$in':
              if (target is List && !target.contains(recordValue)) return false;
              break;
          }
        }
      } else {
        // simple equals
        if ('$recordValue' != '$value') return false;
      }
    }
    return true;
  }

  /// Convert query params like ?name[$like]=riko&age[$gt]=20
  static Map<String, dynamic> parseQueryParams(Map<String, String> params) {
    final Map<String, dynamic> filters = {};
    params.forEach((key, value) {
      final match = RegExp(r'(\w+)\[(\$\w+)\]').firstMatch(key);
      if (match != null) {
        final field = match.group(1)!;
        final op = match.group(2)!;
        filters[field] ??= {};
        filters[field][op] = _parseValue(value);
      } else {
        filters[key] = _parseValue(value);
      }
    });
    return filters;
  }

  static dynamic _parseValue(String v) {
    if (v == 'true') return true;
    if (v == 'false') return false;
    final n = num.tryParse(v);
    if (n != null) return n;
    if (v.contains(',')) return v.split(',').map((e) => e.trim()).toList();
    return v;
  }
}

/// 🔹 Abstract REST service
abstract class DartRestService<T> {
  final String tableName;
  final MySqlInitService hiveService = MySqlInitService();
  // final HiveService hiveService = HiveService();
  final Router router = Router();
  String primaryKey = 'id';

  /// Local hooks
  Hook<T>? beforeGetAll;
  Hook<T>? afterGetAll;
  Hook<T>? beforeGetOne;
  Hook<T>? afterGetOne;
  Hook<T>? beforeCreate;
  ModifyHook<T>? afterCreate;
  Hook<T>? beforeUpdate;
  ModifyHook<T>? afterUpdate;
  Hook<T>? beforeDelete;
  Hook<T>? afterDelete;

  /// Pagination
  bool enablePagination = false;
  int defaultLimit = 20;
  Future<Response> Function(
    Request req,
    Future<Response> Function(HookContext ctx) handler,
  ) get executeSafely => _executeSafely;
  Future<void> Function(Hook<T>? hook, HookContext ctx) get runHook => _runHook;

  /// Optional context builder (custom middleware)
  Map<String, dynamic> Function(Request req)? contextBuilder;

  Map<String, String> get jsonHeader => _jsonHeader;

  DartRestService(this.tableName) {
    router.get('/', getAll);
    router.get('/<id>', getOne);
    router.post('/', create);
    router.put('/<id>', update);
    router.patch('/<id>', update);
    router.delete('/<id>', delete);

    // 🚀 Set default hooks (kalau belum di-override)
    beforeGetAll ??= (ctx) async {
      print('📥 [${ctx["service"]}] Default beforeGetAll executed');
    };
    afterGetAll ??= (ctx) async {
      print('✅ [${ctx["service"]}] Default afterGetAll executed');
    };
    beforeGetOne ??= (ctx) async {
      print('🔍 [${ctx["service"]}] Default beforeGetOne executed');
    };
    afterGetOne ??= (ctx) async {
      print('🎯 [${ctx["service"]}] Default afterGetOne executed');
    };
    beforeCreate ??= (ctx) async {
      print('🧩 [${ctx["service"]}] Default beforeCreate executed');
    };
    afterCreate ??= (data, ctx) async {
      print('💾 [${ctx["service"]}] Default afterCreate executed');
      return data;
    };
    beforeUpdate ??= (ctx) async {
      print('✏️ [${ctx["service"]}] Default beforeUpdate executed');
    };
    afterUpdate ??= (data, ctx) async {
      print('🔄 [${ctx["service"]}] Default afterUpdate executed');
      return data;
    };
    beforeDelete ??= (ctx) async {
      print('🗑 [${ctx["service"]}] Default beforeDelete executed');
    };
    afterDelete ??= (ctx) async {
      print('✅ [${ctx["service"]}] Default afterDelete executed');
    };
  }

  /// Abstract model conversion
  Map<String, dynamic> toJson(T item);
  T fromJson(Map<String, dynamic> json);

  static const _jsonHeader = {'Content-Type': 'application/json'};

  /// 🧠 Build context (default + custom)
  HookContext _buildContext(Request req) {
    final base = {
      'service': tableName,
      'timestamp': DateTime.now().toIso8601String(),
      'method': req.method,
      'headers': req.headers,
      'path': req.requestedUri.path,
    };
    if (contextBuilder != null) {
      final custom = contextBuilder!(req);
      base.addAll(custom.map((key, value) => MapEntry(key, value)));
    }
    return HookContext(req, initial: base);
  }

  /// 🪝 Safe hook runner
  Future<void> _runHook(Hook<T>? hook, HookContext ctx) async {
    if (hook != null) await hook(ctx);
  }

  Future<Response> executeSafelyStream(
    Request req,
    Future<Response> Function(HookContext ctx) handler,
  ) async {
    final ctx = _buildContext(req);
    try {
      final res = await handler(ctx);
      return res;
    } catch (err, stack) {
      await HiveRestFramework.runOnError(ctx, err);
      print("❌ [${ctx["service"]}] STREAM ERROR: $err");
      print(stack);
      return Response.internalServerError(
        body: jsonEncode({'error': err.toString()}),
        headers: jsonHeader,
      );
    }
  }

  /// 🧩 Global hook wrapper
  Future<Response> _executeSafely(
    Request req,
    Future<Response> Function(HookContext ctx) handler,
  ) async {
    final ctx = _buildContext(req);
    try {
      await HiveRestFramework.runBeforeAll(ctx);
      final res = await handler(ctx);
      await HiveRestFramework.runAfterAll(ctx);
      return res;
    } catch (err, stack) {
      await HiveRestFramework.runOnError(ctx, err);
      print('❌ [${ctx["service"]}] Error: $err');
      print(stack);
      return Response.internalServerError(
        body: jsonEncode({'error': err.toString()}),
        headers: _jsonHeader,
      );
    }
  }

  // 🚀 GET ALL
  Future<Response> getAll(Request req) => _executeSafely(req, (ctx) async {
        await _runHook(beforeGetAll, ctx);
        final params = req.url.queryParameters;

// Pisahkan pagination param
        final page = int.tryParse(params['page'] ?? '1') ?? 1;
        final limit =
            int.tryParse(params['limit'] ?? '$defaultLimit') ?? defaultLimit;
        final offset = (page - 1) * limit;

// Buang 'limit' dan 'page' dari params sebelum dikirim ke parseQueryParams
        final filterParams = Map<String, String>.from(params)
          ..remove('limit')
          ..remove('page');

        final filters = QueryFilter.parseQueryParams(filterParams);

        // Ambil data langsung dengan filter dan pagination
        final data = await hiveService.findAll(
          tableName,
          where: filters,
          limit: enablePagination ? limit : null,
          offset: enablePagination ? offset : null,
        );

        if (enablePagination) {
          final allData = await hiveService.findAll(
            tableName,
            where: filters,
            limit: null,
            offset: null,
          );

          final paged = allData.skip(offset).take(limit).toList();

          ctx['pagination'] = {
            'page': page,
            'limit': limit,
            'total': allData.length
          };

          ctx.result ??= {
            'page': page,
            'limit': limit,
            'total': allData.length,
            'data': paged,
          };
        } else {
          final data = await hiveService.findAll(
            tableName,
            where: filters,
            limit: null,
            offset: null,
          );
          ctx.result ??= data;
        }

        await _runHook(afterGetAll, ctx);
        return Response.ok(jsonEncode(ctx.result), headers: _jsonHeader);
      });

  // 🚀 GET ONE
  Future<Response> getOne(Request req, String id) =>
      _executeSafely(req, (ctx) async {
        await _runHook(beforeGetOne, ctx);
        final record =
            await hiveService.findOne(tableName, where: {primaryKey: id});
        ctx.result ??= record;
        if (record == null) {
          return Response.notFound(jsonEncode({'error': 'Data not found'}));
        }
        ctx['record'] = record;
        await _runHook(afterGetOne, ctx);
        if (ctx.result is Response) {
          return ctx.result as Response;
        }
        return Response.ok(jsonEncode(ctx.result), headers: _jsonHeader);
      });

  // 🚀 CREATE
  Future<Response> create(Request req) => _executeSafely(req, (ctx) async {
        // 🎯 1) Kalau multipart → JANGAN readAsString()
        final contentType = req.headers['content-type'] ?? "";
        final isMultipart = contentType.contains("multipart/form-data");

        if (!isMultipart) {
          // JSON biasa → tetap gunakan body
          final payload = jsonDecode(await req.readAsString());
          ctx.payload.addAll(Map<String, dynamic>.from(payload));
        }

        // 🎯 2) Jalankan beforeCreate (upload file isi ctx.payload di sini)
        await _runHook(beforeCreate, ctx);

        // 🎯 3) Insert ke Hive
        final ordered = reorderPrimaryKeyFirst(ctx.payload, primaryKey);

        print('📥 Insert payload = ${ctx.payload}');
        await hiveService.create(tableName, ordered);
        print('✅ Inserted into $tableName');

        // 🎯 4) afterCreate
        var item = fromJson(ordered);
        if (afterCreate != null) item = await afterCreate!(item, ctx);

        // 🎯 5) Response
        final result = {'message': 'Created', 'data': toJson(item)};
        ctx['response'] = result;
        ctx.result ??= result;

        return Response.ok(jsonEncode(ctx.result), headers: _jsonHeader);
      });

  // 🚀 UPDATE
  Future<Response> update(Request req, String id) =>
      _executeSafely(req, (ctx) async {
        final payload = jsonDecode(await req.readAsString());
        ctx.payload.addAll(Map<String, dynamic>.from(payload));
        await _runHook(beforeUpdate, ctx);

        await hiveService.update(tableName, payload, where: {primaryKey: id});

        var item = fromJson(payload);
        if (afterUpdate != null) item = await afterUpdate!(item, ctx);

        final result = {'message': 'Updated', 'data': toJson(item)};
        ctx['response'] = result;
        ctx.result ??= result;
        return Response.ok(jsonEncode(ctx.result), headers: _jsonHeader);
      });

  // 🚀 DELETE
  Future<Response> delete(Request req, String id) =>
      _executeSafely(req, (ctx) async {
        await _runHook(beforeDelete, ctx);
        await hiveService.destroy(tableName, where: {primaryKey: id});
        await _runHook(afterDelete, ctx);

        final result = {'message': 'Deleted $id'};
        ctx['response'] = result;
        ctx.result ??= result;
        return Response.ok(jsonEncode(ctx.result), headers: _jsonHeader);
      });
}

Map<String, dynamic> reorderPrimaryKeyFirst(
    Map<String, dynamic> data, String primaryKey) {
  if (!data.containsKey(primaryKey)) return data;

  final newMap = <String, dynamic>{};
  newMap[primaryKey] = data[primaryKey];

  data.forEach((k, v) {
    if (k != primaryKey) newMap[k] = v;
  });

  return newMap;
}
