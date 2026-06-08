import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../../core/routing/app_router.dart';
import '../../../application/internal/queryservices/person_identification_query_service_impl.dart';
import '../../../infrastructure/api/gateways/biometrics.gateway.dart';
import '../../widgets/identify_person_photo_section.widget.dart';
import '../../widgets/identify_person_result_card.widget.dart';
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
    final dio = AppDependencies.createDio();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Column(
        children: [
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
                      IdentifyPersonPhotoSectionWidget(
                        imagePath: imagePath,
                        isLoading: isLoading,
                        onTakePhoto: () => _pickImage(ImageSource.camera),
                        onGallery: () => _pickImage(ImageSource.gallery),
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
                      const SizedBox(height: 18),
                      if (state.result != null)
                        IdentifyPersonResultCardWidget(
                          result: state.result!,
                          onViewProfile: () {
                            final uuid = state.result!.uuid;
                            if (uuid != null && uuid.isNotEmpty) {
                              AppRouter.openPersonProfile(context, personId: uuid);
                            }
                          },
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
