// Flutter materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// BuildContext tema uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';
// Shell ana denetleyicisini içeri alıyoruz
import '../controller/shell_controller.dart';

/// Yörünge Platformu - Kozmik Alt Navigasyon Çubuğu.
/// 2. Kural: Renkler `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ShellBottomNav extends StatelessWidget {
  // Shell navigasyon kontrolcüsü
  final ShellController controller;

  // ShellBottomNav kurucu metodu
  const ShellBottomNav({super.key, required this.controller});

  // Arayüzü inşa eden build metodu
  @override
  Widget build(BuildContext context) {
    // Uzay renk paletini alıyoruz
    final colors = context.spaceColors;

    // Aktif sekme değiştikçe yeniden çizilmek için ValueListenableBuilder
    return ValueListenableBuilder<int>(
      valueListenable: controller.currentIndex,
      builder: (context, activeIndex, _) {
        // Material 3 NavigationBar bileşeni
        return NavigationBar(
          // Seçili sekme indeksi
          selectedIndex: activeIndex,
          // Sekmeye tıklandığında kontrolcüye bildir
          onDestinationSelected: controller.changeTab,
          // Arka plan yüzey rengi
          backgroundColor: colors.surface,
          // Aktif sekme vurgu rengi
          indicatorColor: colors.primary.withValues(alpha: 0.18),
          // 4 adet ana sekme hedefi
          destinations: const [
            // 1. Sekme: Mentor
            NavigationDestination(
              icon: Icon(Icons.psychology_outlined),
              selectedIcon: Icon(Icons.psychology_rounded),
              label: 'Mentor',
            ), // NavigationDestination kapanışı
            // 2. Sekme: Yatırımcılar
            NavigationDestination(
              icon: Icon(Icons.trending_up_outlined),
              selectedIcon: Icon(Icons.trending_up_rounded),
              label: 'Yatırımcılar',
            ), // NavigationDestination kapanışı
            // 3. Sekme: Programlar
            NavigationDestination(
              icon: Icon(Icons.rocket_launch_outlined),
              selectedIcon: Icon(Icons.rocket_launch_rounded),
              label: 'Programlar',
            ), // NavigationDestination kapanışı
            // 4. Sekme: Topluluk
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups_rounded),
              label: 'Topluluk',
            ), // NavigationDestination kapanışı
          ], // destinations listesi kapanışı
        ); // NavigationBar kapanışı
      }, // builder kapanışı
    ); // ValueListenableBuilder kapanışı
  } // build metodu kapanışı
} // ShellBottomNav sınıfı kapanışı
