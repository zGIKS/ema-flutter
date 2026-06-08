import '../../../domain/model/queries/get_person_profile.query.dart';
import '../../../domain/services/person_profile.query-service.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';
import '../../../interfaces/rest/resources/registered_person_detail.resource.dart';

class PersonProfileQueryServiceImpl implements PersonProfileQueryService {
  final PersonGateway gateway;

  PersonProfileQueryServiceImpl(this.gateway);

  @override
  Future<RegisteredPersonDetailResource> handleGetPersonProfile(
    GetPersonProfileQuery query,
  ) {
    return gateway.getPersonProfile(query);
  }
}
