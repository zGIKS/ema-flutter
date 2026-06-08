import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../shared/interfaces/widgets/ema_app_header.widget.dart';
import '../../../../shared/interfaces/widgets/ema_bottom_navigation.widget.dart';
import '../../../../identity/interfaces/pages/home/home.screen.dart';
import '../../../../identity/interfaces/pages/registered_persons/registered_persons.screen.dart';
import '../../../application/internal/queryservices/person_identification_query_service_impl.dart';
import '../../../infrastructure/api/gateways/biometrics.gateway.dart';
import 'identify_person_cubit.dart';
import 'identify_person_state.dart';

class IdentifyPersonScreen extends StatefulWidget {
  const IdentifyPersonScreen({super.key});

  @override
  State<IdentifyPersonScreen> createState() => _IdentifyPersonScreenState();
}

class _IdentifyPersonScreenState extends State<IdentifyPersonScreen> {
  late final IdentifyPersonCubit _cubit;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final gateway = BiometricsHttpGateway(dio);
    final queryService = PersonIdentificationQueryServiceImpl(gateway);
    _cubit = IdentifyPersonCubit(queryService: queryService);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 90);
    if (pickedFile != null && mounted) {
      _cubit.imagePicked(pickedFile.path);
    }
  }

  Widget _buildResultCard(IdentifyPersonState state) {
    final result = state.result;
    if (result == null) {
      return const SizedBox.shrink();
    }

    final isVerified = result.isVerified;
    final confidenceLabel = '${(result.confidence * 100).toStringAsFixed(1)}%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isVerified ? Icons.verified : Icons.info_outline,
                color: const Color(0xFF0D47A1),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isVerified ? 'Verified User' : 'Unverified Match',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Text(
                confidenceLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEFF),
                  borderRadius: BorderRadius.circular(14),
                  image: result.imageUrl == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(result.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                ),
                child: result.imageUrl == null
                    ? const Icon(Icons.person, color: Color(0xFF0D47A1), size: 32)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${result.firstName ?? ''} ${result.lastName ?? ''}'.trim(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'DNI: ${result.dni ?? '-'}',
                      style: const TextStyle(color: Color(0xFF4B5563)),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FF),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Match: $confidenceLabel',
                        style: const TextStyle(
                          color: Color(0xFF0D47A1),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD1D5DB)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.badge_outlined, size: 18),
              label: const Text('View Profile'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        body: Column(
          children: [
            const EmaAppHeaderWidget(),
            Expanded(
              child: BlocConsumer<IdentifyPersonCubit, IdentifyPersonState>(
                listener: (context, state) {
                  if (state.status == IdentifyPersonStatus.failure && state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.errorMessage!)),
                    );
                  }
                },
                builder: (context, state) {
                  final imagePath = state.imagePath;
                  final isLoading = state.status == IdentifyPersonStatus.loading;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Identify Person',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Scan or upload a photo to identify a person in the system.',
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.35,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE5E7EB)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0F000000),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 170,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF4F5FB),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: const Color(0xFFD9E0F6),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: imagePath == null
                                    ? Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: const [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.camera_alt_rounded, color: Color(0xFF0D47A1), size: 30),
                                              SizedBox(width: 14),
                                              Icon(Icons.image_rounded, color: Color(0xFF0D47A1), size: 30),
                                            ],
                                          ),
                                          SizedBox(height: 18),
                                          Text(
                                            'Drag and drop or tap to select',
                                            style: TextStyle(
                                              color: Color(0xFF4B5563),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.file(
                                          File(imagePath),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 170,
                                        ),
                                      ),
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: isLoading ? null : () => _pickImage(ImageSource.camera),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      ),
                                      icon: const Icon(Icons.camera_alt_outlined, size: 18),
                                      label: const Text('Take Photo'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: isLoading ? null : () => _pickImage(ImageSource.gallery),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                      ),
                                      icon: const Icon(Icons.image_outlined, size: 18),
                                      label: const Text('Gallery'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: isLoading ? null : () => context.read<IdentifyPersonCubit>().identifyPerson(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0D47A1),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                                    elevation: 0,
                                  ),
                                  icon: isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.search_rounded, size: 20),
                                  label: Text(isLoading ? 'Identifying...' : 'Identify Person'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        _buildResultCard(state),
                      ],
                    ),
                  );
                },
              ),
            ),
            EmaBottomNavigationWidget(
              selectedIndex: 1,
              onTap: (index) {
                if (index == 0) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const IdentityHomeScreen()),
                  );
                  return;
                }

                if (index == 2) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const RegisteredPersonsScreen()),
                  );
                  return;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
