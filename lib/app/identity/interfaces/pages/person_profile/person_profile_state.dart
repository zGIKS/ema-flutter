import 'package:equatable/equatable.dart';

import '../../rest/resources/registered_person_detail.resource.dart';

enum PersonProfileStatus { initial, loading, loaded, uploading, failure }

class PersonProfileState extends Equatable {
  static const _unset = Object();

  final PersonProfileStatus status;
  final RegisteredPersonDetailResource? profile;
  final String? errorMessage;

  const PersonProfileState({
    this.status = PersonProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  PersonProfileState copyWith({
    PersonProfileStatus? status,
    Object? profile = _unset,
    Object? errorMessage = _unset,
  }) {
    return PersonProfileState(
      status: status ?? this.status,
      profile: profile == _unset ? this.profile : profile as RegisteredPersonDetailResource?,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
