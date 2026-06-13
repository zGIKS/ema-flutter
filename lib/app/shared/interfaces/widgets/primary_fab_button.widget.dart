import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// Reusable primary floating-action-style button.
///
/// Used as the main CTA at the bottom of list screens hosted inside an
/// [IndexedStack], where the [Scaffold.floatingActionButton] slot is
/// unavailable.
class PrimaryFabButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  const PrimaryFabButton({
    super.key,
    required this.onTap,
    this.icon = Icons.add,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
        ),
      ),
    );
  }
}
