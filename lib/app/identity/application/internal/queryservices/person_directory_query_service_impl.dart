import '../../../domain/model/queries/get_registered_persons.query.dart';
import '../../../domain/services/person.query-service.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';
import '../../../interfaces/rest/resources/registered_persons_page.resource.dart';

class PersonDirectoryQueryServiceImpl implements PersonQueryService {
  final PersonGateway gateway;

  PersonDirectoryQueryServiceImpl(this.gateway);

  @override
  Future<RegisteredPersonsPageResource> handleGetRegisteredPersons(
    GetRegisteredPersonsQuery query,
  ) {
    return gateway.getRegisteredPersons(query);
  }
}
