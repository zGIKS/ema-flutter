import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/app_dio.dart';
import '../../../application/internal/queryservices/person_identification_query_service_impl.dart';
import '../../rest/resources/identify_person_form.resource.dart';
import '../../rest/transform/biometrics_transform.dart';
import 'identify_person_state.dart';

class IdentifyPersonCubit extends Cubit<IdentifyPersonState> {
  final PersonIdentificationQueryServiceImpl queryService;

  IdentifyPersonCubit({required this.queryService}) : super(const IdentifyPersonState());

  void imagePicked(String imagePath) {
    emit(
      state.copyWith(
        imagePath: imagePath,
        status: IdentifyPersonStatus.initial,
        errorMessage: null,
        result: null,
      ),
    );
  }

  void clearImage() {
    emit(const IdentifyPersonState());
  }

  Future<void> identifyPerson() async {
    if (state.imagePath == null) {
      emit(
        state.copyWith(
          status: IdentifyPersonStatus.failure,
          errorMessage: 'Please select a photo first.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: IdentifyPersonStatus.loading, errorMessage: null));

    try {
      final query = toIdentifyPersonQuery(
        IdentifyPersonFormResource(imagePath: state.imagePath!),
      );
      final result = await queryService.handleIdentifyPerson(query);
      emit(
        state.copyWith(
          status: IdentifyPersonStatus.success,
          result: result,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: IdentifyPersonStatus.failure,
          errorMessage: readFriendlyErrorMessage(e, fallbackMessage: 'Unable to identify person'),
        ),
      );
    }
  }

  void clearResult() {
    emit(const IdentifyPersonState());
  }
}
