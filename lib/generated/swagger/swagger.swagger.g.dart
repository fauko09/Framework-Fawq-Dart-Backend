// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'swagger.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

RefreshTokenRequest _$RefreshTokenRequestFromJson(Map<String, dynamic> json) =>
    RefreshTokenRequest(
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$RefreshTokenRequestToJson(
        RefreshTokenRequest instance) =>
    <String, dynamic>{
      'refreshToken': instance.refreshToken,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool?,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'isActive': instance.isActive,
      'roles': instance.roles?.map((e) => e.toJson()).toList(),
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };

Permission _$PermissionFromJson(Map<String, dynamic> json) => Permission(
      id: json['id'] as String?,
      code: json['code'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$PermissionToJson(Permission instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'description': instance.description,
    };

AuthSuccessResponse _$AuthSuccessResponseFromJson(Map<String, dynamic> json) =>
    AuthSuccessResponse(
      accessToken: json['accessToken'] as String?,
      refreshToken: json['refreshToken'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthSuccessResponseToJson(
        AuthSuccessResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user?.toJson(),
    };

CreateUserRequest _$CreateUserRequestFromJson(Map<String, dynamic> json) =>
    CreateUserRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      roleIds: (json['roleIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateUserRequestToJson(CreateUserRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'roleIds': instance.roleIds,
    };

UpdateUserRequest _$UpdateUserRequestFromJson(Map<String, dynamic> json) =>
    UpdateUserRequest(
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$UpdateUserRequestToJson(UpdateUserRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'password': instance.password,
      'isActive': instance.isActive,
    };

CreateRoleRequest _$CreateRoleRequestFromJson(Map<String, dynamic> json) =>
    CreateRoleRequest(
      name: json['name'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$CreateRoleRequestToJson(CreateRoleRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };

AssignRolePermissionsRequest _$AssignRolePermissionsRequestFromJson(
        Map<String, dynamic> json) =>
    AssignRolePermissionsRequest(
      roleId: json['roleId'] as String,
      permissionIds: (json['permissionIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$AssignRolePermissionsRequestToJson(
        AssignRolePermissionsRequest instance) =>
    <String, dynamic>{
      'roleId': instance.roleId,
      'permissionIds': instance.permissionIds,
    };

Get$Response _$Get$ResponseFromJson(Map<String, dynamic> json) => Get$Response(
      message: json['message'] as String?,
      module: json['module'] as String?,
    );

Map<String, dynamic> _$Get$ResponseToJson(Get$Response instance) =>
    <String, dynamic>{
      'message': instance.message,
      'module': instance.module,
    };

ApiAuthLogoutPost$Response _$ApiAuthLogoutPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiAuthLogoutPost$Response(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ApiAuthLogoutPost$ResponseToJson(
        ApiAuthLogoutPost$Response instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

ApiAuthMeGet$Response _$ApiAuthMeGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiAuthMeGet$Response(
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiAuthMeGet$ResponseToJson(
        ApiAuthMeGet$Response instance) =>
    <String, dynamic>{
      'user': instance.user?.toJson(),
    };

ApiAuthRefreshTokenPost$Response _$ApiAuthRefreshTokenPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiAuthRefreshTokenPost$Response(
      accessToken: json['accessToken'] as String?,
    );

Map<String, dynamic> _$ApiAuthRefreshTokenPost$ResponseToJson(
        ApiAuthRefreshTokenPost$Response instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
    };

ApiUsersGet$Response _$ApiUsersGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiUsersGet$Response(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => User.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ApiUsersGet$ResponseToJson(
        ApiUsersGet$Response instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

ApiUsersPost$Response _$ApiUsersPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiUsersPost$Response(
      data: json['data'] == null
          ? null
          : User.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiUsersPost$ResponseToJson(
        ApiUsersPost$Response instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
    };

ApiUsersIdGet$Response _$ApiUsersIdGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiUsersIdGet$Response(
      data: json['data'] == null
          ? null
          : User.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiUsersIdGet$ResponseToJson(
        ApiUsersIdGet$Response instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
    };

ApiUsersIdPatch$Response _$ApiUsersIdPatch$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiUsersIdPatch$Response(
      data: json['data'] == null
          ? null
          : User.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiUsersIdPatch$ResponseToJson(
        ApiUsersIdPatch$Response instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
    };

ApiUsersIdDelete$Response _$ApiUsersIdDelete$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiUsersIdDelete$Response(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ApiUsersIdDelete$ResponseToJson(
        ApiUsersIdDelete$Response instance) =>
    <String, dynamic>{
      'message': instance.message,
    };

ApiRolesGet$Response _$ApiRolesGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiRolesGet$Response(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ApiRolesGet$ResponseToJson(
        ApiRolesGet$Response instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

ApiRolesPost$Response _$ApiRolesPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiRolesPost$Response(
      data: json['data'] == null
          ? null
          : Role.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiRolesPost$ResponseToJson(
        ApiRolesPost$Response instance) =>
    <String, dynamic>{
      'data': instance.data?.toJson(),
    };

ApiPermissionsGet$Response _$ApiPermissionsGet$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiPermissionsGet$Response(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Permission.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$ApiPermissionsGet$ResponseToJson(
        ApiPermissionsGet$Response instance) =>
    <String, dynamic>{
      'data': instance.data?.map((e) => e.toJson()).toList(),
    };

ApiRolePermissionsPost$Response _$ApiRolePermissionsPost$ResponseFromJson(
        Map<String, dynamic> json) =>
    ApiRolePermissionsPost$Response(
      message: json['message'] as String?,
    );

Map<String, dynamic> _$ApiRolePermissionsPost$ResponseToJson(
        ApiRolePermissionsPost$Response instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
