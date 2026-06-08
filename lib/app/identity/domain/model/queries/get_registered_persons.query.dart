class GetRegisteredPersonsQuery {
  final int page;
  final int pageSize;
  final String? searchTerm;
  final String? dni;

  const GetRegisteredPersonsQuery._({
    required this.page,
    required this.pageSize,
    this.searchTerm,
    this.dni,
  });

  factory GetRegisteredPersonsQuery({
    int page = 1,
    int pageSize = 20,
    String? searchTerm,
    String? dni,
  }) {
    if (page <= 0) {
      throw ArgumentError('page must be greater than zero');
    }

    if (pageSize < 1 || pageSize > 100) {
      throw ArgumentError('pageSize must be between 1 and 100');
    }

    return GetRegisteredPersonsQuery._(
      page: page,
      pageSize: pageSize,
      searchTerm: searchTerm,
      dni: dni,
    );
  }
}
