import 'package:flutter/material.dart';

class AuditoryLogsEmptyStateWidget extends StatelessWidget {
  const AuditoryLogsEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No usage history recorded yet'));
  }
}
