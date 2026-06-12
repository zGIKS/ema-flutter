import '../../../domain/model/queries/get_users.query.dart';
import '../../../domain/services/users.query-service.dart';
import '../../../infrastructure/api/gateways/users.gateway.dart';
import '../../../interfaces/rest/resources/authenticated_user.resource.dart';

class UsersQueryServiceImpl implements UsersQueryService {
  final UsersGateway gateway;

  UsersQueryServiceImpl(this.gateway);

  @override
  Future<List<AuthenticatedUserResource>> handleGetUsers(GetUsersQuery query) {
    return gateway.getUsers(query);
  }
}
