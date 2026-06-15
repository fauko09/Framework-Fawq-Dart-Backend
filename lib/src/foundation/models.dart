class Role {
  final String id;
  final String name;
  final String description;

  const Role({
    required this.id,
    required this.name,
    required this.description,
  });
}

typedef JsonMap = Map<String, dynamic>;

class Permission {
  final String id;
  final String code;
  final String description;

  const Permission({
    required this.id,
    required this.code,
    required this.description,
  });
}

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool isActive;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isActive,
  });

  User copyWith({
    String? name,
    String? email,
    String? password,
    bool? isActive,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isActive: isActive ?? this.isActive,
    );
  }
}

class UserRole {
  final String userId;
  final String roleId;

  const UserRole({
    required this.userId,
    required this.roleId,
  });
}

class RolePermission {
  final String roleId;
  final String permissionId;

  const RolePermission({
    required this.roleId,
    required this.permissionId,
  });
}

class Department {
  final String id;
  final String name;

  const Department({
    required this.id,
    required this.name,
  });
}

class Position {
  final String id;
  final String name;

  const Position({
    required this.id,
    required this.name,
  });
}

class CompanySettings {
  final String id;
  final String companyName;
  final String companyCode;
  final String timezone;

  const CompanySettings({
    required this.id,
    required this.companyName,
    required this.companyCode,
    required this.timezone,
  });

  CompanySettings copyWith({
    String? companyName,
    String? companyCode,
    String? timezone,
  }) {
    return CompanySettings(
      id: id,
      companyName: companyName ?? this.companyName,
      companyCode: companyCode ?? this.companyCode,
      timezone: timezone ?? this.timezone,
    );
  }
}

class AuditLog {
  final String id;
  final String actorUserId;
  final String action;
  final String entityType;
  final String entityId;
  final JsonMap? oldValues;
  final JsonMap? newValues;
  final String note;
  final DateTime createdAt;

  const AuditLog({
    required this.id,
    required this.actorUserId,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.oldValues,
    required this.newValues,
    required this.note,
    required this.createdAt,
  });
}

class Employee {
  final String id;
  final String fullName;
  final String nikKtp;
  final String birthPlace;
  final String birthDate;
  final String gender;
  final String address;
  final String phoneNumber;
  final String personalEmail;
  final String maritalStatus;
  final String religion;
  final String npwp;
  final String familyCardNumber;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final String emergencyContactRelation;
  final String employeeCode;
  final String departmentId;
  final String positionId;
  final String divisionId;
  final String workLocation;
  final String directSupervisorId;
  final String joinDate;
  final String employeeStatus;
  final String contractType;
  final String grade;
  final String level;
  final String bankName;
  final String bankAccountNumber;
  final String bankAccountHolder;
  final String bpjsKesehatanNumber;
  final String bpjsKetenagakerjaanNumber;
  final num basicSalary;
  final num fixedAllowance;
  final num fixedDeduction;
  final String userId;

  const Employee({
    required this.id,
    required this.fullName,
    required this.nikKtp,
    required this.birthPlace,
    required this.birthDate,
    required this.gender,
    required this.address,
    required this.phoneNumber,
    required this.personalEmail,
    required this.maritalStatus,
    required this.religion,
    required this.npwp,
    required this.familyCardNumber,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.emergencyContactRelation,
    required this.employeeCode,
    required this.departmentId,
    required this.positionId,
    required this.divisionId,
    required this.workLocation,
    required this.directSupervisorId,
    required this.joinDate,
    required this.employeeStatus,
    required this.contractType,
    required this.grade,
    required this.level,
    required this.bankName,
    required this.bankAccountNumber,
    required this.bankAccountHolder,
    required this.bpjsKesehatanNumber,
    required this.bpjsKetenagakerjaanNumber,
    required this.basicSalary,
    required this.fixedAllowance,
    required this.fixedDeduction,
    required this.userId,
  });

  Employee copyWith({
    String? address,
    String? phoneNumber,
    String? personalEmail,
    String? maritalStatus,
    String? bankName,
    String? bankAccountNumber,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? npwp,
  }) {
    return Employee(
      id: id,
      fullName: fullName,
      nikKtp: nikKtp,
      birthPlace: birthPlace,
      birthDate: birthDate,
      gender: gender,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      personalEmail: personalEmail ?? this.personalEmail,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      religion: religion,
      npwp: npwp ?? this.npwp,
      familyCardNumber: familyCardNumber,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelation: emergencyContactRelation,
      employeeCode: employeeCode,
      departmentId: departmentId,
      positionId: positionId,
      divisionId: divisionId,
      workLocation: workLocation,
      directSupervisorId: directSupervisorId,
      joinDate: joinDate,
      employeeStatus: employeeStatus,
      contractType: contractType,
      grade: grade,
      level: level,
      bankName: bankName ?? this.bankName,
      bankAccountNumber: bankAccountNumber ?? this.bankAccountNumber,
      bankAccountHolder: bankAccountHolder,
      bpjsKesehatanNumber: bpjsKesehatanNumber,
      bpjsKetenagakerjaanNumber: bpjsKetenagakerjaanNumber,
      basicSalary: basicSalary,
      fixedAllowance: fixedAllowance,
      fixedDeduction: fixedDeduction,
      userId: userId,
    );
  }
}

class EmployeeChangeRequest {
  final String id;
  final String employeeId;
  final String fieldChanged;
  final String oldValue;
  final String newValue;
  final String documentFile;
  final String reason;
  final String status;
  final String? reviewedBy;
  final String? reviewedAt;
  final String? reviewNote;
  final String createdAt;
  final String updatedAt;

  const EmployeeChangeRequest({
    required this.id,
    required this.employeeId,
    required this.fieldChanged,
    required this.oldValue,
    required this.newValue,
    required this.documentFile,
    required this.reason,
    required this.status,
    required this.reviewedBy,
    required this.reviewedAt,
    required this.reviewNote,
    required this.createdAt,
    required this.updatedAt,
  });

  EmployeeChangeRequest copyWith({
    String? status,
    String? reviewedBy,
    String? reviewedAt,
    String? reviewNote,
  }) {
    return EmployeeChangeRequest(
      id: id,
      employeeId: employeeId,
      fieldChanged: fieldChanged,
      oldValue: oldValue,
      newValue: newValue,
      documentFile: documentFile,
      reason: reason,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewNote: reviewNote ?? this.reviewNote,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class EmployeeDocument {
  final String id;
  final String employeeId;
  final String documentType;
  final String filePath;
  final String status;
  final String uploadedAt;
  final String? reviewNote;

  const EmployeeDocument({
    required this.id,
    required this.employeeId,
    required this.documentType,
    required this.filePath,
    required this.status,
    required this.uploadedAt,
    required this.reviewNote,
  });

  EmployeeDocument copyWith({
    String? status,
    String? reviewNote,
  }) {
    return EmployeeDocument(
      id: id,
      employeeId: employeeId,
      documentType: documentType,
      filePath: filePath,
      status: status ?? this.status,
      uploadedAt: uploadedAt,
      reviewNote: reviewNote ?? this.reviewNote,
    );
  }
}

class NotificationItem {
  final String id;
  final String userId;
  final String role;
  final String title;
  final String message;
  final bool isRead;
  final String createdAt;

  const NotificationItem({
    required this.id,
    required this.userId,
    required this.role,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      userId: userId,
      role: role,
      title: title,
      message: message,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
    );
  }
}

class ContractRecord {
  final String id;
  final String employeeId;
  final String contractNumber;
  final String contractType;
  final String startDate;
  final String endDate;
  final String positionId;
  final String departmentId;
  final num basicSalary;
  final num allowance;
  final String contractFile;
  final String status;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  const ContractRecord({
    required this.id,
    required this.employeeId,
    required this.contractNumber,
    required this.contractType,
    required this.startDate,
    required this.endDate,
    required this.positionId,
    required this.departmentId,
    required this.basicSalary,
    required this.allowance,
    required this.contractFile,
    required this.status,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  ContractRecord copyWith({
    String? contractNumber,
    String? contractType,
    String? startDate,
    String? endDate,
    String? positionId,
    String? departmentId,
    num? basicSalary,
    num? allowance,
    String? contractFile,
    String? status,
  }) {
    return ContractRecord(
      id: id,
      employeeId: employeeId,
      contractNumber: contractNumber ?? this.contractNumber,
      contractType: contractType ?? this.contractType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      positionId: positionId ?? this.positionId,
      departmentId: departmentId ?? this.departmentId,
      basicSalary: basicSalary ?? this.basicSalary,
      allowance: allowance ?? this.allowance,
      contractFile: contractFile ?? this.contractFile,
      status: status ?? this.status,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class PayslipRecord {
  final String id;
  final String employeeId;
  final String payrollPeriod;
  final num basicSalary;
  final num totalAllowance;
  final num totalDeduction;
  final num bonus;
  final num netSalary;
  final String status;
  final String pdfPath;

  const PayslipRecord({
    required this.id,
    required this.employeeId,
    required this.payrollPeriod,
    required this.basicSalary,
    required this.totalAllowance,
    required this.totalDeduction,
    required this.bonus,
    required this.netSalary,
    required this.status,
    required this.pdfPath,
  });
}

class ContractTemplate {
  final String id;
  final String templateName;
  final String contractType;
  final String templateFile;
  final String description;
  final bool isActive;
  final String createdBy;
  final String createdAt;
  final String updatedAt;

  const ContractTemplate({
    required this.id,
    required this.templateName,
    required this.contractType,
    required this.templateFile,
    required this.description,
    required this.isActive,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  ContractTemplate copyWith({
    String? templateName,
    String? contractType,
    String? templateFile,
    String? description,
    bool? isActive,
  }) {
    return ContractTemplate(
      id: id,
      templateName: templateName ?? this.templateName,
      contractType: contractType ?? this.contractType,
      templateFile: templateFile ?? this.templateFile,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class ContractAsset {
  final String id;
  final String assetType;
  final String assetName;
  final String filePath;
  final bool isDefault;
  final bool isActive;
  final String uploadedBy;
  final String createdAt;
  final String updatedAt;

  const ContractAsset({
    required this.id,
    required this.assetType,
    required this.assetName,
    required this.filePath,
    required this.isDefault,
    required this.isActive,
    required this.uploadedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  ContractAsset copyWith({
    String? assetType,
    String? assetName,
    String? filePath,
    bool? isDefault,
    bool? isActive,
  }) {
    return ContractAsset(
      id: id,
      assetType: assetType ?? this.assetType,
      assetName: assetName ?? this.assetName,
      filePath: filePath ?? this.filePath,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      uploadedBy: uploadedBy,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class ContractVersion {
  final String id;
  final String contractId;
  final int versionNumber;
  final String filePath;
  final String sourceType;
  final String revisionNote;
  final String createdBy;
  final String createdAt;

  const ContractVersion({
    required this.id,
    required this.contractId,
    required this.versionNumber,
    required this.filePath,
    required this.sourceType,
    required this.revisionNote,
    required this.createdBy,
    required this.createdAt,
  });
}

class ContractApprovalStep {
  final String id;
  final String contractId;
  final int stepOrder;
  final String stepCode;
  final String stepName;
  final String approverRole;
  final String approverUserId;
  final String approverEmployeeId;
  final String requiredAction;
  final String status;
  final String? actionAt;
  final String note;
  final String createdAt;
  final String updatedAt;

  const ContractApprovalStep({
    required this.id,
    required this.contractId,
    required this.stepOrder,
    required this.stepCode,
    required this.stepName,
    required this.approverRole,
    required this.approverUserId,
    required this.approverEmployeeId,
    required this.requiredAction,
    required this.status,
    required this.actionAt,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  ContractApprovalStep copyWith({
    String? status,
    String? actionAt,
    String? note,
  }) {
    return ContractApprovalStep(
      id: id,
      contractId: contractId,
      stepOrder: stepOrder,
      stepCode: stepCode,
      stepName: stepName,
      approverRole: approverRole,
      approverUserId: approverUserId,
      approverEmployeeId: approverEmployeeId,
      requiredAction: requiredAction,
      status: status ?? this.status,
      actionAt: actionAt ?? this.actionAt,
      note: note ?? this.note,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class ContractSignature {
  final String id;
  final String contractId;
  final String contractVersionId;
  final String employeeId;
  final String userId;
  final String signatureRole;
  final String signatureType;
  final String signatureImage;
  final String signedAt;
  final String ipAddress;
  final String userAgent;
  final String agreementText;
  final String createdAt;

  const ContractSignature({
    required this.id,
    required this.contractId,
    required this.contractVersionId,
    required this.employeeId,
    required this.userId,
    required this.signatureRole,
    required this.signatureType,
    required this.signatureImage,
    required this.signedAt,
    required this.ipAddress,
    required this.userAgent,
    required this.agreementText,
    required this.createdAt,
  });
}

class ContractRenewal {
  final String id;
  final String oldContractId;
  final String employeeId;
  final String oldStartDate;
  final String oldEndDate;
  final num oldSalary;
  final String newStartDate;
  final String newEndDate;
  final num newSalary;
  final String renewalReason;
  final String hrdNote;
  final String directorNote;
  final String status;
  final String submittedBy;
  final String? approvedBy;
  final String? approvedAt;
  final String createdAt;
  final String updatedAt;

  const ContractRenewal({
    required this.id,
    required this.oldContractId,
    required this.employeeId,
    required this.oldStartDate,
    required this.oldEndDate,
    required this.oldSalary,
    required this.newStartDate,
    required this.newEndDate,
    required this.newSalary,
    required this.renewalReason,
    required this.hrdNote,
    required this.directorNote,
    required this.status,
    required this.submittedBy,
    required this.approvedBy,
    required this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  ContractRenewal copyWith({
    String? status,
    String? directorNote,
    String? approvedBy,
    String? approvedAt,
  }) {
    return ContractRenewal(
      id: id,
      oldContractId: oldContractId,
      employeeId: employeeId,
      oldStartDate: oldStartDate,
      oldEndDate: oldEndDate,
      oldSalary: oldSalary,
      newStartDate: newStartDate,
      newEndDate: newEndDate,
      newSalary: newSalary,
      renewalReason: renewalReason,
      hrdNote: hrdNote,
      directorNote: directorNote ?? this.directorNote,
      status: status ?? this.status,
      submittedBy: submittedBy,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class SalaryMaster {
  final String id;
  final String employeeId;
  final num basicSalary;
  final num positionAllowance;
  final num transportAllowance;
  final num mealAllowance;
  final num communicationAllowance;
  final num otherAllowance;
  final num fixedDeduction;
  final num taxDeduction;
  final num bpjsKesehatanDeduction;
  final num bpjsKetenagakerjaanDeduction;
  final String effectiveDate;
  final String status;
  final String createdAt;
  final String updatedAt;

  const SalaryMaster({
    required this.id,
    required this.employeeId,
    required this.basicSalary,
    required this.positionAllowance,
    required this.transportAllowance,
    required this.mealAllowance,
    required this.communicationAllowance,
    required this.otherAllowance,
    required this.fixedDeduction,
    required this.taxDeduction,
    required this.bpjsKesehatanDeduction,
    required this.bpjsKetenagakerjaanDeduction,
    required this.effectiveDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  SalaryMaster copyWith({
    num? basicSalary,
    num? positionAllowance,
    num? transportAllowance,
    num? mealAllowance,
    num? communicationAllowance,
    num? otherAllowance,
    num? fixedDeduction,
    num? taxDeduction,
    num? bpjsKesehatanDeduction,
    num? bpjsKetenagakerjaanDeduction,
    String? effectiveDate,
    String? status,
  }) {
    return SalaryMaster(
      id: id,
      employeeId: employeeId,
      basicSalary: basicSalary ?? this.basicSalary,
      positionAllowance: positionAllowance ?? this.positionAllowance,
      transportAllowance: transportAllowance ?? this.transportAllowance,
      mealAllowance: mealAllowance ?? this.mealAllowance,
      communicationAllowance:
          communicationAllowance ?? this.communicationAllowance,
      otherAllowance: otherAllowance ?? this.otherAllowance,
      fixedDeduction: fixedDeduction ?? this.fixedDeduction,
      taxDeduction: taxDeduction ?? this.taxDeduction,
      bpjsKesehatanDeduction:
          bpjsKesehatanDeduction ?? this.bpjsKesehatanDeduction,
      bpjsKetenagakerjaanDeduction:
          bpjsKetenagakerjaanDeduction ?? this.bpjsKetenagakerjaanDeduction,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class SalaryHistory {
  final String id;
  final String employeeId;
  final num oldBasicSalary;
  final num newBasicSalary;
  final num oldAllowance;
  final num newAllowance;
  final String effectiveDate;
  final String reason;
  final String status;
  final String? approvedBy;
  final String? approvedAt;
  final String createdAt;
  final String updatedAt;

  const SalaryHistory({
    required this.id,
    required this.employeeId,
    required this.oldBasicSalary,
    required this.newBasicSalary,
    required this.oldAllowance,
    required this.newAllowance,
    required this.effectiveDate,
    required this.reason,
    required this.status,
    required this.approvedBy,
    required this.approvedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  SalaryHistory copyWith({
    String? status,
    String? approvedBy,
    String? approvedAt,
  }) {
    return SalaryHistory(
      id: id,
      employeeId: employeeId,
      oldBasicSalary: oldBasicSalary,
      newBasicSalary: newBasicSalary,
      oldAllowance: oldAllowance,
      newAllowance: newAllowance,
      effectiveDate: effectiveDate,
      reason: reason,
      status: status ?? this.status,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class ApprovalItem {
  final String id;
  final String approvalType;
  final String referenceId;
  final String requesterUserId;
  final String approverUserId;
  final String approverRole;
  final String status;
  final String note;
  final String? actionAt;
  final String createdAt;
  final String updatedAt;

  const ApprovalItem({
    required this.id,
    required this.approvalType,
    required this.referenceId,
    required this.requesterUserId,
    required this.approverUserId,
    required this.approverRole,
    required this.status,
    required this.note,
    required this.actionAt,
    required this.createdAt,
    required this.updatedAt,
  });

  ApprovalItem copyWith({
    String? status,
    String? note,
    String? actionAt,
  }) {
    return ApprovalItem(
      id: id,
      approvalType: approvalType,
      referenceId: referenceId,
      requesterUserId: requesterUserId,
      approverUserId: approverUserId,
      approverRole: approverRole,
      status: status ?? this.status,
      note: note ?? this.note,
      actionAt: actionAt ?? this.actionAt,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class PayrollRecord {
  final String id;
  final String payrollPeriod;
  final String status;
  final int totalEmployee;
  final num totalGrossSalary;
  final num totalDeduction;
  final num totalNetSalary;
  final String submittedBy;
  final String? approvedBy;
  final String? approvedAt;
  final String? publishedAt;
  final String createdAt;
  final String updatedAt;

  const PayrollRecord({
    required this.id,
    required this.payrollPeriod,
    required this.status,
    required this.totalEmployee,
    required this.totalGrossSalary,
    required this.totalDeduction,
    required this.totalNetSalary,
    required this.submittedBy,
    required this.approvedBy,
    required this.approvedAt,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  PayrollRecord copyWith({
    String? status,
    String? approvedBy,
    String? approvedAt,
    String? publishedAt,
  }) {
    return PayrollRecord(
      id: id,
      payrollPeriod: payrollPeriod,
      status: status ?? this.status,
      totalEmployee: totalEmployee,
      totalGrossSalary: totalGrossSalary,
      totalDeduction: totalDeduction,
      totalNetSalary: totalNetSalary,
      submittedBy: submittedBy,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedAt: approvedAt ?? this.approvedAt,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );
  }
}

class PayrollDetail {
  final String id;
  final String payrollId;
  final String employeeId;
  final num basicSalary;
  final num totalAllowance;
  final num totalDeduction;
  final num bonus;
  final num adjustment;
  final num grossSalary;
  final num netSalary;
  final String status;
  final String createdAt;
  final String updatedAt;

  const PayrollDetail({
    required this.id,
    required this.payrollId,
    required this.employeeId,
    required this.basicSalary,
    required this.totalAllowance,
    required this.totalDeduction,
    required this.bonus,
    required this.adjustment,
    required this.grossSalary,
    required this.netSalary,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
}
