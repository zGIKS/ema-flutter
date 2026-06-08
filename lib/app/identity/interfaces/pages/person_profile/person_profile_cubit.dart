import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/internal/commandservices/person_profile_command_service_impl.dart';
import '../../../application/internal/queryservices/person_profile_query_service_impl.dart';
import '../../../domain/model/commands/add_person_face_sample.command.dart';
import '../../../domain/model/queries/get_person_profile.query.dart';
import 'person_profile_state.dart';

class PersonProfileCubit extends Cubit<PersonProfileState> {
  final PersonProfileQueryServiceImpl queryService;
  final PersonProfileCommandServiceImpl commandService;
  final String personId;

  PersonProfileCubit({
    required this.personId,
    required this.queryService,
    required this.commandService,
  }) : super(const PersonProfileState());

  Future<void> loadProfile({bool clearProfile = true}) async {
    emit(
      state.copyWith(
        status: PersonProfileStatus.loading,
        profile: clearProfile ? null : state.profile,
        errorMessage: null,
      ),
    );

    try {
      final profile = await queryService.handleGetPersonProfile(
        GetPersonProfileQuery(personId: personId),
      );
      emit(state.copyWith(status: PersonProfileStatus.loaded, profile: profile, errorMessage: null));
    } catch (e) {
      emit(state.copyWith(status: PersonProfileStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> addPhoto(String imagePath) async {
    emit(state.copyWith(status: PersonProfileStatus.uploading, errorMessage: null));

    try {
      await commandService.handleAddPersonFaceSample(
        AddPersonFaceSampleCommand(personId: personId, imagePath: imagePath),
      );
      await loadProfile();
    } catch (e) {
      emit(state.copyWith(status: PersonProfileStatus.failure, errorMessage: e.toString()));
    }
  }
}
