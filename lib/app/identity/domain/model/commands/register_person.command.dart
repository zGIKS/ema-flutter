import '../valueobjects/peruvian_dni.dart';

class RegisterPersonFaceCommand {
  final PeruvianDni dni;
  final String imagePath;

  const RegisterPersonFaceCommand._({
    required this.dni,
    required this.imagePath,
  });

  factory RegisterPersonFaceCommand({
    required PeruvianDni dni,
    required String imagePath,
  }) {
    final normalizedImagePath = imagePath.trim();
    if (normalizedImagePath.isEmpty) {
      throw ArgumentError('imagePath cannot be empty');
    }

    return RegisterPersonFaceCommand._(
      dni: dni,
      imagePath: normalizedImagePath,
    );
  }
}
