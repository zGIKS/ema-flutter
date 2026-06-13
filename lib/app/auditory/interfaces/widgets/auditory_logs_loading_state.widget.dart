import 'package:flutter/material.dart';

class AuditoryLogsLoadingStateWidget extends StatelessWidget {
  const AuditoryLogsLoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
