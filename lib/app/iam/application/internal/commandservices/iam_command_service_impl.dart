import '../../../domain/model/commands/sign_in.command.dart';
import '../../../domain/services/iam.command-service.dart';
import '../../../infrastructure/api/gateways/iam.gateway.dart';
import '../../../interfaces/rest/resources/authenticated_user.resource.dart';

class IamCommandServiceImpl implements IamCommandService {
  final IamGateway gateway;

  IamCommandServiceImpl(this.gateway);

  @override
  Future<AuthenticatedUserResource> handleSignIn(
    SignInCommand command,
  ) async {
    return gateway.signIn(command);
  }
}
