class UsageLogResource {
  final String operation;
  final String? personId;
  final String? firstName;
  final String? lastName;
  final String? dni;
  final double? confidence;
  final int? samplesAdded;
  final int? totalSamples;
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
    this.samplesAdded,
    this.totalSamples,
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
      samplesAdded: _toInt(json['samples_added']),
      totalSamples: _toInt(json['total_samples']),
      durationMs: _toInt(json['duration_ms']) ?? 0,
      imageUrl: json['image_url'] as String?,
      usedAt: _toInt(json['used_at']) ?? 0,
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) {
    final parsedInt = int.tryParse(value);
    if (parsedInt != null) return parsedInt;
    final parsedDate = DateTime.tryParse(value);
    if (parsedDate != null) return parsedDate.millisecondsSinceEpoch ~/ 1000;
  }
  return null;
}
