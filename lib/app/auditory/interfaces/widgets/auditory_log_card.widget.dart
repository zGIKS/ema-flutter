import 'package:flutter/material.dart';

import '../rest/resources/usage_log.resource.dart';

class AuditoryLogCardWidget extends StatelessWidget {
  final UsageLogResource log;
  final String Function(int timestamp) formatTimestamp;

  const AuditoryLogCardWidget({
    super.key,
    required this.log,
    required this.formatTimestamp,
  });

  @override
  Widget build(BuildContext context) {
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
                        log.confidence != null ? '${(log.confidence! * 100).toStringAsFixed(1)}%' : 'N/A',
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
                  if (log.samplesAdded != null || log.totalSamples != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Added ${log.samplesAdded ?? 0} photos | Total ${log.totalSamples ?? 0}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatTimestamp(log.usedAt),
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
  }
}
