import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance = SharedPreferencesService._internal();

  factory SharedPreferencesService() => _instance;

  SharedPreferences? _preferences;

  SharedPreferencesService._internal();

  /// Initializes the shared preferences instance.
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  /// Saves a value as a string.
  Future<bool> saveString(String key, String value) async {
    return await _preferences?.setString(key, value) ?? false;
  }

  /// Retrieves a string value by key.
  String? getString(String key) {
    return _preferences?.getString(key);
  }

  /// Saves a value as a boolean.
  Future<bool> saveBool(String key, bool value) async {
    return await _preferences?.setBool(key, value) ?? false;
  }

  /// Retrieves a boolean value by key.
  bool? getBool(String key) {
    return _preferences?.getBool(key);
  }

  /// Clears a specific key-value pair.
  Future<bool> remove(String key) async {
    return await _preferences?.remove(key) ?? false;
  }

  /// Clears all stored preferences.
  Future<bool> clear() async {
    return await _preferences?.clear() ?? false;
  }
}
