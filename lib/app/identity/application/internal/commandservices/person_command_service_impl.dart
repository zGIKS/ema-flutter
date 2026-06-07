import '../../../domain/model/commands/register_person.command.dart';
import '../../../domain/services/person.command-service.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';

class PersonCommandServiceImpl implements PersonCommandService {
  final PersonGateway gateway;

  PersonCommandServiceImpl(this.gateway);

  @override
  Future<void> handleRegisterPerson(RegisterPersonCommand command) async {
    await gateway.registerPerson(command);
  }
}
