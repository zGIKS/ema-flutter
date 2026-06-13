import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AppHeaderWidget extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const AppHeaderWidget({super.key, this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.fingerprint,
                color: AppColors.primary,
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Ema',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textBody,
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: onProfileTap,
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.profileAvatarBorder,
                      width: 2,
                    ),
                    color: AppColors.profileAvatarBg,
                  ),
                  child: const Icon(
                    Icons.person,
                    color: AppColors.profileAvatarIcon,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
