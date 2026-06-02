import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickedImagePreviewWidget extends StatelessWidget {
  final XFile? file;

  const PickedImagePreviewWidget({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return const SizedBox.shrink();
    }
    return FutureBuilder(
      future: file!.readAsBytes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData) {
          return SizedBox(height: 220, child: Center(child: Text('No se pudo cargar: ${file!.name}')));
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: Image.memory(snapshot.data!, fit: BoxFit.cover),
          ),
        );
      },
    );
  }
}
