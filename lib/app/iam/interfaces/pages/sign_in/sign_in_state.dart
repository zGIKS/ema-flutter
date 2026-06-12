import 'package:equatable/equatable.dart';
import '../../rest/resources/authenticated_user.resource.dart';

enum SignInStatus { initial, loading, success, failure }

class SignInState extends Equatable {
  static const _unset = Object();

  final SignInStatus status;
  final String? errorMessage;
  final AuthenticatedUserResource? lastResponse;

  const SignInState({
    this.status = SignInStatus.initial,
    this.errorMessage,
    this.lastResponse,
  });

  SignInState copyWith({
    SignInStatus? status,
    Object? errorMessage = _unset,
    Object? lastResponse = _unset,
  }) {
    return SignInState(
      status: status ?? this.status,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      lastResponse: lastResponse == _unset ? this.lastResponse : lastResponse as AuthenticatedUserResource?,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, lastResponse];
}
