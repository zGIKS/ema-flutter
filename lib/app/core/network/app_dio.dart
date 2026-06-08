import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

Dio createAppDio() {
  return Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.httpConnectTimeout,
      receiveTimeout: AppConstants.httpReceiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );
}

String readApiErrorMessage(DioException error, String fallbackMessage) {
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
