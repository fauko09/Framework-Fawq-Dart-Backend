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
  test('contract template asset management and contract lifecycle follow spec', () async {
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

    final createTemplate = await _request(
      app,
      'POST',
      '/api/contract-templates/upload',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'templateName': 'PKWT Standard',
        'contractType': 'PKWT',
        'templateFile': '/templates/pkwt-standard.docx',
        'description': 'Main template',
        'isActive': true,
      },
    );
    expect(createTemplate.statusCode, 201);

    final createAsset = await _request(
      app,
      'POST',
      '/api/contract-assets/upload',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'assetType': 'stamp',
        'assetName': 'Company Stamp',
        'filePath': '/assets/stamp.png',
        'isDefault': true,
        'isActive': true,
      },
    );
    expect(createAsset.statusCode, 201);

    final generateContract = await _request(
      app,
      'POST',
      '/api/contracts/generate',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {
        'employeeId': 'emp-001',
        'contractNumber': 'CTR/2026/NEW-001',
        'contractType': 'PKWT',
        'startDate': '2026-07-01',
        'endDate': '2027-06-30',
        'positionId': 'pos-hr',
        'departmentId': 'dept-hr',
        'basicSalary': 5000000,
        'allowance': 500000,
      },
    );
    expect(generateContract.statusCode, 201);
    final contractId = (await _json(generateContract))['data']['id'] as String;

    final submitApproval = await _request(
      app,
      'POST',
      '/api/contracts/$contractId/submit-approval',
      headers: hrdHeaders,
    );
    expect(submitApproval.statusCode, 200);

    final myPendingApprovals = await _request(
      app,
      'GET',
      '/api/contract-approvals/my-pending',
      headers: hrdHeaders,
    );
    expect(myPendingApprovals.statusCode, 200);

    final contractDetail = await _request(
      app,
      'GET',
      '/api/contracts/$contractId',
      headers: hrdHeaders,
    );
    final detailPayload = await _json(contractDetail);
    final firstStepId = (detailPayload['data']['approvalSteps'] as List).first['id'] as String;

    final approveFirstStep = await _request(
      app,
      'POST',
      '/api/contract-approvals/$firstStepId/approve',
      headers: {
        ...hrdHeaders,
        'content-type': 'application/json',
      },
      body: {'note': 'Approved step'},
    );
    expect(approveFirstStep.statusCode, 200);

    final versions = await _request(
      app,
      'GET',
      '/api/contracts/$contractId/versions',
      headers: hrdHeaders,
    );
    expect(versions.statusCode, 200);

    final signatureStatusBefore = await _request(
      app,
      'GET',
      '/api/contracts/$contractId/signature-status',
      headers: employeeHeaders,
    );
    expect(signatureStatusBefore.statusCode, 200);

    final signContract = await _request(
      app,
      'POST',
      '/api/contracts/$contractId/sign',
      headers: {
        ...employeeHeaders,
        'content-type': 'application/json',
      },
      body: {
        'signatureType': 'draw_canvas',
        'signatureImage': '/signatures/employee1.png',
        'agreementText': 'Saya menyetujui kontrak ini',
      },
    );
    expect(signContract.statusCode, 200);

    final finalDownload = await _request(
      app,
      'GET',
      '/api/contracts/$contractId/download-final',
      headers: employeeHeaders,
    );
    expect(finalDownload.statusCode, 200);
  });

  test('contract renewal follows trigger and approval preparation flow', () async {
    final app = FoundationRest(repository: FoundationRepository.seeded()).handler;
    final hrdHeaders = await _login(
      app,
      email: 'hrd@fga.local',
      password: 'hrd123',
    );

    final createRenewal = await _request(
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
        'renewalReason': 'Good performance',
        'hrdNote': 'Perpanjangan 1 tahun',
      },
    );
    expect(createRenewal.statusCode, 201);
    final renewalId = (await _json(createRenewal))['data']['id'] as String;

    final submitRenewal = await _request(
      app,
      'POST',
      '/api/contract-renewals/$renewalId/submit',
      headers: hrdHeaders,
    );
    expect(submitRenewal.statusCode, 200);

    final renewalDetail = await _request(
      app,
      'GET',
      '/api/contract-renewals/$renewalId',
      headers: hrdHeaders,
    );
    expect(renewalDetail.statusCode, 200);
    expect((await _json(renewalDetail))['data']['status'], 'submitted_to_approval');
  });
}
