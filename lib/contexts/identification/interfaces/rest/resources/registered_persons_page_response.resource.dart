class RegisteredPersonResource {
  final String uuid;
  final String firstName;
  final String lastName;
  final String dni;
  final String? photo;

  const RegisteredPersonResource({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.dni,
    this.photo,
  });

  factory RegisteredPersonResource.fromJson(Map<String, dynamic> json) {
    return RegisteredPersonResource(
      uuid: json['uuid'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      dni: json['dni'] as String,
      photo: json['photo'] as String?,
    );
  }
}

class RegisteredPersonsPageResponseResource {
  final List<RegisteredPersonResource> items;
  final int page;
  final int pageSize;
  final int total;

  const RegisteredPersonsPageResponseResource({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory RegisteredPersonsPageResponseResource.fromJson(Map<String, dynamic> json) {
    final list = json['items'] as List<dynamic>? ?? [];
    return RegisteredPersonsPageResponseResource(
      items: list.map((e) => RegisteredPersonResource.fromJson(e as Map<String, dynamic>)).toList(),
      page: json['page'] as int,
      pageSize: json['page_size'] as int,
      total: json['total'] as int,
    );
  }
}
