import 'dart:typed_data';

class IdentifyPersonQuery {
  final Uint8List image;

  IdentifyPersonQuery._(this.image);

  factory IdentifyPersonQuery({required Uint8List image}) {
    if (image.isEmpty) {
      throw ArgumentError('Image is required');
    }
    return IdentifyPersonQuery._(image);
  }
}

