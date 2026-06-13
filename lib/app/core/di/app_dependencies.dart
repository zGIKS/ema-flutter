import 'package:dio/dio.dart';

import '../network/app_dio.dart';

class AppDependencies {
  AppDependencies._();

  static Dio? _dio;

  static Dio createDio() => _dio ??= createAppDio();
}
