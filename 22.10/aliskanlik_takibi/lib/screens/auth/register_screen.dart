import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../services/firebase/auth_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  // Şifre gücü (0: Boş, 1: Zayıf, 2: Orta, 3: Güçlü)
  int _passwordStrength = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength(String password) {
    if (password.isEmpty) {
      setState(() => _passwordStrength = 0);
      return;
    }

    int score = 0;
    if (password.length >= AppConstants.minPasswordLength) score++;
    if (password.contains(RegExp(r'[A-Z]')) && password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]')) || password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    setState(() => _passwordStrength = score);
  }

  Color _getStrengthColor() {
    switch (_passwordStrength) {
      case 1:
        return AppColors.danger;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.success;
      default:
        return Colors.transparent;
    }
  }

  String _getStrengthText() {
    switch (_passwordStrength) {
      case 1:
        return 'Zayıf';
      case 2:
        return 'Orta';
      case 3:
        return 'Güçlü';
      default:
        return '';
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await _authService.registerWithEmail(
        adSoyad: _nameController.text,
        kullaniciAdi: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        telefon: _phoneController.text,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Hesabınız başarıyla oluşturuldu!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      Navigator.pop(context); // Giriş ekranına veya ana akışa dön
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
        title: const Text('Yeni Hesap Oluştur'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Aramıza Katıl',
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 6),
                Text(
                  'Yeni alışkanlıklar edinmek ve hedeflerine ulaşmak için profilini oluştur.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 24),

                // Ad Soyad
                CustomTextField(
                  controller: _nameController,
                  label: 'Ad Soyad',
                  hintText: 'Ahmet Yılmaz',
                  prefixIcon: Icons.person_outline_rounded,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Lütfen adınızı ve soyadınızı girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kullanıcı Adı (Liderlik tablosunda benzersiz)
                CustomTextField(
                  controller: _usernameController,
                  label: 'Kullanıcı Adı',
                  hintText: 'ahmetyilmaz',
                  prefixIcon: Icons.alternate_email_rounded,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Lütfen bir kullanıcı adı belirleyin.';
                    }
                    if (val.trim().length < 3) {
                      return 'Kullanıcı adı en az 3 karakter olmalıdır.';
                    }
                    if (val.contains(' ')) {
                      return 'Kullanıcı adı boşluk içeremez.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // E-posta
                CustomTextField(
                  controller: _emailController,
                  label: 'E-posta Adresi',
                  hintText: 'ahmet@example.com',
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
                const SizedBox(height: 16),

                // Telefon (Opsiyonel)
                CustomTextField(
                  controller: _phoneController,
                  label: 'Telefon Numarası (Opsiyonel)',
                  hintText: '05xx xxx xx xx',
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Şifre
                CustomTextField(
                  controller: _passwordController,
                  label: 'Şifre',
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _obscurePassword,
                  onChanged: _calculatePasswordStrength,
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
                      return 'Lütfen bir şifre girin.';
                    }
                    if (val.length < AppConstants.minPasswordLength) {
                      return 'Şifre en az ${AppConstants.minPasswordLength} karakter olmalıdır.';
                    }
                    return null;
                  },
                ),

                // Şifre Güvenlik Göstergesi (Soft Pastel Bar)
                if (_passwordStrength > 0) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: _passwordStrength / 3,
                            minHeight: 5,
                            backgroundColor: isDark
                                ? AppColors.surfaceVariantDark
                                : AppColors.borderLight,
                            valueColor: AlwaysStoppedAnimation<Color>(_getStrengthColor()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _getStrengthText(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStrengthColor(),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),

                // Şifre Tekrar
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Şifre Tekrar',
                  hintText: '••••••••',
                  prefixIcon: Icons.lock_reset_rounded,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      size: 20,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                    },
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Lütfen şifrenizi tekrar girin.';
                    }
                    if (val != _passwordController.text) {
                      return 'Girdiğiniz şifreler eşleşmiyor.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Kayıt Ol Butonu
                CustomButton(
                  text: 'Kayıt Ol',
                  isLoading: _isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 16),

                // Zaten hesabın var mı?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Zaten hesabın var mı?',
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Giriş Yap'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
