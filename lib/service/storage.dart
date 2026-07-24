import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;
  static late SharedPreferences _prefs;

  StorageService._();

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 存储 List<String>
  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  static List<String> getStringList(String key) {
    List<String>? value = _prefs.getStringList(key);
    return value ?? [];
  }

  static void clear() => _prefs.clear();
}
