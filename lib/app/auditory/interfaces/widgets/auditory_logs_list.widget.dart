import 'package:flutter/material.dart';

import '../rest/resources/usage_log.resource.dart';
import 'auditory_log_card.widget.dart';

class AuditoryLogsListWidget extends StatelessWidget {
  final List<UsageLogResource> items;
  final String Function(int timestamp) formatTimestamp;

  const AuditoryLogsListWidget({
    super.key,
    required this.items,
    required this.formatTimestamp,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return AuditoryLogCardWidget(
          log: items[index],
          formatTimestamp: formatTimestamp,
        );
      },
    );
  }
}
