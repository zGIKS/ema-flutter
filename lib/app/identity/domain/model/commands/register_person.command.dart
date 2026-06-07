class RegisterPersonCommand {
  final String dni;
  final String imagePath;

  RegisterPersonCommand({
    required this.dni,
    required this.imagePath,
  }) {
    if (dni.length != 8) {
      throw ArgumentError('DNI must be exactly 8 digits');
    }
    if (imagePath.isEmpty) {
      throw ArgumentError('Image path cannot be empty');
    }
  }
}
