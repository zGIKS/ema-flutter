class GetRegisteredPersonsQuery {
  final int page;
  final int pageSize;

  GetRegisteredPersonsQuery._({required this.page, required this.pageSize});

  factory GetRegisteredPersonsQuery({int page = 1, int pageSize = 20}) {
    if (page < 1) {
      throw ArgumentError('La página debe ser mayor o igual a 1.');
    }
    if (pageSize < 1) {
      throw ArgumentError('El tamaño de página debe ser mayor o igual a 1.');
    }
    return GetRegisteredPersonsQuery._(page: page, pageSize: pageSize);
  }
}
