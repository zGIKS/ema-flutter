import 'dart:typed_data';

import 'package:ema/contexts/identification/interfaces/rest/resources/identification_response.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/register_response.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/registered_persons_page_response.resource.dart';

abstract class IdentificationGateway {
  Future<IdentificationResponseResource> identify({required Uint8List imageBytes});

  Future<RegisterResponseResource> register({
    required String firstName,
    required String lastName,
    required String dni,
    required List<Uint8List> images,
  });

  Future<RegisteredPersonsPageResponseResource> getRegisteredPersons({
    required int page,
    required int pageSize,
  });
}
