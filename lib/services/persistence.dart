
import 'package:shared_preferences/shared_preferences.dart';

class PersistenceService {
  static const String _kAppState = 'app_state';
  static const String _kThemeMode = 'theme_mode';

  final SharedPreferences prefs;
  PersistenceService(this.prefs);

  Future<void> saveString(String key, String value) async {
    await prefs.setString(key, value);
  }

  String? getString(String key) => prefs.getString(key);

  Future<void> saveInt(String key, int value) async {
    await prefs.setInt(key, value);
  }

  int? getInt(String key) => prefs.getInt(key);

  Future<void> saveAppState(String json) async => saveString(_kAppState, json);
  String? loadAppState() => getString(_kAppState);

  Future<void> saveThemeMode(int modeIndex) async => saveInt(_kThemeMode, modeIndex);
  int? loadThemeMode() => getInt(_kThemeMode);
}
