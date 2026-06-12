class Password {
  final String value;

  const Password._(this.value);

  factory Password(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Password cannot be empty');
    }
    return Password._(value);
  }
}
