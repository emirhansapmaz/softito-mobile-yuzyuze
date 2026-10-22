import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/firebase/auth_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _authService = AuthService();
  TimeOfDay _reminderTime = const TimeOfDay(hour: 21, minute: 0);

  Future<void> _handlePasswordReset(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$email adresine şifre sıfırlama bağlantısı gönderildi.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              minimumSize: const Size(90, 42),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _authService.signOut();
    }
  }

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null) {
      setState(() => _reminderTime = picked);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Günlük hatırlatma saati ${_reminderTime.format(context)} olarak ayarlandı.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap ve Ayarlar'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _authService.getCurrentUserProfile(),
        builder: (context, snapshot) {
          final profile = snapshot.data;
          final user = _authService.currentUser;
          final displayName = profile?.adSoyad ?? user?.displayName ?? 'Kullanıcı';
          final email = profile?.email ?? user?.email ?? '';
          final username = profile?.kullaniciAdi ?? 'kullanici';

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Profil Kartı
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: isDark
                          ? AppColors.surfaceVariantDark
                          : AppColors.sageGreen.withValues(alpha: 0.2),
                      child: Text(
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : '?',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.deepSage,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '@$username',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepSage,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // BÖLÜM 1: HESAP AYARLARI
              Text(
                'Hesap Ayarları',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildSettingTile(
                icon: Icons.lock_reset_rounded,
                title: 'Şifre Değiştir',
                subtitle: 'E-postana şifre yenileme bağlantısı gönder',
                onTap: () => _handlePasswordReset(email),
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // BÖLÜM 2: UYGULAMA AYARLARI
              Text(
                'Uygulama Tercihleri',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildSettingTile(
                icon: Icons.notifications_active_outlined,
                title: 'Günlük Hatırlatıcı',
                subtitle: 'Günün görevlerini hatırlatma saati: ${_reminderTime.format(context)}',
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                onTap: _pickReminderTime,
                isDark: isDark,
              ),
              const SizedBox(height: 36),

              // Çıkış Yap Butonu (Kırmızı)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dangerLight,
                  foregroundColor: AppColors.danger,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: AppColors.danger.withValues(alpha: 0.3)),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, color: AppColors.danger, size: 20),
                label: const Text(
                  'Oturumu Kapat',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                ),
                onPressed: _handleSignOut,
              ),
              const SizedBox(height: 16),

              // Uygulama Sürüm Bilgisi
              Center(
                child: Text(
                  'Alışkanlık Takibi v1.0.0 • Softito',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.sageGreen.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.sageGreen : AppColors.deepSage,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14.5),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
