import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/shell_controller.dart';

/// Yörünge Platformu - Kozmik Alt Navigasyon Çubuğu.
/// 2. Kural: Renkler `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ShellBottomNav extends StatelessWidget {
  final ShellController controller;

  const ShellBottomNav({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return ValueListenableBuilder<int>(
      valueListenable: controller.currentIndex,
      builder: (context, activeIndex, _) {
        return NavigationBar(
          selectedIndex: activeIndex,
          onDestinationSelected: controller.changeTab,
          backgroundColor: colors.surface,
          indicatorColor: colors.primary.withValues(alpha: 0.18),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.psychology_outlined),
              selectedIcon: Icon(Icons.psychology_rounded),
              label: 'Mentor',
            ),
            NavigationDestination(
              icon: Icon(Icons.trending_up_outlined),
              selectedIcon: Icon(Icons.trending_up_rounded),
              label: 'Yatırımcılar',
            ),
            NavigationDestination(
              icon: Icon(Icons.rocket_launch_outlined),
              selectedIcon: Icon(Icons.rocket_launch_rounded),
              label: 'Programlar',
            ),
            NavigationDestination(
              icon: Icon(Icons.groups_outlined),
              selectedIcon: Icon(Icons.groups_rounded),
              label: 'Topluluk',
            ),
          ],
        );
      },
    );
  }
}
