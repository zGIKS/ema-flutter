import '../../../domain/model/commands/sign_in.command.dart';
import '../../../domain/model/valueobjects/username.valueobject.dart';
import '../../../domain/model/valueobjects/password.valueobject.dart';
import '../resources/sign_in_form.resource.dart';

SignInCommand toSignInCommand(SignInFormResource resource) {
  return SignInCommand(
    username: Username(resource.username),
    password: Password(resource.password),
  );
}
