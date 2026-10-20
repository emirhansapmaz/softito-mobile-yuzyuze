// Flutter materyal tasarım kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Durum yönetimi için Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Uygulama renk paletini içe aktarıyoruz.
import '../../core/theme/app_colors.dart';
// Kimlik doğrulama Provider'ını içe aktarıyoruz.
import '../../providers/auth_provider.dart';
// Tema tercihi Provider'ını içe aktarıyoruz.
import '../../providers/theme_provider.dart';
// Özel buton bileşenlerini içe aktarıyoruz.
import '../../widgets/custom_button.dart';
// Özel form metin kutusu bileşenini içe aktarıyoruz.
import '../../widgets/custom_text_field.dart';
// Logo bileşenini içe aktarıyoruz.
import '../../widgets/sem_logo.dart';
// Giriş başarılı olunca yönlendirilecek Admin ekranını içe aktarıyoruz.
import '../admin/admin_dashboard_screen.dart';
// Giriş başarılı olunca yönlendirilecek Müşteri ana ekranını içe aktarıyoruz.
import '../customer/customer_main_screen.dart';
// Kayıt ol ekranını içe aktarıyoruz.
import 'register_screen.dart';

/// Kullanıcıların (Müşteri veya Admin) e-posta ve şifreyle sisteme giriş yaptığı ekran.
class LoginScreen extends StatefulWidget {
  /// LoginScreen kurucu metodu (Constructor)
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Formun geçerlilik (validation) kontrolünü sağlayan genel anahtar
  final _formKey = GlobalKey<FormState>();
  
  /// E-posta metin giriş denetleyicisi
  final _emailController = TextEditingController();
  
  /// Şifre metin giriş denetleyicisi
  final _passwordController = TextEditingController();

  /// Şifrenin gizli mi (noktalı) yoksa görünür mü olduğunu belirten durum
  bool _isObscurePassword = true;

  @override
  void dispose() {
    // Bellek sızıntılarını önlemek için controller nesnelerini siliyoruz.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ==========================================
  // GİRİŞ YAPMA FONKSİYONU
  // ==========================================
  /// Formu doğrular, kimlik doğrulama isteği gönderir ve kullanıcı rolüne göre ilgili ekrana yönlendirir.
  Future<void> _handleLogin() async {
    // Form alanlarında hata varsa işlemi durduruyoruz.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Provider üzerinden auth servisine erişiyoruz (yeniden çizim tetiklememesi için listen: false).
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Giriş işlemini başlatıyoruz.
    final success = await authProvider.login(email: email, password: password);

    // Giriş başarılı ve ekran hala açıksa rol kontrolü yapıyoruz.
    if (success && mounted) {
      if (authProvider.isAdmin) {
        // Eğer kullanıcı Admin ise Admin Yönetim Paneline yönlendiriyoruz.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        );
      } else {
        // Eğer kullanıcı normal Müşteri ise Müşteri Ana Ekranına yönlendiriyoruz.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const CustomerMainScreen()),
        );
      }
    }
  }

  // ==========================================
  // HIZLI DOLDURMA YARDIMCISI (ÖDEV/TEST İÇİN)
  // ==========================================
  /// Değerlendiren kişinin hızlıca Admin veya Müşteri olarak giriş yapabilmesi için form alanlarını doldurur.
  void _fillQuickCredentials({required bool isAdmin}) {
    setState(() {
      if (isAdmin) {
        _emailController.text = 'admin@semauto.com';
        _passwordController.text = 'admin123';
      } else {
        _emailController.text = 'ahmet@gmail.com';
        _passwordController.text = '123456';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Aktif tema durumunu sorguluyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      // Üst uygulama çubuğu: Logo ve tema değiştirme butonu
      appBar: AppBar(
        title: const SemLogo(fontSize: 22),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Temayı Değiştir',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Ortalanmış SEM Auto Logosu ve Slogan
                  const Center(
                    child: SemLogo(
                      fontSize: 38,
                      showSubtitle: true,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Başlık ve karşılama açıklaması
                  Text(
                    'Hesabınıza Giriş Yapın',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Seyahatinizi planlamak veya yönetmek için bilgilerinizi girin.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ==========================================
                  // E-POSTA GİRİŞ ALANI
                  // ==========================================
                  CustomTextField(
                    controller: _emailController,
                    labelText: 'E-posta Adresi',
                    hintText: 'ornek@semauto.com',
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    // E-posta regex doğrulaması
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'E-posta adresi boş bırakılamaz';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val.trim())) {
                        return 'Geçerli bir e-posta adresi giriniz';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // ==========================================
                  // ŞİFRE GİRİŞ ALANI
                  // ==========================================
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Şifre',
                    hintText: '••••••••',
                    prefixIcon: Icons.lock_outline_rounded,
                    obscureText: _isObscurePassword,
                    textInputAction: TextInputAction.done,
                    // Şifreyi göster/gizle ikonu
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _isObscurePassword = !_isObscurePassword);
                      },
                    ),
                    // Şifre uzunluk kontrolü
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Şifre boş bırakılamaz';
                      }
                      if (val.length < 5) {
                        return 'Şifre en az 5 karakter olmalıdır';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // ==========================================
                  // GİRİŞ YAP BUTONU
                  // ==========================================
                  CustomElevatedButton(
                    text: 'Giriş Yap',
                    isLoading: authProvider.isLoading,
                    onPressed: _handleLogin,
                    icon: Icons.login_rounded,
                  ),
                  const SizedBox(height: 16),

                  // ==========================================
                  // KAYIT OL BUTONU (Yeni kullanıcılar için)
                  // ==========================================
                  CustomOutlinedButton(
                    text: 'Hesabınız Yok mu? Kayıt Olun',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    icon: Icons.person_add_outlined,
                  ),
                  const SizedBox(height: 32),

                  // ==========================================
                  // HIZLI TEST / DEĞERLENDİRME BİLGİ KUTUSU
                  // ==========================================
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDarkElevated : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.tips_and_updates_outlined,
                              size: 18,
                              color: isDark ? AppColors.accentBlue : AppColors.primaryBlue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Ödev / Test Kolaylığı (Hızlı Doldur):',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.textLight : AppColors.textDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            // Hızlı Müşteri Butonu
                            Expanded(
                              child: InkWell(
                                onTap: () => _fillQuickCredentials(isAdmin: false),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person, size: 16, color: AppColors.primaryBlue),
                                      SizedBox(width: 6),
                                      Text(
                                        'Müşteri',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Hızlı Admin Butonu
                            Expanded(
                              child: InkWell(
                                onTap: () => _fillQuickCredentials(isAdmin: true),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: AppColors.error.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shield_rounded, size: 16, color: AppColors.error),
                                      SizedBox(width: 6),
                                      Text(
                                        'Admin',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
