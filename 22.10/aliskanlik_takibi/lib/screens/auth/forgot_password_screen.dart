import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../services/firebase/auth_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _authService = AuthService();

  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.sendPasswordResetEmail(_emailController.text);
      if (!mounted) return;
      setState(() => _isSuccess = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Şifre Sıfırlama'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: _isSuccess
              ? _buildSuccessView(context, isDark)
              : _buildFormView(context, theme, isDark),
        ),
      ),
    );
  }

  Widget _buildFormView(BuildContext context, ThemeData theme, bool isDark) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // İkon Kutusu
          Center(
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.sereneBlue.withValues(alpha: 0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.sereneBlue.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.lock_reset_rounded,
                  size: 38,
                  color: isDark ? AppColors.sereneBlue : AppColors.deepSage,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Şifreni mi Unuttun?',
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 8),
          Text(
            'Kayıtlı e-posta adresini gir. Sana şifreni güvenle sıfırlayabileceğin bir bağlantı göndereceğiz.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),

          // E-posta Girdisi
          CustomTextField(
            controller: _emailController,
            label: 'Kayıtlı E-posta Adresi',
            hintText: 'ornek@email.com',
            prefixIcon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Lütfen e-posta adresinizi girin.';
              }
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(val.trim())) {
                return 'Lütfen geçerli bir e-posta adresi girin.';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Gönder Butonu
          CustomButton(
            text: 'Şifre Sıfırlama Bağlantısı Gönder',
            isLoading: _isLoading,
            onPressed: _handleResetPassword,
          ),
          const SizedBox(height: 16),

          // İptal / Geri Dön
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Giriş Ekranına Dön'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessView(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.mark_email_read_rounded,
                size: 42,
                color: AppColors.success,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Bağlantı Gönderildi!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22),
        ),
        const SizedBox(height: 10),
        Text(
          '${_emailController.text} adresine şifre sıfırlama bağlantısı iletildi. Lütfen gelen kutunu (ve spam klasörünü) kontrol et.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.4,
              ),
        ),
        const SizedBox(height: 36),
        CustomButton(
          text: 'Giriş Ekranına Dön',
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
