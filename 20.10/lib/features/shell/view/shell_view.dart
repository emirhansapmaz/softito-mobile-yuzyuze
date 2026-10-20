import 'package:flutter/material.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/starfield_background.dart';
import '../../auth/widget/logout_button.dart';
import '../../mentor/view/mentor_view.dart';
import '../../programlar/view/programlar_view.dart';
import '../../topluluk/view/topluluk_view.dart';
import '../../yatirimci/view/yatirimci_view.dart';
import '../controller/shell_controller.dart';
import '../widget/profile_badge.dart';
import '../widget/shell_bottom_nav.dart';
import '../widget/theme_toggle_button.dart';

/// Yörünge Platformu - Ana Navigasyon (Shell) Görünümü.
/// 4 ana modülü `IndexedStack` ile durum kaybı olmadan yönetir.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ShellView extends StatefulWidget {
  const ShellView({super.key});

  @override
  State<ShellView> createState() => _ShellViewState();
}

class _ShellViewState extends State<ShellView> {
  late final ShellController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ShellController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yörünge Platformu', style: context.textTheme.titleMedium),
        actions: const [
          ThemeToggleButton(),
          ProfileBadge(),
          LogoutButton(),
        ],
      ),
      body: StarfieldBackground(
        child: ValueListenableBuilder<int>(
          valueListenable: _controller.currentIndex,
          builder: (context, activeIndex, _) {
            return IndexedStack(
              index: activeIndex,
              children: const [
                MentorView(),
                YatirimciView(),
                ProgramlarView(),
                ToplulukView(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: ShellBottomNav(controller: _controller),
    );
  }
}
