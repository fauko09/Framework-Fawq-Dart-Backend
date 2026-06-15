class BootstrapRoleSeed {
  final String id;
  final String name;
  final String description;

  const BootstrapRoleSeed({
    required this.id,
    required this.name,
    required this.description,
  });
}

class BootstrapPermissionSeed {
  final String id;
  final String code;
  final String description;

  const BootstrapPermissionSeed({
    required this.id,
    required this.code,
    required this.description,
  });
}

class BootstrapUserSeed {
  final String id;
  final String name;
  final String email;
  final String password;
  final bool isActive;

  const BootstrapUserSeed({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isActive,
  });
}

class BootstrapUserDetailSeed {
  final String id;
  final String userId;
  final String address;
  final String phone;
  final String? phone2;
  final String nik;
  final String nikKtp;
  final String noBank;
  final String namaBank;

  const BootstrapUserDetailSeed({
    required this.id,
    required this.userId,
    required this.address,
    required this.phone,
    required this.phone2,
    required this.nik,
    required this.nikKtp,
    required this.noBank,
    required this.namaBank,
  });
}

class BootstrapDepartmentSeed {
  final String id;
  final String name;

  const BootstrapDepartmentSeed({
    required this.id,
    required this.name,
  });
}

class BootstrapEmployeeSeed {
  final String id;
  final String userId;
  final String fullName;
  final String departmentId;
  final String? positionId;
  final String employeeStatus;
  final String? contractType;
  final int? basicSalary;

  const BootstrapEmployeeSeed({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.departmentId,
    required this.positionId,
    required this.employeeStatus,
    required this.contractType,
    required this.basicSalary,
  });
}

class BootstrapRolePermissionSeed {
  final String roleName;
  final String permissionCode;

  const BootstrapRolePermissionSeed({
    required this.roleName,
    required this.permissionCode,
  });
}

class BootstrapUserRoleSeed {
  final String userEmail;
  final String roleName;

  const BootstrapUserRoleSeed({
    required this.userEmail,
    required this.roleName,
  });
}

class BootstrapSeedCatalog {
  static const superAdminUserId = 'user-super-admin';
  static const superAdminEmail = 'superadmin@fga.local';
  static const retailOperationsDepartmentId = 'dept-operasional-toko';

  static const roles = <BootstrapRoleSeed>[
    BootstrapRoleSeed(
      id: 'role-super-admin',
      name: 'super_admin',
      description: 'Super Admin',
    ),
    BootstrapRoleSeed(
      id: 'role-admin-hris',
      name: 'admin_hris',
      description: 'Admin HRIS',
    ),
    BootstrapRoleSeed(
      id: 'role-hrd',
      name: 'hrd',
      description: 'HRD',
    ),
    BootstrapRoleSeed(
      id: 'role-legal',
      name: 'legal',
      description: 'Legal',
    ),
    BootstrapRoleSeed(
      id: 'role-direktur',
      name: 'direktur',
      description: 'Direktur',
    ),
    BootstrapRoleSeed(
      id: 'role-upliner-langsung',
      name: 'upliner_langsung',
      description: 'Upliner Langsung',
    ),
    BootstrapRoleSeed(
      id: 'role-employee',
      name: 'employee',
      description: 'Employee',
    ),
  ];

  static const permissions = <BootstrapPermissionSeed>[
    BootstrapPermissionSeed(
      id: 'perm-manage-users',
      code: 'manage_users',
      description: 'Manage users',
    ),
    BootstrapPermissionSeed(
      id: 'perm-manage-roles',
      code: 'manage_roles',
      description: 'Manage roles',
    ),
    BootstrapPermissionSeed(
      id: 'perm-manage-permissions',
      code: 'manage_permissions',
      description: 'Manage permissions',
    ),
    BootstrapPermissionSeed(
      id: 'perm-manage-company-settings',
      code: 'manage_company_settings',
      description: 'Manage company settings',
    ),
    BootstrapPermissionSeed(
      id: 'perm-manage-departments',
      code: 'manage_departments',
      description: 'Manage departments',
    ),
    BootstrapPermissionSeed(
      id: 'perm-manage-positions',
      code: 'manage_positions',
      description: 'Manage positions',
    ),
    BootstrapPermissionSeed(
      id: 'perm-view-audit-logs',
      code: 'view_audit_logs',
      description: 'View audit logs',
    ),
  ];

  static const users = <BootstrapUserSeed>[
    BootstrapUserSeed(
      id: superAdminUserId,
      name: 'Super Admin',
      email: superAdminEmail,
      password: 'superadmin123',
      isActive: true,
    ),
  ];

  static const userDetails = <BootstrapUserDetailSeed>[
    BootstrapUserDetailSeed(
      id: 'user-detail-super-admin',
      userId: superAdminUserId,
      address: 'Jl. Boulevard Emas No. 88, Jakarta Utara',
      phone: '081234567890',
      phone2: '0215558899',
      nik: '3175091501900001',
      nikKtp: '3175091501900001',
      noBank: '1234567890',
      namaBank: 'BCA',
    ),
  ];

  static const departments = <BootstrapDepartmentSeed>[
    BootstrapDepartmentSeed(
      id: retailOperationsDepartmentId,
      name: 'Operasional Toko',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-penjualan',
      name: 'Penjualan',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-purchasing-emas',
      name: 'Purchasing Emas',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-gudang-inventori',
      name: 'Gudang dan Inventori',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-keuangan',
      name: 'Keuangan',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-human-capital',
      name: 'Human Capital',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-marketing',
      name: 'Marketing',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-customer-service',
      name: 'Customer Service',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-security',
      name: 'Security',
    ),
    BootstrapDepartmentSeed(
      id: 'dept-compliance',
      name: 'Compliance',
    ),
  ];

  static const employees = <BootstrapEmployeeSeed>[
    BootstrapEmployeeSeed(
      id: 'employee-super-admin',
      userId: superAdminUserId,
      fullName: 'Super Admin',
      departmentId: retailOperationsDepartmentId,
      positionId: null,
      employeeStatus: 'aktif',
      contractType: 'tetap',
      basicSalary: 15000000,
    ),
  ];

  static const rolePermissions = <BootstrapRolePermissionSeed>[
    BootstrapRolePermissionSeed(
      roleName: 'super_admin',
      permissionCode: 'manage_users',
    ),
    BootstrapRolePermissionSeed(
      roleName: 'super_admin',
      permissionCode: 'manage_roles',
    ),
    BootstrapRolePermissionSeed(
      roleName: 'super_admin',
      permissionCode: 'manage_permissions',
    ),
    BootstrapRolePermissionSeed(
      roleName: 'super_admin',
      permissionCode: 'manage_company_settings',
    ),
    BootstrapRolePermissionSeed(
      roleName: 'super_admin',
      permissionCode: 'manage_departments',
    ),
    BootstrapRolePermissionSeed(
      roleName: 'super_admin',
      permissionCode: 'manage_positions',
    ),
    BootstrapRolePermissionSeed(
      roleName: 'super_admin',
      permissionCode: 'view_audit_logs',
    ),
  ];

  static const userRoles = <BootstrapUserRoleSeed>[
    BootstrapUserRoleSeed(
      userEmail: superAdminEmail,
      roleName: 'super_admin',
    ),
  ];

  static String roleId(String roleName) {
    return roles.firstWhere((role) => role.name == roleName).id;
  }

  static String permissionId(String permissionCode) {
    return permissions
        .firstWhere((permission) => permission.code == permissionCode)
        .id;
  }

  static String userId(String email) {
    return users.firstWhere((user) => user.email == email).id;
  }
}
