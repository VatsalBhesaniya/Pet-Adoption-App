import 'package:adopt_pets/manager/app_storage_manager.dart';
import 'package:flutter/material.dart';

class ThemeChanger extends ChangeNotifier {
  ThemeChanger({
    required this.appStorageManager,
  });

  final AppStorageManager appStorageManager;

  ThemeMode getThemeMode() {
    final String mode = appStorageManager.getThemeMode();
    if (mode == AppThemeMode.light.title) {
      return ThemeMode.light;
    }
    if (mode == AppThemeMode.dark.title) {
      return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  void setTheme(AppThemeMode themeMode) {
    appStorageManager.toggleThemeMode(themeMode);
    notifyListeners();
  }
}
