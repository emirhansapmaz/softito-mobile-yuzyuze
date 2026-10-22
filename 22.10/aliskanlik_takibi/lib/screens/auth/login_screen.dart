import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../services/firebase/auth_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../main_navigation_screen.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.signInWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Giriş başarılı! Hoş geldiniz.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      // Ana Ekrana yönlendir
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
      );
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Minimalist Logo & İllüstrasyon Alanı
                  Center(
                    child: Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceVariantDark
                            : AppColors.sageGreen.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.sageGreen.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.spa_rounded,
                          size: 44,
                          color: isDark ? AppColors.sageGreen : AppColors.deepSage,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Başlık & Açıklama
                  Text(
                    AppConstants.appName,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Dengeli bir yaşam ve güçlü irade için tekrar hoş geldin.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 36),

                  // E-posta Girdisi
                  CustomTextField(
                    controller: _emailController,
                    label: 'E-posta Adresi',
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
                  const SizedBox(height: 18),

                  // Şifre Girdisi
                  CustomTextField(
                    controller: _passwordController,
                    label: 'Şifre',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 20,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Lütfen şifrenizi girin.';
                      }
                      return null;
                    },
                  ),

                  // Şifremi Unuttum Bağlantısı
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Şifremi Unuttum',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.sageGreen : AppColors.deepSage,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Giriş Yap Butonu
                  CustomButton(
                    text: 'Giriş Yap',
                    isLoading: _isLoading,
                    onPressed: _handleLogin,
                  ),
                  const SizedBox(height: 24),

                  // Kayıt Ol Yönlendirmesi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hesabın yok mu?',
                        style: theme.textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text('Hemen Kayıt Ol'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
