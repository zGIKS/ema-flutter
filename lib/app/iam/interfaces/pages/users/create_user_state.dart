import 'package:equatable/equatable.dart';

import '../../rest/resources/authenticated_user.resource.dart';

enum CreateUserStatus { initial, loading, success, failure }

class CreateUserState extends Equatable {
  static const _unset = Object();

  final CreateUserStatus status;
  final String? errorMessage;
  final AuthenticatedUserResource? createdUser;

  const CreateUserState({
    this.status = CreateUserStatus.initial,
    this.errorMessage,
    this.createdUser,
  });

  CreateUserState copyWith({
    CreateUserStatus? status,
    Object? errorMessage = _unset,
    Object? createdUser = _unset,
  }) {
    return CreateUserState(
      status: status ?? this.status,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      createdUser: createdUser == _unset ? this.createdUser : createdUser as AuthenticatedUserResource?,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, createdUser];
}
