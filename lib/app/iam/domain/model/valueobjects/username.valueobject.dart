class Username {
  final String value;

  const Username._(this.value);

  factory Username(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    return Username._(normalized);
  }
}
