// lib/core/storage/token_manager.dart

import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  TokenManager._();

  static const String _tokenKey = 'auth_token';

  // ── حفظ التوكن ──
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // ── جلب التوكن ──
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // ── مسح التوكن ──
  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}
