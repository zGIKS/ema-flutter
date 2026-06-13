class NewUserPassword {
  final String value;

  const NewUserPassword._(this.value);

  factory NewUserPassword(String value) {
    final normalized = value;
    if (normalized.length < 12) {
      throw ArgumentError('Password must be at least 12 characters long');
    }
    if (!RegExp(r'[a-z]').hasMatch(normalized)) {
      throw ArgumentError('Password must include a lowercase letter');
    }
    if (!RegExp(r'[A-Z]').hasMatch(normalized)) {
      throw ArgumentError('Password must include an uppercase letter');
    }
    if (!RegExp(r'\d').hasMatch(normalized)) {
      throw ArgumentError('Password must include a digit');
    }
    if (!RegExp(r'[^A-Za-z0-9]').hasMatch(normalized)) {
      throw ArgumentError('Password must include a symbol');
    }
    return NewUserPassword._(normalized);
  }
}
