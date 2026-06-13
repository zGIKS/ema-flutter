import '../../../domain/model/commands/create_user.command.dart';
import '../../../domain/model/commands/update_user_role.command.dart';
import '../../../domain/services/users.command-service.dart';
import '../../../infrastructure/api/gateways/users.gateway.dart';
import '../../../interfaces/rest/resources/authenticated_user.resource.dart';

class UsersCommandServiceImpl implements UsersCommandService {
  final UsersGateway gateway;

  UsersCommandServiceImpl(this.gateway);

  @override
  Future<AuthenticatedUserResource> handleCreateUser(CreateUserCommand command) {
    return gateway.createUser(command);
  }

  @override
  Future<AuthenticatedUserResource> handleUpdateUserRole(UpdateUserRoleCommand command) {
    return gateway.updateUserRole(command);
  }
}
