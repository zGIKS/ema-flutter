import 'registered_person.resource.dart';

class RegisteredPersonsPageResource {
  final List<RegisteredPersonResource> items;
  final int page;
  final int pageSize;
  final int total;

  const RegisteredPersonsPageResource({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory RegisteredPersonsPageResource.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List? ?? const <dynamic>[])
        .whereType<Map>()
        .map((item) => RegisteredPersonResource.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);

    return RegisteredPersonsPageResource(
      items: rawItems,
      page: (json['page'] as int?) ?? 1,
      pageSize: (json['page_size'] as int?) ?? 20,
      total: (json['total'] as int?) ?? 0,
    );
  }
}
