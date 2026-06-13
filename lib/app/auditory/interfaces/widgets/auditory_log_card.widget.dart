import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

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
    final isFaceSampleUpload = log.operation == 'add_face_samples';
    final isRegister = log.operation == 'register';
    final isIdentified = log.personId != null && !isFaceSampleUpload && !isRegister;

    final badgeLabel = isFaceSampleUpload
        ? 'PHOTOS ADDED'
        : isRegister
            ? 'REGISTERED'
            : isIdentified
                ? 'IDENTIFIED'
                : 'UNKNOWN';

    final badgeColor = isFaceSampleUpload
        ? AppColors.auditFaceBg
        : isRegister
            ? AppColors.auditActionBg
            : isIdentified
                ? AppColors.auditActionBg
                : AppColors.errorBg;

    final badgeTextColor = isFaceSampleUpload
        ? AppColors.auditFaceText
        : isRegister
            ? AppColors.auditActionText
            : isIdentified
                ? AppColors.auditActionText
                : AppColors.auditErrorText;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border, width: 1),
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
                color: AppColors.surfaceVariant,
                child: log.imageUrl != null && log.imageUrl!.isNotEmpty
                    ? Image.network(
                        log.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.broken_image,
                          color: AppColors.textHint,
                        ),
                      )
                    : const Icon(
                        Icons.face,
                        size: 36,
                        color: AppColors.textHint,
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (log.firstName ?? '').trim().isEmpty && (log.lastName ?? '').trim().isEmpty
                        ? 'User ID: ${log.personId ?? '-'}'
                        : '${log.firstName ?? ''} ${log.lastName ?? ''}'.trim(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isFaceSampleUpload ? AppColors.adminBadgeText : AppColors.textTitle,
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
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.speed, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        log.confidence != null ? '${(log.confidence! * 100).toStringAsFixed(1)}%' : 'N/A',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.timer_outlined, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(
                        '${(log.durationMs / 1000).toStringAsFixed(2)} s',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  if (isFaceSampleUpload || log.samplesAdded != null || log.totalSamples != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Added ${log.samplesAdded ?? 0} photos | Total ${log.totalSamples ?? 0}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
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
                          color: AppColors.textHint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          badgeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeTextColor,
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
