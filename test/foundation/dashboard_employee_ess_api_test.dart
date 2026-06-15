import 'dart:convert';

import 'package:server/src/foundation/repositories.dart';
import 'package:shelf/shelf.dart';
import 'package:test/test.dart';

import '../../bin/foundation/foundation_rest.dart';

Future<Response> _request(
  Handler handler,
  String method,
  String path, {
  Map<String, String>? headers,
  Object? body,
}) async {
  return await Future<Response>.value(
    handler(
      Request(
        method,
        Uri.parse('http://localhost$path'),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      ),
    ),
  );
}

Future<Map<String, dynamic>> _json(Response response) async {
  return jsonDecode(await response.readAsString()) as Map<String, dynamic>;
}

Future<Map<String, String>> _login(
  Handler app, {
  required String email,
  required String password,
}) async {
  final response = await _request(
    app,
    'POST',
    '/api/auth/login',
    headers: {'content-type': 'application/json'},
    body: {'email': email, 'password': password},
  );
  final payload = await _json(response);
  return {'authorization': 'Bearer ${payload['accessToken']}'};
}

void main() {
  test('dashboard endpoints expose hrd director and employee widgets from spec', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;
    final superAdminHeaders = await _login(
      app,
      email: 'superadmin@fga.local',
      password: 'superadmin123',
    );
    final employeeHeaders = await _login(
      app,
      email: 'employee1@fga.local',
      password: 'employee123',
    );

    final hrd = await _request(app, 'GET', '/api/dashboard/hrd', headers: superAdminHeaders);
    expect(hrd.statusCode, 200);
    final hrdPayload = await _json(hrd);
    expect(hrdPayload['data']['totalActiveEmployees'], isA<int>());
    expect(hrdPayload['data']['employeesByDepartment'], isA<List<dynamic>>());

    final director = await _request(
      app,
      'GET',
      '/api/dashboard/director',
      headers: superAdminHeaders,
    );
    expect(director.statusCode, 200);
    final directorPayload = await _json(director);
    expect(directorPayload['data']['totalActiveEmployees'], isA<int>());
    expect(directorPayload['data']['salaryCostPerMonth'], isA<List<dynamic>>());

    final employee = await _request(
      app,
      'GET',
      '/api/dashboard/employee',
      headers: employeeHeaders,
    );
    expect(employee.statusCode, 200);
    final employeePayload = await _json(employee);
    expect(employeePayload['data']['activeContractStatus'], isNotEmpty);
    expect(employeePayload['data']['personalNotifications'], isA<List<dynamic>>());
  });

  test('employee management and employee self service flows follow spec', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;
    final superAdminHeaders = await _login(
      app,
      email: 'superadmin@fga.local',
      password: 'superadmin123',
    );
    final employeeHeaders = await _login(
      app,
      email: 'employee1@fga.local',
      password: 'employee123',
    );

    final createEmployee = await _request(
      app,
      'POST',
      '/api/employees',
      headers: {
        ...superAdminHeaders,
        'content-type': 'application/json',
      },
      body: {
        'fullName': 'Finance Staff',
        'nikKtp': '1234567890',
        'birthPlace': 'Jakarta',
        'birthDate': '1995-01-10',
        'gender': 'female',
        'address': 'Jl. Finance',
        'phoneNumber': '08123456789',
        'personalEmail': 'finance.staff@fga.local',
        'maritalStatus': 'single',
        'religion': 'Islam',
        'npwp': '09.999.999.9-999.000',
        'familyCardNumber': '3170000000000001',
        'emergencyContactName': 'Ibu Finance',
        'emergencyContactPhone': '0811111111',
        'emergencyContactRelation': 'mother',
        'employeeCode': 'EMP-003',
        'departmentId': 'dept-fin',
        'positionId': 'pos-fin',
        'divisionId': 'div-fin',
        'workLocation': 'Jakarta',
        'directSupervisorId': 'emp-001',
        'joinDate': '2026-01-01',
        'employeeStatus': 'active',
        'contractType': 'PKWT',
        'grade': 'A',
        'level': 'staff',
        'bankName': 'BCA',
        'bankAccountNumber': '123456789',
        'bankAccountHolder': 'Finance Staff',
        'bpjsKesehatanNumber': 'BPJS-KES-003',
        'bpjsKetenagakerjaanNumber': 'BPJS-KER-003',
        'basicSalary': 5000000,
        'fixedAllowance': 500000,
        'fixedDeduction': 150000,
      },
    );
    expect(createEmployee.statusCode, 201);
    final employeeId = (await _json(createEmployee))['data']['id'] as String;

    final listEmployees = await _request(
      app,
      'GET',
      '/api/employees',
      headers: superAdminHeaders,
    );
    expect(listEmployees.statusCode, 200);

    final profile = await _request(
      app,
      'GET',
      '/api/employees/emp-001/profile',
      headers: superAdminHeaders,
    );
    expect(profile.statusCode, 200);

    final contracts = await _request(
      app,
      'GET',
      '/api/employees/emp-001/contracts',
      headers: superAdminHeaders,
    );
    expect(contracts.statusCode, 200);

    final payslips = await _request(
      app,
      'GET',
      '/api/employees/emp-001/payslips',
      headers: superAdminHeaders,
    );
    expect(payslips.statusCode, 200);

    final createChangeRequest = await _request(
      app,
      'POST',
      '/api/employee-change-requests',
      headers: {
        ...employeeHeaders,
        'content-type': 'application/json',
      },
      body: {
        'fieldChanged': 'address',
        'newValue': 'Jl. Baru 123',
        'documentFile': '/files/support-1.pdf',
        'reason': 'Pindah domisili',
      },
    );
    expect(createChangeRequest.statusCode, 201);
    final changeRequestId = (await _json(createChangeRequest))['data']['id'] as String;

    final approveChangeRequest = await _request(
      app,
      'POST',
      '/api/employee-change-requests/$changeRequestId/approve',
      headers: {
        ...superAdminHeaders,
        'content-type': 'application/json',
      },
      body: {'reviewNote': 'Approved by HRD'},
    );
    expect(approveChangeRequest.statusCode, 200);

    final employeeAfterApprove = await _request(
      app,
      'GET',
      '/api/employees/emp-001',
      headers: superAdminHeaders,
    );
    expect((await _json(employeeAfterApprove))['data']['address'], 'Jl. Baru 123');

    final uploadDocument = await _request(
      app,
      'POST',
      '/api/employee-documents/upload',
      headers: {
        ...employeeHeaders,
        'content-type': 'application/json',
      },
      body: {
        'documentType': 'KTP',
        'filePath': '/files/ktp-employee1.pdf',
      },
    );
    expect(uploadDocument.statusCode, 201);
    final documentId = (await _json(uploadDocument))['data']['id'] as String;

    final verifyDocument = await _request(
      app,
      'POST',
      '/api/employee-documents/$documentId/verify',
      headers: superAdminHeaders,
    );
    expect(verifyDocument.statusCode, 200);

    final getDocuments = await _request(
      app,
      'GET',
      '/api/employee-documents',
      headers: superAdminHeaders,
    );
    expect(getDocuments.statusCode, 200);

    final deleteEmployee = await _request(
      app,
      'DELETE',
      '/api/employees/$employeeId',
      headers: superAdminHeaders,
    );
    expect(deleteEmployee.statusCode, 200);
  });
}
