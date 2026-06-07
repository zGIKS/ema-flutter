import 'package:flutter/material.dart';

class EmaAppHeaderWidget extends StatelessWidget {
  const EmaAppHeaderWidget({super.key});

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
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.fingerprint,
                color: Color(0xFF2563EB),
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
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFD1D5DB), width: 2),
                color: const Color(0xFFF3F4F6),
              ),
              child: const Icon(
                Icons.person,
                color: Color(0xFF6B7280),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
