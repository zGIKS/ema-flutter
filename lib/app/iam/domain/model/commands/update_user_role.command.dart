import '../valueobjects/user_id.valueobject.dart';
import '../valueobjects/user_role.valueobject.dart';

class UpdateUserRoleCommand {
  final UserId userId;
  final UserRole role;

  const UpdateUserRoleCommand({
    required this.userId,
    required this.role,
  });
}
