import 'package:dio/dio.dart';
import '../../../../core/network/app_dio.dart';
import '../../../domain/model/queries/get_usage_logs.query.dart';
import '../../../interfaces/rest/resources/usage_logs_page.resource.dart';

abstract class AuditoryGateway {
  Future<UsageLogsPageResource> getUsageLogs(GetUsageLogsQuery query);
}

class AuditoryHttpGateway implements AuditoryGateway {
  final Dio dio;

  AuditoryHttpGateway(this.dio);

  @override
  Future<UsageLogsPageResource> getUsageLogs(GetUsageLogsQuery query) async {
    try {
      final response = await dio.get(
        '/api/v1/auditory/usage-logs',
        queryParameters: {
          'page': query.page,
          'page_size': query.pageSize,
        },
      );

      return UsageLogsPageResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(readFriendlyErrorMessage(e, fallbackMessage: 'Failed to load usage logs'));
    }
  }
}
