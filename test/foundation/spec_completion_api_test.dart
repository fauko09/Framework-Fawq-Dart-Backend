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
  test('spec completion endpoints support update and delete flows', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;
    final hrdHeaders = await _login(
      app,
      email: 'hrd@fga.local',
      password: 'hrd123',
    );

    final template = await _request(
      app,
      'POST',
      '/api/contract-templates/upload',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'templateName': 'Initial Template',
        'contractType': 'PKWT',
        'templateFile': '/templates/initial.docx',
        'description': 'Initial description',
        'isActive': true,
      },
    );
    final templateId = (await _json(template))['data']['id'] as String;

    final updateTemplate = await _request(
      app,
      'PATCH',
      '/api/contract-templates/$templateId',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'templateName': 'Revised Template',
        'description': 'Updated description',
        'isActive': false,
      },
    );
    expect(updateTemplate.statusCode, 200);
    expect((await _json(updateTemplate))['data']['templateName'], 'Revised Template');

    final asset = await _request(
      app,
      'POST',
      '/api/contract-assets/upload',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'assetType': 'stamp',
        'assetName': 'Stamp A',
        'filePath': '/assets/stamp-a.png',
        'isDefault': false,
        'isActive': true,
      },
    );
    final assetId = (await _json(asset))['data']['id'] as String;

    final updateAsset = await _request(
      app,
      'PATCH',
      '/api/contract-assets/$assetId',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'assetName': 'Stamp Primary',
        'isDefault': true,
      },
    );
    expect(updateAsset.statusCode, 200);
    expect((await _json(updateAsset))['data']['assetName'], 'Stamp Primary');

    final contract = await _request(
      app,
      'POST',
      '/api/contracts/generate',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'employeeId': 'emp-001',
        'contractNumber': 'CTR/2026/UPDATE-001',
        'contractType': 'PKWT',
        'startDate': '2026-07-01',
        'endDate': '2027-06-30',
        'positionId': 'pos-hr',
        'departmentId': 'dept-hr',
        'basicSalary': 5200000,
        'allowance': 500000,
      },
    );
    final contractId = (await _json(contract))['data']['id'] as String;

    final updateContract = await _request(
      app,
      'PATCH',
      '/api/contracts/$contractId',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'status': 'revision_required',
      },
    );
    expect(updateContract.statusCode, 200);
    expect((await _json(updateContract))['data']['status'], 'revision_required');

    final renewal = await _request(
      app,
      'POST',
      '/api/contract-renewals',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'oldContractId': 'ctr-001',
        'employeeId': 'emp-001',
        'oldStartDate': '2026-01-01',
        'oldEndDate': '2026-12-31',
        'newStartDate': '2027-01-01',
        'newEndDate': '2027-12-31',
        'oldSalary': 4500000,
        'newSalary': 5000000,
        'renewalReason': 'Performance',
        'hrdNote': 'Review salary increase',
      },
    );
    final renewalId = (await _json(renewal))['data']['id'] as String;

    final updateRenewal = await _request(
      app,
      'PATCH',
      '/api/contract-renewals/$renewalId',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'status': 'revision',
        'directorNote': 'Adjust term first',
      },
    );
    expect(updateRenewal.statusCode, 200);
    expect((await _json(updateRenewal))['data']['status'], 'revision');

    final salaryMaster = await _request(
      app,
      'POST',
      '/api/salary-masters',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'employeeId': 'emp-001',
        'basicSalary': 5100000,
        'positionAllowance': 250000,
        'transportAllowance': 150000,
        'mealAllowance': 100000,
        'communicationAllowance': 50000,
        'otherAllowance': 30000,
        'fixedDeduction': 150000,
        'taxDeduction': 100000,
        'bpjsKesehatanDeduction': 50000,
        'bpjsKetenagakerjaanDeduction': 50000,
        'effectiveDate': '2026-07-01',
        'status': 'approved',
      },
    );
    final salaryMasterId = (await _json(salaryMaster))['data']['id'] as String;

    final updateSalaryMaster = await _request(
      app,
      'PATCH',
      '/api/salary-masters/$salaryMasterId',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'basicSalary': 5300000,
        'status': 'approved',
      },
    );
    expect(updateSalaryMaster.statusCode, 200);
    expect((await _json(updateSalaryMaster))['data']['basicSalary'], 5300000);

    final payroll = await _request(
      app,
      'POST',
      '/api/payrolls/generate',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {'payrollPeriod': '2026-09'},
    );
    final payrollId = (await _json(payroll))['data']['id'] as String;

    final updatePayroll = await _request(
      app,
      'PATCH',
      '/api/payrolls/$payrollId',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {'status': 'draft'},
    );
    expect(updatePayroll.statusCode, 200);
    expect((await _json(updatePayroll))['data']['status'], 'draft');

    final deleteTemplate = await _request(
      app,
      'DELETE',
      '/api/contract-templates/$templateId',
      headers: hrdHeaders,
    );
    expect(deleteTemplate.statusCode, 200);

    final deleteAsset = await _request(
      app,
      'DELETE',
      '/api/contract-assets/$assetId',
      headers: hrdHeaders,
    );
    expect(deleteAsset.statusCode, 200);
  });
}
