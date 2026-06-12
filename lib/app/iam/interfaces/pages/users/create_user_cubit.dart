import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/app_dio.dart';
import '../../../application/internal/commandservices/users_command_service_impl.dart';
import '../../../interfaces/rest/resources/create_user_form.resource.dart';
import '../../../interfaces/rest/transform/users_transform.dart';
import 'create_user_state.dart';

class CreateUserCubit extends Cubit<CreateUserState> {
  final UsersCommandServiceImpl commandService;

  CreateUserCubit({required this.commandService}) : super(const CreateUserState());

  Future<void> submitForm({
    required String username,
    required String password,
  }) async {
    emit(state.copyWith(status: CreateUserStatus.loading, errorMessage: null, createdUser: null));

    try {
      final createdUser = await commandService.handleCreateUser(
        toCreateUserCommand(
          CreateUserFormResource(
            username: username,
            password: password,
          ),
        ),
      );
      emit(
        state.copyWith(
          status: CreateUserStatus.success,
          createdUser: createdUser,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: CreateUserStatus.failure,
          errorMessage: readFriendlyErrorMessage(e, fallbackMessage: 'Unable to create user'),
        ),
      );
    }
  }

  void clearForm() {
    emit(const CreateUserState());
  }
}
