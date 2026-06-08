import '../../../domain/model/queries/identify_person.query.dart';
import '../../../domain/services/person_identification.query-service.dart';
import '../../../infrastructure/api/gateways/biometrics.gateway.dart';
import '../../../interfaces/rest/resources/identification_response.resource.dart';

class PersonIdentificationQueryServiceImpl implements PersonIdentificationQueryService {
  final BiometricsGateway gateway;

  PersonIdentificationQueryServiceImpl(this.gateway);

  @override
  Future<IdentificationResponseResource> handleIdentifyPerson(IdentifyPersonQuery query) {
    return gateway.identifyPerson(query);
  }
}
