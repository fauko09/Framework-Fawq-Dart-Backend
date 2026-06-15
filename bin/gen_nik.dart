import 'dart:math';

enum EmployeeType {
  pkwtt,
  pkwt,
  magang,
}

String generateEmployeeUid(EmployeeType type) {
  final random = Random();

  // index 0 = abjad
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final firstLetter = letters[random.nextInt(letters.length)];

  // index 1 = kode jenis karyawan
  final typeCode = switch (type) {
    EmployeeType.pkwtt => '8',
    EmployeeType.pkwt => '5',
    EmployeeType.magang => '3',
  };

  // index 2 - 6 = numeric random, total 5 digit
  final numbers = List.generate(
    5,
    (_) => random.nextInt(10).toString(),
  ).join();

  return '$firstLetter$typeCode$numbers';
}