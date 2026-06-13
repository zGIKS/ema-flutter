class RegisteredPersonDetailResource {
  final String uuid;
  final String firstName;
  final String lastName;
  final String dni;
  final String? imageUrl;
  final List<String> sampleImageUrls;
  final int totalSamples;

  const RegisteredPersonDetailResource({
    required this.uuid,
    required this.firstName,
    required this.lastName,
    required this.dni,
    required this.imageUrl,
    required this.sampleImageUrls,
    required this.totalSamples,
  });

  factory RegisteredPersonDetailResource.fromJson(Map<String, dynamic> json) {
    final sampleImageUrls = (json['sample_image_urls'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .toList(growable: false);

    return RegisteredPersonDetailResource(
      uuid: (json['uuid'] as String?) ?? '',
      firstName: (json['first_name'] as String?) ?? '',
      lastName: (json['last_name'] as String?) ?? '',
      dni: (json['dni'] as String?) ?? '',
      imageUrl: json['image_url'] as String?,
      sampleImageUrls: sampleImageUrls,
      totalSamples: (json['total_samples'] as int?) ?? sampleImageUrls.length,
    );
  }
}
