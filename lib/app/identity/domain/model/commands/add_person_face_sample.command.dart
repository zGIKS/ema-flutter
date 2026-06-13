class AddPersonFaceSampleCommand {
  final String personId;
  final String imagePath;

  const AddPersonFaceSampleCommand._({
    required this.personId,
    required this.imagePath,
  });

  factory AddPersonFaceSampleCommand({
    required String personId,
    required String imagePath,
  }) {
    if (personId.trim().isEmpty) {
      throw ArgumentError('personId cannot be empty');
    }

    if (imagePath.trim().isEmpty) {
      throw ArgumentError('imagePath cannot be empty');
    }

    return AddPersonFaceSampleCommand._(
      personId: personId.trim(),
      imagePath: imagePath.trim(),
    );
  }
}
