import 'package:equatable/equatable.dart';
import '../../rest/resources/register_person_response.resource.dart';

enum RegisterPersonStatus { initial, loading, success, failure }

class RegisterPersonState extends Equatable {
  static const _unset = Object();

  final String? imagePath;
  final RegisterPersonStatus status;
  final String? errorMessage;
  final RegisterPersonResponseResource? lastResponse;

  const RegisterPersonState({
    this.imagePath,
    this.status = RegisterPersonStatus.initial,
    this.errorMessage,
    this.lastResponse,
  });

  RegisterPersonState copyWith({
    Object? imagePath = _unset,
    RegisterPersonStatus? status,
    Object? errorMessage = _unset,
    Object? lastResponse = _unset,
  }) {
    return RegisterPersonState(
      imagePath: imagePath == _unset ? this.imagePath : imagePath as String?,
      status: status ?? this.status,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      lastResponse: lastResponse == _unset ? this.lastResponse : lastResponse as RegisterPersonResponseResource?,
    );
  }

  @override
  List<Object?> get props => [imagePath, status, errorMessage, lastResponse];
}
