import 'package:dio/dio.dart';
import '../../../../core/network/app_dio.dart';
import '../../../domain/model/commands/sign_in.command.dart';
import '../../../interfaces/rest/resources/authenticated_user.resource.dart';

abstract class IamGateway {
  Future<AuthenticatedUserResource> signIn(
    SignInCommand command,
  );
}

class IamHttpGateway implements IamGateway {
  final Dio dio;

  IamHttpGateway(this.dio);

  @override
  Future<AuthenticatedUserResource> signIn(
    SignInCommand command,
  ) async {
    try {
      final response = await dio.post(
        '/api/v1/iam/login',
        data: {
          'username': command.username.value,
          'password': command.password.value,
        },
      );

      return AuthenticatedUserResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(
        readFriendlyErrorMessage(e, fallbackMessage: 'Failed to sign in'),
      );
    }
  }
}
