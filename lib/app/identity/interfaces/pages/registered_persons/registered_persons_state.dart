import 'package:equatable/equatable.dart';
import '../../rest/resources/registered_persons_page.resource.dart';

enum RegisteredPersonsStatus { initial, loading, success, empty, failure }

class RegisteredPersonsState extends Equatable {
  static const _unset = Object();

  final RegisteredPersonsStatus status;
  final RegisteredPersonsPageResource? page;
  final String? errorMessage;

  const RegisteredPersonsState({
    this.status = RegisteredPersonsStatus.initial,
    this.page,
    this.errorMessage,
  });

  RegisteredPersonsState copyWith({
    RegisteredPersonsStatus? status,
    Object? page = _unset,
    Object? errorMessage = _unset,
  }) {
    return RegisteredPersonsState(
      status: status ?? this.status,
      page: page == _unset ? this.page : page as RegisteredPersonsPageResource?,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, page, errorMessage];
}
