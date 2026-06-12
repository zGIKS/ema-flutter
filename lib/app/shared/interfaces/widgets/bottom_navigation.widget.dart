import 'package:flutter/material.dart';

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
    final items = <_EmaBottomNavigationItem>[
      const _EmaBottomNavigationItem(label: 'Users', icon: Icons.people),
      const _EmaBottomNavigationItem(label: 'Identify', icon: Icons.face_retouching_natural),
      const _EmaBottomNavigationItem(label: 'People', icon: Icons.person),
      const _EmaBottomNavigationItem(label: 'History', icon: Icons.history),
    ];

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F5FB),
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
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
                      color: isSelected ? const Color(0xFF2563EB) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                          size: 28,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
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
