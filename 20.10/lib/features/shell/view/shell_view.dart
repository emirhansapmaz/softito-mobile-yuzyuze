// Flutter materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// BuildContext tema ve tipografi yardımcı uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';
// Yıldız alanı arka plan bileşenini içeri alıyoruz
import '../../../core/widgets/starfield_background.dart';
// Oturumu kapat butonu bileşenini içeri alıyoruz
import '../../auth/widget/logout_button.dart';
// 1. Sekme: Mentor ekranı
import '../../mentor/view/mentor_view.dart';
// 3. Sekme: Programlar ekranı
import '../../programlar/view/programlar_view.dart';
// 4. Sekme: Topluluk ekranı
import '../../topluluk/view/topluluk_view.dart';
// 2. Sekme: Yatırımcılar ekranı
import '../../yatirimci/view/yatirimci_view.dart';
// Shell navigasyon kontrolcüsü
import '../controller/shell_controller.dart';
// Fikir durumu profil rozeti
import '../widget/profile_badge.dart';
// Alt navigasyon çubuğu
import '../widget/shell_bottom_nav.dart';
// Tema değiştirme butonu
import '../widget/theme_toggle_button.dart';

/// Yörünge Platformu - Ana Navigasyon (Shell) Görünümü.
/// 4 ana modülü `IndexedStack` ile durum kaybı olmadan yönetir.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ShellView extends StatefulWidget {
  // Sabit kurucu metot
  const ShellView({super.key});

  // Durum nesnesini bağlayan metot
  @override
  State<ShellView> createState() => _ShellViewState();
} // ShellView sınıfı kapanışı

// Ana navigasyon ekranının durum sınıfı
class _ShellViewState extends State<ShellView> {
  // Navigasyon kontrolcüsü nesnesi
  late final ShellController _controller;

  // Başlangıç metodu
  @override
  void initState() {
    super.initState();
    // Kontrolcüyü ayağa kaldırıyoruz
    _controller = ShellController();
  } // initState metodu kapanışı

  // Bellekten temizleme metodu
  @override
  void dispose() {
    // Kontrolcüyü serbest bırakıyoruz
    _controller.dispose();
    super.dispose();
  } // dispose metodu kapanışı

  // Arayüzü inşa eden build metodu (40 satır kuralına uygun)
  @override
  Widget build(BuildContext context) {
    // Scaffold iskeletini döndürüyoruz
    return Scaffold(
      // Üst uygulama çubuğu
      appBar: AppBar(
        title: Text('Yörünge Platformu', style: context.textTheme.titleMedium),
        actions: const [
          // Açık/koyu tema butonu
          ThemeToggleButton(),
          // Fikir durumu rozet butonu
          ProfileBadge(),
          // Çıkış yap butonu
          LogoutButton(),
        ], // actions kapanışı
      ), // AppBar kapanışı
      // Yıldızlı uzay gövdesi
      body: StarfieldBackground(
        // Aktif sekme değiştikçe IndexedStack'i güncelleyen builder
        child: ValueListenableBuilder<int>(
          valueListenable: _controller.currentIndex,
          builder: (context, activeIndex, _) {
            // Durum kaybını önleyen katmanlı sekme yapısı
            return IndexedStack(
              index: activeIndex,
              children: const [
                // Sekme 0: Mentorlar
                MentorView(),
                // Sekme 1: Yatırımcılar
                YatirimciView(),
                // Sekme 2: Destek Programları
                ProgramlarView(),
                // Sekme 3: Topluluk Gönderileri
                ToplulukView(),
              ], // IndexedStack çocukları kapanışı
            ); // IndexedStack kapanışı
          }, // builder kapanışı
        ), // ValueListenableBuilder kapanışı
      ), // StarfieldBackground kapanışı
      // Alt navigasyon çubuğu
      bottomNavigationBar: ShellBottomNav(controller: _controller),
    ); // Scaffold kapanışı
  } // build metodu kapanışı
} // _ShellViewState sınıfı kapanışı
