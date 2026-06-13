import '../model/commands/register_person.command.dart';
import '../../interfaces/rest/resources/register_person_response.resource.dart';

abstract class PersonCommandService {
  Future<RegisterPersonResponseResource> handleRegisterPersonFace(
    RegisterPersonFaceCommand command,
  );
}
