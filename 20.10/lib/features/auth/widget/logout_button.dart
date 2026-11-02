// Flutter'ın temel materyal tasarım kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Standart boşluk ve kenarlık yarıçapı değerlerini içeri alıyoruz
import '../../../core/constants/app_spacing.dart';
// BuildContext tema ve tipografi yardımcı uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';
// Kimlik doğrulama kontrolcüsünü içeri alıyoruz
import '../controller/auth_controller.dart';
// Giriş ekranı görünümünü içeri alıyoruz
import '../view/auth_view.dart';

/// Yörünge Platformu - Çıkış Yap Butonu.
/// AppBar veya profil ekranlarında oturum kapatmak için kullanılır.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class LogoutButton extends StatelessWidget {
  // Sabit kurucu metot
  const LogoutButton({super.key});

  // Kullanıcıdan onay alıp oturumu kapatan asenkron fonksiyon
  Future<void> _confirmAndLogout(BuildContext context) async {
    // Uzay tema renkleri
    final colors = context.spaceColors;
    // Tipografi teması
    final textTheme = context.textTheme;

    // Onay iletişim kutusunu ekrana açıyoruz
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        // İletişim kutusu yapısı
        return AlertDialog(
          // Kart arka plan rengi
          backgroundColor: colors.cardBackground,
          // Yuvarlatılmış köşeler ve kenarlık çizgisi
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            side: BorderSide(color: colors.border),
          ), // RoundedRectangleBorder kapanışı
          // Başlık metni
          title: Text(
            'Oturumu Kapat',
            style: textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ), // copyWith kapanışı
          ), // Text kapanışı
          // Onay sorusu metni
          content: Text(
            'Hesabınızdan çıkış yapmak ve giriş ekranına dönmek istediğinize emin misiniz?',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ), // copyWith kapanışı
          ), // Text kapanışı
          // Aksiyon butonları
          actions: [
            // Vazgeç butonu
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Vazgeç',
                style: textTheme.labelLarge?.copyWith(
                  color: colors.textSecondary,
                ), // copyWith kapanışı
              ), // Text kapanışı
            ), // TextButton kapanışı
            // Çıkış yap onay butonu
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error.withValues(alpha: 0.15),
                foregroundColor: colors.error,
                elevation: 0,
                side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
              ), // ElevatedButton.styleFrom kapanışı
              child: const Text('Çıkış Yap'),
            ), // ElevatedButton kapanışı
          ], // actions listesi kapanışı
        ); // AlertDialog kapanışı
      }, // builder kapanışı
    ); // showDialog kapanışı

    // Kullanıcı onayladıysa ve ekran halen aktifse
    if (shouldLogout == true && context.mounted) {
      // Oturumu temizle
      await AuthController.instance.logout();
      // Ekran halen aktifse giriş sayfasına yönlendir
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (context) => const AuthView()),
          (route) => false,
        ); // pushAndRemoveUntil kapanışı
      } // if mounted sonu
    } // if shouldLogout sonu
  } // _confirmAndLogout metodu kapanışı

  // Arayüzü çizen build metodu
  @override
  Widget build(BuildContext context) {
    // Tema renkleri
    final colors = context.spaceColors;

    // Çıkış yap ikon butonu
    return IconButton(
      icon: Icon(Icons.logout_rounded, color: colors.textSecondary, size: 20),
      tooltip: 'Oturumu Kapat',
      onPressed: () => _confirmAndLogout(context),
    ); // IconButton kapanışı
  } // build metodu kapanışı
} // LogoutButton sınıfı kapanışı
