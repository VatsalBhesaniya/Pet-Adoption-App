import 'package:shared_preferences/shared_preferences.dart';

class AppStorageManager {
  AppStorageManager({
    required this.sharedPreferences,
  }) {
    initStorage();
  }

  SharedPreferences sharedPreferences;
  final String themeMode = 'themeMode';

  void initStorage() {
    final bool isThemeModeSelected = sharedPreferences.containsKey(themeMode);
    if (!isThemeModeSelected) {
      sharedPreferences.setString(themeMode, AppThemeMode.system.title);
    }
  }

  void toggleThemeMode(AppThemeMode mode) {
    sharedPreferences.setString(themeMode, mode.title);
  }

  String getThemeMode() {
    return sharedPreferences.getString(themeMode) ?? AppThemeMode.system.title;
  }

  void setAdoptedPet(String key, String value) {
    sharedPreferences.setString(key, value);
  }

  Future<String?> getAdoptedPet(String key) async {
    return sharedPreferences.getString(key);
  }
}

enum AppThemeMode { system, light, dark }

extension AppThemeModeExtension on AppThemeMode {
  String get title {
    switch (this) {
      case AppThemeMode.system:
        return 'System';
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
    }
  }
}
