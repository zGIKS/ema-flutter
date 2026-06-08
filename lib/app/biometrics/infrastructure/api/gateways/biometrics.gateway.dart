import 'package:dio/dio.dart';

import '../../../../core/network/app_dio.dart';
import '../../../domain/model/queries/identify_person.query.dart';
import '../../../interfaces/rest/resources/identification_response.resource.dart';

abstract class BiometricsGateway {
  Future<IdentificationResponseResource> identifyPerson(IdentifyPersonQuery query);
}

class BiometricsHttpGateway implements BiometricsGateway {
  final Dio dio;

  BiometricsHttpGateway(this.dio);

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
        '/api/v1/biometrics/identify',
        data: formData,
      );

      return IdentificationResponseResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(readApiErrorMessage(e, 'Failed to identify person'));
    }
  }
}
