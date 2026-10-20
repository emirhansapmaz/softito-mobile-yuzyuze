// Flutter materyal tasarım kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Durum yönetimi için Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Uygulama tema renklerini içe aktarıyoruz.
import '../../core/theme/app_colors.dart';
// Kimlik doğrulama ve kullanıcı yönetim servisini içe aktarıyoruz.
import '../../providers/auth_provider.dart';
// Kullanıcı sözleşmesi açılır penceresini içe aktarıyoruz.
import '../../widgets/contract_dialog.dart';
// Özel buton bileşenlerini içe aktarıyoruz.
import '../../widgets/custom_button.dart';
// Özel metin giriş kutusu bileşenini içe aktarıyoruz.
import '../../widgets/custom_text_field.dart';
// Logo bileşenini içe aktarıyoruz.
import '../../widgets/sem_logo.dart';

/// Yeni müşteri hesabı oluşturma, NFC ile ehliyet okutma ve sözleşme onayı ekranı.
class RegisterScreen extends StatefulWidget {
  /// RegisterScreen kurucu metodu (Constructor)
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Formun doğruluk durumunu denetleyen global anahtar
  final _formKey = GlobalKey<FormState>();

  /// Ad giriş alanı kontrolcüsü
  final _firstNameController = TextEditingController();
  
  /// Soyad giriş alanı kontrolcüsü
  final _lastNameController = TextEditingController();
  
  /// E-posta giriş alanı kontrolcüsü
  final _emailController = TextEditingController();
  
  /// T.C. Kimlik No giriş alanı kontrolcüsü
  final _tcNoController = TextEditingController();
  
  /// Sürücü Belgesi / Ehliyet seri numarası kontrolcüsü
  final _drivingLicenseController = TextEditingController();
  
  /// Şifre giriş alanı kontrolcüsü
  final _passwordController = TextEditingController();

  /// Şifre karakterlerinin gizli olup olmadığını belirten bayrak
  bool _isObscurePassword = true;
  
  /// Kullanıcı sözleşmesinin onaylanıp onaylanmadığı durumu
  bool _isAgreementAccepted = false;
  
  /// NFC okuma simülasyonunun devam edip etmediğini belirten bayrak
  bool _isNfcSimulating = false;
  
  /// Ehliyetin NFC ile doğrulanıp doğrulanmadığını belirten bayrak
  bool _isNfcVerified = false;

  @override
  void dispose() {
    // Form denetleyicilerini bellekten siliyoruz.
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _tcNoController.dispose();
    _drivingLicenseController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ==========================================
  // NFC İLE EHLİYET OKUMA SİMÜLASYONU
  // ==========================================
  /// Yeni çipli sürücü belgelerini telefonun NFC anteniyle okuma sürecini simüle eder.
  void _simulateNfcRead() {
    setState(() => _isNfcSimulating = true);

    // Ekranda NFC okuma animasyonu ve yönlendirme içeren bir AlertDialog açıyoruz.
    showDialog(
      context: context,
      barrierDismissible: false, // Kullanıcı dışarı tıklayıp kapatamaz.
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            // NFC anten simgesi ve yuvarlak zemin
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
            // İşlem sürdüğünü belirten yükleniyor göstergesi
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          ],
        ),
      ),
    );

    // 2 saniye sonra NFC okumayı tamamlayıp sahte çip verilerini form alanlarına otomatik dolduruyoruz.
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (!mounted) return;
      Navigator.of(context).pop(); // NFC diyaloğunu kapatıyoruz.

      setState(() {
        _isNfcSimulating = false;
        _isNfcVerified = true;
        // Eğer ad-soyad boşsa çipten okunan değerleri giriyoruz.
        if (_firstNameController.text.isEmpty) _firstNameController.text = 'Emirhan';
        if (_lastNameController.text.isEmpty) _lastNameController.text = 'Sapmaz';
        _tcNoController.text = '29384756102';
        _drivingLicenseController.text = 'TR-34-889921';
      });

      // Başarılı doğrulama bildirim çubuğu (SnackBar) gösteriyoruz.
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

  // ==========================================
  // KULLANICI SÖZLEŞMESİ PENCERESİ
  // ==========================================
  /// Sözleşme modalını açar ve kullanıcı onaylarsa onay kutusunu işaretler.
  Future<void> _openContractModal() async {
    final accepted = await ContractDialog.show(context);
    if (accepted == true) {
      setState(() {
        _isAgreementAccepted = true;
      });
    }
  }

  // ==========================================
  // KAYIT TAMAMLAMA İŞLEMİ
  // ==========================================
  /// Formu denetler, sözleşme kontrolü yapar ve yeni hesabı oluşturur.
  Future<void> _handleRegister() async {
    // Form doğrulama kontrolü
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Sözleşme onaylanmamışsa hata mesajı verip işlemi engelliyoruz.
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
    // Ad ve soyadı tek bir tam ad dizesi olarak birleştiriyoruz.
    final fullName = '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';

    // Provider üzerinden kayıt işlemini çağırıyoruz.
    final success = await authProvider.register(
      fullName: fullName,
      email: _emailController.text,
      tcNo: _tcNoController.text,
      drivingLicenseNo: _drivingLicenseController.text,
      password: _passwordController.text,
      isNfcVerified: _isNfcVerified,
    );

    // Kayıt başarılıysa kullanıcıya bilgi verip giriş ekranına döndürüyoruz.
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hesabınız başarıyla oluşturuldu! Hoş geldiniz, $fullName.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop(); // Login ekranına geri dönüş
    }
  }

  @override
  Widget build(BuildContext context) {
    // Aktif temanın koyu mod durumunu kontrol ediyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const SemLogo(fontSize: 22),
        // Geri dönüş butonu
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
                // Ekran Başlığı ve Açıklaması
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

                // ==========================================
                // NFC İLE EHLİYET DOĞRULAMA KARTI
                // ==========================================
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
                      // Durum ikonu (Tik veya NFC dalgaları)
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
                      // Bilgilendirme metinleri
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
                      // NFC Okutma veya Yenileme Butonu
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

                // ==========================================
                // AD VE SOYAD ALANLARI
                // ==========================================
                Row(
                  children: [
                    // Ad kutusu
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
                    // Soyad kutusu
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

                // ==========================================
                // T.C. KİMLİK NUMARASI ALANI
                // ==========================================
                // 11 hane ve sıfır ile başlamama kuralı regex ile denetlenir.
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

                // ==========================================
                // SÜRÜCÜ BELGESİ / EHLİYET NUMARASI
                // ==========================================
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

                // ==========================================
                // E-POSTA ALANI
                // ==========================================
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

                // ==========================================
                // ŞİFRE ALANI
                // ==========================================
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

                // ==========================================
                // KULLANICI SÖZLEŞMESİ ONAY KUTUSU (Checkbox)
                // ==========================================
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

                // ==========================================
                // KAYIT OL BUTONU (Sözleşme onaysızsa devre dışı)
                // ==========================================
                CustomElevatedButton(
                  text: 'Kayıt Ol',
                  isLoading: authProvider.isLoading,
                  onPressed: _isAgreementAccepted ? _handleRegister : null,
                  icon: Icons.person_add_alt_1_rounded,
                ),
                const SizedBox(height: 20),

                // ==========================================
                // GİRİŞ YAP EKRANINA GERİ DÖNÜŞ BAĞLANTISI
                // ==========================================
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
