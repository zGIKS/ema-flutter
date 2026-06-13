import '../../../domain/model/queries/get_usage_logs.query.dart';
import '../../../interfaces/rest/resources/usage_logs_page.resource.dart';
import '../../../infrastructure/api/gateways/auditory.gateway.dart';

abstract class AuditoryQueryService {
  Future<UsageLogsPageResource> handleGetUsageLogs(GetUsageLogsQuery query);
}

class AuditoryQueryServiceImpl implements AuditoryQueryService {
  final AuditoryGateway gateway;

  AuditoryQueryServiceImpl(this.gateway);

  @override
  Future<UsageLogsPageResource> handleGetUsageLogs(GetUsageLogsQuery query) {
    return gateway.getUsageLogs(query);
  }
}
