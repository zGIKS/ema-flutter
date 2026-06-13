class GetUsageLogsQuery {
  final int page;
  final int pageSize;

  const GetUsageLogsQuery._({
    required this.page,
    required this.pageSize,
  });

  factory GetUsageLogsQuery({
    int page = 1,
    int pageSize = 20,
  }) {
    if (page <= 0) {
      throw ArgumentError('page must be greater than zero');
    }

    if (pageSize < 1 || pageSize > 100) {
      throw ArgumentError('pageSize must be between 1 and 100');
    }

    return GetUsageLogsQuery._(
      page: page,
      pageSize: pageSize,
    );
  }
}
