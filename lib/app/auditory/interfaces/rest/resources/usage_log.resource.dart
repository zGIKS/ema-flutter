class UsageLogResource {
  final String operation;
  final String? personId;
  final String? firstName;
  final String? lastName;
  final String? dni;
  final double? confidence;
  final int durationMs;
  final String? imageUrl;
  final int usedAt;

  const UsageLogResource({
    required this.operation,
    this.personId,
    this.firstName,
    this.lastName,
    this.dni,
    this.confidence,
    required this.durationMs,
    this.imageUrl,
    required this.usedAt,
  });

  factory UsageLogResource.fromJson(Map<String, dynamic> json) {
    return UsageLogResource(
      operation: json['operation'] as String? ?? '',
      personId: json['person_id'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      dni: json['dni'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      durationMs: json['duration_ms'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      usedAt: json['used_at'] as int? ?? 0,
    );
  }
}
