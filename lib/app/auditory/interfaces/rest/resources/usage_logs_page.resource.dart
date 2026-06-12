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
      page: _toInt(json['page']) ?? 1,
      pageSize: _toInt(json['page_size']) ?? 20,
      total: _toInt(json['total']) ?? 0,
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}
