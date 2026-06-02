import 'package:ema/contexts/identification/domain/model/queries/identify_person.query.dart';
import 'package:ema/contexts/identification/domain/model/queries/get_registered_persons.query.dart';
import 'package:ema/contexts/identification/domain/services/identification.query-service.dart';
import 'package:ema/contexts/identification/infrastructure/api/gateways/identification.gateway.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/identification_response.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/registered_persons_page_response.resource.dart';

class IdentificationQueryServiceImpl implements IdentificationQueryService {
  final IdentificationGateway _gateway;

  IdentificationQueryServiceImpl(this._gateway);

  @override
  Future<IdentificationResponseResource> identify(IdentifyPersonQuery query) {
    return _gateway.identify(imageBytes: query.image);
  }

  @override
  Future<RegisteredPersonsPageResponseResource> getRegisteredPersons(GetRegisteredPersonsQuery query) {
    return _gateway.getRegisteredPersons(
      page: query.page,
      pageSize: query.pageSize,
    );
  }
}
