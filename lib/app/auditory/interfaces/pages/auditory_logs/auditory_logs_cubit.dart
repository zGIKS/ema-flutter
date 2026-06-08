import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/app_dio.dart';
import '../../../application/internal/queryservices/auditory_query_service_impl.dart';
import '../../../interfaces/rest/transform/auditory_transform.dart';
import 'auditory_logs_state.dart';

class AuditoryLogsCubit extends Cubit<AuditoryLogsState> {
  final AuditoryQueryServiceImpl queryService;

  AuditoryLogsCubit({required this.queryService}) : super(const AuditoryLogsState());

  Future<void> loadLogs({
    int page = 1,
    int pageSize = 20,
    bool clearPage = true,
  }) async {
    emit(
      state.copyWith(
        status: AuditoryLogsStatus.loading,
        page: clearPage ? null : state.page,
        errorMessage: null,
      ),
    );

    try {
      final query = toGetUsageLogsQuery(page: page, pageSize: pageSize);
      final response = await queryService.handleGetUsageLogs(query);
      emit(
        state.copyWith(
          status: response.items.isEmpty ? AuditoryLogsStatus.empty : AuditoryLogsStatus.success,
          page: response,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AuditoryLogsStatus.failure,
          errorMessage: readFriendlyErrorMessage(e, fallbackMessage: 'Unable to load usage logs'),
        ),
      );
    }
  }
}
