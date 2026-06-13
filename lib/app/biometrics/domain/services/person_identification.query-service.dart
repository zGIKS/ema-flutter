import '../model/queries/identify_person.query.dart';
import '../../interfaces/rest/resources/identification_response.resource.dart';

abstract class PersonIdentificationQueryService {
  Future<IdentificationResponseResource> handleIdentifyPerson(
    IdentifyPersonQuery query,
  );
}
