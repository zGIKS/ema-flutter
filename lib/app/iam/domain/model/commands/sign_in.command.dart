import '../valueobjects/username.valueobject.dart';
import '../valueobjects/password.valueobject.dart';

class SignInCommand {
  final Username username;
  final Password password;

  const SignInCommand({
    required this.username,
    required this.password,
  });
}
