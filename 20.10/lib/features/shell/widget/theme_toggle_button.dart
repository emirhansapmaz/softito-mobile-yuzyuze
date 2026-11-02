// Flutter materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// BuildContext tema uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';
// Singleton tema yöneticisini içeri alıyoruz
import '../../../core/theme/theme_controller.dart';

/// "Derin Uzay" ve "Şafak Fırlatışı" temaları arasında geçiş sağlayan buton.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ThemeToggleButton extends StatelessWidget {
  // Sabit kurucu metot
  const ThemeToggleButton({super.key});

  // Arayüzü inşa eden build metodu
  @override
  Widget build(BuildContext context) {
    // Koyu mod açık mı kontrolü
    final isDark = context.isDarkMode;
    // İkon butonunu döndürüyoruz
    return IconButton(
      // İpucu açıklaması
      tooltip: isDark ? 'Şafak Fırlatışı Teması' : 'Derin Uzay Teması',
      // Koyuysa güneş, açıksa ay ikonu
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: context.spaceColors.primary,
      ), // Icon kapanışı
      // Tıklanınca temayı değiştir
      onPressed: ThemeController.instance.toggleTheme,
    ); // IconButton kapanışı
  } // build metodu kapanışı
} // ThemeToggleButton sınıfı kapanışı
