import 'package:flutter/material.dart';

/// Harici paket kullanılmadan, salt ValueNotifier ile yönetilen tema denetleyicisi.
class ThemeController {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  /// Uygulamanın anlık temasını tutan ve dinleyen reaktif bildirimci.
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.light);

  /// Anlık tema modu
  ThemeMode get currentTheme => themeModeNotifier.value;

  /// Koyu tema aktif mi?
  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  /// Temayı aydınlık/koyu arasında değiştirir
  void toggleTheme() {
    themeModeNotifier.value =
        isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  /// Belirli bir tema modunu uygular
  void setTheme(ThemeMode mode) {
    themeModeNotifier.value = mode;
  }

  /// Denetleyiciyi serbest bırakma
  void dispose() {
    themeModeNotifier.dispose();
  }
}
