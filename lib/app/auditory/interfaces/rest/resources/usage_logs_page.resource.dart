import 'usage_log.resource.dart';

class UsageLogsPageResource {
  final List<UsageLogResource> items;
  final int page;
  final int pageSize;
  final int total;

  const UsageLogsPageResource({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory UsageLogsPageResource.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List? ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => UsageLogResource.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);

    return UsageLogsPageResource(
      items: rawItems,
      page: (json['page'] as int?) ?? 1,
      pageSize: (json['page_size'] as int?) ?? 20,
      total: (json['total'] as int?) ?? 0,
    );
  }
}
