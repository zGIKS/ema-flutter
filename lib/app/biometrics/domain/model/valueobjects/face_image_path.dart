class FaceImagePath {
  final String value;

  const FaceImagePath._(this.value);

  factory FaceImagePath(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError('imagePath cannot be empty');
    }

    return FaceImagePath._(normalized);
  }
}
