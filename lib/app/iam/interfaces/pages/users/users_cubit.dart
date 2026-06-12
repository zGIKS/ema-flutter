import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/app_dio.dart';
import '../../../application/internal/commandservices/users_command_service_impl.dart';
import '../../../application/internal/queryservices/users_query_service_impl.dart';
import '../../../domain/model/commands/update_user_role.command.dart';
import '../../../domain/model/valueobjects/user_id.valueobject.dart';
import '../../../domain/model/valueobjects/user_role.valueobject.dart';
import '../../../interfaces/rest/transform/users_transform.dart';
import 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  final UsersQueryServiceImpl queryService;
  final UsersCommandServiceImpl commandService;

  UsersCubit({
    required this.queryService,
    required this.commandService,
  }) : super(const UsersState());

  Future<void> loadUsers({bool clearUsers = true}) async {
    emit(
      state.copyWith(
        status: UsersStatus.loading,
        users: clearUsers ? const [] : state.users,
        errorMessage: null,
      ),
    );

    try {
      final users = await queryService.handleGetUsers(toGetUsersQuery());
      emit(
        state.copyWith(
          status: users.isEmpty ? UsersStatus.empty : UsersStatus.success,
          users: users,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UsersStatus.failure,
          errorMessage: readFriendlyErrorMessage(e, fallbackMessage: 'Unable to load users'),
        ),
      );
    }
  }

  Future<void> updateUserRole({
    required String userId,
    required UserRole role,
  }) {
    return commandService.handleUpdateUserRole(
      UpdateUserRoleCommand(
        userId: UserId(userId),
        role: role,
      ),
    );
  }
}
