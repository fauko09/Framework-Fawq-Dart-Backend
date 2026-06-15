import 'package:uuid/uuid.dart';

import 'models.dart';

class FoundationRepository {
  FoundationRepository({
    required this.roles,
    required this.permissions,
    required this.rolePermissions,
    required this.users,
    required this.userRoles,
    required this.departments,
    required this.positions,
    required this.companySettings,
    required this.auditLogs,
    required this.employees,
    required this.employeeChangeRequests,
    required this.employeeDocuments,
    required this.notifications,
    required this.contracts,
    required this.payslips,
    required this.contractTemplates,
    required this.contractAssets,
    required this.contractVersions,
    required this.contractApprovalSteps,
    required this.contractSignatures,
    required this.contractRenewals,
    required this.salaryMasters,
    required this.salaryHistories,
    required this.approvals,
    required this.payrolls,
    required this.payrollDetails,
  });

  final List<Role> roles;
  final List<Permission> permissions;
  final List<RolePermission> rolePermissions;
  final List<User> users;
  final List<UserRole> userRoles;
  final List<Department> departments;
  final List<Position> positions;
  CompanySettings companySettings;
  final List<AuditLog> auditLogs;
  final List<Employee> employees;
  final List<EmployeeChangeRequest> employeeChangeRequests;
  final List<EmployeeDocument> employeeDocuments;
  final List<NotificationItem> notifications;
  final List<ContractRecord> contracts;
  final List<PayslipRecord> payslips;
  final List<ContractTemplate> contractTemplates;
  final List<ContractAsset> contractAssets;
  final List<ContractVersion> contractVersions;
  final List<ContractApprovalStep> contractApprovalSteps;
  final List<ContractSignature> contractSignatures;
  final List<ContractRenewal> contractRenewals;
  final List<SalaryMaster> salaryMasters;
  final List<SalaryHistory> salaryHistories;
  final List<ApprovalItem> approvals;
  final List<PayrollRecord> payrolls;
  final List<PayrollDetail> payrollDetails;

  static FoundationRepository seeded() {
    const uuid = Uuid();

    final roles = <Role>[
      Role(
        id: uuid.v4(),
        name: 'super_admin',
        description: 'Super Admin',
      ),
      Role(
        id: uuid.v4(),
        name: 'admin_hris',
        description: 'Admin HRIS',
      ),
      Role(id: uuid.v4(), name: 'hrd', description: 'HRD'),
      Role(id: uuid.v4(), name: 'legal', description: 'Legal'),
      Role(id: uuid.v4(), name: 'direktur', description: 'Direktur'),
      Role(
        id: uuid.v4(),
        name: 'upliner_langsung',
        description: 'Upliner Langsung',
      ),
      Role(id: uuid.v4(), name: 'employee', description: 'Employee'),
    ];

    final permissions = <Permission>[
      Permission(
        id: uuid.v4(),
        code: 'manage_users',
        description: 'Manage users',
      ),
      Permission(
        id: uuid.v4(),
        code: 'manage_roles',
        description: 'Manage roles',
      ),
      Permission(
        id: uuid.v4(),
        code: 'manage_permissions',
        description: 'Manage permissions',
      ),
      Permission(
        id: uuid.v4(),
        code: 'manage_company_settings',
        description: 'Manage company settings',
      ),
      Permission(
        id: uuid.v4(),
        code: 'manage_departments',
        description: 'Manage departments',
      ),
      Permission(
        id: uuid.v4(),
        code: 'manage_positions',
        description: 'Manage positions',
      ),
      Permission(
        id: uuid.v4(),
        code: 'view_audit_logs',
        description: 'View audit logs',
      ),
    ];

    final adminUser = User(
      id: uuid.v4(),
      name: 'Super Admin',
      email: 'superadmin@fga.local',
      password: 'superadmin123',
      isActive: true,
    );

    final adminHrisUser = User(
      id: uuid.v4(),
      name: 'Admin HRIS',
      email: 'admin-hris@fga.local',
      password: 'adminhris123',
      isActive: true,
    );

    final hrdUser = User(
      id: uuid.v4(),
      name: 'HRD User',
      email: 'hrd@fga.local',
      password: 'hrd123',
      isActive: true,
    );
    final employeeUser = User(
      id: uuid.v4(),
      name: 'Employee One',
      email: 'employee1@fga.local',
      password: 'employee123',
      isActive: true,
    );

    final superAdminRole = roles.first;
    final adminHrisRole = roles.firstWhere((role) => role.name == 'admin_hris');
    final hrdRole = roles.firstWhere((role) => role.name == 'hrd');
    final employeeRole = roles.firstWhere((role) => role.name == 'employee');

    final departments = [
      Department(id: 'dept-hr', name: 'Human Resources'),
      Department(id: 'dept-legal', name: 'Legal'),
      Department(id: 'dept-fin', name: 'Finance'),
    ];
    final positions = [
      Position(id: 'pos-hr', name: 'HR Officer'),
      Position(id: 'pos-legal', name: 'Legal Counsel'),
      Position(id: 'pos-fin', name: 'Finance Staff'),
    ];
    final employees = [
      Employee(
        id: 'emp-001',
        fullName: 'Employee One',
        nikKtp: '3171111111111111',
        birthPlace: 'Jakarta',
        birthDate: '1998-05-10',
        gender: 'male',
        address: 'Jl. Lama 1',
        phoneNumber: '081200000001',
        personalEmail: 'employee1@personal.local',
        maritalStatus: 'single',
        religion: 'Islam',
        npwp: '00.111.222.3-444.000',
        familyCardNumber: '3171111111111112',
        emergencyContactName: 'Parent One',
        emergencyContactPhone: '081200000099',
        emergencyContactRelation: 'parent',
        employeeCode: 'EMP-001',
        departmentId: 'dept-hr',
        positionId: 'pos-hr',
        divisionId: 'div-hr',
        workLocation: 'Jakarta',
        directSupervisorId: 'emp-hrd',
        joinDate: '2025-01-01',
        employeeStatus: 'contract',
        contractType: 'PKWT',
        grade: 'B',
        level: 'staff',
        bankName: 'BCA',
        bankAccountNumber: '111222333',
        bankAccountHolder: 'Employee One',
        bpjsKesehatanNumber: 'BPJS-KES-001',
        bpjsKetenagakerjaanNumber: 'BPJS-KER-001',
        basicSalary: 4500000,
        fixedAllowance: 500000,
        fixedDeduction: 100000,
        userId: employeeUser.id,
      ),
    ];
    final contracts = [
      ContractRecord(
        id: 'ctr-001',
        employeeId: 'emp-001',
        contractNumber: 'CTR/2026/001',
        contractType: 'PKWT',
        startDate: '2026-01-01',
        endDate: '2026-12-31',
        positionId: 'pos-hr',
        departmentId: 'dept-hr',
        basicSalary: 4500000,
        allowance: 500000,
        contractFile: '/contracts/ctr-001.pdf',
        status: 'signed_active',
        createdBy: hrdUser.id,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    ];
    final payslips = [
      PayslipRecord(
        id: 'payslip-001',
        employeeId: 'emp-001',
        payrollPeriod: '2026-05',
        basicSalary: 4500000,
        totalAllowance: 500000,
        totalDeduction: 250000,
        bonus: 100000,
        netSalary: 4850000,
        status: 'published',
        pdfPath: '/payslips/payslip-001.pdf',
      ),
    ];

    return FoundationRepository(
      roles: roles,
      permissions: permissions,
      rolePermissions: [
        ...permissions.map(
          (permission) => RolePermission(
            roleId: superAdminRole.id,
            permissionId: permission.id,
          ),
        ),
        ...permissions.map(
          (permission) => RolePermission(
            roleId: adminHrisRole.id,
            permissionId: permission.id,
          ),
        ),
      ],
      users: [adminUser, adminHrisUser, hrdUser, employeeUser],
      userRoles: [
        UserRole(
          userId: adminUser.id,
          roleId: superAdminRole.id,
        ),
        UserRole(
          userId: adminHrisUser.id,
          roleId: adminHrisRole.id,
        ),
        UserRole(
          userId: hrdUser.id,
          roleId: hrdRole.id,
        ),
        UserRole(
          userId: employeeUser.id,
          roleId: employeeRole.id,
        ),
      ],
      departments: departments,
      positions: positions,
      companySettings: CompanySettings(
        id: uuid.v4(),
        companyName: 'FGA',
        companyCode: 'FGA',
        timezone: 'Asia/Jakarta',
      ),
      auditLogs: [],
      employees: employees,
      employeeChangeRequests: [],
      employeeDocuments: [
        EmployeeDocument(
          id: 'doc-001',
          employeeId: 'emp-001',
          documentType: 'CV',
          filePath: '/documents/cv-001.pdf',
          status: 'verified',
          uploadedAt: DateTime.now().toIso8601String(),
          reviewNote: 'Verified',
        ),
      ],
      notifications: [
        NotificationItem(
          id: 'notif-001',
          userId: employeeUser.id,
          role: 'employee',
          title: 'Slip gaji tersedia',
          message: 'Slip gaji bulan terakhir sudah tersedia.',
          isRead: false,
          createdAt: DateTime.now().toIso8601String(),
        ),
      ],
      contracts: contracts,
      payslips: payslips,
      contractTemplates: [],
      contractAssets: [],
      contractVersions: [
        ContractVersion(
          id: 'cv-001',
          contractId: 'ctr-001',
          versionNumber: 1,
          filePath: '/contracts/ctr-001-v1.pdf',
          sourceType: 'signed_final',
          revisionNote: 'Initial signed contract',
          createdBy: hrdUser.id,
          createdAt: DateTime.now().toIso8601String(),
        ),
      ],
      contractApprovalSteps: [],
      contractSignatures: [],
      contractRenewals: [],
      salaryMasters: [],
      salaryHistories: [],
      approvals: [],
      payrolls: [],
      payrollDetails: [],
    );
  }

  User? findUserByEmail(String email) {
    return users.where((user) => user.email == email).cast<User?>().firstOrNull;
  }

  User? findUserById(String id) {
    return users.where((user) => user.id == id).cast<User?>().firstOrNull;
  }

  List<User> listUsers() => List.unmodifiable(users);

  User createUser({
    required String name,
    required String email,
    required String password,
    required List<String> roleIds,
  }) {
    final user = User(
      id: const Uuid().v4(),
      name: name,
      email: email,
      password: password,
      isActive: true,
    );
    users.add(user);
    userRoles.removeWhere((link) => link.userId == user.id);
    userRoles.addAll(roleIds.map((roleId) => UserRole(userId: user.id, roleId: roleId)));
    return user;
  }

  User? updateUser(
    String id, {
    String? name,
    String? email,
    String? password,
    bool? isActive,
  }) {
    final index = users.indexWhere((user) => user.id == id);
    if (index == -1) return null;
    final updated = users[index].copyWith(
      name: name,
      email: email,
      password: password,
      isActive: isActive,
    );
    users[index] = updated;
    return updated;
  }

  void deleteUser(String id) {
    users.removeWhere((user) => user.id == id);
    userRoles.removeWhere((link) => link.userId == id);
  }

  Role? findRoleById(String id) {
    return roles.where((role) => role.id == id).cast<Role?>().firstOrNull;
  }

  Role createRole({
    required String name,
    required String description,
  }) {
    final role = Role(
      id: const Uuid().v4(),
      name: name,
      description: description,
    );
    roles.add(role);
    return role;
  }

  Role? updateRole(
    String id, {
    String? name,
    String? description,
  }) {
    final index = roles.indexWhere((role) => role.id == id);
    if (index == -1) return null;
    final existing = roles[index];
    final updated = Role(
      id: existing.id,
      name: name ?? existing.name,
      description: description ?? existing.description,
    );
    roles[index] = updated;
    return updated;
  }

  void deleteRole(String id) {
    roles.removeWhere((role) => role.id == id);
    userRoles.removeWhere((link) => link.roleId == id);
    rolePermissions.removeWhere((link) => link.roleId == id);
  }

  void assignPermissions(String roleId, List<String> permissionIds) {
    rolePermissions.removeWhere((link) => link.roleId == roleId);
    rolePermissions.addAll(
      permissionIds.map(
        (permissionId) => RolePermission(roleId: roleId, permissionId: permissionId),
      ),
    );
  }

  bool userHasRole(String userId, String roleName) {
    final roleIds = roles.where((role) => role.name == roleName).map((role) => role.id).toSet();
    return userRoles.any((link) => link.userId == userId && roleIds.contains(link.roleId));
  }

  void recordAudit({
    required String actorUserId,
    required String action,
    required String entityType,
    required String entityId,
    JsonMap? oldValues,
    JsonMap? newValues,
    required String note,
  }) {
    auditLogs.add(
      AuditLog(
        id: const Uuid().v4(),
        actorUserId: actorUserId,
        action: action,
        entityType: entityType,
        entityId: entityId,
        oldValues: oldValues,
        newValues: newValues,
        note: note,
        createdAt: DateTime.now(),
      ),
    );
  }

  List<Department> listDepartments() => List.unmodifiable(departments);

  Department createDepartment(String name) {
    final department = Department(
      id: const Uuid().v4(),
      name: name,
    );
    departments.add(department);
    return department;
  }

  List<Position> listPositions() => List.unmodifiable(positions);

  Position createPosition(String name) {
    final position = Position(
      id: const Uuid().v4(),
      name: name,
    );
    positions.add(position);
    return position;
  }

  CompanySettings updateCompanySettings({
    String? companyName,
    String? companyCode,
    String? timezone,
  }) {
    companySettings = companySettings.copyWith(
      companyName: companyName,
      companyCode: companyCode,
      timezone: timezone,
    );
    return companySettings;
  }

  List<AuditLog> listAuditLogs() => List.unmodifiable(auditLogs);
  List<Employee> listEmployees() => List.unmodifiable(employees);
  List<EmployeeChangeRequest> listEmployeeChangeRequests() =>
      List.unmodifiable(employeeChangeRequests);
  List<EmployeeDocument> listEmployeeDocuments() =>
      List.unmodifiable(employeeDocuments);
  List<NotificationItem> listNotificationsForUser(String userId) => List.unmodifiable(
        notifications.where((item) => item.userId == userId).toList(),
      );
  List<ContractRecord> listContracts() => List.unmodifiable(contracts);
  List<PayslipRecord> listPayslips() => List.unmodifiable(payslips);
  List<ContractTemplate> listContractTemplates() => List.unmodifiable(contractTemplates);
  List<ContractAsset> listContractAssets() => List.unmodifiable(contractAssets);
  List<ContractVersion> listContractVersions(String contractId) =>
      List.unmodifiable(contractVersions.where((item) => item.contractId == contractId).toList());
  List<ContractApprovalStep> listContractApprovalSteps(String contractId) =>
      List.unmodifiable(contractApprovalSteps.where((item) => item.contractId == contractId).toList());
  List<ContractApprovalStep> listPendingContractApprovalsForUser(String userId) =>
      List.unmodifiable(contractApprovalSteps.where((item) => item.approverUserId == userId && item.status == 'pending').toList());
  List<ContractSignature> listContractSignatures(String contractId) =>
      List.unmodifiable(contractSignatures.where((item) => item.contractId == contractId).toList());
  List<ContractRenewal> listContractRenewals() => List.unmodifiable(contractRenewals);
  List<SalaryMaster> listSalaryMasters() => List.unmodifiable(salaryMasters);
  List<SalaryHistory> listSalaryHistories(String employeeId) =>
      List.unmodifiable(salaryHistories.where((item) => item.employeeId == employeeId).toList());
  List<ApprovalItem> listApprovals() => List.unmodifiable(approvals);
  List<PayrollRecord> listPayrolls() => List.unmodifiable(payrolls);
  List<PayrollDetail> listPayrollDetails(String payrollId) =>
      List.unmodifiable(payrollDetails.where((item) => item.payrollId == payrollId).toList());

  Employee? findEmployeeById(String id) {
    return employees.where((employee) => employee.id == id).cast<Employee?>().firstOrNull;
  }

  Employee? findEmployeeByUserId(String userId) {
    return employees.where((employee) => employee.userId == userId).cast<Employee?>().firstOrNull;
  }

  Employee createEmployee(JsonMap payload) {
    final nextNumber = employees.length + 1;
    final employee = Employee(
      id: 'emp-${nextNumber.toString().padLeft(3, '0')}',
      fullName: payload['fullName'] as String? ?? '',
      nikKtp: payload['nikKtp'] as String? ?? '',
      birthPlace: payload['birthPlace'] as String? ?? '',
      birthDate: payload['birthDate'] as String? ?? '',
      gender: payload['gender'] as String? ?? '',
      address: payload['address'] as String? ?? '',
      phoneNumber: payload['phoneNumber'] as String? ?? '',
      personalEmail: payload['personalEmail'] as String? ?? '',
      maritalStatus: payload['maritalStatus'] as String? ?? '',
      religion: payload['religion'] as String? ?? '',
      npwp: payload['npwp'] as String? ?? '',
      familyCardNumber: payload['familyCardNumber'] as String? ?? '',
      emergencyContactName: payload['emergencyContactName'] as String? ?? '',
      emergencyContactPhone: payload['emergencyContactPhone'] as String? ?? '',
      emergencyContactRelation: payload['emergencyContactRelation'] as String? ?? '',
      employeeCode: payload['employeeCode'] as String? ?? '',
      departmentId: payload['departmentId'] as String? ?? '',
      positionId: payload['positionId'] as String? ?? '',
      divisionId: payload['divisionId'] as String? ?? '',
      workLocation: payload['workLocation'] as String? ?? '',
      directSupervisorId: payload['directSupervisorId'] as String? ?? '',
      joinDate: payload['joinDate'] as String? ?? '',
      employeeStatus: payload['employeeStatus'] as String? ?? '',
      contractType: payload['contractType'] as String? ?? '',
      grade: payload['grade'] as String? ?? '',
      level: payload['level'] as String? ?? '',
      bankName: payload['bankName'] as String? ?? '',
      bankAccountNumber: payload['bankAccountNumber'] as String? ?? '',
      bankAccountHolder: payload['bankAccountHolder'] as String? ?? '',
      bpjsKesehatanNumber: payload['bpjsKesehatanNumber'] as String? ?? '',
      bpjsKetenagakerjaanNumber: payload['bpjsKetenagakerjaanNumber'] as String? ?? '',
      basicSalary: payload['basicSalary'] as num? ?? 0,
      fixedAllowance: payload['fixedAllowance'] as num? ?? 0,
      fixedDeduction: payload['fixedDeduction'] as num? ?? 0,
      userId: '',
    );
    employees.add(employee);
    return employee;
  }

  Employee? updateEmployee(String id, JsonMap payload) {
    final index = employees.indexWhere((employee) => employee.id == id);
    if (index == -1) return null;
    final existing = employees[index];
    final updated = existing.copyWith(
      address: payload['address'] as String?,
      phoneNumber: payload['phoneNumber'] as String?,
      personalEmail: payload['personalEmail'] as String?,
      maritalStatus: payload['maritalStatus'] as String?,
      bankName: payload['bankName'] as String?,
      bankAccountNumber: payload['bankAccountNumber'] as String?,
      emergencyContactName: payload['emergencyContactName'] as String?,
      emergencyContactPhone: payload['emergencyContactPhone'] as String?,
      npwp: payload['npwp'] as String?,
    );
    employees[index] = updated;
    return updated;
  }

  void deleteEmployee(String id) {
    employees.removeWhere((employee) => employee.id == id);
  }

  List<ContractRecord> contractsForEmployee(String employeeId) {
    return contracts.where((contract) => contract.employeeId == employeeId).toList();
  }

  List<PayslipRecord> payslipsForEmployee(String employeeId) {
    return payslips.where((item) => item.employeeId == employeeId).toList();
  }

  EmployeeChangeRequest createEmployeeChangeRequest({
    required String employeeId,
    required String fieldChanged,
    required String newValue,
    required String documentFile,
    required String reason,
  }) {
    final employee = findEmployeeById(employeeId)!;
    final oldValue = employeeFieldValue(employee, fieldChanged);
    final now = DateTime.now().toIso8601String();
    final request = EmployeeChangeRequest(
      id: 'ecr-${employeeChangeRequests.length + 1}',
      employeeId: employeeId,
      fieldChanged: fieldChanged,
      oldValue: oldValue,
      newValue: newValue,
      documentFile: documentFile,
      reason: reason,
      status: 'pending',
      reviewedBy: null,
      reviewedAt: null,
      reviewNote: null,
      createdAt: now,
      updatedAt: now,
    );
    employeeChangeRequests.add(request);
    return request;
  }

  EmployeeChangeRequest? findEmployeeChangeRequestById(String id) {
    return employeeChangeRequests
        .where((request) => request.id == id)
        .cast<EmployeeChangeRequest?>()
        .firstOrNull;
  }

  EmployeeChangeRequest? updateEmployeeChangeRequestStatus(
    String id, {
    required String status,
    required String reviewedBy,
    required String reviewNote,
  }) {
    final index = employeeChangeRequests.indexWhere((request) => request.id == id);
    if (index == -1) return null;
    final updated = employeeChangeRequests[index].copyWith(
      status: status,
      reviewedBy: reviewedBy,
      reviewedAt: DateTime.now().toIso8601String(),
      reviewNote: reviewNote,
    );
    employeeChangeRequests[index] = updated;
    if (status == 'approved') {
      applyEmployeeChangeRequest(updated);
    }
    return updated;
  }

  void applyEmployeeChangeRequest(EmployeeChangeRequest request) {
    final index = employees.indexWhere((employee) => employee.id == request.employeeId);
    if (index == -1) return;
    final employee = employees[index];
    switch (request.fieldChanged) {
      case 'address':
        employees[index] = employee.copyWith(address: request.newValue);
        break;
      case 'phone_number':
      case 'phoneNumber':
        employees[index] = employee.copyWith(phoneNumber: request.newValue);
        break;
      case 'personal_email':
      case 'personalEmail':
        employees[index] = employee.copyWith(personalEmail: request.newValue);
        break;
      case 'marital_status':
      case 'maritalStatus':
        employees[index] = employee.copyWith(maritalStatus: request.newValue);
        break;
      case 'bank_account_number':
      case 'bankAccountNumber':
        employees[index] = employee.copyWith(bankAccountNumber: request.newValue);
        break;
      case 'bank_name':
      case 'bankName':
        employees[index] = employee.copyWith(bankName: request.newValue);
        break;
      case 'emergency_contact_name':
      case 'emergencyContactName':
        employees[index] = employee.copyWith(emergencyContactName: request.newValue);
        break;
      case 'emergency_contact_phone':
      case 'emergencyContactPhone':
        employees[index] = employee.copyWith(emergencyContactPhone: request.newValue);
        break;
      case 'npwp':
        employees[index] = employee.copyWith(npwp: request.newValue);
        break;
    }
  }

  EmployeeDocument uploadEmployeeDocument({
    required String employeeId,
    required String documentType,
    required String filePath,
  }) {
    final document = EmployeeDocument(
      id: 'edoc-${employeeDocuments.length + 1}',
      employeeId: employeeId,
      documentType: documentType,
      filePath: filePath,
      status: 'pending_verification',
      uploadedAt: DateTime.now().toIso8601String(),
      reviewNote: null,
    );
    employeeDocuments.add(document);
    return document;
  }

  EmployeeDocument? findEmployeeDocumentById(String id) {
    return employeeDocuments
        .where((document) => document.id == id)
        .cast<EmployeeDocument?>()
        .firstOrNull;
  }

  EmployeeDocument? updateEmployeeDocumentStatus(
    String id, {
    required String status,
    String? reviewNote,
  }) {
    final index = employeeDocuments.indexWhere((document) => document.id == id);
    if (index == -1) return null;
    final updated = employeeDocuments[index].copyWith(
      status: status,
      reviewNote: reviewNote,
    );
    employeeDocuments[index] = updated;
    return updated;
  }

  void addNotification({
    required String userId,
    required String role,
    required String title,
    required String message,
  }) {
    notifications.add(
      NotificationItem(
        id: 'notif-${notifications.length + 1}',
        userId: userId,
        role: role,
        title: title,
        message: message,
        isRead: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
    );
  }

  String employeeFieldValue(Employee employee, String fieldChanged) {
    switch (fieldChanged) {
      case 'address':
        return employee.address;
      case 'phone_number':
      case 'phoneNumber':
        return employee.phoneNumber;
      case 'personal_email':
      case 'personalEmail':
        return employee.personalEmail;
      case 'marital_status':
      case 'maritalStatus':
        return employee.maritalStatus;
      case 'bank_account_number':
      case 'bankAccountNumber':
        return employee.bankAccountNumber;
      case 'bank_name':
      case 'bankName':
        return employee.bankName;
      case 'emergency_contact_name':
      case 'emergencyContactName':
        return employee.emergencyContactName;
      case 'emergency_contact_phone':
      case 'emergencyContactPhone':
        return employee.emergencyContactPhone;
      case 'npwp':
        return employee.npwp;
      default:
        return '';
    }
  }

  ContractTemplate createContractTemplate({
    required String templateName,
    required String contractType,
    required String templateFile,
    required String description,
    required bool isActive,
    required String createdBy,
  }) {
    final now = DateTime.now().toIso8601String();
    final item = ContractTemplate(
      id: 'ctpl-${contractTemplates.length + 1}',
      templateName: templateName,
      contractType: contractType,
      templateFile: templateFile,
      description: description,
      isActive: isActive,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );
    contractTemplates.add(item);
    return item;
  }

  ContractAsset createContractAsset({
    required String assetType,
    required String assetName,
    required String filePath,
    required bool isDefault,
    required bool isActive,
    required String uploadedBy,
  }) {
    final now = DateTime.now().toIso8601String();
    final item = ContractAsset(
      id: 'casset-${contractAssets.length + 1}',
      assetType: assetType,
      assetName: assetName,
      filePath: filePath,
      isDefault: isDefault,
      isActive: isActive,
      uploadedBy: uploadedBy,
      createdAt: now,
      updatedAt: now,
    );
    contractAssets.add(item);
    return item;
  }

  ContractTemplate? findContractTemplateById(String id) {
    return contractTemplates
        .where((item) => item.id == id)
        .cast<ContractTemplate?>()
        .firstOrNull;
  }

  ContractTemplate? updateContractTemplate(String id, JsonMap payload) {
    final index = contractTemplates.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = contractTemplates[index].copyWith(
      templateName: payload['templateName'] as String?,
      contractType: payload['contractType'] as String?,
      templateFile: payload['templateFile'] as String?,
      description: payload['description'] as String?,
      isActive: payload['isActive'] as bool?,
    );
    contractTemplates[index] = updated;
    return updated;
  }

  void deleteContractTemplate(String id) {
    contractTemplates.removeWhere((item) => item.id == id);
  }

  ContractAsset? findContractAssetById(String id) {
    return contractAssets
        .where((item) => item.id == id)
        .cast<ContractAsset?>()
        .firstOrNull;
  }

  ContractAsset? updateContractAsset(String id, JsonMap payload) {
    final index = contractAssets.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = contractAssets[index].copyWith(
      assetType: payload['assetType'] as String?,
      assetName: payload['assetName'] as String?,
      filePath: payload['filePath'] as String?,
      isDefault: payload['isDefault'] as bool?,
      isActive: payload['isActive'] as bool?,
    );
    contractAssets[index] = updated;
    return updated;
  }

  void deleteContractAsset(String id) {
    contractAssets.removeWhere((item) => item.id == id);
  }

  ContractRecord createContract({
    required String employeeId,
    required String contractNumber,
    required String contractType,
    required String startDate,
    required String endDate,
    required String positionId,
    required String departmentId,
    required num basicSalary,
    required num allowance,
    required String contractFile,
    required String createdBy,
    required String status,
  }) {
    final now = DateTime.now().toIso8601String();
    final contract = ContractRecord(
      id: 'ctr-${(contracts.length + 1).toString().padLeft(3, '0')}',
      employeeId: employeeId,
      contractNumber: contractNumber,
      contractType: contractType,
      startDate: startDate,
      endDate: endDate,
      positionId: positionId,
      departmentId: departmentId,
      basicSalary: basicSalary,
      allowance: allowance,
      contractFile: contractFile,
      status: status,
      createdBy: createdBy,
      createdAt: now,
      updatedAt: now,
    );
    contracts.add(contract);
    addContractVersion(
      contractId: contract.id,
      filePath: contractFile,
      sourceType: status == 'generated' ? 'generated' : 'uploaded',
      revisionNote: 'Initial version',
      createdBy: createdBy,
    );
    return contract;
  }

  ContractRecord? findContractById(String id) {
    return contracts.where((contract) => contract.id == id).cast<ContractRecord?>().firstOrNull;
  }

  ContractRecord? updateContractStatus(String id, String status) {
    final index = contracts.indexWhere((contract) => contract.id == id);
    if (index == -1) return null;
    final updated = contracts[index].copyWith(status: status);
    contracts[index] = updated;
    return updated;
  }

  ContractRecord? updateContract(String id, JsonMap payload) {
    final index = contracts.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = contracts[index].copyWith(
      contractNumber: payload['contractNumber'] as String?,
      contractType: payload['contractType'] as String?,
      startDate: payload['startDate'] as String?,
      endDate: payload['endDate'] as String?,
      positionId: payload['positionId'] as String?,
      departmentId: payload['departmentId'] as String?,
      basicSalary: payload['basicSalary'] as num?,
      allowance: payload['allowance'] as num?,
      contractFile: payload['contractFile'] as String?,
      status: payload['status'] as String?,
    );
    contracts[index] = updated;
    return updated;
  }

  ContractVersion addContractVersion({
    required String contractId,
    required String filePath,
    required String sourceType,
    required String revisionNote,
    required String createdBy,
  }) {
    final version = ContractVersion(
      id: 'cv-${contractVersions.length + 1}',
      contractId: contractId,
      versionNumber: listContractVersions(contractId).length + 1,
      filePath: filePath,
      sourceType: sourceType,
      revisionNote: revisionNote,
      createdBy: createdBy,
      createdAt: DateTime.now().toIso8601String(),
    );
    contractVersions.add(version);
    return version;
  }

  List<ContractApprovalStep> createContractApprovalFlow(String contractId) {
    final hrdUser = users.firstWhere((user) => user.email == 'hrd@fga.local');
    final employeeUser = users.firstWhere((user) => user.email == 'employee1@fga.local');
    final steps = [
      (
        code: 'direct_supervisor',
        name: 'Direct Supervisor',
        role: 'upliner_langsung',
        userId: hrdUser.id,
        employeeId: 'emp-hrd',
        action: 'approve'
      ),
      (
        code: 'hrd',
        name: 'HRD Final Check',
        role: 'hrd',
        userId: hrdUser.id,
        employeeId: 'emp-hrd',
        action: 'review'
      ),
      (
        code: 'legal',
        name: 'Legal Review',
        role: 'legal',
        userId: hrdUser.id,
        employeeId: 'emp-legal',
        action: 'review'
      ),
      (
        code: 'director',
        name: 'Director Approval',
        role: 'direktur',
        userId: hrdUser.id,
        employeeId: 'emp-director',
        action: 'approve'
      ),
      (
        code: 'employee_signature',
        name: 'Employee Signature',
        role: 'employee',
        userId: employeeUser.id,
        employeeId: 'emp-001',
        action: 'sign'
      ),
    ];
    final now = DateTime.now().toIso8601String();
    final created = <ContractApprovalStep>[];
    for (var index = 0; index < steps.length; index++) {
      final step = ContractApprovalStep(
        id: 'caps-${contractApprovalSteps.length + 1}',
        contractId: contractId,
        stepOrder: index + 1,
        stepCode: steps[index].code,
        stepName: steps[index].name,
        approverRole: steps[index].role,
        approverUserId: steps[index].userId,
        approverEmployeeId: steps[index].employeeId,
        requiredAction: steps[index].action,
        status: index == 0 ? 'pending' : 'waiting',
        actionAt: null,
        note: '',
        createdAt: now,
        updatedAt: now,
      );
      contractApprovalSteps.add(step);
      created.add(step);
    }
    return created;
  }

  ContractApprovalStep? findContractApprovalStepById(String id) {
    return contractApprovalSteps
        .where((step) => step.id == id)
        .cast<ContractApprovalStep?>()
        .firstOrNull;
  }

  ContractApprovalStep? updateContractApprovalStepStatus(
    String id, {
    required String status,
    required String note,
  }) {
    final index = contractApprovalSteps.indexWhere((step) => step.id == id);
    if (index == -1) return null;
    final updated = contractApprovalSteps[index].copyWith(
      status: status,
      actionAt: DateTime.now().toIso8601String(),
      note: note,
    );
    contractApprovalSteps[index] = updated;
    if (status == 'approved' || status == 'signed') {
      advanceContractApproval(updated.contractId, updated.stepOrder);
    }
    return updated;
  }

  void advanceContractApproval(String contractId, int currentOrder) {
    final nextIndex = contractApprovalSteps.indexWhere(
      (step) => step.contractId == contractId && step.stepOrder == currentOrder + 1,
    );
    if (nextIndex != -1) {
      contractApprovalSteps[nextIndex] =
          contractApprovalSteps[nextIndex].copyWith(status: 'pending');
    } else {
      updateContractStatus(contractId, 'waiting_employee_signature');
    }
  }

  ContractSignature addContractSignature({
    required String contractId,
    required String contractVersionId,
    required String employeeId,
    required String userId,
    required String signatureRole,
    required String signatureType,
    required String signatureImage,
    required String agreementText,
  }) {
    final now = DateTime.now().toIso8601String();
    final signature = ContractSignature(
      id: 'csig-${contractSignatures.length + 1}',
      contractId: contractId,
      contractVersionId: contractVersionId,
      employeeId: employeeId,
      userId: userId,
      signatureRole: signatureRole,
      signatureType: signatureType,
      signatureImage: signatureImage,
      signedAt: now,
      ipAddress: '127.0.0.1',
      userAgent: 'Codex-Test',
      agreementText: agreementText,
      createdAt: now,
    );
    contractSignatures.add(signature);
    return signature;
  }

  ContractRenewal createContractRenewal({
    required JsonMap payload,
    required String submittedBy,
  }) {
    final now = DateTime.now().toIso8601String();
    final item = ContractRenewal(
      id: 'crn-${contractRenewals.length + 1}',
      oldContractId: payload['oldContractId'] as String? ?? '',
      employeeId: payload['employeeId'] as String? ?? '',
      oldStartDate: payload['oldStartDate'] as String? ?? '',
      oldEndDate: payload['oldEndDate'] as String? ?? '',
      oldSalary: payload['oldSalary'] as num? ?? 0,
      newStartDate: payload['newStartDate'] as String? ?? '',
      newEndDate: payload['newEndDate'] as String? ?? '',
      newSalary: payload['newSalary'] as num? ?? 0,
      renewalReason: payload['renewalReason'] as String? ?? '',
      hrdNote: payload['hrdNote'] as String? ?? '',
      directorNote: '',
      status: 'pending_hr_review',
      submittedBy: submittedBy,
      approvedBy: null,
      approvedAt: null,
      createdAt: now,
      updatedAt: now,
    );
    contractRenewals.add(item);
    return item;
  }

  ContractRenewal? findContractRenewalById(String id) {
    return contractRenewals.where((item) => item.id == id).cast<ContractRenewal?>().firstOrNull;
  }

  ContractRenewal? updateContractRenewalStatus(
    String id, {
    required String status,
    String? directorNote,
    String? approvedBy,
  }) {
    final index = contractRenewals.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = contractRenewals[index].copyWith(
      status: status,
      directorNote: directorNote,
      approvedBy: approvedBy,
      approvedAt: approvedBy == null ? null : DateTime.now().toIso8601String(),
    );
    contractRenewals[index] = updated;
    return updated;
  }

  ContractRenewal? updateContractRenewal(String id, JsonMap payload) {
    final index = contractRenewals.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = contractRenewals[index].copyWith(
      status: payload['status'] as String?,
      directorNote: payload['directorNote'] as String?,
      approvedBy: payload['approvedBy'] as String?,
      approvedAt: payload['approvedAt'] as String?,
    );
    contractRenewals[index] = updated;
    return updated;
  }

  SalaryMaster createSalaryMaster(JsonMap payload) {
    final now = DateTime.now().toIso8601String();
    final item = SalaryMaster(
      id: 'sm-${salaryMasters.length + 1}',
      employeeId: payload['employeeId'] as String? ?? '',
      basicSalary: payload['basicSalary'] as num? ?? 0,
      positionAllowance: payload['positionAllowance'] as num? ?? 0,
      transportAllowance: payload['transportAllowance'] as num? ?? 0,
      mealAllowance: payload['mealAllowance'] as num? ?? 0,
      communicationAllowance: payload['communicationAllowance'] as num? ?? 0,
      otherAllowance: payload['otherAllowance'] as num? ?? 0,
      fixedDeduction: payload['fixedDeduction'] as num? ?? 0,
      taxDeduction: payload['taxDeduction'] as num? ?? 0,
      bpjsKesehatanDeduction: payload['bpjsKesehatanDeduction'] as num? ?? 0,
      bpjsKetenagakerjaanDeduction: payload['bpjsKetenagakerjaanDeduction'] as num? ?? 0,
      effectiveDate: payload['effectiveDate'] as String? ?? '',
      status: payload['status'] as String? ?? 'draft',
      createdAt: now,
      updatedAt: now,
    );
    salaryMasters.add(item);
    return item;
  }

  SalaryMaster? findSalaryMasterByEmployeeId(String employeeId) {
    return salaryMasters.where((item) => item.employeeId == employeeId).cast<SalaryMaster?>().firstOrNull;
  }

  SalaryMaster? findSalaryMasterById(String id) {
    return salaryMasters.where((item) => item.id == id).cast<SalaryMaster?>().firstOrNull;
  }

  SalaryMaster? updateSalaryMaster(String id, JsonMap payload) {
    final index = salaryMasters.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = salaryMasters[index].copyWith(
      basicSalary: payload['basicSalary'] as num?,
      positionAllowance: payload['positionAllowance'] as num?,
      transportAllowance: payload['transportAllowance'] as num?,
      mealAllowance: payload['mealAllowance'] as num?,
      communicationAllowance: payload['communicationAllowance'] as num?,
      otherAllowance: payload['otherAllowance'] as num?,
      fixedDeduction: payload['fixedDeduction'] as num?,
      taxDeduction: payload['taxDeduction'] as num?,
      bpjsKesehatanDeduction: payload['bpjsKesehatanDeduction'] as num?,
      bpjsKetenagakerjaanDeduction:
          payload['bpjsKetenagakerjaanDeduction'] as num?,
      effectiveDate: payload['effectiveDate'] as String?,
      status: payload['status'] as String?,
    );
    salaryMasters[index] = updated;
    return updated;
  }

  SalaryHistory createSalaryChangeRequest({
    required JsonMap payload,
    required Employee employee,
  }) {
    final current = findSalaryMasterByEmployeeId(employee.id);
    final oldAllowance = (current?.positionAllowance ?? 0) +
        (current?.transportAllowance ?? 0) +
        (current?.mealAllowance ?? 0) +
        (current?.communicationAllowance ?? 0) +
        (current?.otherAllowance ?? 0);
    final now = DateTime.now().toIso8601String();
    final item = SalaryHistory(
      id: 'sh-${salaryHistories.length + 1}',
      employeeId: employee.id,
      oldBasicSalary: current?.basicSalary ?? employee.basicSalary,
      newBasicSalary: payload['newBasicSalary'] as num? ?? employee.basicSalary,
      oldAllowance: oldAllowance,
      newAllowance: payload['newAllowance'] as num? ?? employee.fixedAllowance,
      effectiveDate: payload['effectiveDate'] as String? ?? '',
      reason: payload['reason'] as String? ?? '',
      status: 'pending_approval',
      approvedBy: null,
      approvedAt: null,
      createdAt: now,
      updatedAt: now,
    );
    salaryHistories.add(item);
    return item;
  }

  SalaryHistory? findSalaryHistoryById(String id) {
    return salaryHistories.where((item) => item.id == id).cast<SalaryHistory?>().firstOrNull;
  }

  SalaryHistory? updateSalaryHistoryStatus(
    String id, {
    required String status,
    String? approvedBy,
  }) {
    final index = salaryHistories.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = salaryHistories[index].copyWith(
      status: status,
      approvedBy: approvedBy,
      approvedAt: approvedBy == null ? null : DateTime.now().toIso8601String(),
    );
    salaryHistories[index] = updated;
    return updated;
  }

  ApprovalItem createApproval({
    required String approvalType,
    required String referenceId,
    required String requesterUserId,
    required String approverUserId,
    required String approverRole,
  }) {
    final now = DateTime.now().toIso8601String();
    final item = ApprovalItem(
      id: 'apr-${approvals.length + 1}',
      approvalType: approvalType,
      referenceId: referenceId,
      requesterUserId: requesterUserId,
      approverUserId: approverUserId,
      approverRole: approverRole,
      status: 'pending',
      note: '',
      actionAt: null,
      createdAt: now,
      updatedAt: now,
    );
    approvals.add(item);
    return item;
  }

  ApprovalItem? findApprovalByReference(String approvalType, String referenceId) {
    return approvals
        .where((item) => item.approvalType == approvalType && item.referenceId == referenceId)
        .cast<ApprovalItem?>()
        .firstOrNull;
  }

  ApprovalItem? updateApprovalStatus(
    String id, {
    required String status,
    required String note,
  }) {
    final index = approvals.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = approvals[index].copyWith(
      status: status,
      note: note,
      actionAt: DateTime.now().toIso8601String(),
    );
    approvals[index] = updated;
    return updated;
  }

  PayrollRecord generatePayroll({
    required String payrollPeriod,
    required String submittedBy,
  }) {
    final now = DateTime.now().toIso8601String();
    final details = employees.map((employee) {
      final salary = findSalaryMasterByEmployeeId(employee.id);
      final basic = salary?.basicSalary ?? employee.basicSalary;
      final allowance = (salary?.positionAllowance ?? 0) +
          (salary?.transportAllowance ?? 0) +
          (salary?.mealAllowance ?? 0) +
          (salary?.communicationAllowance ?? 0) +
          (salary?.otherAllowance ?? 0);
      final deduction = (salary?.fixedDeduction ?? employee.fixedDeduction) +
          (salary?.taxDeduction ?? 0) +
          (salary?.bpjsKesehatanDeduction ?? 0) +
          (salary?.bpjsKetenagakerjaanDeduction ?? 0);
      const bonus = 0;
      const adjustment = 0;
      final gross = basic + allowance + bonus + adjustment;
      final net = gross - deduction;
      return PayrollDetail(
        id: 'pd-${payrollDetails.length + 1}-${employee.id}',
        payrollId: 'draft',
        employeeId: employee.id,
        basicSalary: basic,
        totalAllowance: allowance,
        totalDeduction: deduction,
        bonus: bonus,
        adjustment: adjustment,
        grossSalary: gross,
        netSalary: net,
        status: 'generated',
        createdAt: now,
        updatedAt: now,
      );
    }).toList();
    final payroll = PayrollRecord(
      id: 'pr-${payrolls.length + 1}',
      payrollPeriod: payrollPeriod,
      status: 'generated',
      totalEmployee: details.length,
      totalGrossSalary: details.fold<num>(0, (sum, item) => sum + item.grossSalary),
      totalDeduction: details.fold<num>(0, (sum, item) => sum + item.totalDeduction),
      totalNetSalary: details.fold<num>(0, (sum, item) => sum + item.netSalary),
      submittedBy: submittedBy,
      approvedBy: null,
      approvedAt: null,
      publishedAt: null,
      createdAt: now,
      updatedAt: now,
    );
    payrolls.add(payroll);
    payrollDetails.addAll(details.map((detail) => PayrollDetail(
          id: detail.id,
          payrollId: payroll.id,
          employeeId: detail.employeeId,
          basicSalary: detail.basicSalary,
          totalAllowance: detail.totalAllowance,
          totalDeduction: detail.totalDeduction,
          bonus: detail.bonus,
          adjustment: detail.adjustment,
          grossSalary: detail.grossSalary,
          netSalary: detail.netSalary,
          status: detail.status,
          createdAt: detail.createdAt,
          updatedAt: detail.updatedAt,
        )));
    return payroll;
  }

  PayrollRecord? findPayrollById(String id) {
    return payrolls.where((item) => item.id == id).cast<PayrollRecord?>().firstOrNull;
  }

  PayrollRecord? updatePayrollStatus(
    String id, {
    required String status,
    String? approvedBy,
    bool publish = false,
  }) {
    final index = payrolls.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = payrolls[index].copyWith(
      status: status,
      approvedBy: approvedBy,
      approvedAt: approvedBy == null ? null : DateTime.now().toIso8601String(),
      publishedAt: publish ? DateTime.now().toIso8601String() : payrolls[index].publishedAt,
    );
    payrolls[index] = updated;
    return updated;
  }

  void publishPayslipsForPayroll(String payrollId) {
    final details = listPayrollDetails(payrollId);
    for (final detail in details) {
      payslips.add(
        PayslipRecord(
          id: 'payslip-${payslips.length + 1}',
          employeeId: detail.employeeId,
          payrollPeriod: findPayrollById(payrollId)!.payrollPeriod,
          basicSalary: detail.basicSalary,
          totalAllowance: detail.totalAllowance,
          totalDeduction: detail.totalDeduction,
          bonus: detail.bonus,
          netSalary: detail.netSalary,
          status: 'published',
          pdfPath: '/payslips/$payrollId-${detail.employeeId}.pdf',
        ),
      );
      final employee = findEmployeeById(detail.employeeId);
      if (employee != null && employee.userId.isNotEmpty) {
        addNotification(
          userId: employee.userId,
          role: 'employee',
          title: 'Slip gaji sudah tersedia',
          message: 'Slip gaji periode ${findPayrollById(payrollId)!.payrollPeriod} sudah tersedia.',
        );
      }
    }
  }

  NotificationItem? markNotificationRead(String id) {
    final index = notifications.indexWhere((item) => item.id == id);
    if (index == -1) return null;
    final updated = notifications[index].copyWith(isRead: true);
    notifications[index] = updated;
    return updated;
  }

  void markAllNotificationsRead(String userId) {
    for (var i = 0; i < notifications.length; i++) {
      if (notifications[i].userId == userId) {
        notifications[i] = notifications[i].copyWith(isRead: true);
      }
    }
  }

  JsonMap userToMap(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'isActive': user.isActive,
      'roles': userRoles
          .where((link) => link.userId == user.id)
          .map((link) => findRoleById(link.roleId))
          .whereType<Role>()
          .map(roleToMap)
          .toList(),
    };
  }

  JsonMap roleToMap(Role role) {
    return {
      'id': role.id,
      'name': role.name,
      'description': role.description,
    };
  }

  JsonMap permissionToMap(Permission permission) {
    return {
      'id': permission.id,
      'code': permission.code,
      'description': permission.description,
    };
  }

  JsonMap departmentToMap(Department department) {
    return {
      'id': department.id,
      'name': department.name,
    };
  }

  JsonMap positionToMap(Position position) {
    return {
      'id': position.id,
      'name': position.name,
    };
  }

  JsonMap companySettingsToMap(CompanySettings settings) {
    return {
      'id': settings.id,
      'companyName': settings.companyName,
      'companyCode': settings.companyCode,
      'timezone': settings.timezone,
    };
  }

  JsonMap auditLogToMap(AuditLog auditLog) {
    return {
      'id': auditLog.id,
      'actorUserId': auditLog.actorUserId,
      'action': auditLog.action,
      'entityType': auditLog.entityType,
      'entityId': auditLog.entityId,
      'oldValues': auditLog.oldValues,
      'newValues': auditLog.newValues,
      'note': auditLog.note,
      'createdAt': auditLog.createdAt.toIso8601String(),
    };
  }

  JsonMap employeeToMap(Employee employee) {
    return {
      'id': employee.id,
      'fullName': employee.fullName,
      'nikKtp': employee.nikKtp,
      'birthPlace': employee.birthPlace,
      'birthDate': employee.birthDate,
      'gender': employee.gender,
      'address': employee.address,
      'phoneNumber': employee.phoneNumber,
      'personalEmail': employee.personalEmail,
      'maritalStatus': employee.maritalStatus,
      'religion': employee.religion,
      'npwp': employee.npwp,
      'familyCardNumber': employee.familyCardNumber,
      'emergencyContactName': employee.emergencyContactName,
      'emergencyContactPhone': employee.emergencyContactPhone,
      'emergencyContactRelation': employee.emergencyContactRelation,
      'employeeCode': employee.employeeCode,
      'departmentId': employee.departmentId,
      'positionId': employee.positionId,
      'divisionId': employee.divisionId,
      'workLocation': employee.workLocation,
      'directSupervisorId': employee.directSupervisorId,
      'joinDate': employee.joinDate,
      'employeeStatus': employee.employeeStatus,
      'contractType': employee.contractType,
      'grade': employee.grade,
      'level': employee.level,
      'bankName': employee.bankName,
      'bankAccountNumber': employee.bankAccountNumber,
      'bankAccountHolder': employee.bankAccountHolder,
      'bpjsKesehatanNumber': employee.bpjsKesehatanNumber,
      'bpjsKetenagakerjaanNumber': employee.bpjsKetenagakerjaanNumber,
      'basicSalary': employee.basicSalary,
      'fixedAllowance': employee.fixedAllowance,
      'fixedDeduction': employee.fixedDeduction,
      'userId': employee.userId,
    };
  }

  JsonMap employeeChangeRequestToMap(EmployeeChangeRequest request) {
    return {
      'id': request.id,
      'employeeId': request.employeeId,
      'fieldChanged': request.fieldChanged,
      'oldValue': request.oldValue,
      'newValue': request.newValue,
      'documentFile': request.documentFile,
      'reason': request.reason,
      'status': request.status,
      'reviewedBy': request.reviewedBy,
      'reviewedAt': request.reviewedAt,
      'reviewNote': request.reviewNote,
      'createdAt': request.createdAt,
      'updatedAt': request.updatedAt,
    };
  }

  JsonMap employeeDocumentToMap(EmployeeDocument document) {
    return {
      'id': document.id,
      'employeeId': document.employeeId,
      'documentType': document.documentType,
      'filePath': document.filePath,
      'status': document.status,
      'uploadedAt': document.uploadedAt,
      'reviewNote': document.reviewNote,
    };
  }

  JsonMap notificationToMap(NotificationItem notification) {
    return {
      'id': notification.id,
      'userId': notification.userId,
      'role': notification.role,
      'title': notification.title,
      'message': notification.message,
      'isRead': notification.isRead,
      'createdAt': notification.createdAt,
    };
  }

  JsonMap contractToMap(ContractRecord contract) {
    return {
      'id': contract.id,
      'employeeId': contract.employeeId,
      'contractNumber': contract.contractNumber,
      'contractType': contract.contractType,
      'startDate': contract.startDate,
      'endDate': contract.endDate,
      'positionId': contract.positionId,
      'departmentId': contract.departmentId,
      'basicSalary': contract.basicSalary,
      'allowance': contract.allowance,
      'contractFile': contract.contractFile,
      'status': contract.status,
      'createdBy': contract.createdBy,
      'createdAt': contract.createdAt,
      'updatedAt': contract.updatedAt,
    };
  }

  JsonMap payslipToMap(PayslipRecord payslip) {
    return {
      'id': payslip.id,
      'employeeId': payslip.employeeId,
      'payrollPeriod': payslip.payrollPeriod,
      'basicSalary': payslip.basicSalary,
      'totalAllowance': payslip.totalAllowance,
      'totalDeduction': payslip.totalDeduction,
      'bonus': payslip.bonus,
      'netSalary': payslip.netSalary,
      'status': payslip.status,
      'pdfPath': payslip.pdfPath,
    };
  }

  JsonMap contractTemplateToMap(ContractTemplate item) => {
        'id': item.id,
        'templateName': item.templateName,
        'contractType': item.contractType,
        'templateFile': item.templateFile,
        'description': item.description,
        'isActive': item.isActive,
        'createdBy': item.createdBy,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };

  JsonMap contractAssetToMap(ContractAsset item) => {
        'id': item.id,
        'assetType': item.assetType,
        'assetName': item.assetName,
        'filePath': item.filePath,
        'isDefault': item.isDefault,
        'isActive': item.isActive,
        'uploadedBy': item.uploadedBy,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };

  JsonMap contractVersionToMap(ContractVersion item) => {
        'id': item.id,
        'contractId': item.contractId,
        'versionNumber': item.versionNumber,
        'filePath': item.filePath,
        'sourceType': item.sourceType,
        'revisionNote': item.revisionNote,
        'createdBy': item.createdBy,
        'createdAt': item.createdAt,
      };

  JsonMap contractApprovalStepToMap(ContractApprovalStep item) => {
        'id': item.id,
        'contractId': item.contractId,
        'stepOrder': item.stepOrder,
        'stepCode': item.stepCode,
        'stepName': item.stepName,
        'approverRole': item.approverRole,
        'approverUserId': item.approverUserId,
        'approverEmployeeId': item.approverEmployeeId,
        'requiredAction': item.requiredAction,
        'status': item.status,
        'actionAt': item.actionAt,
        'note': item.note,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };

  JsonMap contractSignatureToMap(ContractSignature item) => {
        'id': item.id,
        'contractId': item.contractId,
        'contractVersionId': item.contractVersionId,
        'employeeId': item.employeeId,
        'userId': item.userId,
        'signatureRole': item.signatureRole,
        'signatureType': item.signatureType,
        'signatureImage': item.signatureImage,
        'signedAt': item.signedAt,
        'ipAddress': item.ipAddress,
        'userAgent': item.userAgent,
        'agreementText': item.agreementText,
        'createdAt': item.createdAt,
      };

  JsonMap contractRenewalToMap(ContractRenewal item) => {
        'id': item.id,
        'oldContractId': item.oldContractId,
        'employeeId': item.employeeId,
        'oldStartDate': item.oldStartDate,
        'oldEndDate': item.oldEndDate,
        'oldSalary': item.oldSalary,
        'newStartDate': item.newStartDate,
        'newEndDate': item.newEndDate,
        'newSalary': item.newSalary,
        'renewalReason': item.renewalReason,
        'hrdNote': item.hrdNote,
        'directorNote': item.directorNote,
        'status': item.status,
        'submittedBy': item.submittedBy,
        'approvedBy': item.approvedBy,
        'approvedAt': item.approvedAt,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };

  JsonMap salaryMasterToMap(SalaryMaster item) => {
        'id': item.id,
        'employeeId': item.employeeId,
        'basicSalary': item.basicSalary,
        'positionAllowance': item.positionAllowance,
        'transportAllowance': item.transportAllowance,
        'mealAllowance': item.mealAllowance,
        'communicationAllowance': item.communicationAllowance,
        'otherAllowance': item.otherAllowance,
        'fixedDeduction': item.fixedDeduction,
        'taxDeduction': item.taxDeduction,
        'bpjsKesehatanDeduction': item.bpjsKesehatanDeduction,
        'bpjsKetenagakerjaanDeduction': item.bpjsKetenagakerjaanDeduction,
        'effectiveDate': item.effectiveDate,
        'status': item.status,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };

  JsonMap salaryHistoryToMap(SalaryHistory item) => {
        'id': item.id,
        'employeeId': item.employeeId,
        'oldBasicSalary': item.oldBasicSalary,
        'newBasicSalary': item.newBasicSalary,
        'oldAllowance': item.oldAllowance,
        'newAllowance': item.newAllowance,
        'effectiveDate': item.effectiveDate,
        'reason': item.reason,
        'status': item.status,
        'approvedBy': item.approvedBy,
        'approvedAt': item.approvedAt,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };

  JsonMap approvalToMap(ApprovalItem item) => {
        'id': item.id,
        'approvalType': item.approvalType,
        'referenceId': item.referenceId,
        'requesterUserId': item.requesterUserId,
        'approverUserId': item.approverUserId,
        'approverRole': item.approverRole,
        'status': item.status,
        'note': item.note,
        'actionAt': item.actionAt,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };

  JsonMap payrollToMap(PayrollRecord item) => {
        'id': item.id,
        'payrollPeriod': item.payrollPeriod,
        'status': item.status,
        'totalEmployee': item.totalEmployee,
        'totalGrossSalary': item.totalGrossSalary,
        'totalDeduction': item.totalDeduction,
        'totalNetSalary': item.totalNetSalary,
        'submittedBy': item.submittedBy,
        'approvedBy': item.approvedBy,
        'approvedAt': item.approvedAt,
        'publishedAt': item.publishedAt,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };

  JsonMap payrollDetailToMap(PayrollDetail item) => {
        'id': item.id,
        'payrollId': item.payrollId,
        'employeeId': item.employeeId,
        'basicSalary': item.basicSalary,
        'totalAllowance': item.totalAllowance,
        'totalDeduction': item.totalDeduction,
        'bonus': item.bonus,
        'adjustment': item.adjustment,
        'grossSalary': item.grossSalary,
        'netSalary': item.netSalary,
        'status': item.status,
        'createdAt': item.createdAt,
        'updatedAt': item.updatedAt,
      };
}

extension<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
