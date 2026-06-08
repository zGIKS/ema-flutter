class IdentificationResponseResource {
  final String? uuid;
  final String? firstName;
  final String? lastName;
  final String? dni;
  final String? imageUrl;
  final double confidence;

  const IdentificationResponseResource({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.imageUrl,
    required this.confidence,
  });

  factory IdentificationResponseResource.fromJson(Map<String, dynamic> json) {
    return IdentificationResponseResource(
      uuid: json['uuid'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      dni: json['dni'] as String?,
      imageUrl: json['image_url'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
    );
  }

  bool get isVerified => confidence >= 0.85 && uuid != null;
}
