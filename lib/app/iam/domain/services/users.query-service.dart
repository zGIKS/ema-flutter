import '../model/queries/get_users.query.dart';
import '../../interfaces/rest/resources/authenticated_user.resource.dart';

abstract class UsersQueryService {
  Future<List<AuthenticatedUserResource>> handleGetUsers(GetUsersQuery query);
}
