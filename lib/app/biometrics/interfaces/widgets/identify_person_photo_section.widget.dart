import 'package:flutter/material.dart';

import '../../../shared/interfaces/widgets/ema_face_upload_card.widget.dart';

class IdentifyPersonPhotoSectionWidget extends StatelessWidget {
  final String? imagePath;
  final bool isLoading;
  final VoidCallback onTakePhoto;
  final VoidCallback onGallery;

  const IdentifyPersonPhotoSectionWidget({
    super.key,
    required this.imagePath,
    required this.isLoading,
    required this.onTakePhoto,
    required this.onGallery,
  });

  @override
  Widget build(BuildContext context) {
    return EmaFaceUploadCardWidget(
      imagePath: imagePath,
      onTakePhoto: onTakePhoto,
      onGallery: onGallery,
    );
  }
}
