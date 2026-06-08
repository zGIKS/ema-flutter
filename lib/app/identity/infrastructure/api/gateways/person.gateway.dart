import 'package:dio/dio.dart';
import '../../../domain/model/commands/add_person_face_sample.command.dart';
import '../../../domain/model/commands/register_person.command.dart';
import '../../../domain/model/queries/get_person_profile.query.dart';
import '../../../domain/model/queries/get_registered_persons.query.dart';
import '../../../../core/network/app_dio.dart';
import '../../../interfaces/rest/resources/add_face_samples_response.resource.dart';
import '../../../interfaces/rest/resources/register_person_response.resource.dart';
import '../../../interfaces/rest/resources/registered_person_detail.resource.dart';
import '../../../interfaces/rest/resources/registered_persons_page.resource.dart';

abstract class PersonGateway {
  Future<RegisterPersonResponseResource> registerPersonFace(
    RegisterPersonFaceCommand command,
  );

  Future<RegisteredPersonsPageResource> getRegisteredPersons(
    GetRegisteredPersonsQuery query,
  );

  Future<RegisteredPersonDetailResource> getPersonProfile(
    GetPersonProfileQuery query,
  );

  Future<AddFaceSamplesResponseResource> addPersonFaceSample(
    AddPersonFaceSampleCommand command,
  );
}

class PersonHttpGateway implements PersonGateway {
  final Dio dio;

  PersonHttpGateway(this.dio);

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
        '/api/v1/identity/register',
        data: formData,
      );

      return RegisterPersonResponseResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(readApiErrorMessage(e, 'Failed to register person'));
    }
  }

  @override
  Future<RegisteredPersonsPageResource> getRegisteredPersons(
    GetRegisteredPersonsQuery query,
  ) async {
    try {
      final response = await dio.get(
        '/api/v1/identity/persons',
        queryParameters: {
          'page': query.page,
          'page_size': query.pageSize,
          if (query.searchTerm != null) 'search': query.searchTerm,
          if (query.dni != null) 'dni': query.dni,
        },
      );

      return RegisteredPersonsPageResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(readApiErrorMessage(e, 'Failed to load registered persons'));
    }
  }

  @override
  Future<RegisteredPersonDetailResource> getPersonProfile(
    GetPersonProfileQuery query,
  ) async {
    try {
      final response = await dio.get('/api/v1/identity/persons/${query.personId}');

      return RegisteredPersonDetailResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(readApiErrorMessage(e, 'Failed to load person profile'));
    }
  }

  @override
  Future<AddFaceSamplesResponseResource> addPersonFaceSample(
    AddPersonFaceSampleCommand command,
  ) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        command.imagePath,
        filename: 'sample.jpg',
      ),
    });

    try {
      final response = await dio.post(
        '/api/v1/identity/persons/${command.personId}/samples',
        data: formData,
      );

      return AddFaceSamplesResponseResource.fromJson(
        Map<String, dynamic>.from(response.data as Map),
      );
    } on DioException catch (e) {
      throw Exception(readApiErrorMessage(e, 'Failed to add face sample'));
    }
  }
}
