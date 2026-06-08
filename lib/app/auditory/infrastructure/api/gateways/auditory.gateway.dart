import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../domain/model/queries/get_usage_logs.query.dart';
import '../../../interfaces/rest/resources/usage_logs_page.resource.dart';

abstract class AuditoryGateway {
  Future<UsageLogsPageResource> getUsageLogs(GetUsageLogsQuery query);
}

class AuditoryHttpGateway implements AuditoryGateway {
  final Dio dio;

  AuditoryHttpGateway(this.dio);

  String get _baseUrl {
    return (dotenv.env['API_BASE_URL'] ?? dotenv.env['BACKEND_URL'] ?? 'http://10.0.2.2:8080')
        .replaceAll(RegExp(r'/$'), '');
  }

  @override
  Future<UsageLogsPageResource> getUsageLogs(GetUsageLogsQuery query) async {
    try {
      final response = await dio.get(
        '$_baseUrl/api/v1/auditory/usage-logs',
        queryParameters: {
          'page': query.page,
          'page_size': query.pageSize,
        },
      );

      return UsageLogsPageResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(_readErrorMessage(e, 'Failed to load usage logs'));
    }
  }

  String _readErrorMessage(DioException error, String fallbackMessage) {
    final data = error.response?.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }
    }

    final message = error.message;
    if (message != null && message.trim().isNotEmpty) {
      return message;
    }

    return fallbackMessage;
  }
}
