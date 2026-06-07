import '../model/commands/register_person.command.dart';

abstract class PersonCommandService {
  Future<void> handleRegisterPerson(RegisterPersonCommand command);
}
