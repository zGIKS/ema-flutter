class RegisteredPersonResource {
  final String uuid;
  final String firstName;
  final String lastName;
  final String dni;
  final String? imageUrl;

  const RegisteredPersonResource({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.imageUrl,
  });

  factory RegisteredPersonResource.fromJson(Map<String, dynamic> json) {
    return RegisteredPersonResource(
      uuid: (json['uuid'] as String?) ?? '',
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
      dni: (json['dni'] as String?) ?? '',
      imageUrl: json['image_url'] as String?,
    );
  }
}
