class PersonNameValueObject {
  final String value;

  PersonNameValueObject._(this.value);

  factory PersonNameValueObject(String raw) {
    // Normalize spaces: join single spaces
    final normalized = raw.trim().split(RegExp(r'\s+')).join(' ');
    if (normalized.isEmpty) {
      throw ArgumentError('El nombre/apellido no puede estar vacío.');
    }
    if (normalized.length > 80) {
      throw ArgumentError('El nombre/apellido no puede exceder los 80 caracteres.');
    }

    final spanishNameRegex = RegExp(r'^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+(?: [A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)*$');
    if (!spanishNameRegex.hasMatch(normalized)) {
      throw ArgumentError(
          'El nombre/apellido solo puede contener letras españolas, espacios, eñes y tildes.');
    }

    return PersonNameValueObject._(normalized);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonNameValueObject &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
