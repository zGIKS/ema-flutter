import 'package:dio/dio.dart';

class ApiErrorResource implements Exception {
  final String message;
  final int? statusCode;

  const ApiErrorResource({required this.message, this.statusCode});

  factory ApiErrorResource.fromDioException(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data['detail'] is String) {
      return ApiErrorResource(message: data['detail'] as String, statusCode: status);
    }
    return ApiErrorResource(message: e.message ?? 'Network error', statusCode: status);
  }

  @override
  String toString() => statusCode == null ? message : '($statusCode) $message';
}

