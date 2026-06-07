import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../domain/model/commands/register_person.command.dart';
import '../../../domain/model/queries/get_registered_persons.query.dart';
import '../../../interfaces/rest/resources/register_person_response.resource.dart';
import '../../../interfaces/rest/resources/registered_persons_page.resource.dart';

abstract class PersonGateway {
  Future<RegisterPersonResponseResource> registerPersonFace(
    RegisterPersonFaceCommand command,
  );

  Future<RegisteredPersonsPageResource> getRegisteredPersons(
    GetRegisteredPersonsQuery query,
  );
}

class PersonHttpGateway implements PersonGateway {
  final Dio dio;

  PersonHttpGateway(this.dio);

  String get _baseUrl {
    return (dotenv.env['API_BASE_URL'] ?? dotenv.env['BACKEND_URL'] ?? 'http://10.0.2.2:8080')
        .replaceAll(RegExp(r'/$'), '');
  }

  @override
  Future<RegisterPersonResponseResource> registerPersonFace(
    RegisterPersonFaceCommand command,
  ) async {
    final formData = FormData.fromMap({
      'dni': command.dni.value,
      'file': await MultipartFile.fromFile(
        command.imagePath,
        filename: 'profile.jpg',
      ),
    });

    try {
      final response = await dio.post(
        '$_baseUrl/api/v1/identity/register',
        data: formData,
      );

      return RegisterPersonResponseResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(_readErrorMessage(e, 'Failed to register person'));
    }
  }

  @override
  Future<RegisteredPersonsPageResource> getRegisteredPersons(
    GetRegisteredPersonsQuery query,
  ) async {
    try {
      final response = await dio.get(
        '$_baseUrl/api/v1/identity/persons',
        queryParameters: {
          'page': query.page,
          'page_size': query.pageSize,
        },
      );

      return RegisteredPersonsPageResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(_readErrorMessage(e, 'Failed to load registered persons'));
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
