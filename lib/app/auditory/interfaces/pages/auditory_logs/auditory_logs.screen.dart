import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/app_dependencies.dart';
import '../../../application/internal/queryservices/auditory_query_service_impl.dart';
import '../../../infrastructure/api/gateways/auditory.gateway.dart';
import 'auditory_logs_cubit.dart';
import 'auditory_logs_state.dart';

class AuditoryLogsScreen extends StatefulWidget {
  const AuditoryLogsScreen({super.key});

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
    _cubit.loadLogs();
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
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == AuditoryLogsStatus.failure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        state.errorMessage ?? 'Unable to load usage logs',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<AuditoryLogsCubit>().loadLogs(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            final page = state.page;
            if (page == null || page.items.isEmpty) {
              return const Center(child: Text('No usage history recorded yet'));
            }

            return RefreshIndicator(
              onRefresh: () => context.read<AuditoryLogsCubit>().loadLogs(),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: page.items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final log = page.items[index];
                  final isIdentified = log.personId != null;

                  return Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              width: 70,
                              height: 70,
                              color: const Color(0xFFF1F5F9),
                              child: log.imageUrl != null && log.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      log.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => const Icon(
                                        Icons.broken_image,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.face,
                                      size: 36,
                                      color: Color(0xFF94A3B8),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isIdentified
                                      ? '${log.firstName ?? ''} ${log.lastName ?? ''}'.trim().isEmpty
                                          ? 'User ID: ${log.personId}'
                                          : '${log.firstName} ${log.lastName}'
                                      : 'Unauthorized/Not Detected',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: isIdentified ? const Color(0xFF1E293B) : const Color(0xFFB91C1C),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (isIdentified && log.dni != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    'DNI: ${log.dni}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.speed, size: 14, color: Color(0xFF64748B)),
                                    const SizedBox(width: 4),
                                    Text(
                                      log.confidence != null
                                          ? '${(log.confidence! * 100).toStringAsFixed(1)}%'
                                          : 'N/A',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF64748B)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${(log.durationMs / 1000).toStringAsFixed(2)} s',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _formatTimestamp(log.usedAt),
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF94A3B8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isIdentified ? const Color(0xFFE0F2FE) : const Color(0xFFFEE2E2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        isIdentified ? 'IDENTIFIED' : 'UNKNOWN',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: isIdentified ? const Color(0xFF0369A1) : const Color(0xFFB91C1C),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
