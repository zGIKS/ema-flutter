import '../../../domain/model/commands/register_person.command.dart';
import '../../../domain/model/queries/get_registered_persons.query.dart';
import '../../../domain/model/valueobjects/peruvian_dni.dart';
import '../resources/register_person_form.resource.dart';

RegisterPersonFaceCommand toRegisterPersonFaceCommand(
  RegisterPersonFormResource resource,
) {
  return RegisterPersonFaceCommand(
    dni: PeruvianDni(resource.dni),
    imagePath: resource.imagePath,
  );
}

GetRegisteredPersonsQuery toGetRegisteredPersonsQuery({
  int page = 1,
  int pageSize = 20,
}) {
  return GetRegisteredPersonsQuery(
    page: page,
    pageSize: pageSize,
  );
}
