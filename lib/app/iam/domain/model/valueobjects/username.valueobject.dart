class Username {
  final String value;

  const Username._(this.value);

  factory Username(String value) {
    final normalized = value.trim().toLowerCase();
    if (normalized.isEmpty) {
      throw ArgumentError('Username cannot be empty');
    }
    if (!RegExp(r'^[a-z]{3,30}$').hasMatch(normalized)) {
      throw ArgumentError('Username must contain only letters and be 3 to 30 characters long');
    }
    return Username._(normalized);
  }
}
