import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:ema/contexts/identification/infrastructure/api/gateways/identification.gateway.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/api_error.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/identification_response.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/register_response.resource.dart';
import 'package:ema/contexts/identification/interfaces/rest/resources/registered_persons_page_response.resource.dart';

class IdentificationHttpGateway implements IdentificationGateway {
  final Dio _dio;

  IdentificationHttpGateway(this._dio);

  @override
  Future<IdentificationResponseResource> identify({required Uint8List imageBytes}) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(imageBytes, filename: 'image.jpg'),
      });

      final res = await _dio.post<Map<String, dynamic>>(
        '/identify',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = res.data;
      if (data == null) {
        throw const ApiErrorResource(message: 'Respuesta vacía del servidor');
      }
      return IdentificationResponseResource.fromJson(data);
    } on DioException catch (e) {
      throw ApiErrorResource.fromDioException(e);
    }
  }

  @override
  Future<RegisterResponseResource> register({
    required String firstName,
    required String lastName,
    required String dni,
    required List<Uint8List> images,
  }) async {
    try {
      final formData = FormData();
      formData.fields.addAll([
        MapEntry('first_name', firstName),
        MapEntry('last_name', lastName),
        MapEntry('dni', dni),
      ]);

      for (var i = 0; i < images.length; i++) {
        formData.files.add(MapEntry(
          'files',
          MultipartFile.fromBytes(images[i], filename: 'face_$i.jpg'),
        ));
      }

      final res = await _dio.post<Map<String, dynamic>>(
        '/register',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );

      final data = res.data;
      if (data == null) {
        throw const ApiErrorResource(message: 'Respuesta vacía del servidor');
      }
      return RegisterResponseResource.fromJson(data);
    } on DioException catch (e) {
      throw ApiErrorResource.fromDioException(e);
    }
  }

  @override
  Future<RegisteredPersonsPageResponseResource> getRegisteredPersons({
    required int page,
    required int pageSize,
  }) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>(
        '/persons',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      final data = res.data;
      if (data == null) {
        throw const ApiErrorResource(message: 'Respuesta vacía del servidor');
      }
      return RegisteredPersonsPageResponseResource.fromJson(data);
    } on DioException catch (e) {
      throw ApiErrorResource.fromDioException(e);
    }
  }
}
