import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../iam/application/internal/session_manager.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const BottomNavigationWidget({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = SessionManager.isAdmin;
    final items = isAdmin
        ? const <_EmaBottomNavigationItem>[
            _EmaBottomNavigationItem(label: 'Users', icon: Icons.people),
            _EmaBottomNavigationItem(label: 'Identify', icon: Icons.face_retouching_natural),
            _EmaBottomNavigationItem(label: 'People', icon: Icons.person),
            _EmaBottomNavigationItem(label: 'History', icon: Icons.history),
          ]
        : const <_EmaBottomNavigationItem>[
            _EmaBottomNavigationItem(label: 'Identify', icon: Icons.face_retouching_natural),
            _EmaBottomNavigationItem(label: 'History', icon: Icons.history),
          ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.navBackground,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowMedium,
                blurRadius: 16,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == selectedIndex;

              return Expanded(
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onTap(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    height: 72,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? Colors.white : AppColors.textDisabled,
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : AppColors.textDisabled,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _EmaBottomNavigationItem {
  final String label;
  final IconData icon;

  const _EmaBottomNavigationItem({
    required this.label,
    required this.icon,
  });
}
