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
  test('salary and payroll flows follow spec endpoints', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;
    final hrdHeaders = await _login(
      app,
      email: 'hrd@fga.local',
      password: 'hrd123',
    );
    final employeeHeaders = await _login(
      app,
      email: 'employee1@fga.local',
      password: 'employee123',
    );

    final createSalaryMaster = await _request(
      app,
      'POST',
      '/api/salary-masters',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'employeeId': 'emp-001',
        'basicSalary': 5000000,
        'positionAllowance': 500000,
        'transportAllowance': 300000,
        'mealAllowance': 200000,
        'communicationAllowance': 100000,
        'otherAllowance': 50000,
        'fixedDeduction': 150000,
        'taxDeduction': 100000,
        'bpjsKesehatanDeduction': 50000,
        'bpjsKetenagakerjaanDeduction': 50000,
        'effectiveDate': '2026-07-01',
        'status': 'approved',
      },
    );
    expect(createSalaryMaster.statusCode, 201);

    final createSalaryChangeRequest = await _request(
      app,
      'POST',
      '/api/salary-change-requests',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'employeeId': 'emp-001',
        'newBasicSalary': 5500000,
        'newAllowance': 1200000,
        'effectiveDate': '2026-08-01',
        'reason': 'Promotion',
      },
    );
    expect(createSalaryChangeRequest.statusCode, 201);
    final salaryChangeId = (await _json(createSalaryChangeRequest))['data']['id'] as String;

    final approveSalaryChange = await _request(
      app,
      'POST',
      '/api/salary-change-requests/$salaryChangeId/approve',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {'note': 'Approved by director'},
    );
    expect(approveSalaryChange.statusCode, 200);

    final generatePayroll = await _request(
      app,
      'POST',
      '/api/payrolls/generate',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {'payrollPeriod': '2026-08'},
    );
    expect(generatePayroll.statusCode, 201);
    final payrollId = (await _json(generatePayroll))['data']['id'] as String;

    final submitPayroll = await _request(
      app,
      'POST',
      '/api/payrolls/$payrollId/submit-approval',
      headers: hrdHeaders,
    );
    expect(submitPayroll.statusCode, 200);

    final approvePayroll = await _request(
      app,
      'POST',
      '/api/payrolls/$payrollId/approve',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {'note': 'Approved'},
    );
    expect(approvePayroll.statusCode, 200);

    final publishPayroll = await _request(
      app,
      'POST',
      '/api/payrolls/$payrollId/publish',
      headers: hrdHeaders,
    );
    expect(publishPayroll.statusCode, 200);

    final myPayslips = await _request(
      app,
      'GET',
      '/api/payslips/my',
      headers: employeeHeaders,
    );
    expect(myPayslips.statusCode, 200);
    final payslipId = ((await _json(myPayslips))['data'] as List).first['id'] as String;

    final payslipDetail = await _request(
      app,
      'GET',
      '/api/payslips/$payslipId',
      headers: employeeHeaders,
    );
    expect(payslipDetail.statusCode, 200);

    final payslipDownload = await _request(
      app,
      'GET',
      '/api/payslips/$payslipId/download',
      headers: employeeHeaders,
    );
    expect(payslipDownload.statusCode, 200);
  });

  test('notifications reports approvals and audit endpoints are available', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;
    final hrdHeaders = await _login(
      app,
      email: 'hrd@fga.local',
      password: 'hrd123',
    );

    final approvals = await _request(app, 'GET', '/api/approvals', headers: hrdHeaders);
    expect(approvals.statusCode, 200);

    final reportsEmployees = await _request(
      app,
      'GET',
      '/api/reports/employees',
      headers: hrdHeaders,
    );
    expect(reportsEmployees.statusCode, 200);

    final reportsContracts = await _request(
      app,
      'GET',
      '/api/reports/contracts',
      headers: hrdHeaders,
    );
    expect(reportsContracts.statusCode, 200);

    final reportsPayrolls = await _request(
      app,
      'GET',
      '/api/reports/payrolls',
      headers: hrdHeaders,
    );
    expect(reportsPayrolls.statusCode, 200);

    final reportsSalaryCost = await _request(
      app,
      'GET',
      '/api/reports/salary-cost',
      headers: hrdHeaders,
    );
    expect(reportsSalaryCost.statusCode, 200);

    final notifications = await _request(
      app,
      'GET',
      '/api/notifications',
      headers: hrdHeaders,
    );
    expect(notifications.statusCode, 200);

    final notificationsPayload = await _json(notifications);
    if ((notificationsPayload['data'] as List).isNotEmpty) {
      final notificationId = (notificationsPayload['data'] as List).first['id'] as String;
      final markRead = await _request(
        app,
        'PATCH',
        '/api/notifications/$notificationId/read',
        headers: hrdHeaders,
      );
      expect(markRead.statusCode, 200);
    }

    final readAll = await _request(
      app,
      'PATCH',
      '/api/notifications/read-all',
      headers: hrdHeaders,
    );
    expect(readAll.statusCode, 200);

    final auditLogs = await _request(
      app,
      'GET',
      '/api/audit-logs',
      headers: hrdHeaders,
    );
    expect(auditLogs.statusCode, 200);
  });
}
