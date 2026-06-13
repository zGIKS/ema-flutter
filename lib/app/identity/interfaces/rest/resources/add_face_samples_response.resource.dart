class AddFaceSamplesResponseResource {
  final String personId;
  final int totalSamples;
  final List<String> sampleImageUrls;

  const AddFaceSamplesResponseResource({
    required this.personId,
    required this.totalSamples,
    required this.sampleImageUrls,
  });

  factory AddFaceSamplesResponseResource.fromJson(Map<String, dynamic> json) {
    final sampleImageUrls = (json['sample_image_urls'] as List? ?? const <dynamic>[])
        .whereType<String>()
        .where((value) => value.trim().isNotEmpty)
        .toList(growable: false);

    return AddFaceSamplesResponseResource(
      personId: (json['person_id'] as String?) ?? '',
      totalSamples: (json['total_samples'] as int?) ?? sampleImageUrls.length,
      sampleImageUrls: sampleImageUrls,
    );
  }
}
