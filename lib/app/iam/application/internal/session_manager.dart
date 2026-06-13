import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  SessionManager._();

  static const _tokenKey = 'ema.session.token';
  static const _usernameKey = 'ema.session.username';
  static const _userIdKey = 'ema.session.user_id';
  static const _roleKey = 'ema.session.role';
  
  static String? _token;
  static String? _username;
  static String? _userId;
  static String? _role;

  static Future<void> loadPersistedSession() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(_tokenKey);
    _username = prefs.getString(_usernameKey);
    _userId = prefs.getString(_userIdKey);
    _role = prefs.getString(_roleKey);
  }

  static Future<void> saveSession({
    required String token,
    required String username,
    required String userId,
    required String role,
  }) async {
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

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_roleKey, resolvedRole);
  }

  static Future<void> clearSession() async {
    _token = null;
    _username = null;
    _userId = null;
    _role = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_roleKey);
  }

  static String? get token => _token;
  static String? get username => _username;
  static String? get userId => _userId;
  static String? get role => _role;
  static bool get isAuthenticated => _token != null;
  static bool get isAdmin => _role?.toLowerCase() == 'admin';
}
