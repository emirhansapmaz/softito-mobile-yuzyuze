// Flutter'ın temel materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Standart boşluk ve kenarlık yarıçapı değerlerini içeri alıyoruz
import '../../../core/constants/app_spacing.dart';
// BuildContext tema ve tipografi yardımcı uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';
// Yıldız alanı arka plan bileşenini içeri alıyoruz
import '../../../core/widgets/starfield_background.dart';
// Giriş yapıldıktan sonra geçilecek ana kabuk ekranı (ShellView)
import '../../shell/view/shell_view.dart';
// Kimlik doğrulama kontrolcüsünü içeri alıyoruz
import '../controller/auth_controller.dart';
// Mock test kullanıcı verilerini içeri alıyoruz
import '../data/mock_auth_data.dart';
// Kullanıcı rolü numaralandırmasını içeri alıyoruz
import '../models/user_role.dart';
// Özel giriş metin kutusu bileşenini içeri alıyoruz
import '../widget/auth_text_field.dart';
// Özel giriş yap butonunu içeri alıyoruz
import '../widget/login_button.dart';
// Rol seçim kartı bileşenini içeri alıyoruz
import '../widget/role_selection_card.dart';

/// Yörünge Platformu - Kimlik Doğrulama ve Rol Seçim Ekranı.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class AuthView extends StatefulWidget {
  // Sabit kurucu metot
  const AuthView({super.key});

  // Durum nesnesini oluşturan metot
  @override
  State<AuthView> createState() => _AuthViewState();
} // AuthView sınıfı kapanışı

// Kimlik doğrulama ekranının durum sınıfı
class _AuthViewState extends State<AuthView> {
  // Kimlik doğrulama denetleyicisi
  late final AuthController _authController;
  // E-posta metin kutusu kontrolcüsü
  late final TextEditingController _emailController;
  // Şifre metin kutusu kontrolcüsü
  late final TextEditingController _passwordController;

  // Ekran ilk açıldığında çalışan başlangıç fonksiyonu
  @override
  void initState() {
    // Üst sınıfın initState metodunu çağırıyoruz
    super.initState();
    // Singleton controller örneğini alıyoruz
    _authController = AuthController.instance;
    // Varsayılan olarak girişimci e-postasını dolduruyoruz
    _emailController = TextEditingController(text: kMockEntrepreneur.email);
    // Varsayılan test şifresini dolduruyoruz
    _passwordController = TextEditingController(text: 'yorunge123');

    // Rol değiştiğinde e-posta alanını senkronize etmek için dinleyici ekliyoruz
    _authController.selectedRoleNotifier.addListener(_syncEmailWithRole);
  } // initState metodu kapanışı

  // Seçilen role göre formdaki e-postayı otomatik güncelleyen fonksiyon
  void _syncEmailWithRole() {
    // Seçili rolü oku
    final role = _authController.selectedRole;
    // Rol boşsa çık
    if (role == null) return;
    // O role sahip mock kullanıcıyı bul
    final user = kMockUsers.firstWhere(
      (u) => u.role == role,
      orElse: () => kMockEntrepreneur,
    ); // firstWhere kapanışı
    // E-posta kutusuna ata
    _emailController.text = user.email;
  } // _syncEmailWithRole metodu kapanışı

  // Ekrandan çıkıldığında kaynakları temizleme
  @override
  void dispose() {
    // Rol dinleyicisini kaldır
    _authController.selectedRoleNotifier.removeListener(_syncEmailWithRole);
    // E-posta kontrolcüsünü bellekten at
    _emailController.dispose();
    // Şifre kontrolcüsünü bellekten at
    _passwordController.dispose();
    // Üst sınıf dispose çağrısı
    super.dispose();
  } // dispose metodu kapanışı

  // Giriş yap butonuna basıldığında çalışan fonksiyon
  Future<void> _handleLogin() async {
    // Giriş isteğini gönderiyoruz
    final success = await _authController.login(
      _emailController.text,
      _passwordController.text,
    ); // login çağrısı kapanışı
    // Giriş başarılıysa ve ekran halen aktifse
    if (success && mounted) {
      // Ana kabuk ekranına yönlendir ve önceki sayfayı yığından temizle
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (context) => const ShellView()),
      ); // pushReplacement kapanışı
    } // if sonu
  } // _handleLogin metodu kapanışı

  // Arayüzü inşa eden build metodu (40 satır kuralına uygun)
  @override
  Widget build(BuildContext context) {
    // İskelet widget'ı döndürüyoruz
    return Scaffold(
      // Yıldızlı uzay arka planı
      body: StarfieldBackground(
        // Güvenli alan
        child: SafeArea(
          // Kaydırılabilir gövde
          child: SingleChildScrollView(
            // Kenar boşlukları 24 piksel
            padding: AppSpacing.paddingAllLg,
            // Dikey sıralama kolonu
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo ve karşılama başlığı
                const _AuthHeader(),
                // 24 piksel dikey boşluk
                AppSpacing.gapH24,
                // Rol seçim kartları bölümü
                _RoleSelectionSection(controller: _authController),
                // 24 piksel dikey boşluk
                AppSpacing.gapH24,
                // Giriş formu ve buton bölümü
                _AuthFormSection(
                  authController: _authController,
                  emailController: _emailController,
                  passwordController: _passwordController,
                  onLogin: _handleLogin,
                ), // _AuthFormSection kapanışı
              ], // Column çocukları kapanışı
            ), // Column kapanışı
          ), // SingleChildScrollView kapanışı
        ), // SafeArea kapanışı
      ), // StarfieldBackground kapanışı
    ); // Scaffold kapanışı
  } // build metodu kapanışı
} // _AuthViewState sınıfı kapanışı

/// Başlık ve Logo Bölümü
class _AuthHeader extends StatelessWidget {
  // Sabit kurucu metot
  const _AuthHeader();

  // Başlık arayüzünü çizen metot
  @override
  Widget build(BuildContext context) {
    // Tema renkleri
    final colors = context.spaceColors;
    // Tipografi teması
    final textTheme = context.textTheme;

    return Column(
      children: [
        // Roket logolu dairesel kutu
        _buildLogo(colors),
        // 12 piksel dikey boşluk
        AppSpacing.gapH12,
        // YÖRÜNGE başlığı
        Text(
          'YÖRÜNGE',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: colors.textPrimary,
          ), // copyWith kapanışı
        ), // Text kapanışı
        // 4 piksel dikey boşluk
        AppSpacing.gapH4,
        // Alt slogan açıklaması
        Text(
          'Girişimcilik ve Yatırım Ekosistemi',
          style: textTheme.bodyMedium?.copyWith(
            color: colors.textSecondary,
          ), // copyWith kapanışı
          textAlign: TextAlign.center,
        ), // Text kapanışı
      ], // Column çocukları kapanışı
    ); // Column kapanışı
  } // build metodu kapanışı

  // Dairesel parıldayan roket logosunu üreten yardımcı metot
  Widget _buildLogo(dynamic colors) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: colors.primary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.glow.withValues(alpha: 0.5),
            blurRadius: 20,
          ), // BoxShadow kapanışı
        ], // boxShadow listesi kapanışı
      ), // BoxDecoration kapanışı
      child: Icon(Icons.rocket_launch_rounded, size: 32, color: colors.primary),
    ); // Container kapanışı
  } // _buildLogo metodu kapanışı
} // _AuthHeader sınıfı kapanışı

/// Rol Seçimi Bölümü
class _RoleSelectionSection extends StatelessWidget {
  // Kimlik kontrolcüsü
  final AuthController controller;

  // Kurucu metot
  const _RoleSelectionSection({required this.controller});

  // Rol seçim alanını çizen metot
  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.spaceColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bölüm başlığı
        Text(
          'Giriş Yapmak İstediğiniz Rolü Seçin',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.textPrimary,
          ), // copyWith kapanışı
        ), // Text kapanışı
        // 12 piksel dikey boşluk
        AppSpacing.gapH12,
        // Seçili rolün değişimini dinleyen builder
        ValueListenableBuilder<UserRole?>(
          valueListenable: controller.selectedRoleNotifier,
          builder: (context, selectedRole, _) {
            return Column(
              // Enum'daki tüm rolleri kartlara dönüştürüyoruz
              children: UserRole.values.map((role) {
                return RoleSelectionCard(
                  role: role,
                  isSelected: selectedRole == role,
                  onTap: () => controller.selectRole(role),
                ); // RoleSelectionCard kapanışı
              }).toList(), // map ve toList kapanışı
            ); // Column kapanışı
          }, // builder kapanışı
        ), // ValueListenableBuilder kapanışı
      ], // Column çocukları kapanışı
    ); // Column kapanışı
  } // build metodu kapanışı
} // _RoleSelectionSection sınıfı kapanışı

/// Giriş Formu ve Buton Bölümü
class _AuthFormSection extends StatelessWidget {
  final AuthController authController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onLogin;

  const _AuthFormSection({
    required this.authController,
    required this.emailController,
    required this.passwordController,
    required this.onLogin,
  }); // Kurucu metod kapanışı

  // Form arayüzünü çizen metot
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // E-posta metin giriş alanı
        AuthTextField(
          controller: emailController,
          label: 'E-Posta Adresi',
          hint: 'ornek@yorunge.io',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ), // AuthTextField kapanışı
        // 16 piksel boşluk
        AppSpacing.gapH16,
        // Şifre metin giriş alanı
        AuthTextField(
          controller: passwordController,
          label: 'Şifre',
          hint: '••••••••',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
        ), // AuthTextField kapanışı
        // 24 piksel boşluk
        AppSpacing.gapH24,
        // Giriş butonunun yüklenme durumunu dinleyen builder
        ValueListenableBuilder<bool>(
          valueListenable: authController.isLoadingNotifier,
          builder: (context, isLoading, _) {
            return LoginButton(
              onPressed: onLogin,
              isLoading: isLoading,
              title: 'Yörüngeye Bağlan',
            ); // LoginButton kapanışı
          }, // builder kapanışı
        ), // ValueListenableBuilder kapanışı
      ], // Column çocukları kapanışı
    ); // Column kapanışı
  } // build metodu kapanışı
} // _AuthFormSection sınıfı kapanışı
