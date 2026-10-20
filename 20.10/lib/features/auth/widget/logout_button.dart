import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../controller/auth_controller.dart';
import '../view/auth_view.dart';

/// Yörünge Platformu - Çıkış Yap Butonu.
/// AppBar veya profil ekranlarında oturum kapatmak için kullanılır.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  Future<void> _confirmAndLogout(BuildContext context) async {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: colors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            side: BorderSide(color: colors.border),
          ),
          title: Text(
            'Oturumu Kapat',
            style: textTheme.titleMedium?.copyWith(
              color: colors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Hesabınızdan çıkış yapmak ve giriş ekranına dönmek istediğinize emin misiniz?',
            style: textTheme.bodyMedium?.copyWith(
              color: colors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Vazgeç',
                style: textTheme.labelLarge?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.error.withValues(alpha: 0.15),
                foregroundColor: colors.error,
                elevation: 0,
                side: BorderSide(color: colors.error.withValues(alpha: 0.5)),
              ),
              child: const Text('Çıkış Yap'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true && context.mounted) {
      await AuthController.instance.logout();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (context) => const AuthView()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return IconButton(
      icon: Icon(Icons.logout_rounded, color: colors.textSecondary, size: 20),
      tooltip: 'Oturumu Kapat',
      onPressed: () => _confirmAndLogout(context),
    );
  }
}
