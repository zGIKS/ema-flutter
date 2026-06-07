import '../../../domain/model/commands/register_person.command.dart';
import '../../../domain/services/person.command-service.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';
import '../../../interfaces/rest/resources/register_person_response.resource.dart';

class PersonCommandServiceImpl implements PersonCommandService {
  final PersonGateway gateway;

  PersonCommandServiceImpl(this.gateway);

  @override
  Future<RegisterPersonResponseResource> handleRegisterPersonFace(
    RegisterPersonFaceCommand command,
  ) async {
    return gateway.registerPersonFace(command);
  }
}
