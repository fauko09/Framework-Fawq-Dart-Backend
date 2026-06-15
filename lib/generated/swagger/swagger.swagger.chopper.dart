// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'swagger.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Swagger extends Swagger {
  _$Swagger([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Swagger;

  @override
  Future<Response<Get$Response>> _get(
      {SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
          description: '',
          summary: 'API root health check',
          operationId: 'getRootHealth',
          consumes: [],
          produces: [],
          security: [],
          tags: ["Health"],
          deprecated: false)}) {
    final Uri $url = Uri.parse('/');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Get$Response, Get$Response>($request);
  }

  @override
  Future<Response<AuthSuccessResponse>> _apiAuthLoginPost({
    required LoginRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
        description: '',
        summary: 'Login and issue tokens',
        operationId: 'login',
        consumes: [],
        produces: [],
        security: [],
        tags: ["Auth"],
        deprecated: false),
  }) {
    final Uri $url = Uri.parse('/api/auth/login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<AuthSuccessResponse, AuthSuccessResponse>($request);
  }

  @override
  Future<Response<ApiAuthLogoutPost$Response>> _apiAuthLogoutPost(
      {SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
          description: '',
          summary: 'Logout current access token',
          operationId: 'logout',
          consumes: [],
          produces: [],
          security: ["bearerAuth"],
          tags: ["Auth"],
          deprecated: false)}) {
    final Uri $url = Uri.parse('/api/auth/logout');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client
        .send<ApiAuthLogoutPost$Response, ApiAuthLogoutPost$Response>($request);
  }

  @override
  Future<Response<ApiAuthMeGet$Response>> _apiAuthMeGet(
      {SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
          description: '',
          summary: 'Get current authenticated user',
          operationId: 'getMe',
          consumes: [],
          produces: [],
          security: ["bearerAuth"],
          tags: ["Auth"],
          deprecated: false)}) {
    final Uri $url = Uri.parse('/api/auth/me');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<ApiAuthMeGet$Response, ApiAuthMeGet$Response>($request);
  }

  @override
  Future<Response<ApiAuthRefreshTokenPost$Response>> _apiAuthRefreshTokenPost({
    required RefreshTokenRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
        description: '',
        summary: 'Refresh access token',
        operationId: 'refreshToken',
        consumes: [],
        produces: [],
        security: [],
        tags: ["Auth"],
        deprecated: false),
  }) {
    final Uri $url = Uri.parse('/api/auth/refresh-token');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<ApiAuthRefreshTokenPost$Response,
        ApiAuthRefreshTokenPost$Response>($request);
  }

  @override
  Future<Response<ApiUsersGet$Response>> _apiUsersGet(
      {SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
          description: '',
          summary: 'List users',
          operationId: 'listUsers',
          consumes: [],
          produces: [],
          security: ["bearerAuth"],
          tags: ["Users"],
          deprecated: false)}) {
    final Uri $url = Uri.parse('/api/users');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<ApiUsersGet$Response, ApiUsersGet$Response>($request);
  }

  @override
  Future<Response<ApiUsersPost$Response>> _apiUsersPost({
    required CreateUserRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
        description: '',
        summary: 'Create user',
        operationId: 'createUser',
        consumes: [],
        produces: [],
        security: ["bearerAuth"],
        tags: ["Users"],
        deprecated: false),
  }) {
    final Uri $url = Uri.parse('/api/users');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<ApiUsersPost$Response, ApiUsersPost$Response>($request);
  }

  @override
  Future<Response<ApiUsersIdGet$Response>> _apiUsersIdGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
        description: '',
        summary: 'Get user by id',
        operationId: 'getUserById',
        consumes: [],
        produces: [],
        security: ["bearerAuth"],
        tags: ["Users"],
        deprecated: false),
  }) {
    final Uri $url = Uri.parse('/api/users/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client
        .send<ApiUsersIdGet$Response, ApiUsersIdGet$Response>($request);
  }

  @override
  Future<Response<ApiUsersIdPatch$Response>> _apiUsersIdPatch({
    required String? id,
    required UpdateUserRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
        description: '',
        summary: 'Update user',
        operationId: 'updateUser',
        consumes: [],
        produces: [],
        security: ["bearerAuth"],
        tags: ["Users"],
        deprecated: false),
  }) {
    final Uri $url = Uri.parse('/api/users/${id}');
    final $body = body;
    final Request $request = Request(
      'PATCH',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client
        .send<ApiUsersIdPatch$Response, ApiUsersIdPatch$Response>($request);
  }

  @override
  Future<Response<ApiUsersIdDelete$Response>> _apiUsersIdDelete({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
        description: '',
        summary: 'Delete user',
        operationId: 'deleteUser',
        consumes: [],
        produces: [],
        security: ["bearerAuth"],
        tags: ["Users"],
        deprecated: false),
  }) {
    final Uri $url = Uri.parse('/api/users/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client
        .send<ApiUsersIdDelete$Response, ApiUsersIdDelete$Response>($request);
  }

  @override
  Future<Response<ApiRolesGet$Response>> _apiRolesGet(
      {SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
          description: '',
          summary: 'List roles',
          operationId: 'listRoles',
          consumes: [],
          produces: [],
          security: ["bearerAuth"],
          tags: ["Roles"],
          deprecated: false)}) {
    final Uri $url = Uri.parse('/api/roles');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<ApiRolesGet$Response, ApiRolesGet$Response>($request);
  }

  @override
  Future<Response<ApiRolesPost$Response>> _apiRolesPost({
    required CreateRoleRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
        description: '',
        summary: 'Create role',
        operationId: 'createRole',
        consumes: [],
        produces: [],
        security: ["bearerAuth"],
        tags: ["Roles"],
        deprecated: false),
  }) {
    final Uri $url = Uri.parse('/api/roles');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<ApiRolesPost$Response, ApiRolesPost$Response>($request);
  }

  @override
  Future<Response<ApiPermissionsGet$Response>> _apiPermissionsGet(
      {SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
          description: '',
          summary: 'List permissions',
          operationId: 'listPermissions',
          consumes: [],
          produces: [],
          security: ["bearerAuth"],
          tags: ["Permissions"],
          deprecated: false)}) {
    final Uri $url = Uri.parse('/api/permissions');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client
        .send<ApiPermissionsGet$Response, ApiPermissionsGet$Response>($request);
  }

  @override
  Future<Response<ApiRolePermissionsPost$Response>> _apiRolePermissionsPost({
    required AssignRolePermissionsRequest? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
        description: '',
        summary: 'Assign permissions to role',
        operationId: 'assignRolePermissions',
        consumes: [],
        produces: [],
        security: ["bearerAuth"],
        tags: ["Permissions"],
        deprecated: false),
  }) {
    final Uri $url = Uri.parse('/api/role-permissions');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<ApiRolePermissionsPost$Response,
        ApiRolePermissionsPost$Response>($request);
  }
}
