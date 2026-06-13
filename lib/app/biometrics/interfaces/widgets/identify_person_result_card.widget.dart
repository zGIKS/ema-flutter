import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../iam/application/internal/session_manager.dart';

import '../rest/resources/identification_response.resource.dart';

class IdentifyPersonResultCardWidget extends StatelessWidget {
  final IdentificationResponseResource result;
  final VoidCallback onViewProfile;

  const IdentifyPersonResultCardWidget({
    super.key,
    required this.result,
    required this.onViewProfile,
  });

  @override
  Widget build(BuildContext context) {
    final isVerified = result.isVerified;
    final confidenceLabel = '${(result.confidence * 100).toStringAsFixed(1)}%';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderWarm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isVerified ? Icons.verified : Icons.info_outline,
                color: AppColors.primaryDark,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                isVerified ? 'Verified User' : 'Unverified Match',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTitle,
                ),
              ),
              const Spacer(),
              Text(
                confidenceLabel,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.avatarBackground,
                  borderRadius: BorderRadius.circular(14),
                  image: result.imageUrl == null
                      ? null
                      : DecorationImage(
                          image: NetworkImage(result.imageUrl!),
                          fit: BoxFit.cover,
                        ),
                ),
                child: result.imageUrl == null
                    ? const Icon(Icons.person, color: AppColors.primaryDark, size: 32)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${result.firstName ?? ''} ${result.lastName ?? ''}'.trim(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textTitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'DNI: ${result.dni ?? '-'}',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Match: $confidenceLabel',
                        style: const TextStyle(
                          color: AppColors.primaryDark,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (SessionManager.isAdmin) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onViewProfile,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.profileAvatarBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.badge_outlined, size: 18),
                label: const Text('View Profile'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
