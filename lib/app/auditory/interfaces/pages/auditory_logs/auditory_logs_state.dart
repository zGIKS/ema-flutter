import 'package:equatable/equatable.dart';
import '../../../interfaces/rest/resources/usage_logs_page.resource.dart';

enum AuditoryLogsStatus { initial, loading, success, empty, failure }

class AuditoryLogsState extends Equatable {
  static const _unset = Object();

  final AuditoryLogsStatus status;
  final UsageLogsPageResource? page;
  final String? errorMessage;

  const AuditoryLogsState({
    this.status = AuditoryLogsStatus.initial,
    this.page,
    this.errorMessage,
  });

  AuditoryLogsState copyWith({
    AuditoryLogsStatus? status,
    Object? page = _unset,
    Object? errorMessage = _unset,
  }) {
    return AuditoryLogsState(
      status: status ?? this.status,
      page: page == _unset ? this.page : page as UsageLogsPageResource?,
      errorMessage: errorMessage == _unset ? this.errorMessage : errorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [status, page, errorMessage];
}
