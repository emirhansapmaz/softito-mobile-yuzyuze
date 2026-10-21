import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../auth/presentation/login_screen.dart';
import '../../home/presentation/app_settings_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController(text: 'Ahmet Yılmaz');
  final _emailController = TextEditingController(text: 'ahmet@example.com');
  final _phoneController = TextEditingController(text: '+90 555 123 45 67');
  final _hintController = TextEditingController(text: 'İlk evcil hayvanım: pamuk');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _hintController.dispose();
    super.dispose();
  }

  void _onSaveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil bilgileri başarıyla güncellendi!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesap & Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Avatar
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 54,
                        color: AppColors.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _nameController.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _emailController.text,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 28),

              // Profile Form Fields
              CustomTextField(
                controller: _nameController,
                label: 'Ad Soyad',
                prefixIcon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _emailController,
                label: 'E-posta',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneController,
                label: 'Telefon Numarası',
                prefixIcon: Icons.phone_outlined,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _hintController,
                label: 'Kolay Giriş İpucu (Password Hint)',
                prefixIcon: Icons.lightbulb_outline,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Bilgileri Güncelle',
                icon: Icons.save_outlined,
                onPressed: _onSaveProfile,
              ),
              const SizedBox(height: 12),

              // Uygulama Ayarları Butonu
              CustomButton(
                text: 'Uygulama Ayarları',
                icon: Icons.tune_rounded,
                isOutlined: true,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AppSettingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Logout Button
              SizedBox(
                height: 52,
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: Icon(
                    Icons.logout_rounded,
                    color: isDark ? const Color(0xFFEF5350) : const Color(0xFFD32F2F),
                    size: 20,
                  ),
                  label: Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFEF5350) : const Color(0xFFD32F2F),
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFFE53935).withValues(alpha: 0.12)
                        : const Color(0xFFFFF0F0),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFFE53935).withValues(alpha: 0.35)
                          : const Color(0xFFFFCDD2),
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _onLogout,
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
