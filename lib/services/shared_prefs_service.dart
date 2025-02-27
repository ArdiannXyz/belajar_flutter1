import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _preferences;
  static const String _emailKey = 'user_email';

  SharedPrefsService._();

  static Future<SharedPrefsService> getInstance() async {
    _instance ??= SharedPrefsService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> saveEmail(String email) async {
    return await _preferences?.setString(_emailKey, email) ?? false;
  }

  String? getEmail() {
    return _preferences?.getString(_emailKey);
  }

  Future<bool> clearEmail() async {
    return await _preferences?.remove(_emailKey) ?? false;
  }
}
