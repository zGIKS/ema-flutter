import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_dio.dart';
import '../../rest/resources/sign_in_form.resource.dart';
import '../../rest/transform/iam_transform.dart';
import '../../../application/internal/commandservices/iam_command_service_impl.dart';
import '../../../application/internal/session_manager.dart';
import 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  final IamCommandServiceImpl commandService;

  SignInCubit({required this.commandService}) : super(const SignInState());

  Future<void> submitForm({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty || password.trim().isEmpty) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: 'Username and password cannot be empty.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: SignInStatus.loading));

    try {
      final resource = SignInFormResource(
        username: username,
        password: password,
      );
      final command = toSignInCommand(resource);
      final response = await commandService.handleSignIn(command);
      
      // Save session info
      SessionManager.saveSession(
        token: response.accessToken,
        username: response.username,
        userId: response.userId,
      );

      emit(
        state.copyWith(
          status: SignInStatus.success,
          lastResponse: response,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SignInStatus.failure,
          errorMessage: readFriendlyErrorMessage(e, fallbackMessage: 'Unable to sign in'),
        ),
      );
    }
  }

  void clearForm() {
    emit(const SignInState());
  }
}
