import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/theme/theme_controller.dart';

/// "Derin Uzay" ve "Şafak Fırlatışı" temaları arasında geçiş sağlayan buton.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return IconButton(
      tooltip: isDark ? 'Şafak Fırlatışı Teması' : 'Derin Uzay Teması',
      icon: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        color: context.spaceColors.primary,
      ),
      onPressed: ThemeController.instance.toggleTheme,
    );
  }
}
