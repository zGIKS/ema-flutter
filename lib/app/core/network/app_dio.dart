import 'package:dio/dio.dart';

import '../constants/app_constants.dart';

import '../../iam/application/internal/session_manager.dart';

Dio createAppDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.httpConnectTimeout,
      receiveTimeout: AppConstants.httpReceiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = SessionManager.token;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
}

String readApiErrorMessage(DioException error, String fallbackMessage) {
  final type = error.type;
  if (type == DioExceptionType.connectionError || type == DioExceptionType.connectionTimeout) {
    return 'Connection error. Please check your internet and try again.';
  }

  if (type == DioExceptionType.receiveTimeout || type == DioExceptionType.sendTimeout) {
    return 'Request timed out. Please try again.';
  }

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

String readFriendlyErrorMessage(Object error, {String fallbackMessage = 'Something went wrong'}) {
  if (error is DioException) {
    return readApiErrorMessage(error, fallbackMessage);
  }

  final text = error.toString();
  if (text.startsWith('Exception: ')) {
    return text.replaceFirst('Exception: ', '').trim();
  }

  if (text.trim().isNotEmpty) {
    return text;
  }

  return fallbackMessage;
}
