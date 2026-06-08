import '../../../domain/model/commands/add_person_face_sample.command.dart';
import '../../../domain/services/person_profile.command-service.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';
import '../../../interfaces/rest/resources/add_face_samples_response.resource.dart';

class PersonProfileCommandServiceImpl implements PersonProfileCommandService {
  final PersonGateway gateway;

  PersonProfileCommandServiceImpl(this.gateway);

  @override
  Future<AddFaceSamplesResponseResource> handleAddPersonFaceSample(
    AddPersonFaceSampleCommand command,
  ) {
    return gateway.addPersonFaceSample(command);
  }
}
