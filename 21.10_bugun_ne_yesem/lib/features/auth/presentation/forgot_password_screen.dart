import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _retrievedHint;
  bool _isLoadingHint = false;

  @override
  void dispose() {
    _emailController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _lookupHint() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen önce e-posta adresinizi giriniz.')),
      );
      return;
    }

    setState(() => _isLoadingHint = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isLoadingHint = false;
        _retrievedHint = 'İpucu: İlk evcil hayvanınızın adı (Örn: pamuk)';
      });
    });
  }

  void _onResetPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Şifre sıfırlama bağlantısı e-posta adresinize gönderildi!'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifremi Unuttum'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Şifre Yenileme & Kolay Giriş',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Hesabına ait e-posta adresini girerek şifreni sıfırlayabilir veya önceden belirlediğin kolay giriş ipucunu görüntüleyebilirsin.',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 28),

              CustomTextField(
                controller: _emailController,
                label: 'Kayıtlı E-posta Adresi',
                hint: 'ornek@email.com',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),

              // Kolay Giriş İpucu Kartı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.lightbulb_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Kolay Giriş İpucu',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _isLoadingHint ? null : _lookupHint,
                          child: _isLoadingHint
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('İpucumu Getir'),
                        ),
                      ],
                    ),
                    if (_retrievedHint != null) ...[
                      const Divider(height: 20),
                      Text(
                        _retrievedHint!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),

              CustomTextField(
                controller: _newPasswordController,
                label: 'Yeni Şifre',
                hint: '••••••••',
                prefixIcon: Icons.lock_reset_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Yeni Şifre (Tekrar)',
                hint: '••••••••',
                prefixIcon: Icons.lock_reset_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Şifreyi Güncelle & Sıfırla',
                icon: Icons.send_rounded,
                onPressed: _onResetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
