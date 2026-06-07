import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../domain/model/commands/register_person.command.dart';

abstract class PersonGateway {
  Future<void> registerPerson(RegisterPersonCommand command);
}

class PersonHttpGateway implements PersonGateway {
  final Dio dio;

  PersonHttpGateway(this.dio);

  @override
  Future<void> registerPerson(RegisterPersonCommand command) async {
    final baseUrl = dotenv.env['BACKEND_URL'] ?? 'http://127.0.0.1:8080';
    
    final formData = FormData.fromMap({
      'dni': command.dni,
      'file': await MultipartFile.fromFile(
        command.imagePath,
        filename: 'profile.jpg',
      ),
    });

    try {
      await dio.post(
        '$baseUrl/api/v1/identity/register',
        data: formData,
      );
    } catch (e) {
      throw Exception('Failed to register person: $e');
    }
  }
}
