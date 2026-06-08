import 'package:dio/dio.dart';

import '../network/app_dio.dart';

class AppDependencies {
  AppDependencies._();

  static Dio createDio() => createAppDio();
}
