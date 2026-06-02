import 'package:ema/contexts/identification/domain/model/commands/register_person.command.dart';
import 'package:ema/contexts/identification/domain/services/identification.command-service.dart';
import 'package:ema/contexts/identification/infrastructure/api/gateways/identification.gateway.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/register_response.resource.dart';

class IdentificationCommandServiceImpl implements IdentificationCommandService {
  final IdentificationGateway _gateway;

  IdentificationCommandServiceImpl(this._gateway);

  @override
  Future<RegisterResponseResource> register(RegisterPersonCommand command) {
    return _gateway.register(
      firstName: command.firstName.value,
      lastName: command.lastName.value,
      dni: command.dni.value,
      images: command.images,
    );
  }
}
