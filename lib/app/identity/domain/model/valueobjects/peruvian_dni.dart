class PeruvianDni {
  final String value;

  const PeruvianDni._(this.value);

  factory PeruvianDni(String value) {
    final normalized = value.trim();
    if (normalized.length != 8 || int.tryParse(normalized) == null) {
      throw ArgumentError('DNI must contain exactly 8 digits');
    }

    return PeruvianDni._(normalized);
  }
}
