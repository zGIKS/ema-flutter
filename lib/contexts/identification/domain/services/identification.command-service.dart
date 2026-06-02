import 'package:ema/contexts/identification/domain/model/commands/register_person.command.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/register_response.resource.dart';

abstract class IdentificationCommandService {
  Future<RegisterResponseResource> register(RegisterPersonCommand command);
}

