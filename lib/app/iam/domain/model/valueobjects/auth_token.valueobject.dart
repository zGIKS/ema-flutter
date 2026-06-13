class AuthToken {
  final String value;

  const AuthToken._(this.value);

  factory AuthToken(String value) {
    if (value.trim().isEmpty) {
      throw ArgumentError('Token cannot be empty');
    }
    return AuthToken._(value);
  }
}
