import 'package:dio/dio.dart';

import '../../../../core/network/app_dio.dart';
import '../../../domain/model/commands/create_user.command.dart';
import '../../../domain/model/commands/update_user_role.command.dart';
import '../../../domain/model/queries/get_users.query.dart';
import '../../../interfaces/rest/resources/authenticated_user.resource.dart';

abstract class UsersGateway {
  Future<List<AuthenticatedUserResource>> getUsers(GetUsersQuery query);

  Future<AuthenticatedUserResource> createUser(CreateUserCommand command);

  Future<AuthenticatedUserResource> updateUserRole(UpdateUserRoleCommand command);
}

class UsersHttpGateway implements UsersGateway {
  final Dio dio;

  UsersHttpGateway(this.dio);

  @override
  Future<List<AuthenticatedUserResource>> getUsers(GetUsersQuery query) async {
    try {
      final response = await dio.get('/api/v1/iam/users');
      final data = (response.data as List<dynamic>? ?? const []);
      return data
          .map((item) => AuthenticatedUserResource.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(growable: false);
    } on DioException catch (e) {
      throw Exception(readFriendlyErrorMessage(e, fallbackMessage: 'Failed to load users'));
    }
  }

  @override
  Future<AuthenticatedUserResource> createUser(CreateUserCommand command) async {
    try {
      final response = await dio.post(
        '/api/v1/iam/users',
        data: {
          'username': command.username.value,
          'password': command.password.value,
        },
      );

      return AuthenticatedUserResource.fromJson(Map<String, dynamic>.from(response.data as Map));
    } on DioException catch (e) {
      throw Exception(readFriendlyErrorMessage(e, fallbackMessage: 'Failed to create user'));
    }
  }

  @override
  Future<AuthenticatedUserResource> updateUserRole(UpdateUserRoleCommand command) async {
    try {
      final response = await dio.patch(
        '/api/v1/iam/users/${command.userId.value}/role',
        data: {
          'role': command.role.value,
        },
      );

      return AuthenticatedUserResource.fromJson(Map<String, dynamic>.from(response.data as Map));
    } on DioException catch (e) {
      throw Exception(readFriendlyErrorMessage(e, fallbackMessage: 'Failed to update user role'));
    }
  }
}
