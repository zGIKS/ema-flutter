class UserId {
  final String value;

  const UserId._(this.value);

  factory UserId(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('UserId cannot be empty');
    }

    if (!RegExp(
      r'^[0-9a-fA-F]{8}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{4}-'
      r'[0-9a-fA-F]{12}$',
    ).hasMatch(normalized)) {
      throw ArgumentError('UserId must be a valid UUID');
    }

    return UserId._(normalized);
  }
}
