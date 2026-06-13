import '../model/queries/get_registered_persons.query.dart';
import '../../interfaces/rest/resources/registered_persons_page.resource.dart';

abstract class PersonQueryService {
  Future<RegisteredPersonsPageResource> handleGetRegisteredPersons(
    GetRegisteredPersonsQuery query,
  );
}
