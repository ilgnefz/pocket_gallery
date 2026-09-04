import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._();
  factory StorageService() => _instance;
  static late SharedPreferences _prefs;

  StorageService._();

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> setBool(String key, bool value) async =>
      await _prefs.setBool(key, value);

  static bool? getBool(String key) => _prefs.getBool(key);

  static Future<bool> setInt(String key, int value) async =>
      await _prefs.setInt(key, value);

  static int? getInt(String key) => _prefs.getInt(key);

  static Future<bool> setStringList(String key, List<String> value) async =>
      await _prefs.setStringList(key, value);

  static List<String> getStringList(String key) =>
      _prefs.getStringList(key) ?? [];

  static void clear() => _prefs.clear();
}
