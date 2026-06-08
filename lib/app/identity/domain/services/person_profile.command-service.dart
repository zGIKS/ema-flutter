import '../model/commands/add_person_face_sample.command.dart';
import '../../interfaces/rest/resources/add_face_samples_response.resource.dart';

abstract class PersonProfileCommandService {
  Future<AddFaceSamplesResponseResource> handleAddPersonFaceSample(
    AddPersonFaceSampleCommand command,
  );
}
