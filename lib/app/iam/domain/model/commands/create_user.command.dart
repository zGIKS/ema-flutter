import '../valueobjects/new_user_password.valueobject.dart';
import '../valueobjects/username.valueobject.dart';

class CreateUserCommand {
  final Username username;
  final NewUserPassword password;

  const CreateUserCommand({
    required this.username,
    required this.password,
  });
}
