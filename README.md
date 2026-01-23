# DART FRAMEWORK OR TAMPLATE BACKEND ORM MYSQL 
# CREATED BY FAUKO MISSALAM
# Dart REST + Migrator (MySQL) CLI Generator

# Compile EXE 
dart compile exe -o build/main bin/server.dart
./build/main.exe


# .env:
DB_HOST=localhost
DB_PORT=3360
DB_USER=root
DB_PASSWORD=root
DB_NAME=
DB_SYNC_FORCE=false
DB_SYNC_ALTER=true
PORT_SERVER=8302


Repository ini berisi skrip CLI (Dart) untuk:
1) Generate **Model Migrator** (schema table MySQL) + auto-register ke `model_registry.dart`
2) Generate **Service REST** (custom/service model) dengan hook `before/after` untuk CRUD
3) Contoh **MySQL Init Service** (wrapper CRUD) dengan format `where` mirip Sequelize (ringkas, bisa `$gt/$lt/$like/$in`)

---

## 1) Struktur Folder (yang diasumsikan oleh generator)

Pastikan struktur ini ada (atau akan dibuat otomatis oleh generator):

bin/
dart_rest/
models/
<table>.dart
model_registry.dart
migrator/
model.dart
column.dart
relation.dart
dart_rest_service.dart

<service_name>/
<service_name>_rest.dart


Catatan:
- Generator model menulis file ke: `bin/dart_rest/models/<name>.dart`
- Registry model akan di-update di: `bin/dart_rest/model_registry.dart`
- Generator service menulis file ke: `bin/<name>/<name>_rest.dart`

---

## 2) Prasyarat

- Dart SDK terpasang
- Pastikan dependency untuk MySQL dan synchronized ada pada `pubspec.yaml` (jika Anda menjalankan `MySqlInitService`):

Contoh minimal:
```yaml
dependencies:
  synchronized: any
  # mysql package sesuai implementasi Anda (mysql.dart / connector Anda)

3) CLI: Generate Model Migrator + Register Otomatis
Tujuan

Membuat file model migrator untuk table MySQL (schema sederhana) dan menambahkan class model tersebut ke registry registeredModels.

Script

Skrip generator model (yang Anda berikan) akan:

Membuat file: bin/dart_rest/models/<name>.dart (jika belum ada)

Parse isi model_registry.dart untuk ambil model lama (pattern: ClassName(),)

Menambahkan model baru lalu menulis ulang registry dengan daftar import & registeredModels

Cara pakai

Misal ingin membuat model untuk table users:

dart run <nama_file_generator_model>.dart users

Output:

bin/dart_rest/models/users.dart

bin/dart_rest/model_registry.dart ter-update dan berisi Users() di registeredModels

Naming rules

Argumen CLI dianggap sebagai nama table: contoh quota_detail

Class model akan jadi PascalCase:

users -> Users

quota_detail -> QuotaDetail

Contoh hasil file model

Untuk table users:

class Users extends Model {
  @override
  String get table => 'users';

  @override
  Map<String, Column> get schema => {
    'users_id': Column.string(length: 50, primaryKey: true),
  };
}


Catatan penting:

Default schema hanya membuat <table>_id sebagai primary key string(50).

Anda biasanya perlu menambah kolom lain secara manual di file model (atau Anda bisa extend generator untuk membaca metadata).

4) CLI: Generate Service REST (Custom / Service Model)
Tujuan

Membuat service class XxxRest yang extend DartRestService<Map<String,dynamic>> dengan hook lengkap:

Get All: beforeGetAll, afterGetAll

Get One: beforeGetOne, afterGetOne

Create: beforeCreate, afterCreate

Update: beforeUpdate, afterUpdate

Delete: beforeDelete, afterDelete

Cara pakai

Misal ingin membuat service event:

dart run <nama_file_generator_service>.dart event

dart run bin/gen_rest.dart ping --no-db ( custom service no db )

Output:

bin/event/event_rest.dart

Naming rules

Argumen CLI: event

Class: EventRest

Resource route: 'event'

Primary key: 'event_id'

Pagination: enablePagination = true

5) Registry Model (model_registry.dart)

File registry bersifat AUTO GENERATED – DO NOT EDIT.

Bentuk output:

import 'migrator/model.dart';
import '../dart_rest/models/users.dart';
import '../dart_rest/models/quota_detail.dart';

// AUTO GENERATED – DO NOT EDIT
final List<Model> registeredModels = [
  Users(),
  QuotaDetail(),
];


Catatan:

Generator melakukan parsing dengan regex (\w+)\(\),

Artinya, registry mengandalkan format penulisan ClassName(), di list agar bisa terbaca.

6) MySqlInitService (CRUD + Where Operator Mirip Sequelize)

Class MySqlInitService adalah wrapper untuk operasi:

findAll(table, where, limit, offset)

findOne(table, where)

create(table, data)

update(table, data, where)

destroy(table, where)

count(table, where)

Thread safety

Semua operasi dibungkus Lock() dari package synchronized:

Mencegah race condition ketika ada banyak request bersamaan.

Cocok untuk skenario server sederhana yang shared connection state.

Format where (ringkas)

Anda bisa menulis where seperti ini:

Sama dengan (=)
where: {"status": "active"}

Operator:
where: {
  "price": {r"$gt": 100},
  "qty": {r"$lt": 50},
  "name": {r"$like": "john"},
  "id": {r"$in": ["A1", "A2", "A3"]},
  "role": {r"$ne": "admin"},
}


Mapping operator -> format internal connector:

$gt -> ['>', val]

$lt -> ['<', val]

$eq -> val

$ne -> ['!=', val]

$like-> ['like', '%val%']

$in -> ['in', val]

Catatan:

'$like' otomatis dibungkus wildcard %...%

Pastikan connector conn.getAll/getOne/update/delete mendukung format where tersebut.

7) Quick Start (Contoh Alur)
A. Generate model table
dart run <gen_model>.dart users
dart run <gen_model>.dart quota_detail

B. Jalankan migrator (contoh konsep)

Tergantung implementasi migrator Anda, umumnya:

Import registeredModels

Loop setiap Model untuk sync schema ke MySQL

Pseudo:

for (final m in registeredModels) {
  await migrator.sync(m);
}

C. Generate service REST
dart run <gen_service>.dart users
dart run <gen_service>.dart quota_detail


Lalu isi hook sesuai kebutuhan (validasi, transformasi data, auth, dll).

8) Praktik Baik

Pisahkan migrator/ (schema) dan service/ (logic API) agar perubahan schema tidak mengganggu business rules.

Jangan mengedit model_registry.dart manual—biarkan generator mengelola.

Jika butuh composite primary key / relasi:

Extend Model.schema

Tambahkan relation.dart sesuai mekanisme migrator Anda

9) Troubleshooting
Model tidak masuk registry

Penyebab umum:

Format list di registry tidak sesuai ClassName(),

File registry rusak/berbeda format sehingga regex tidak match

Solusi:

Pastikan list registeredModels memakai format:

final List<Model> registeredModels = [
  Users(),
];

Service file sudah ada

Generator akan stop jika file sudah ada:

Hapus file lama jika memang ingin regenerate

Atau buat nama service yang berbeda

10) Roadmap (Opsional)

Jika Anda ingin generator lebih “Sequelize-like”, beberapa fitur yang bisa ditambahkan:

Generate schema kolom dari metadata database (DESCRIBE TABLE)

Support relasi otomatis hasMany/belongsTo

Generate migration diff (alter) vs force-create

Generate DTO/Model strongly typed (bukan Map)
