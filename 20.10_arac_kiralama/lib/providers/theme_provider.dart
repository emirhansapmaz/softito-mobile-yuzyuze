// Flutter materyal arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';

/// Uygulamanın Açık / Koyu tema tercihini yöneten ve dinleyicilere bildiren Provider sınıfı.
class ThemeProvider extends ChangeNotifier {
  /// Mevcut tema modu (Varsayılan olarak cihazın sistem temasına uyumlu 'ThemeMode.system')
  ThemeMode _themeMode = ThemeMode.system;

  /// Aktif tema modunu dışarıya aktaran getter
  ThemeMode get themeMode => _themeMode;

  /// Temanın anlık olarak koyu (dark) modda olup olmadığını kontrol eden mantıksal getter
  bool get isDarkMode {
    // Eğer tema sistem moduna ayarlıysa, cihazın mevcut sistem parlaklık ayarını kontrol ediyoruz.
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    // Sistem modu değilse doğrudan _themeMode'un koyu mod olup olmadığına bakıyoruz.
    return _themeMode == ThemeMode.dark;
  }

  /// Açık ve Koyu tema arasında hızlı geçiş yapan metot
  void toggleTheme() {
    if (_themeMode == ThemeMode.dark) {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.dark;
    }
    // Arayüzün yeni temayla yeniden çizilmesi için dinleyicileri uyarıyoruz.
    notifyListeners();
  }

  /// İstenilen tema modunu (system, light, dark) doğrudan ayarlayan metot
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    // Değişikliği widget'lara bildiriyoruz.
    notifyListeners();
  }
}
