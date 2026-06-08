import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../domain/model/queries/identify_person.query.dart';
import '../../../interfaces/rest/resources/identification_response.resource.dart';

abstract class BiometricsGateway {
  Future<IdentificationResponseResource> identifyPerson(IdentifyPersonQuery query);
}

class BiometricsHttpGateway implements BiometricsGateway {
  final Dio dio;

  BiometricsHttpGateway(this.dio);

  String get _baseUrl {
    return (dotenv.env['API_BASE_URL'] ?? dotenv.env['BACKEND_URL'] ?? 'http://10.0.2.2:8080')
        .replaceAll(RegExp(r'/$'), '');
  }

  @override
  Future<IdentificationResponseResource> identifyPerson(IdentifyPersonQuery query) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        query.imagePath.value,
        filename: 'identify.jpg',
      ),
    });

    try {
      final response = await dio.post(
        '$_baseUrl/api/v1/biometrics/identify',
        data: formData,
      );

      return IdentificationResponseResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(_readErrorMessage(e, 'Failed to identify person'));
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
