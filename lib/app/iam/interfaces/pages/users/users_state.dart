import 'package:equatable/equatable.dart';

import '../../rest/resources/authenticated_user.resource.dart';

enum UsersStatus { initial, loading, success, empty, failure }

class UsersState extends Equatable {
  static const _unset = Object();

  final UsersStatus status;
  final List<AuthenticatedUserResource> users;
  final String? errorMessage;

  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.errorMessage,
  });

  UsersState copyWith({
    UsersStatus? status,
    List<AuthenticatedUserResource>? users,
    Object? errorMessage = _unset,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, users, errorMessage];
}
