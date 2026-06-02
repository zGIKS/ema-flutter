import 'dart:typed_data';

import 'package:ema/contexts/identification/domain/model/commands/register_person.command.dart';
import 'package:ema/contexts/identification/domain/services/identification.command-service.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/api_error.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/register_response.resource.dart';
import 'package:ema/contexts/identification/interfaces/widgets/picked_image_preview.widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterScreen extends StatefulWidget {
  final IdentificationCommandService commandService;

  const RegisterScreen({super.key, required this.commandService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dniController = TextEditingController();

  bool _loading = false;
  final List<XFile> _picked = [];
  RegisterResponseResource? _result;
  String? _error;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dniController.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    final img = await _picker.pickImage(source: ImageSource.camera, imageQuality: 90);
    if (!mounted) return;
    setState(() {
      if (img != null) _picked.add(img);
      _result = null;
      _error = null;
    });
  }

  Future<void> _pickImagesFromGallery() async {
    final imgs = await _picker.pickMultiImage(imageQuality: 90);
    if (!mounted) return;
    setState(() {
      _picked.addAll(imgs);
      _result = null;
      _error = null;
    });
  }

  void _removeImageAt(int index) {
    setState(() {
      _picked.removeAt(index);
      _result = null;
    });
  }

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_picked.isEmpty) {
      setState(() => _error = 'Selecciona al menos una imagen');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _result = null;
    });

    try {
      final List<Uint8List> bytes = [];
      for (final f in _picked) {
        bytes.add(await f.readAsBytes());
      }

      final command = RegisterPersonCommand(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        dni: _dniController.text,
        images: bytes,
      );

      final res = await widget.commandService.register(command);
      if (mounted) {
        setState(() {
          _result = res;
          // Clear inputs on success
          _firstNameController.clear();
          _lastNameController.clear();
          _dniController.clear();
          _picked.clear();
        });
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
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'Nombres',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'El nombre es obligatorio';
                }
                final normalized = val.trim().split(RegExp(r'\s+')).join(' ');
                if (normalized.length > 80) {
                  return 'No puede exceder los 80 caracteres';
                }
                final regex = RegExp(r'^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+(?: [A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)*$');
                if (!regex.hasMatch(normalized)) {
                  return 'Solo se permiten letras, tildes y eñes';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Apellidos',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'El apellido es obligatorio';
                }
                final normalized = val.trim().split(RegExp(r'\s+')).join(' ');
                if (normalized.length > 80) {
                  return 'No puede exceder los 80 caracteres';
                }
                final regex = RegExp(r'^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+(?: [A-Za-zÁÉÍÓÚÜÑáéíóúüñ]+)*$');
                if (!regex.hasMatch(normalized)) {
                  return 'Solo se permiten letras, tildes y eñes';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _dniController,
              decoration: const InputDecoration(
                labelText: 'DNI',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'El DNI es obligatorio';
                }
                final trimmed = val.trim();
                if (trimmed.length != 8 || !RegExp(r'^\d+$').hasMatch(trimmed)) {
                  return 'El DNI debe tener exactamente 8 dígitos numéricos';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Fotos de Rostro (Mínimo 1):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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
                    onPressed: _loading ? null : _pickImagesFromGallery,
                    icon: const Icon(Icons.collections),
                    label: const Text('Galería'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_picked.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Ninguna foto seleccionada aún.'),
              )
            else
              Column(
                children: [
                  for (var i = 0; i < _picked.length; i++) ...[
                    Stack(
                      children: [
                        PickedImagePreviewWidget(file: _picked[i]),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: IconButton.filledTonal(
                            onPressed: _loading ? null : () => _removeImageAt(i),
                            icon: const Icon(Icons.close),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ]
                ],
              ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _loading ? null : _register,
              icon: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.person_add),
              label: Text(_loading ? 'Registrando...' : 'Registrar Persona'),
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
            if (_result != null) _RegisterResultCard(result: _result!),
          ],
        ),
      ),
    );
  }
}

class _RegisterResultCard extends StatelessWidget {
  final RegisterResponseResource result;

  const _RegisterResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '¡Registro Exitoso!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.green[700],
              ),
            ),
            const Divider(height: 20),
            Text(
              'Nombre: ${result.firstName} ${result.lastName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text('DNI: ${result.dni}'),
            const SizedBox(height: 4),
            Text('Estado de Enrolamiento: ${result.enrolled ? "Enrolado" : "Pendiente"}'),
          ],
        ),
      ),
    );
  }
}
