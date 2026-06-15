# Dart REST Framework

Framework backend Dart untuk MySQL, REST, migrasi, seeder, dan Swagger UI.

## Run

```bash
dart pub get
dart run bin/server.dart
```

Default port:
- API: `PORT_SERVER` dari `.env`
- Swagger UI: `2001`

## Env

```env
DB_HOST=localhost
DB_PORT=3360
DB_USER=root
DB_PASSWORD=root
DB_NAME=hris_fga
DB_SYNC_FORCE=false
DB_SYNC_ALTER=true
PORT_SERVER=8302
```

## Alur Framework

Folder `bin/` adalah entrypoint framework.

- `bin/gen_model.dart` membuat model migrator di `bin/dart_rest/models/` dan update `bin/dart_rest/model_registry.dart`
- `bin/gen_rest.dart` membuat service REST di `bin/<service>/<service>_rest.dart`
- `bin/server.dart` adalah composition root yang mount service, migrator, seeder, middleware, dan Swagger UI

## Generate Model

```bash
dart run bin/gen_model.dart users
```

Hasil:

- `bin/dart_rest/models/users.dart`
- `bin/dart_rest/model_registry.dart` ter-update otomatis

## Generate REST

```bash
dart run bin/gen_rest.dart ping --no-db
```

Hasil:

- `bin/ping/ping_rest.dart`

Untuk service yang pakai DB, jalankan tanpa `--no-db`.

## Before / After

Sebelum menambah resource baru:

1. Generate model dengan `bin/gen_model.dart`
2. Generate service dengan `bin/gen_rest.dart`
3. Mount service itu di `bin/server.dart`

Sesudah generate:

- Model migrator masuk ke registry otomatis
- Service REST bisa langsung dipakai sebagai route di `bin/server.dart`

## MySQL Init Service

`bin/dart_rest/mysql/mysql_service.dart` dipakai untuk operasi CRUD dasar dan filter `where` sederhana seperti:

```dart
{
  "status": "active",
  "price": {r"$gt": 100},
  "name": {r"$like": "john"},
}
```

Sekarang service ini juga mendukung query ORM-style join untuk kebutuhan `GET` / `SELECT`.

### ORM Join

Join tersedia lewat:

- `join(...)`
- `innerJoin(...)`
- `leftJoin(...)`
- `rightJoin(...)`
- `fullOuterJoin(...)`

Struktur relasi join:

```dart
{
  'table': 'roles',
  'sourceTable': 'user_roles',
  'sourceKey': 'role_id',
  'targetKey': 'role_id',
  'type': 'INNER',
}
```

Keterangan:

- `table`: tabel yang akan di-join
- `sourceTable`: tabel sumber relasi
- `sourceKey`: kolom pada `sourceTable`
- `targetKey`: kolom pada tabel join
- `type`: optional, bisa `INNER`, `LEFT`, `RIGHT`, `FULL`

Contoh `INNER JOIN` sederhana:

```dart
final rows = await model.innerJoin(
  'user_roles',
  joins: [
    {
      'table': 'roles',
      'sourceTable': 'user_roles',
      'sourceKey': 'role_id',
      'targetKey': 'role_id',
    },
    {
      'table': 'role_permissions',
      'sourceTable': 'roles',
      'sourceKey': 'role_id',
      'targetKey': 'role_id',
    },
    {
      'table': 'permissions',
      'sourceTable': 'role_permissions',
      'sourceKey': 'permission_id ',
      'targetKey': 'permission_id ',
    }
  ],
  fields: [
    'user_roles.user_id',
    'roles.name AS role_name',
  ],
  where: {
    'user_roles.user_id': userId,
  },
);
```

Contoh multi join berantai dan bercabang:

```dart
final rows = await model.join(
  'users',
  joins: [
    {
      'table': 'table1',
      'sourceTable': 'users',
      'sourceKey': 'table1_id',
      'targetKey': 'id',
      'type': 'INNER',
    },
    {
      'table': 'table2',
      'sourceTable': 'table1',
      'sourceKey': 'table2_id',
      'targetKey': 'id',
      'type': 'LEFT',
    },
    {
      'table': 'table3',
      'sourceTable': 'table1',
      'sourceKey': 'table3_id',
      'targetKey': 'id',
      'type': 'LEFT',
    },
  ],
  fields: [
    'users.user_id',
    'table1.name AS table1_name',
    'table2.name AS table2_name',
    'table3.name AS table3_name',
  ],
  where: {
    'users.user_id': userId,
  },
  orderBy: 'users.user_id DESC',
  limit: 10,
  offset: 0,
);
```

Contoh `FULL OUTER JOIN`:

```dart
final rows = await model.fullOuterJoin(
  'user_roles',
  joins: [
    {
      'table': 'roles',
      'sourceTable': 'user_roles',
      'sourceKey': 'role_id',
      'targetKey': 'role_id',
    },
  ],
  fields: [
    'user_roles.user_id',
    'roles.name AS role_name',
  ],
);
```

Catatan:

- `fields` dipakai sebagai fragmen SQL mentah untuk bagian `SELECT`
- `where` mendukung operator yang sama seperti CRUD biasa: `r"$gt"`, `r"$lt"`, `r"$eq"`, `r"$ne"`, `r"$like"`, `r"$in"`
- `FULL OUTER JOIN` di MySQL diemulasikan dengan `LEFT JOIN UNION RIGHT JOIN`
- Implementasi `FULL OUTER JOIN` saat ini dibatasi untuk satu relasi join
- Fitur join ini ditujukan untuk operasi baca data, bukan `create/update/delete`

## Seeder

Bootstrap seed ada di:

- `bin/dart_rest/seeder/bootstrap_seed_catalog.dart`
- `bin/dart_rest/seeder/bootstrap_seeder.dart`

Seed default mencakup:

- `super_admin`
- `admin_hris`
- `hrd`
- `legal`
- `direktur`
- `upliner_langsung`
- `employee`

## Swagger UI

Swagger UI dijalankan di port `2001` dari file:

- `swagger-ui/swagger.json`

## Build EXE

```bash
dart compile exe -o build/main bin/server.dart
./build/main
```
