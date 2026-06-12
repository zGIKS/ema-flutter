class SessionManager {
  SessionManager._();
  
  static String? _token;
  static String? _username;
  static String? _userId;

  static void saveSession({
    required String token,
    required String username,
    required String userId,
  }) {
    _token = token;
    _username = username;
    _userId = userId;
  }

  static void clearSession() {
    _token = null;
    _username = null;
    _userId = null;
  }

  static String? get token => _token;
  static String? get username => _username;
  static String? get userId => _userId;
  static bool get isAuthenticated => _token != null;
}
