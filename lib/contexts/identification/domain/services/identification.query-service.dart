import 'package:ema/contexts/identification/domain/model/queries/identify_person.query.dart';
import 'package:ema/contexts/identification/domain/model/queries/get_registered_persons.query.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/identification_response.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/registered_persons_page_response.resource.dart';

abstract class IdentificationQueryService {
  Future<IdentificationResponseResource> identify(IdentifyPersonQuery query);
  Future<RegisteredPersonsPageResponseResource> getRegisteredPersons(GetRegisteredPersonsQuery query);
}
