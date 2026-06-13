import 'package:flutter/material.dart';

import '../../../shared/interfaces/widgets/face_upload_card.widget.dart';

class IdentifyPersonPhotoSectionWidget extends StatelessWidget {
  final String? imagePath;
  final bool isLoading;
  final VoidCallback onTakePhoto;
  final VoidCallback onGallery;
  final VoidCallback onClear;

  const IdentifyPersonPhotoSectionWidget({
    super.key,
    required this.imagePath,
    required this.isLoading,
    required this.onTakePhoto,
    required this.onGallery,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return FaceUploadCardWidget(
      imagePath: imagePath,
      onTakePhoto: onTakePhoto,
      onGallery: onGallery,
      onClear: onClear,
    );
  }
}
