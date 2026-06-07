import 'package:equatable/equatable.dart';

enum RegisterPersonStatus { initial, loading, success, failure }

class RegisterPersonState extends Equatable {
  final String? imagePath;
  final RegisterPersonStatus status;
  final String? errorMessage;

  const RegisterPersonState({
    this.imagePath,
    this.status = RegisterPersonStatus.initial,
    this.errorMessage,
  });

  RegisterPersonState copyWith({
    String? imagePath,
    RegisterPersonStatus? status,
    String? errorMessage,
  }) {
    return RegisterPersonState(
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [imagePath, status, errorMessage];
}
