import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static String get apiBaseUrl {
    return (dotenv.env['API_BASE_URL'] ?? dotenv.env['BACKEND_URL'] ?? 'http://10.0.2.2:8080')
        .replaceAll(RegExp(r'/$'), '');
  }

  static const Duration httpConnectTimeout = Duration(seconds: 20);
  static const Duration httpReceiveTimeout = Duration(seconds: 30);
}
