// Flutter'ın temel arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';

/// Yörünge Platformu - Saf Dart ve ValueNotifier ile yönetilen tema denetleyicisi.
/// 1. Kural gereği: Harici paket kullanılmaz, yalnızca yerleşik ValueNotifier kullanılır.
class ThemeController {
  // Sınıfın dışarıdan new ile üretilmesini engelleyen özel gizli kurucu
  ThemeController._();

  /// Tekil örnek (Singleton) yapısı ile her yerden aynı nesneye erişim
  static final ThemeController instance = ThemeController._();

  /// Anlık tema modunu (`ThemeMode.dark` veya `ThemeMode.light`) tutan reaktif bildirimci.
  /// Varsayılan: "Derin Uzay" (ThemeMode.dark)
  final ValueNotifier<ThemeMode> themeModeNotifier =
      ValueNotifier<ThemeMode>(ThemeMode.dark);

  /// Anlık tema modunu dışa aktaran getter
  ThemeMode get currentTheme => themeModeNotifier.value;

  /// Koyu tema ("Derin Uzay") aktif mi kontrol eden pratik getter
  bool get isDarkMode => themeModeNotifier.value == ThemeMode.dark;

  /// Temayı "Derin Uzay" (Dark) ve "Şafak Fırlatışı" (Light) arasında değiştiren fonksiyon
  void toggleTheme() {
    // Koyuysa açık yap, açıksa koyu yap
    themeModeNotifier.value =
        isDarkMode ? ThemeMode.light : ThemeMode.dark;
  } // toggleTheme metodu kapanışı

  /// İstenen temayı doğrudan ayarlayan fonksiyon
  void setTheme(ThemeMode mode) {
    // Mevcut moddan farklıysa yeni modu ata ve dinleyicileri uyar
    if (themeModeNotifier.value != mode) {
      themeModeNotifier.value = mode;
    } // if sonu
  } // setTheme metodu kapanışı

  /// Denetleyiciyi bellekten temizleme metodu
  void dispose() {
    // ValueNotifier nesnesini serbest bırakıyoruz
    themeModeNotifier.dispose();
  } // dispose metodu kapanışı
} // ThemeController sınıfı kapanışı
