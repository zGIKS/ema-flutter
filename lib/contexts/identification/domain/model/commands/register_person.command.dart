import 'dart:typed_data';
import 'package:ema/contexts/identification/domain/model/valueobjects/person_name.valueobject.dart';
import 'package:ema/contexts/identification/domain/model/valueobjects/peruvian_dni.valueobject.dart';

class RegisterPersonCommand {
  final PersonNameValueObject firstName;
  final PersonNameValueObject lastName;
  final PeruvianDniValueObject dni;
  final List<Uint8List> images;

  RegisterPersonCommand._({
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.images,
  });

  factory RegisterPersonCommand({
    required String firstName,
    required String lastName,
    required String dni,
    required List<Uint8List> images,
  }) {
    if (images.isEmpty) {
      throw ArgumentError('Se requiere al menos una imagen.');
    }
    return RegisterPersonCommand._(
      firstName: PersonNameValueObject(firstName),
      lastName: PersonNameValueObject(lastName),
      dni: PeruvianDniValueObject(dni),
      images: List.unmodifiable(images),
    );
  }
}
