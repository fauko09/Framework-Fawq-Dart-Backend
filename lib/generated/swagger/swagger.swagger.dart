// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element_parameter

import 'package:json_annotation/json_annotation.dart';
import 'package:json_annotation/json_annotation.dart' as json;
import 'package:collection/collection.dart';
import 'dart:convert';

import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show MultipartFile;
import 'package:chopper/chopper.dart' as chopper;
import 'swagger.metadata.swagger.dart';

part 'swagger.swagger.chopper.dart';
part 'swagger.swagger.g.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Swagger extends ChopperService {
  static Swagger create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Swagger(client);
    }

    final newClient = ChopperClient(
      services: [_$Swagger()],
      converter: converter ?? $JsonSerializableConverter(),
      interceptors: interceptors ?? [],
      client: httpClient,
      authenticator: authenticator,
      errorConverter: errorConverter,
      baseUrl: baseUrl ?? Uri.parse('http://'),
    );
    return _$Swagger(newClient);
  }

  ///API root health check
  Future<chopper.Response<Get$Response>> get() {
    generatedMapping.putIfAbsent(
      Get$Response,
      () => Get$Response.fromJsonFactory,
    );

    return _get();
  }

  ///API root health check
  @GET(path: '/')
  Future<chopper.Response<Get$Response>> _get({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'API root health check',
      operationId: 'getRootHealth',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Health"],
      deprecated: false,
    ),
  });

  ///Login and issue tokens
  Future<chopper.Response<AuthSuccessResponse>> apiAuthLoginPost({
    required LoginRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      AuthSuccessResponse,
      () => AuthSuccessResponse.fromJsonFactory,
    );

    return _apiAuthLoginPost(body: body);
  }

  ///Login and issue tokens
  @POST(path: '/api/auth/login', optionalBody: true)
  Future<chopper.Response<AuthSuccessResponse>> _apiAuthLoginPost({
    @Body() required LoginRequest? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Login and issue tokens',
      operationId: 'login',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Auth"],
      deprecated: false,
    ),
  });

  ///Logout current access token
  Future<chopper.Response<ApiAuthLogoutPost$Response>> apiAuthLogoutPost() {
    generatedMapping.putIfAbsent(
      ApiAuthLogoutPost$Response,
      () => ApiAuthLogoutPost$Response.fromJsonFactory,
    );

    return _apiAuthLogoutPost();
  }

  ///Logout current access token
  @POST(path: '/api/auth/logout', optionalBody: true)
  Future<chopper.Response<ApiAuthLogoutPost$Response>> _apiAuthLogoutPost({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Logout current access token',
      operationId: 'logout',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Auth"],
      deprecated: false,
    ),
  });

  ///Get current authenticated user
  Future<chopper.Response<ApiAuthMeGet$Response>> apiAuthMeGet() {
    generatedMapping.putIfAbsent(
      ApiAuthMeGet$Response,
      () => ApiAuthMeGet$Response.fromJsonFactory,
    );

    return _apiAuthMeGet();
  }

  ///Get current authenticated user
  @GET(path: '/api/auth/me')
  Future<chopper.Response<ApiAuthMeGet$Response>> _apiAuthMeGet({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get current authenticated user',
      operationId: 'getMe',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Auth"],
      deprecated: false,
    ),
  });

  ///Refresh access token
  Future<chopper.Response<ApiAuthRefreshTokenPost$Response>>
  apiAuthRefreshTokenPost({required RefreshTokenRequest? body}) {
    generatedMapping.putIfAbsent(
      ApiAuthRefreshTokenPost$Response,
      () => ApiAuthRefreshTokenPost$Response.fromJsonFactory,
    );

    return _apiAuthRefreshTokenPost(body: body);
  }

  ///Refresh access token
  @POST(path: '/api/auth/refresh-token', optionalBody: true)
  Future<chopper.Response<ApiAuthRefreshTokenPost$Response>>
  _apiAuthRefreshTokenPost({
    @Body() required RefreshTokenRequest? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Refresh access token',
      operationId: 'refreshToken',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Auth"],
      deprecated: false,
    ),
  });

  ///List users
  Future<chopper.Response<ApiUsersGet$Response>> apiUsersGet() {
    generatedMapping.putIfAbsent(
      ApiUsersGet$Response,
      () => ApiUsersGet$Response.fromJsonFactory,
    );

    return _apiUsersGet();
  }

  ///List users
  @GET(path: '/api/users')
  Future<chopper.Response<ApiUsersGet$Response>> _apiUsersGet({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List users',
      operationId: 'listUsers',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///Create user
  Future<chopper.Response<ApiUsersPost$Response>> apiUsersPost({
    required CreateUserRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      ApiUsersPost$Response,
      () => ApiUsersPost$Response.fromJsonFactory,
    );

    return _apiUsersPost(body: body);
  }

  ///Create user
  @POST(path: '/api/users', optionalBody: true)
  Future<chopper.Response<ApiUsersPost$Response>> _apiUsersPost({
    @Body() required CreateUserRequest? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create user',
      operationId: 'createUser',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///Get user by id
  ///@param id
  Future<chopper.Response<ApiUsersIdGet$Response>> apiUsersIdGet({
    required String? id,
  }) {
    generatedMapping.putIfAbsent(
      ApiUsersIdGet$Response,
      () => ApiUsersIdGet$Response.fromJsonFactory,
    );

    return _apiUsersIdGet(id: id);
  }

  ///Get user by id
  ///@param id
  @GET(path: '/api/users/{id}')
  Future<chopper.Response<ApiUsersIdGet$Response>> _apiUsersIdGet({
    @Path('id') required String? id,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get user by id',
      operationId: 'getUserById',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///Update user
  ///@param id
  Future<chopper.Response<ApiUsersIdPatch$Response>> apiUsersIdPatch({
    required String? id,
    required UpdateUserRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      ApiUsersIdPatch$Response,
      () => ApiUsersIdPatch$Response.fromJsonFactory,
    );

    return _apiUsersIdPatch(id: id, body: body);
  }

  ///Update user
  ///@param id
  @PATCH(path: '/api/users/{id}', optionalBody: true)
  Future<chopper.Response<ApiUsersIdPatch$Response>> _apiUsersIdPatch({
    @Path('id') required String? id,
    @Body() required UpdateUserRequest? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update user',
      operationId: 'updateUser',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///Delete user
  ///@param id
  Future<chopper.Response<ApiUsersIdDelete$Response>> apiUsersIdDelete({
    required String? id,
  }) {
    generatedMapping.putIfAbsent(
      ApiUsersIdDelete$Response,
      () => ApiUsersIdDelete$Response.fromJsonFactory,
    );

    return _apiUsersIdDelete(id: id);
  }

  ///Delete user
  ///@param id
  @DELETE(path: '/api/users/{id}')
  Future<chopper.Response<ApiUsersIdDelete$Response>> _apiUsersIdDelete({
    @Path('id') required String? id,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete user',
      operationId: 'deleteUser',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Users"],
      deprecated: false,
    ),
  });

  ///List roles
  Future<chopper.Response<ApiRolesGet$Response>> apiRolesGet() {
    generatedMapping.putIfAbsent(
      ApiRolesGet$Response,
      () => ApiRolesGet$Response.fromJsonFactory,
    );

    return _apiRolesGet();
  }

  ///List roles
  @GET(path: '/api/roles')
  Future<chopper.Response<ApiRolesGet$Response>> _apiRolesGet({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List roles',
      operationId: 'listRoles',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Roles"],
      deprecated: false,
    ),
  });

  ///Create role
  Future<chopper.Response<ApiRolesPost$Response>> apiRolesPost({
    required CreateRoleRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      ApiRolesPost$Response,
      () => ApiRolesPost$Response.fromJsonFactory,
    );

    return _apiRolesPost(body: body);
  }

  ///Create role
  @POST(path: '/api/roles', optionalBody: true)
  Future<chopper.Response<ApiRolesPost$Response>> _apiRolesPost({
    @Body() required CreateRoleRequest? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create role',
      operationId: 'createRole',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Roles"],
      deprecated: false,
    ),
  });

  ///List permissions
  Future<chopper.Response<ApiPermissionsGet$Response>> apiPermissionsGet() {
    generatedMapping.putIfAbsent(
      ApiPermissionsGet$Response,
      () => ApiPermissionsGet$Response.fromJsonFactory,
    );

    return _apiPermissionsGet();
  }

  ///List permissions
  @GET(path: '/api/permissions')
  Future<chopper.Response<ApiPermissionsGet$Response>> _apiPermissionsGet({
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List permissions',
      operationId: 'listPermissions',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Permissions"],
      deprecated: false,
    ),
  });

  ///Assign permissions to role
  Future<chopper.Response<ApiRolePermissionsPost$Response>>
  apiRolePermissionsPost({required AssignRolePermissionsRequest? body}) {
    generatedMapping.putIfAbsent(
      ApiRolePermissionsPost$Response,
      () => ApiRolePermissionsPost$Response.fromJsonFactory,
    );

    return _apiRolePermissionsPost(body: body);
  }

  ///Assign permissions to role
  @POST(path: '/api/role-permissions', optionalBody: true)
  Future<chopper.Response<ApiRolePermissionsPost$Response>>
  _apiRolePermissionsPost({
    @Body() required AssignRolePermissionsRequest? body,
    @chopper.Tag()
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Assign permissions to role',
      operationId: 'assignRolePermissions',
      consumes: [],
      produces: [],
      security: ["bearerAuth"],
      tags: ["Permissions"],
      deprecated: false,
    ),
  });
}

@JsonSerializable(explicitToJson: true)
class ErrorResponse {
  const ErrorResponse({this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);

  static const toJsonFactory = _$ErrorResponseToJson;
  Map<String, dynamic> toJson() => _$ErrorResponseToJson(this);

  @JsonKey(name: 'message')
  final String? message;
  static const fromJsonFactory = _$ErrorResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ErrorResponse &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $ErrorResponseExtension on ErrorResponse {
  ErrorResponse copyWith({String? message}) {
    return ErrorResponse(message: message ?? this.message);
  }

  ErrorResponse copyWithWrapped({Wrapped<String?>? message}) {
    return ErrorResponse(
      message: (message != null ? message.value : this.message),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  static const toJsonFactory = _$LoginRequestToJson;
  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);

  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  static const fromJsonFactory = _$LoginRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is LoginRequest &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      runtimeType.hashCode;
}

extension $LoginRequestExtension on LoginRequest {
  LoginRequest copyWith({String? email, String? password}) {
    return LoginRequest(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  LoginRequest copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<String>? password,
  }) {
    return LoginRequest(
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class RefreshTokenRequest {
  const RefreshTokenRequest({required this.refreshToken});

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);

  static const toJsonFactory = _$RefreshTokenRequestToJson;
  Map<String, dynamic> toJson() => _$RefreshTokenRequestToJson(this);

  @JsonKey(name: 'refreshToken')
  final String refreshToken;
  static const fromJsonFactory = _$RefreshTokenRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is RefreshTokenRequest &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(refreshToken) ^ runtimeType.hashCode;
}

extension $RefreshTokenRequestExtension on RefreshTokenRequest {
  RefreshTokenRequest copyWith({String? refreshToken}) {
    return RefreshTokenRequest(refreshToken: refreshToken ?? this.refreshToken);
  }

  RefreshTokenRequest copyWithWrapped({Wrapped<String>? refreshToken}) {
    return RefreshTokenRequest(
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class User {
  const User({this.id, this.name, this.email, this.isActive, this.roles});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static const toJsonFactory = _$UserToJson;
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'isActive')
  final bool? isActive;
  @JsonKey(name: 'roles', defaultValue: <Role>[])
  final List<Role>? roles;
  static const fromJsonFactory = _$UserFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is User &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality().equals(
                  other.isActive,
                  isActive,
                )) &&
            (identical(other.roles, roles) ||
                const DeepCollectionEquality().equals(other.roles, roles)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(isActive) ^
      const DeepCollectionEquality().hash(roles) ^
      runtimeType.hashCode;
}

extension $UserExtension on User {
  User copyWith({
    String? id,
    String? name,
    String? email,
    bool? isActive,
    List<Role>? roles,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      roles: roles ?? this.roles,
    );
  }

  User copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? email,
    Wrapped<bool?>? isActive,
    Wrapped<List<Role>?>? roles,
  }) {
    return User(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      email: (email != null ? email.value : this.email),
      isActive: (isActive != null ? isActive.value : this.isActive),
      roles: (roles != null ? roles.value : this.roles),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Role {
  const Role({this.id, this.name, this.description});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  static const toJsonFactory = _$RoleToJson;
  Map<String, dynamic> toJson() => _$RoleToJson(this);

  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'description')
  final String? description;
  static const fromJsonFactory = _$RoleFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Role &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $RoleExtension on Role {
  Role copyWith({String? id, String? name, String? description}) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  Role copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? description,
  }) {
    return Role(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Permission {
  const Permission({this.id, this.code, this.description});

  factory Permission.fromJson(Map<String, dynamic> json) =>
      _$PermissionFromJson(json);

  static const toJsonFactory = _$PermissionToJson;
  Map<String, dynamic> toJson() => _$PermissionToJson(this);

  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'code')
  final String? code;
  @JsonKey(name: 'description')
  final String? description;
  static const fromJsonFactory = _$PermissionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Permission &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $PermissionExtension on Permission {
  Permission copyWith({String? id, String? code, String? description}) {
    return Permission(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
    );
  }

  Permission copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? code,
    Wrapped<String?>? description,
  }) {
    return Permission(
      id: (id != null ? id.value : this.id),
      code: (code != null ? code.value : this.code),
      description: (description != null ? description.value : this.description),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AuthSuccessResponse {
  const AuthSuccessResponse({this.accessToken, this.refreshToken, this.user});

  factory AuthSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthSuccessResponseFromJson(json);

  static const toJsonFactory = _$AuthSuccessResponseToJson;
  Map<String, dynamic> toJson() => _$AuthSuccessResponseToJson(this);

  @JsonKey(name: 'accessToken')
  final String? accessToken;
  @JsonKey(name: 'refreshToken')
  final String? refreshToken;
  @JsonKey(name: 'user')
  final User? user;
  static const fromJsonFactory = _$AuthSuccessResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AuthSuccessResponse &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality().equals(
                  other.accessToken,
                  accessToken,
                )) &&
            (identical(other.refreshToken, refreshToken) ||
                const DeepCollectionEquality().equals(
                  other.refreshToken,
                  refreshToken,
                )) &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^
      const DeepCollectionEquality().hash(refreshToken) ^
      const DeepCollectionEquality().hash(user) ^
      runtimeType.hashCode;
}

extension $AuthSuccessResponseExtension on AuthSuccessResponse {
  AuthSuccessResponse copyWith({
    String? accessToken,
    String? refreshToken,
    User? user,
  }) {
    return AuthSuccessResponse(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  AuthSuccessResponse copyWithWrapped({
    Wrapped<String?>? accessToken,
    Wrapped<String?>? refreshToken,
    Wrapped<User?>? user,
  }) {
    return AuthSuccessResponse(
      accessToken: (accessToken != null ? accessToken.value : this.accessToken),
      refreshToken: (refreshToken != null
          ? refreshToken.value
          : this.refreshToken),
      user: (user != null ? user.value : this.user),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateUserRequest {
  const CreateUserRequest({
    required this.name,
    required this.email,
    required this.password,
    this.roleIds,
  });

  factory CreateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUserRequestFromJson(json);

  static const toJsonFactory = _$CreateUserRequestToJson;
  Map<String, dynamic> toJson() => _$CreateUserRequestToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'password')
  final String password;
  @JsonKey(name: 'roleIds', defaultValue: <String>[])
  final List<String>? roleIds;
  static const fromJsonFactory = _$CreateUserRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateUserRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.roleIds, roleIds) ||
                const DeepCollectionEquality().equals(other.roleIds, roleIds)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(roleIds) ^
      runtimeType.hashCode;
}

extension $CreateUserRequestExtension on CreateUserRequest {
  CreateUserRequest copyWith({
    String? name,
    String? email,
    String? password,
    List<String>? roleIds,
  }) {
    return CreateUserRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      roleIds: roleIds ?? this.roleIds,
    );
  }

  CreateUserRequest copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String>? email,
    Wrapped<String>? password,
    Wrapped<List<String>?>? roleIds,
  }) {
    return CreateUserRequest(
      name: (name != null ? name.value : this.name),
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
      roleIds: (roleIds != null ? roleIds.value : this.roleIds),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateUserRequest {
  const UpdateUserRequest({
    this.name,
    this.email,
    this.password,
    this.isActive,
  });

  factory UpdateUserRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserRequestFromJson(json);

  static const toJsonFactory = _$UpdateUserRequestToJson;
  Map<String, dynamic> toJson() => _$UpdateUserRequestToJson(this);

  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'email')
  final String? email;
  @JsonKey(name: 'password')
  final String? password;
  @JsonKey(name: 'isActive')
  final bool? isActive;
  static const fromJsonFactory = _$UpdateUserRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateUserRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.password, password) ||
                const DeepCollectionEquality().equals(
                  other.password,
                  password,
                )) &&
            (identical(other.isActive, isActive) ||
                const DeepCollectionEquality().equals(
                  other.isActive,
                  isActive,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(password) ^
      const DeepCollectionEquality().hash(isActive) ^
      runtimeType.hashCode;
}

extension $UpdateUserRequestExtension on UpdateUserRequest {
  UpdateUserRequest copyWith({
    String? name,
    String? email,
    String? password,
    bool? isActive,
  }) {
    return UpdateUserRequest(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      isActive: isActive ?? this.isActive,
    );
  }

  UpdateUserRequest copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? email,
    Wrapped<String?>? password,
    Wrapped<bool?>? isActive,
  }) {
    return UpdateUserRequest(
      name: (name != null ? name.value : this.name),
      email: (email != null ? email.value : this.email),
      password: (password != null ? password.value : this.password),
      isActive: (isActive != null ? isActive.value : this.isActive),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateRoleRequest {
  const CreateRoleRequest({required this.name, required this.description});

  factory CreateRoleRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateRoleRequestFromJson(json);

  static const toJsonFactory = _$CreateRoleRequestToJson;
  Map<String, dynamic> toJson() => _$CreateRoleRequestToJson(this);

  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String description;
  static const fromJsonFactory = _$CreateRoleRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateRoleRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $CreateRoleRequestExtension on CreateRoleRequest {
  CreateRoleRequest copyWith({String? name, String? description}) {
    return CreateRoleRequest(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  CreateRoleRequest copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String>? description,
  }) {
    return CreateRoleRequest(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AssignRolePermissionsRequest {
  const AssignRolePermissionsRequest({
    required this.roleId,
    required this.permissionIds,
  });

  factory AssignRolePermissionsRequest.fromJson(Map<String, dynamic> json) =>
      _$AssignRolePermissionsRequestFromJson(json);

  static const toJsonFactory = _$AssignRolePermissionsRequestToJson;
  Map<String, dynamic> toJson() => _$AssignRolePermissionsRequestToJson(this);

  @JsonKey(name: 'roleId')
  final String roleId;
  @JsonKey(name: 'permissionIds', defaultValue: <String>[])
  final List<String> permissionIds;
  static const fromJsonFactory = _$AssignRolePermissionsRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AssignRolePermissionsRequest &&
            (identical(other.roleId, roleId) ||
                const DeepCollectionEquality().equals(other.roleId, roleId)) &&
            (identical(other.permissionIds, permissionIds) ||
                const DeepCollectionEquality().equals(
                  other.permissionIds,
                  permissionIds,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(roleId) ^
      const DeepCollectionEquality().hash(permissionIds) ^
      runtimeType.hashCode;
}

extension $AssignRolePermissionsRequestExtension
    on AssignRolePermissionsRequest {
  AssignRolePermissionsRequest copyWith({
    String? roleId,
    List<String>? permissionIds,
  }) {
    return AssignRolePermissionsRequest(
      roleId: roleId ?? this.roleId,
      permissionIds: permissionIds ?? this.permissionIds,
    );
  }

  AssignRolePermissionsRequest copyWithWrapped({
    Wrapped<String>? roleId,
    Wrapped<List<String>>? permissionIds,
  }) {
    return AssignRolePermissionsRequest(
      roleId: (roleId != null ? roleId.value : this.roleId),
      permissionIds: (permissionIds != null
          ? permissionIds.value
          : this.permissionIds),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class Get$Response {
  const Get$Response({this.message, this.module});

  factory Get$Response.fromJson(Map<String, dynamic> json) =>
      _$Get$ResponseFromJson(json);

  static const toJsonFactory = _$Get$ResponseToJson;
  Map<String, dynamic> toJson() => _$Get$ResponseToJson(this);

  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'module')
  final String? module;
  static const fromJsonFactory = _$Get$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Get$Response &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(
                  other.message,
                  message,
                )) &&
            (identical(other.module, module) ||
                const DeepCollectionEquality().equals(other.module, module)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^
      const DeepCollectionEquality().hash(module) ^
      runtimeType.hashCode;
}

extension $Get$ResponseExtension on Get$Response {
  Get$Response copyWith({String? message, String? module}) {
    return Get$Response(
      message: message ?? this.message,
      module: module ?? this.module,
    );
  }

  Get$Response copyWithWrapped({
    Wrapped<String?>? message,
    Wrapped<String?>? module,
  }) {
    return Get$Response(
      message: (message != null ? message.value : this.message),
      module: (module != null ? module.value : this.module),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiAuthLogoutPost$Response {
  const ApiAuthLogoutPost$Response({this.message});

  factory ApiAuthLogoutPost$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiAuthLogoutPost$ResponseFromJson(json);

  static const toJsonFactory = _$ApiAuthLogoutPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiAuthLogoutPost$ResponseToJson(this);

  @JsonKey(name: 'message')
  final String? message;
  static const fromJsonFactory = _$ApiAuthLogoutPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiAuthLogoutPost$Response &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $ApiAuthLogoutPost$ResponseExtension on ApiAuthLogoutPost$Response {
  ApiAuthLogoutPost$Response copyWith({String? message}) {
    return ApiAuthLogoutPost$Response(message: message ?? this.message);
  }

  ApiAuthLogoutPost$Response copyWithWrapped({Wrapped<String?>? message}) {
    return ApiAuthLogoutPost$Response(
      message: (message != null ? message.value : this.message),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiAuthMeGet$Response {
  const ApiAuthMeGet$Response({this.user});

  factory ApiAuthMeGet$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiAuthMeGet$ResponseFromJson(json);

  static const toJsonFactory = _$ApiAuthMeGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiAuthMeGet$ResponseToJson(this);

  @JsonKey(name: 'user')
  final User? user;
  static const fromJsonFactory = _$ApiAuthMeGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiAuthMeGet$Response &&
            (identical(other.user, user) ||
                const DeepCollectionEquality().equals(other.user, user)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(user) ^ runtimeType.hashCode;
}

extension $ApiAuthMeGet$ResponseExtension on ApiAuthMeGet$Response {
  ApiAuthMeGet$Response copyWith({User? user}) {
    return ApiAuthMeGet$Response(user: user ?? this.user);
  }

  ApiAuthMeGet$Response copyWithWrapped({Wrapped<User?>? user}) {
    return ApiAuthMeGet$Response(user: (user != null ? user.value : this.user));
  }
}

@JsonSerializable(explicitToJson: true)
class ApiAuthRefreshTokenPost$Response {
  const ApiAuthRefreshTokenPost$Response({this.accessToken});

  factory ApiAuthRefreshTokenPost$Response.fromJson(
    Map<String, dynamic> json,
  ) => _$ApiAuthRefreshTokenPost$ResponseFromJson(json);

  static const toJsonFactory = _$ApiAuthRefreshTokenPost$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$ApiAuthRefreshTokenPost$ResponseToJson(this);

  @JsonKey(name: 'accessToken')
  final String? accessToken;
  static const fromJsonFactory = _$ApiAuthRefreshTokenPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiAuthRefreshTokenPost$Response &&
            (identical(other.accessToken, accessToken) ||
                const DeepCollectionEquality().equals(
                  other.accessToken,
                  accessToken,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(accessToken) ^ runtimeType.hashCode;
}

extension $ApiAuthRefreshTokenPost$ResponseExtension
    on ApiAuthRefreshTokenPost$Response {
  ApiAuthRefreshTokenPost$Response copyWith({String? accessToken}) {
    return ApiAuthRefreshTokenPost$Response(
      accessToken: accessToken ?? this.accessToken,
    );
  }

  ApiAuthRefreshTokenPost$Response copyWithWrapped({
    Wrapped<String?>? accessToken,
  }) {
    return ApiAuthRefreshTokenPost$Response(
      accessToken: (accessToken != null ? accessToken.value : this.accessToken),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiUsersGet$Response {
  const ApiUsersGet$Response({this.data});

  factory ApiUsersGet$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiUsersGet$ResponseFromJson(json);

  static const toJsonFactory = _$ApiUsersGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiUsersGet$ResponseToJson(this);

  @JsonKey(name: 'data', defaultValue: <User>[])
  final List<User>? data;
  static const fromJsonFactory = _$ApiUsersGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiUsersGet$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $ApiUsersGet$ResponseExtension on ApiUsersGet$Response {
  ApiUsersGet$Response copyWith({List<User>? data}) {
    return ApiUsersGet$Response(data: data ?? this.data);
  }

  ApiUsersGet$Response copyWithWrapped({Wrapped<List<User>?>? data}) {
    return ApiUsersGet$Response(data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class ApiUsersPost$Response {
  const ApiUsersPost$Response({this.data});

  factory ApiUsersPost$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiUsersPost$ResponseFromJson(json);

  static const toJsonFactory = _$ApiUsersPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiUsersPost$ResponseToJson(this);

  @JsonKey(name: 'data')
  final User? data;
  static const fromJsonFactory = _$ApiUsersPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiUsersPost$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $ApiUsersPost$ResponseExtension on ApiUsersPost$Response {
  ApiUsersPost$Response copyWith({User? data}) {
    return ApiUsersPost$Response(data: data ?? this.data);
  }

  ApiUsersPost$Response copyWithWrapped({Wrapped<User?>? data}) {
    return ApiUsersPost$Response(data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class ApiUsersIdGet$Response {
  const ApiUsersIdGet$Response({this.data});

  factory ApiUsersIdGet$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiUsersIdGet$ResponseFromJson(json);

  static const toJsonFactory = _$ApiUsersIdGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiUsersIdGet$ResponseToJson(this);

  @JsonKey(name: 'data')
  final User? data;
  static const fromJsonFactory = _$ApiUsersIdGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiUsersIdGet$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $ApiUsersIdGet$ResponseExtension on ApiUsersIdGet$Response {
  ApiUsersIdGet$Response copyWith({User? data}) {
    return ApiUsersIdGet$Response(data: data ?? this.data);
  }

  ApiUsersIdGet$Response copyWithWrapped({Wrapped<User?>? data}) {
    return ApiUsersIdGet$Response(
      data: (data != null ? data.value : this.data),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiUsersIdPatch$Response {
  const ApiUsersIdPatch$Response({this.data});

  factory ApiUsersIdPatch$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiUsersIdPatch$ResponseFromJson(json);

  static const toJsonFactory = _$ApiUsersIdPatch$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiUsersIdPatch$ResponseToJson(this);

  @JsonKey(name: 'data')
  final User? data;
  static const fromJsonFactory = _$ApiUsersIdPatch$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiUsersIdPatch$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $ApiUsersIdPatch$ResponseExtension on ApiUsersIdPatch$Response {
  ApiUsersIdPatch$Response copyWith({User? data}) {
    return ApiUsersIdPatch$Response(data: data ?? this.data);
  }

  ApiUsersIdPatch$Response copyWithWrapped({Wrapped<User?>? data}) {
    return ApiUsersIdPatch$Response(
      data: (data != null ? data.value : this.data),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiUsersIdDelete$Response {
  const ApiUsersIdDelete$Response({this.message});

  factory ApiUsersIdDelete$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiUsersIdDelete$ResponseFromJson(json);

  static const toJsonFactory = _$ApiUsersIdDelete$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiUsersIdDelete$ResponseToJson(this);

  @JsonKey(name: 'message')
  final String? message;
  static const fromJsonFactory = _$ApiUsersIdDelete$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiUsersIdDelete$Response &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $ApiUsersIdDelete$ResponseExtension on ApiUsersIdDelete$Response {
  ApiUsersIdDelete$Response copyWith({String? message}) {
    return ApiUsersIdDelete$Response(message: message ?? this.message);
  }

  ApiUsersIdDelete$Response copyWithWrapped({Wrapped<String?>? message}) {
    return ApiUsersIdDelete$Response(
      message: (message != null ? message.value : this.message),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiRolesGet$Response {
  const ApiRolesGet$Response({this.data});

  factory ApiRolesGet$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiRolesGet$ResponseFromJson(json);

  static const toJsonFactory = _$ApiRolesGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiRolesGet$ResponseToJson(this);

  @JsonKey(name: 'data', defaultValue: <Role>[])
  final List<Role>? data;
  static const fromJsonFactory = _$ApiRolesGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiRolesGet$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $ApiRolesGet$ResponseExtension on ApiRolesGet$Response {
  ApiRolesGet$Response copyWith({List<Role>? data}) {
    return ApiRolesGet$Response(data: data ?? this.data);
  }

  ApiRolesGet$Response copyWithWrapped({Wrapped<List<Role>?>? data}) {
    return ApiRolesGet$Response(data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class ApiRolesPost$Response {
  const ApiRolesPost$Response({this.data});

  factory ApiRolesPost$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiRolesPost$ResponseFromJson(json);

  static const toJsonFactory = _$ApiRolesPost$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiRolesPost$ResponseToJson(this);

  @JsonKey(name: 'data')
  final Role? data;
  static const fromJsonFactory = _$ApiRolesPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiRolesPost$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $ApiRolesPost$ResponseExtension on ApiRolesPost$Response {
  ApiRolesPost$Response copyWith({Role? data}) {
    return ApiRolesPost$Response(data: data ?? this.data);
  }

  ApiRolesPost$Response copyWithWrapped({Wrapped<Role?>? data}) {
    return ApiRolesPost$Response(data: (data != null ? data.value : this.data));
  }
}

@JsonSerializable(explicitToJson: true)
class ApiPermissionsGet$Response {
  const ApiPermissionsGet$Response({this.data});

  factory ApiPermissionsGet$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiPermissionsGet$ResponseFromJson(json);

  static const toJsonFactory = _$ApiPermissionsGet$ResponseToJson;
  Map<String, dynamic> toJson() => _$ApiPermissionsGet$ResponseToJson(this);

  @JsonKey(name: 'data', defaultValue: <Permission>[])
  final List<Permission>? data;
  static const fromJsonFactory = _$ApiPermissionsGet$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiPermissionsGet$Response &&
            (identical(other.data, data) ||
                const DeepCollectionEquality().equals(other.data, data)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(data) ^ runtimeType.hashCode;
}

extension $ApiPermissionsGet$ResponseExtension on ApiPermissionsGet$Response {
  ApiPermissionsGet$Response copyWith({List<Permission>? data}) {
    return ApiPermissionsGet$Response(data: data ?? this.data);
  }

  ApiPermissionsGet$Response copyWithWrapped({
    Wrapped<List<Permission>?>? data,
  }) {
    return ApiPermissionsGet$Response(
      data: (data != null ? data.value : this.data),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiRolePermissionsPost$Response {
  const ApiRolePermissionsPost$Response({this.message});

  factory ApiRolePermissionsPost$Response.fromJson(Map<String, dynamic> json) =>
      _$ApiRolePermissionsPost$ResponseFromJson(json);

  static const toJsonFactory = _$ApiRolePermissionsPost$ResponseToJson;
  Map<String, dynamic> toJson() =>
      _$ApiRolePermissionsPost$ResponseToJson(this);

  @JsonKey(name: 'message')
  final String? message;
  static const fromJsonFactory = _$ApiRolePermissionsPost$ResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiRolePermissionsPost$Response &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(message) ^ runtimeType.hashCode;
}

extension $ApiRolePermissionsPost$ResponseExtension
    on ApiRolePermissionsPost$Response {
  ApiRolePermissionsPost$Response copyWith({String? message}) {
    return ApiRolePermissionsPost$Response(message: message ?? this.message);
  }

  ApiRolePermissionsPost$Response copyWithWrapped({Wrapped<String?>? message}) {
    return ApiRolePermissionsPost$Response(
      message: (message != null ? message.value : this.message),
    );
  }
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
    chopper.Response response,
  ) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
        body:
            DateTime.parse((response.body as String).replaceAll('"', ''))
                as ResultType,
      );
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
      body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType,
    );
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
