import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_person_state.dart';
import '../../../application/internal/commandservices/person_command_service_impl.dart';
import '../../../domain/model/commands/register_person.command.dart';

class RegisterPersonCubit extends Cubit<RegisterPersonState> {
  final PersonCommandServiceImpl commandService;

  RegisterPersonCubit({required this.commandService}) : super(const RegisterPersonState());

  void imagePicked(String imagePath) {
    emit(state.copyWith(imagePath: imagePath, status: RegisterPersonStatus.initial, errorMessage: null));
  }

  Future<void> submitForm(String dni) async {
    if (state.imagePath == null) {
      emit(state.copyWith(status: RegisterPersonStatus.failure, errorMessage: 'Please select an identity photo first.'));
      return;
    }

    emit(state.copyWith(status: RegisterPersonStatus.loading));

    try {
      final command = RegisterPersonCommand(
        dni: dni,
        imagePath: state.imagePath!,
      );
      await commandService.handleRegisterPerson(command);
      emit(state.copyWith(status: RegisterPersonStatus.success));
    } catch (e) {
      emit(state.copyWith(status: RegisterPersonStatus.failure, errorMessage: e.toString()));
    }
  }
}
