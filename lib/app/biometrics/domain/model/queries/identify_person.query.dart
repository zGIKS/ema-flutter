import '../valueobjects/face_image_path.dart';

class IdentifyPersonQuery {
  final FaceImagePath imagePath;

  const IdentifyPersonQuery._({
    required this.imagePath,
  });

  factory IdentifyPersonQuery({required FaceImagePath imagePath}) {
    return IdentifyPersonQuery._(imagePath: imagePath);
  }
}
