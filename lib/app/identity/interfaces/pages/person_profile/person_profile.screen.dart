import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../application/internal/commandservices/person_profile_command_service_impl.dart';
import '../../../application/internal/queryservices/person_profile_query_service_impl.dart';
import '../../../infrastructure/api/gateways/person.gateway.dart';
import '../../../../shared/interfaces/widgets/material_loading.widget.dart';
import 'person_profile_cubit.dart';
import 'person_profile_state.dart';

class PersonProfileScreen extends StatefulWidget {
  final String personId;

  const PersonProfileScreen({super.key, required this.personId});

  @override
  State<PersonProfileScreen> createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends State<PersonProfileScreen> {
  late final PersonProfileCubit _cubit;

  @override
  void initState() {
    super.initState();
    final dio = AppDependencies.createDio();
    final gateway = PersonHttpGateway(dio);
    final queryService = PersonProfileQueryServiceImpl(gateway);
    final commandService = PersonProfileCommandServiceImpl(gateway);
    _cubit = PersonProfileCubit(
      personId: widget.personId,
      queryService: queryService,
      commandService: commandService,
    );
    _cubit.loadProfile();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source, imageQuality: 90);
    if (picked != null && mounted) {
      await _cubit.addPhoto(picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Person Profile',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        body: BlocConsumer<PersonProfileCubit, PersonProfileState>(
          listener: (context, state) {
            if (state.status == PersonProfileStatus.failure && state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage!)),
              );
            }
          },
          builder: (context, state) {
            if (state.status == PersonProfileStatus.loading || state.status == PersonProfileStatus.initial) {
              return const MaterialLoadingWidget();
            }

            final profile = state.profile;
            if (profile == null) {
              return Center(
                child: ElevatedButton(
                  onPressed: () => context.read<PersonProfileCubit>().loadProfile(),
                  child: const Text('Retry'),
                ),
              );
            }

            final isUploading = state.status == PersonProfileStatus.uploading;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 56,
                          backgroundColor: AppColors.avatarBackground,
                          backgroundImage: profile.imageUrl != null && profile.imageUrl!.isNotEmpty
                              ? NetworkImage(profile.imageUrl!)
                              : null,
                          child: profile.imageUrl == null || profile.imageUrl!.isEmpty
                              ? const Icon(Icons.person, size: 48, color: AppColors.primaryDark)
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${profile.firstName} ${profile.lastName}',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'DNI ${profile.dni}',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${profile.totalSamples} registered photos',
                            style: const TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Registered Photos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  if (profile.sampleImageUrls.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderWarm),
                      ),
                      child: const Text('No sample photos yet'),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profile.sampleImageUrls.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        final imageUrl = profile.sampleImageUrls[index];
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            color: AppColors.surfaceVariant,
                            child: imageUrl.isEmpty
                                ? const Icon(Icons.image_outlined, color: AppColors.textHint)
                                : Image.network(imageUrl, fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: isUploading ? null : () => _pickImage(ImageSource.camera),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      icon: isUploading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.add_a_photo_outlined),
                      label: Text(isUploading ? 'Uploading...' : 'Add New Photo'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: isUploading ? null : () => _pickImage(ImageSource.gallery),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryDark,
                        side: const BorderSide(color: AppColors.primaryDark),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Upload from Gallery'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
