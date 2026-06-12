import '../../../domain/model/commands/create_user.command.dart';
import '../../../domain/model/commands/update_user_role.command.dart';
import '../../../domain/model/queries/get_users.query.dart';
import '../../../domain/model/valueobjects/new_user_password.valueobject.dart';
import '../../../domain/model/valueobjects/user_id.valueobject.dart';
import '../../../domain/model/valueobjects/user_role.valueobject.dart';
import '../../../domain/model/valueobjects/username.valueobject.dart';
import '../resources/create_user_form.resource.dart';
import '../resources/update_user_role_form.resource.dart';

CreateUserCommand toCreateUserCommand(CreateUserFormResource resource) {
  return CreateUserCommand(
    username: Username(resource.username),
    password: NewUserPassword(resource.password),
  );
}

UpdateUserRoleCommand toUpdateUserRoleCommand({
  required String userId,
  required UpdateUserRoleFormResource resource,
}) {
  return UpdateUserRoleCommand(
    userId: UserId(userId),
    role: UserRole.fromValue(resource.role),
  );
}

GetUsersQuery toGetUsersQuery() {
  return const GetUsersQuery();
}
