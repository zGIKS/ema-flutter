import '../../../domain/model/queries/get_usage_logs.query.dart';

GetUsageLogsQuery toGetUsageLogsQuery({
  int page = 1,
  int pageSize = 20,
}) {
  return GetUsageLogsQuery(
    page: page,
    pageSize: pageSize,
  );
}
