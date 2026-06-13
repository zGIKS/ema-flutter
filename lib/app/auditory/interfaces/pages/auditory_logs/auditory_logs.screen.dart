import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../application/internal/queryservices/auditory_query_service_impl.dart';
import '../../../infrastructure/api/gateways/auditory.gateway.dart';
import '../../widgets/auditory_logs_empty_state.widget.dart';
import '../../widgets/auditory_logs_error_state.widget.dart';
import '../../widgets/auditory_logs_list.widget.dart';
import '../../../../shared/interfaces/widgets/material_loading.widget.dart';
import 'auditory_logs_cubit.dart';
import 'auditory_logs_state.dart';

class AuditoryLogsScreen extends StatefulWidget {
  final bool isActive;

  const AuditoryLogsScreen({super.key, required this.isActive});

  @override
  State<AuditoryLogsScreen> createState() => _AuditoryLogsScreenState();
}

class _AuditoryLogsScreenState extends State<AuditoryLogsScreen> {
  late final AuditoryLogsCubit _cubit;

  @override
  void initState() {
    super.initState();
    final dio = AppDependencies.createDio();
    final gateway = AuditoryHttpGateway(dio);
    final queryService = AuditoryQueryServiceImpl(gateway);
    _cubit = AuditoryLogsCubit(queryService: queryService);
    if (widget.isActive) {
      _cubit.loadLogs(clearPage: true);
    }
  }

  @override
  void didUpdateWidget(covariant AuditoryLogsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isActive && widget.isActive) {
      _cubit.loadLogs(clearPage: true);
    }
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$month $day, $year - $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: BlocBuilder<AuditoryLogsCubit, AuditoryLogsState>(
          builder: (context, state) {
            if (state.status == AuditoryLogsStatus.loading || state.status == AuditoryLogsStatus.initial) {
              return const MaterialLoadingWidget();
            }

            if (state.status == AuditoryLogsStatus.failure) {
              return AuditoryLogsErrorStateWidget(
                message: state.errorMessage ?? 'Unable to load usage logs',
                onRetry: () => context.read<AuditoryLogsCubit>().loadLogs(clearPage: true),
              );
            }

            final page = state.page;
            if (page == null || page.items.isEmpty) {
              return const AuditoryLogsEmptyStateWidget();
            }

            return RefreshIndicator(
              onRefresh: () => context.read<AuditoryLogsCubit>().loadLogs(clearPage: true),
              child: AuditoryLogsListWidget(
                items: page.items,
                formatTimestamp: _formatTimestamp,
              ),
            );
          },
        ),
      ),
    );
  }
}
