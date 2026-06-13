class GetPersonProfileQuery {
  final String personId;

  const GetPersonProfileQuery._({required this.personId});

  factory GetPersonProfileQuery({required String personId}) {
    if (personId.trim().isEmpty) {
      throw ArgumentError('personId cannot be empty');
    }

    return GetPersonProfileQuery._(personId: personId.trim());
  }
}
