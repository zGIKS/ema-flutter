import 'dart:convert';

class SessionManager {
  SessionManager._();
  
  static String? _token;
  static String? _username;
  static String? _userId;
  static String? _role;

  static void saveSession({
    required String token,
    required String username,
    required String userId,
    required String role,
  }) {
    _token = token;
    _username = username;
    _userId = userId;
    
    String resolvedRole = role;
    if (resolvedRole.isEmpty) {
      try {
        final parts = token.split('.');
        if (parts.length == 3) {
          final payload = parts[1];
          final normalized = base64Url.normalize(payload);
          final decodedBytes = base64Url.decode(normalized);
          final payloadString = utf8.decode(decodedBytes);
          final Map<String, dynamic> payloadMap = jsonDecode(payloadString);
          if (payloadMap.containsKey('role')) {
            resolvedRole = payloadMap['role'] as String;
          }
        }
      } catch (_) {
        // Fallback
      }
    }
    
    _role = resolvedRole;
  }

  static void clearSession() {
    _token = null;
    _username = null;
    _userId = null;
    _role = null;
  }

  static String? get token => _token;
  static String? get username => _username;
  static String? get userId => _userId;
  static String? get role => _role;
  static bool get isAuthenticated => _token != null;
  static bool get isAdmin => _role?.toLowerCase() == 'admin';
}

