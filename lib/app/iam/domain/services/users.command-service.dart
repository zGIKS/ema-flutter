import '../model/commands/create_user.command.dart';
import '../model/commands/update_user_role.command.dart';
import '../../interfaces/rest/resources/authenticated_user.resource.dart';

abstract class UsersCommandService {
  Future<AuthenticatedUserResource> handleCreateUser(CreateUserCommand command);

  Future<AuthenticatedUserResource> handleUpdateUserRole(UpdateUserRoleCommand command);
}
