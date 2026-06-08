import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/interfaces/widgets/face_upload_card.widget.dart';
import '../pages/register_person/register_person_cubit.dart';
import '../pages/register_person/register_person_state.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _dniController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null && mounted) {
      context.read<RegisterPersonCubit>().imagePicked(pickedFile.path);
    }
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      context.read<RegisterPersonCubit>().submitForm(_dniController.text);
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterPersonCubit, RegisterPersonState>(
      listener: (context, state) {
        if (state.status == RegisterPersonStatus.success) {
          final response = state.lastResponse;
          final message = response == null
              ? 'Person registered successfully'
              : '${response.firstName} ${response.lastName} registered successfully';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
          _dniController.clear();
          context.read<RegisterPersonCubit>().clearForm();
        } else if (state.status == RegisterPersonStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage ?? 'Error occurred')),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == RegisterPersonStatus.loading;
        final imagePath = state.imagePath;

        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'IDENTITY PHOTO',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B5563),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              FaceUploadCardWidget(
                imagePath: imagePath,
                onTakePhoto: () => _pickImage(ImageSource.camera),
                onGallery: () => _pickImage(ImageSource.gallery),
                onClear: () => context.read<RegisterPersonCubit>().clearImage(),
              ),
              const SizedBox(height: 32),
              const Text(
                'DNI',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 8,
                decoration: InputDecoration(
                  hintText: '8-digit document number',
                  hintStyle: const TextStyle(color: Color(0xFFA0AABF)),
                  helperText: 'Must be exactly 8 digits',
                  helperStyle: const TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
                  prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF4B5563)),
                  filled: true,
                  fillColor: Colors.white,
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6B7280)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF6B7280)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length != 8) {
                    return 'DNI must be exactly 8 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: isLoading ? null : _onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D47A1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  icon: isLoading 
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                      : const Icon(Icons.save_outlined),
                  label: Text(
                    isLoading ? 'Registering...' : 'Register Person',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
