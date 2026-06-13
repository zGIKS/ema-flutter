import '../model/commands/sign_in.command.dart';
import '../../interfaces/rest/resources/authenticated_user.resource.dart';

abstract class IamCommandService {
  Future<AuthenticatedUserResource> handleSignIn(
    SignInCommand command,
  );
}
