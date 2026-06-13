import '../model/queries/get_person_profile.query.dart';
import '../../interfaces/rest/resources/registered_person_detail.resource.dart';

abstract class PersonProfileQueryService {
  Future<RegisteredPersonDetailResource> handleGetPersonProfile(
    GetPersonProfileQuery query,
  );
}
