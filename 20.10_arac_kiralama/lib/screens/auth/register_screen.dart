import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/contract_dialog.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/sem_logo.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _tcNoController = TextEditingController();
  final _drivingLicenseController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isObscurePassword = true;
  bool _isAgreementAccepted = false;
  bool _isNfcSimulating = false;
  bool _isNfcVerified = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _tcNoController.dispose();
    _drivingLicenseController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // NFC İle Ehliyet Okuma Simülasyonu
  void _simulateNfcRead() {
    setState(() => _isNfcSimulating = true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.nfc_rounded,
                size: 56,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'NFC Okuyucu Aktif',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Lütfen yeni nesil çipli sürücü belgenizi telefonun arka üst kısmına yaklaştırın...',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );

    // 2 saniye sonra NFC okumayı tamamla ve bilgileri doldur
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.of(context).pop(); // Diyaloğu kapat

      setState(() {
        _isNfcSimulating = false;
        _isNfcVerified = true;
        if (_firstNameController.text.isEmpty) _firstNameController.text = 'Emirhan';
        if (_lastNameController.text.isEmpty) _lastNameController.text = 'Sapmaz';
        _tcNoController.text = '29384756102';
        _drivingLicenseController.text = 'TR-34-889921';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text('Ehliyet çipi NFC ile başarıyla okundu ve doğrulandı!'),
              ),
            ],
          ),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  // Kullanıcı Sözleşmesi Modalı
  Future<void> _openContractModal() async {
    final accepted = await ContractDialog.show(context);
    if (accepted == true) {
      setState(() {
        _isAgreementAccepted = true;
      });
    }
  }

  // Kayıt İşlemi
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isAgreementAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen devam etmek için kullanıcı sözleşmesini onaylayın.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

    final success = await authProvider.register(
      fullName: fullName,
      email: _emailController.text,
      tcNo: _tcNoController.text,
      drivingLicenseNo: _drivingLicenseController.text,
      password: _passwordController.text,
      isNfcVerified: _isNfcVerified,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hesabınız başarıyla oluşturuldu! Hoş geldiniz, $fullName.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(); // Login ekranına dön
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const SemLogo(fontSize: 22),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Başlık
                Text(
                  'Yeni Hesap Oluştur',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Ayrıcalıklı araç kiralama deneyimine hemen başlayın.',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 24),

                // NFC Ehliyet Okutma Kartı / Butonu
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isNfcVerified
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.primaryBlue.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _isNfcVerified
                          ? AppColors.success
                          : AppColors.primaryBlue.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isNfcVerified ? AppColors.success : AppColors.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isNfcVerified ? Icons.check_rounded : Icons.nfc_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isNfcVerified ? 'Ehliyet Doğrulandı' : 'Hızlı Doğrulama',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: _isNfcVerified
                                    ? AppColors.success
                                    : (isDark ? AppColors.textLight : AppColors.textDark),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _isNfcVerified
                                  ? 'Bilgiler başarıyla aktarıldı'
                                  : 'Çipli ehliyetinizi NFC ile aktarın',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton.icon(
                        onPressed: _isNfcSimulating ? null : _simulateNfcRead,
                        icon: const Icon(Icons.contactless_outlined, size: 18),
                        label: Text(_isNfcVerified ? 'Yenile' : 'NFC İle Okut'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size.zero,
                          foregroundColor: _isNfcVerified ? AppColors.success : AppColors.primaryBlue,
                          side: BorderSide(
                            color: _isNfcVerified ? AppColors.success : AppColors.primaryBlue,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Ad & Soyad
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _firstNameController,
                        labelText: 'Ad',
                        hintText: 'Adınız',
                        prefixIcon: Icons.person_outline_rounded,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Ad zorunludur';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CustomTextField(
                        controller: _lastNameController,
                        labelText: 'Soyad',
                        hintText: 'Soyadınız',
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'Soyad zorunludur';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // T.C. Kimlik Numarası (Regex ve 11 hane kontrolü)
                CustomTextField(
                  controller: _tcNoController,
                  labelText: 'T.C. Kimlik Numarası',
                  hintText: '11 haneli kimlik numaranız',
                  prefixIcon: Icons.badge_outlined,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'TC Kimlik No zorunludur';
                    }
                    if (!RegExp(r'^[1-9]{1}[0-9]{10}$').hasMatch(val.trim())) {
                      return 'Geçerli 11 haneli TC Kimlik Numarası giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Ehliyet Bilgileri
                CustomTextField(
                  controller: _drivingLicenseController,
                  labelText: 'Sürücü Belgesi / Ehliyet No',
                  hintText: 'Örn: TR-34-123456',
                  prefixIcon: Icons.credit_card_outlined,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Ehliyet bilgisi zorunludur';
                    }
                    if (val.trim().length < 5) {
                      return 'Lütfen geçerli bir ehliyet seri numarası girin';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // E-posta
                CustomTextField(
                  controller: _emailController,
                  labelText: 'E-posta Adresi',
                  hintText: 'ornek@semauto.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'E-posta adresi zorunludur';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                      return 'Geçerli bir e-posta adresi giriniz';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Şifre
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Şifre',
                  hintText: 'En az 6 karakter',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: _isObscurePassword,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() => _isObscurePassword = !_isObscurePassword);
                    },
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Şifre zorunludur';
                    }
                    if (val.length < 6) {
                      return 'Şifre en az 6 karakter olmalıdır';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kullanıcı Sözleşmesi Checkbox & Link
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _isAgreementAccepted,
                      activeColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      onChanged: (val) {
                        setState(() {
                          _isAgreementAccepted = val ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: _openContractModal,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(
                                text: 'Kullanıcı Sözleşmesini',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryBlue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              TextSpan(
                                text: ' okudum ve onaylıyorum.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isDark ? AppColors.textLight : AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Kayıt Ol Butonu (Sözleşme onaylanmadan pasif)
                CustomElevatedButton(
                  text: 'Kayıt Ol',
                  isLoading: authProvider.isLoading,
                  onPressed: _isAgreementAccepted ? _handleRegister : null,
                  icon: Icons.person_add_alt_1_rounded,
                ),
                const SizedBox(height: 20),

                // Zaten hesabı var mı?
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Zaten bir hesabınız var mı? ',
                        style: TextStyle(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Giriş Yap',
                          style: TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
