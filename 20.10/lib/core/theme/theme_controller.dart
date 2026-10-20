import 'package:flutter/material.dart';

/// Yörünge Platformu - Saf Dart ve ValueNotifier ile yönetilen tema denetleyicisi.
/// 1. Kural gereği: Harici paket kullanılmaz, yalnızca yerleşik ValueNotifier kullanılır.
class ThemeController {
  ThemeController._();

  /// Tekil örnek (Singleton)
  static final ThemeController instance = ThemeController._();

  /// Anlık tema modunu (`ThemeMode.dark` veya `ThemeMode.light`) tutan reaktif bildirimci.
  /// Varsayılan: "Derin Uzay" (ThemeMode.dark)
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  /// Anlık tema modu
  ThemeMode get currentTheme => themeModeNotifier.value;

  /// Koyu tema ("Derin Uzay") aktif mi?
  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  /// Temayı "Derin Uzay" (Dark) ve "Şafak Fırlatışı" (Light) arasında değiştirir
  void toggleTheme() {
    themeModeNotifier.value =
        isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }

  /// İstenen temayı doğrudan ayarlar
  void setTheme(ThemeMode mode) {
    if (themeModeNotifier.value != mode) {
      themeModeNotifier.value = mode;
    }
  }

  /// Denetleyiciyi bellekten temizleme
  void dispose() {
    themeModeNotifier.dispose();
  }
}
