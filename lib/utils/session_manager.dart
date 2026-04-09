import 'package:shared_preferences/shared_preferences.dart';

/// Persists login session across app restarts using SharedPreferences.
class SessionManager {
  static const _keyId    = 'session_id';
  static const _keyRole  = 'session_role';
  static const _keyPw    = 'session_pw';

  static Future<void> saveSession({
    required String id,
    required String role,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyId,   id);
    await prefs.setString(_keyRole, role);
    await prefs.setString(_keyPw,   password);
  }

  static Future<Map<String, String>?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final id   = prefs.getString(_keyId);
    final role = prefs.getString(_keyRole);
    final pw   = prefs.getString(_keyPw);
    if (id != null && role != null && pw != null) {
      return {'id': id, 'role': role, 'password': pw};
    }
    return null;
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyId);
    await prefs.remove(_keyRole);
    await prefs.remove(_keyPw);
  }
}
