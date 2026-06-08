import 'package:equatable/equatable.dart';
import '../../rest/resources/identification_response.resource.dart';

enum IdentifyPersonStatus { initial, loading, success, failure }

class IdentifyPersonState extends Equatable {
  static const _unset = Object();

  final String? imagePath;
  final IdentifyPersonStatus status;
  final String? errorMessage;
  final IdentificationResponseResource? result;

  const IdentifyPersonState({
    this.imagePath,
    this.status = IdentifyPersonStatus.initial,
    this.errorMessage,
    this.result,
  });

  IdentifyPersonState copyWith({
    Object? imagePath = _unset,
    IdentifyPersonStatus? status,
    Object? errorMessage = _unset,
    Object? result = _unset,
  }) {
    return IdentifyPersonState(
      imagePath: imagePath == _unset ? this.imagePath : imagePath as String?,
      status: status ?? this.status,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
      result: result == _unset ? this.result : result as IdentificationResponseResource?,
    );
  }

  @override
  List<Object?> get props => [imagePath, status, errorMessage, result];
}
