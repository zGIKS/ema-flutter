class RegisterPersonResponseResource {
  final String firstName;
  final String lastName;
  final String dni;
  final bool enrolled;

  const RegisterPersonResponseResource({
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.enrolled,
  });

  factory RegisterPersonResponseResource.fromJson(Map<String, dynamic> json) {
    return RegisterPersonResponseResource(
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
      dni: (json['dni'] as String?) ?? '',
      enrolled: json['enrolled'] as bool? ?? false,
    );
  }
}
