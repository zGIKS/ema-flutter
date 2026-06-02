class PeruvianDniValueObject {
  final String value;

  PeruvianDniValueObject._(this.value);

  factory PeruvianDniValueObject(String raw) {
    final trimmed = raw.trim();
    if (trimmed.length != 8 || !RegExp(r'^\d+$').hasMatch(trimmed)) {
      throw ArgumentError('El DNI peruano debe tener exactamente 8 dígitos.');
    }
    return PeruvianDniValueObject._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PeruvianDniValueObject &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
