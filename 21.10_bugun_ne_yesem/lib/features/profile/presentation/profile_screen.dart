// Flutter'ın temel görsel arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Riverpod durum yönetimi paketini içeri alıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama renk paleti sabitleri
import '../../../core/theme/app_colors.dart';
// Özel tasarım buton bileşenimiz
import '../../../shared/widgets/custom_button.dart';
// Özel tasarım metin giriş alanı bileşenimiz
import '../../../shared/widgets/custom_text_field.dart';
// Çıkış yapıldığında yönlendirilecek giriş ekranı
import '../../auth/presentation/login_screen.dart';
// Uygulama ayarları ekranı
import '../../home/presentation/app_settings_screen.dart';

// Kullanıcı profil ve hesap ayarlarını yöneten Riverpod Stateful ekranı
class ProfileScreen extends ConsumerStatefulWidget {
  // Sabit kurucu metot
  const ProfileScreen({super.key});

  // State nesnesini bağlayan override metodu
  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
} // ProfileScreen sınıfı kapanışı

// Profil ekranının durum yönetim sınıfı
class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  // İsim alanı için başlangıç metinli kontrolcü
  final _nameController = TextEditingController(text: 'Ahmet Yılmaz');
  // E-posta alanı için başlangıç metinli kontrolcü
  final _emailController = TextEditingController(text: 'ahmet@example.com');
  // Telefon alanı için kontrolcü
  final _phoneController = TextEditingController(text: '+90 555 123 45 67');
  // Güvenlik ipucu alanı için kontrolcü
  final _hintController = TextEditingController(text: 'İlk evcil hayvanım: pamuk');

  // Ekran kapandığında bellek sızıntısını önlemek için kontrolcüleri serbest bırakıyoruz
  @override
  void dispose() {
    // İsim kontrolcüsünü bellekten at
    _nameController.dispose();
    // E-posta kontrolcüsünü bellekten at
    _emailController.dispose();
    // Telefon kontrolcüsünü bellekten at
    _phoneController.dispose();
    // İpucu kontrolcüsünü bellekten at
    _hintController.dispose();
    // Üst sınıfın dispose metodunu çağır
    super.dispose();
  } // dispose metodu kapanışı

  // Profil bilgilerini kaydetme simülasyonu
  void _onSaveProfile() {
    // Kullanıcıya başarı mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        // Başarı metni
        content: Text('Profil bilgileri başarıyla güncellendi!'),
        // Yeşil başarı rengi
        backgroundColor: AppColors.success,
      ), // SnackBar kapanışı
    ); // showSnackBar kapanışı
  } // _onSaveProfile metodu kapanışı

  // Çıkış yap onay penceresini açan metot
  void _onLogout() {
    // Onay iletişim kutusunu ekrana basıyoruz
    showDialog(
      // İçerik bağlamı
      context: context,
      // İletişim kutusu tasarımı
      builder: (ctx) => AlertDialog(
        // İletişim kutusu başlığı
        title: const Text('Çıkış Yap'),
        // İletişim kutusu onay sorusu
        content: const Text('Hesabınızdan çıkış yapmak istediğinize emin misiniz?'),
        // Alt buton aksiyonları
        actions: [
          // İptal butonu
          TextButton(
            // Tıklanınca pencereyi kapat
            onPressed: () => Navigator.of(ctx).pop(),
            // Buton metni
            child: const Text('İptal'),
          ), // TextButton kapanışı
          // Çıkış yap onay butonu
          ElevatedButton(
            // Buton stili
            style: ElevatedButton.styleFrom(
              // Kırmızı tehlike rengi
              backgroundColor: AppColors.error,
              // Beyaz yazı rengi
              foregroundColor: Colors.white,
            ), // ElevatedButton.styleFrom kapanışı
            // Tıklanınca oturumu sonlandır ve giriş ekranına yönlendir
            onPressed: () {
              // Dialog penceresini kapat
              Navigator.of(ctx).pop();
              // Giriş ekranına git ve önceki tüm sayfaları yığından temizle
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              ); // pushAndRemoveUntil kapanışı
            }, // onPressed kapanışı
            // Buton metni
            child: const Text('Çıkış Yap'),
          ), // ElevatedButton kapanışı
        ], // actions listesi kapanışı
      ), // AlertDialog kapanışı
    ); // showDialog kapanışı
  } // _onLogout metodu kapanışı

  // Arayüzü inşa eden temel yapı
  @override
  Widget build(BuildContext context) {
    // Koyu tema açık mı kontrolü
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sayfa iskeletini döndürüyoruz
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Ekran başlığı
        title: const Text('Hesap & Profil'),
      ), // AppBar kapanışı
      // Güvenli alan widget'ı
      body: SafeArea(
        // Küçük ekranlarda taşmayı önleyen kaydırılabilir gövde
        child: SingleChildScrollView(
          // Sayfa kenar boşlukları
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          // Dikey dizilim kolonu
          child: Column(
            // Kolon çocukları
            children: [
              // Profil Resmi / Avatar Alanı
              Center(
                // Katmanlı tasarım için Stack
                child: Stack(
                  // Katman çocukları
                  children: [
                    // Yuvarlak profil resmi çerçevesi
                    CircleAvatar(
                      // Çap yarıçapı
                      radius: 46,
                      // Açık turuncu arka plan
                      backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                      // Kullanıcı ikonu
                      child: const Icon(
                        Icons.person_rounded,
                        size: 54,
                        color: AppColors.primary,
                      ), // Icon kapanışı
                    ), // CircleAvatar kapanışı
                    // Sağ alt köşeye kamera ikonu yerleştiriyoruz
                    Positioned(
                      // Alttan sıfır
                      bottom: 0,
                      // Sağdan sıfır
                      right: 0,
                      // Küçük yuvarlak kamera rozeti
                      child: Container(
                        // İç kenar boşluğu
                        padding: const EdgeInsets.all(6),
                        // Daire şekli ve turuncu renk
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ), // BoxDecoration kapanışı
                        // Kamera ikonu
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ), // Icon kapanışı
                      ), // Container kapanışı
                    ), // Positioned kapanışı
                  ], // Stack çocukları kapanışı
                ), // Stack kapanışı
              ), // Center kapanışı
              // Dikey boşluk
              const SizedBox(height: 12),
              // Kullanıcı Adı Metni
              Text(
                _nameController.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ), // TextStyle kapanışı
              ), // Text kapanışı
              // Kullanıcı E-posta Metni
              Text(
                _emailController.text,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ), // TextStyle kapanışı
              ), // Text kapanışı
              // Dikey boşluk
              const SizedBox(height: 28),

              // Profil Bilgileri Form Alanları
              // Ad Soyad Giriş Alanı
              CustomTextField(
                controller: _nameController,
                label: 'Ad Soyad',
                prefixIcon: Icons.person_outline,
              ), // CustomTextField kapanışı
              const SizedBox(height: 16),
              // E-posta Giriş Alanı
              CustomTextField(
                controller: _emailController,
                label: 'E-posta',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ), // CustomTextField kapanışı
              const SizedBox(height: 16),
              // Telefon Numarası Giriş Alanı
              CustomTextField(
                controller: _phoneController,
                label: 'Telefon Numarası',
                prefixIcon: Icons.phone_outlined,
              ), // CustomTextField kapanışı
              const SizedBox(height: 16),
              // Güvenlik İpucu Giriş Alanı
              CustomTextField(
                controller: _hintController,
                label: 'Kolay Giriş İpucu (Password Hint)',
                prefixIcon: Icons.lightbulb_outline,
              ), // CustomTextField kapanışı
              const SizedBox(height: 24),

              // Bilgileri Güncelle Butonu
              CustomButton(
                text: 'Bilgileri Güncelle',
                icon: Icons.save_outlined,
                onPressed: _onSaveProfile,
              ), // CustomButton kapanışı
              const SizedBox(height: 12),

              // Uygulama Ayarları Butonu (Görünüm, Dil vs.)
              CustomButton(
                text: 'Uygulama Ayarları',
                icon: Icons.tune_rounded,
                isOutlined: true,
                // Ayarlar ekranına geçiş
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AppSettingsScreen(),
                    ), // MaterialPageRoute kapanışı
                  ); // push kapanışı
                }, // onPressed kapanışı
              ), // CustomButton kapanışı
              const SizedBox(height: 16),

              // Oturumu Kapat / Çıkış Yap Butonu
              SizedBox(
                height: 52,
                width: double.infinity,
                child: OutlinedButton.icon(
                  // Çıkış ikonu
                  icon: Icon(
                    Icons.logout_rounded,
                    color: isDark ? const Color(0xFFEF5350) : const Color(0xFFD32F2F),
                    size: 20,
                  ), // Icon kapanışı
                  // Çıkış metni
                  label: Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFEF5350) : const Color(0xFFD32F2F),
                    ), // TextStyle kapanışı
                  ), // Text kapanışı
                  // Buton stili
                  style: OutlinedButton.styleFrom(
                    backgroundColor: isDark
                        ? const Color(0xFFE53935).withValues(alpha: 0.12)
                        : const Color(0xFFFFF0F0),
                    side: BorderSide(
                      color: isDark
                          ? const Color(0xFFE53935).withValues(alpha: 0.35)
                          : const Color(0xFFFFCDD2),
                      width: 1.2,
                    ), // BorderSide kapanışı
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ), // RoundedRectangleBorder kapanışı
                    elevation: 0,
                  ), // OutlinedButton.styleFrom kapanışı
                  // Tıklanınca çıkış onay penceresi açılsın
                  onPressed: _onLogout,
                ), // OutlinedButton.icon kapanışı
              ), // SizedBox kapanışı
              // Sayfa sonu boşluğu
              const SizedBox(height: 28),
            ], // Column çocukları kapanışı
          ), // Column kapanışı
        ), // SingleChildScrollView kapanışı
      ), // SafeArea kapanışı
    ); // Scaffold kapanışı
  } // build metodu kapanışı
} // _ProfileScreenState sınıfı kapanışı
