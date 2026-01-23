import 'mysql.dart';
import 'package:synchronized/synchronized.dart';

class MySqlInitService {
  static final Lock _lock = Lock();

  /// 🔍 GET ALL
  Future<List<Map<String, dynamic>>> findAll(
    String table, {
    Map<String, dynamic>? where,
    int? limit,
    int? offset,
  }) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();

      final result = await conn.getAll(
        table: table,
        fields: '*',
        where: _mapToWhere(where),
        limit: limit,
        debug: false,
      );

      return List<Map<String, dynamic>>.from(result);
    });
  }

  /// 🔍 GET ONE
  Future<Map<String, dynamic>?> findOne(
    String table, {
    required Map<String, dynamic> where,
  }) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();

      final result = await conn.getOne(
        table: table,
        fields: '*',
        where: _mapToWhere(where),
        debug: false,
      );

      if (result == null || result.isEmpty) return null;
      return Map<String, dynamic>.from(result);
    });
  }

  /// ➕ CREATE
  Future<void> create(
    String table,
    Map<String, dynamic> data,
  ) async {
    await _lock.synchronized(() async {
      final conn = await MySqlInit.connect();
      await conn.insert(
        table: table,
        insertData: data,
        debug: true,
      );
    });
  }

  /// 🔁 UPDATE
  Future<int> update(
    String table,
    Map<String, dynamic> data, {
    required Map<String, dynamic> where,
  }) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();
      final res = await conn.update(
        table: table,
        updateData: data,
        where: _mapToWhere(where),
        debug: true,
      );
      return res.toInt();
    });
  }

  /// 🗑 DELETE
  Future<int> destroy(
    String table, {
    required Map<String, dynamic> where,
  }) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();
      final res = await conn.delete(
        table: table,
        where: _mapToWhere(where),
        debug: true,
      );
      return res.toInt();
    });
  }

  /// Helper: convert where to valid format
  Map<String, dynamic> _mapToWhere(Map<String, dynamic>? where) {
    if (where == null || where.isEmpty) return {};

    final formatted = <String, dynamic>{};

    where.forEach((key, value) {
      if (value is Map) {
        value.forEach((op, val) {
          switch (op) {
            case r'$gt':
              formatted[key] = ['>', val];
              break;
            case r'$lt':
              formatted[key] = ['<', val];
              break;
            case r'$eq':
              formatted[key] = val;
              break;
            case r'$ne':
              formatted[key] = ['!=', val];
              break;
            case r'$like':
              formatted[key] = ['like', '%$val%'];
              break;
            case r'$in':
              formatted[key] = ['in', val];
              break;
          }
        });
      } else {
        formatted[key] = value;
      }
    });

    return formatted;
  }

  /// 🔢 COUNT
  Future<int> count(String table, {Map<String, dynamic>? where}) async {
    return _lock.synchronized(() async {
      final conn = await MySqlInit.connect();
      final res = await conn.count(
        table: table,
        where: _mapToWhere(where),
        debug: false,
      );
      return res;
    });
  }
}
