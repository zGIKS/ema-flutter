import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_dio.dart';
import 'register_person_state.dart';
import '../../../application/internal/commandservices/person_command_service_impl.dart';
import '../../../interfaces/rest/resources/register_person_form.resource.dart';
import '../../../interfaces/rest/transform/identity_transform.dart';

class RegisterPersonCubit extends Cubit<RegisterPersonState> {
  final PersonCommandServiceImpl commandService;

  RegisterPersonCubit({required this.commandService}) : super(const RegisterPersonState());

  void imagePicked(String imagePath) {
    emit(
      state.copyWith(
        imagePath: imagePath,
        status: RegisterPersonStatus.initial,
        errorMessage: null,
        lastResponse: null,
      ),
    );
  }

  void clearImage() {
    emit(
      state.copyWith(
        imagePath: null,
        status: RegisterPersonStatus.initial,
        errorMessage: null,
        lastResponse: null,
      ),
    );
  }

  Future<void> submitForm(String dni) async {
    if (state.imagePath == null) {
      emit(
        state.copyWith(
          status: RegisterPersonStatus.failure,
          errorMessage: 'Please select an identity photo first.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: RegisterPersonStatus.loading));

    try {
      final command = toRegisterPersonFaceCommand(
        RegisterPersonFormResource(
          dni: dni,
          imagePath: state.imagePath!,
        ),
      );
      final response = await commandService.handleRegisterPersonFace(command);
      emit(
        state.copyWith(
          status: RegisterPersonStatus.success,
          lastResponse: response,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: RegisterPersonStatus.failure,
          errorMessage: readFriendlyErrorMessage(e, fallbackMessage: 'Unable to register person'),
        ),
      );
    }
  }

  void clearForm() {
    emit(const RegisterPersonState());
  }
}
