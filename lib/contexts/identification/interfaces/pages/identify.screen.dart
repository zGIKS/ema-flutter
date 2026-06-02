import 'dart:convert';
import 'dart:typed_data';

import 'package:ema/contexts/identification/domain/model/queries/identify_person.query.dart';
import 'package:ema/contexts/identification/domain/services/identification.query-service.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/api_error.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/identification_response.resource.dart';
import 'package:ema/contexts/identification/interfaces/widgets/picked_image_preview.widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class IdentifyScreen extends StatefulWidget {
  final IdentificationQueryService queryService;

  const IdentifyScreen({super.key, required this.queryService});

  @override
  State<IdentifyScreen> createState() => _IdentifyScreenState();
}

class _IdentifyScreenState extends State<IdentifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  bool _loading = false;
  XFile? _picked;
  IdentificationResponseResource? _result;
  String? _error;

  Future<void> _takePhoto() async {
    final img = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (!mounted) return;
    setState(() {
      _picked = img;
      _result = null;
      _error = null;
    });
  }

  Future<void> _pickFromGallery() async {
    final img = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 90);
    if (!mounted) return;
    setState(() {
      _picked = img;
      _result = null;
      _error = null;
    });
  }

  Future<void> _identify() async {
    if (_picked == null) {
      setState(() => _error = 'Selecciona una imagen primero');
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final Uint8List bytes = await _picked!.readAsBytes();
      final query = IdentifyPersonQuery(image: bytes);
      final res = await widget.queryService.identify(query);
      if (mounted) {
        setState(() => _result = res);
      }
    } on ApiErrorResource catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _loading ? null : _takePhoto,
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Cámara'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _loading ? null : _pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PickedImagePreviewWidget(file: _picked),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _loading ? null : _identify,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.search),
              label: Text(_loading ? 'Procesando...' : 'Identificar'),
            ),
            const SizedBox(height: 16),
            if (_error != null)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_error!),
                ),
              ),
            if (_result != null) _IdentifyResultCard(result: _result!),
            if (_result == null && _error == null && !_loading)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text('Estado: vacío (elige una imagen y presiona Identificar)'),
              ),
          ],
        ),
      ),
    );
  }
}

class _IdentifyResultCard extends StatelessWidget {
  final IdentificationResponseResource result;

  const _IdentifyResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final hasMatch = result.firstName != null;
    final photoBytes = result.photo != null ? base64Decode(result.photo!) : null;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasMatch ? 'Persona Identificada' : 'Persona No Identificada',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: hasMatch ? Colors.green[700] : Colors.red[700],
              ),
            ),
            const Divider(height: 24),
            if (photoBytes != null) ...[
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                    image: DecorationImage(
                      image: MemoryImage(photoBytes),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            if (hasMatch) ...[
              Text(
                'Nombre: ${result.firstName} ${result.lastName}',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'DNI: ${result.dni}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              'Credibilidad de Identificación: ${(result.confidence * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
