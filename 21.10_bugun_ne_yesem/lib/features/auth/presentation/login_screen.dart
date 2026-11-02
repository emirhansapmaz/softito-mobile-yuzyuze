// Flutter Material arayüz bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Riverpod durum yönetimi kütüphanesini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama geneli sabitleri içe aktarıyoruz
import '../../../core/constants/app_constants.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';
// Ortak buton bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/custom_button.dart';
// Ortak metin giriş kutusu bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/custom_text_field.dart';
// Giriş sonrası yönlendirilecek ana iskelet ekranı
import '../../home/presentation/main_scaffold_screen.dart';
// Şifremi unuttum ekranını içe aktarıyoruz
import 'forgot_password_screen.dart';
// Yeni kayıt olma ekranını içe aktarıyoruz
import 'register_screen.dart';

// Kullanıcı giriş formunu ve sosyal oturum açma butonlarını barındıran ekran bileşeni
class LoginScreen extends ConsumerStatefulWidget {
  // LoginScreen sınıfının değişmez kurucu metodu
  const LoginScreen({
    // Üst sınıfa key parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (State) yöneticisini bağlayan metot
  @override
  // ConsumerState nesnesi döndürüyoruz
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
// LoginScreen sınıfının kapanış parantezi
}

// Giriş ekranının form kontrolcülerini ve buton tıklama mantığını yöneten State sınıfımız
class _LoginScreenState extends ConsumerState<LoginScreen> {
  // E-posta metin giriş kutusu kontrolcüsü
  final _emailController = TextEditingController();
  // Şifre metin giriş kutusu kontrolcüsü
  final _passwordController = TextEditingController();
  // Form doğrulama anahtarı (GlobalKey)
  final _formKey = GlobalKey<FormState>();
  // Şifrenin gizli olup olmadığını kontrol eden durum bayrağı
  bool _obscurePassword = true;

  // Sayfa bellekten kaldırılırken kontrolcüleri serbest bırakan dispose metodu
  @override
  // dispose gövdesi
  void dispose() {
    // E-posta kontrolcüsünü bellekten temizliyoruz
    _emailController.dispose();
    // Şifre kontrolcüsünü bellekten temizliyoruz
    _passwordController.dispose();
    // Üst sınıfın dispose fonksiyonunu çağırıyoruz
    super.dispose();
  // dispose metodunun kapanış parantezi
  }

  // Giriş yap butonuna tıklandığında çalışan fonksiyonumuz
  void _onLogin() {
    // Kullanıcıyı doğrudan ana sayfaya yönlendiriyoruz ve geri dönmesini engelliyoruz
    Navigator.of(context).pushReplacement(
      // Sayfa rotası
      MaterialPageRoute(
        // Ana iskelet ekranını inşa ediyoruz
        builder: (_) => const MainScaffoldScreen(),
      // MaterialPageRoute kapanışı
      ),
    // pushReplacement kapanışı
    );
  // _onLogin metodunun kapanış parantezi
  }

  // Ekranın görsel ağacını inşa eden build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sayfanın temel iskeleti
    return Scaffold(
      // Çentik ve sistem çubuklarının altına taşmayı önleyen SafeArea
      body: SafeArea(
        // Klavye açıldığında taşmayı önleyen kaydırılabilir gövde
        child: SingleChildScrollView(
          // Yatayda 24, dikeyde 32 piksel kenar boşluğu
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          // Giriş formu bileşeni
          child: Form(
            // Form doğrulama anahtarını bağlıyoruz
            key: _formKey,
            // Form elemanlarını alt alta dizen Column
            child: Column(
              // Elemanları sola hizalıyoruz
              crossAxisAlignment: CrossAxisAlignment.start,
              // Sütun elemanları listesi
              children: [
                // 20 piksel dikey boşluk
                const SizedBox(height: 20),

                // Başlık ikonu ve logosunu ortalayan Center
                Center(
                  // İkonun arkasındaki yuvarlak kutu
                  child: Container(
                    // 18 piksel iç boşluk
                    padding: const EdgeInsets.all(18),
                    // Yuvarlak dekorasyon
                    decoration: BoxDecoration(
                      // Yüzde 12 şeffaf yeşil arka plan
                      color: AppColors.primary.withValues(alpha: 0.12),
                      // Dairesel şekil
                      shape: BoxShape.circle,
                    // BoxDecoration kapanışı
                    ),
                    // Mutfak tencere/kepçe ikonu
                    child: const Icon(
                      // Mutfak simgesi
                      Icons.soup_kitchen_rounded,
                      // 48 piksel büyük boyut
                      size: 48,
                      // Yeşil ana renk
                      color: AppColors.primary,
                    // Icon kapanışı
                    ),
                  // Container kapanışı
                  ),
                // Center kapanışı
                ),
                // 24 piksel dikey boşluk
                const SizedBox(height: 24),

                // Uygulama başlığı metni
                Center(
                  // Başlık metni
                  child: Text(
                    // 'Bugün Ne Yesem?' adı
                    AppConstants.appName,
                    // Başlık stili
                    style: const TextStyle(
                      // 26 punto boyut
                      fontSize: 26,
                      // Kalın font
                      fontWeight: FontWeight.bold,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                // Center kapanışı
                ),
                // 6 piksel dikey boşluk
                const SizedBox(height: 6),

                // Açıklama slogan metni
                Center(
                  // Slogan metni
                  child: Text(
                    // Slogan içeriği
                    'Lezzetli tarifler ve sürpriz menüler seni bekliyor',
                    // Metni ortalıyoruz
                    textAlign: TextAlign.center,
                    // Metin stili
                    style: TextStyle(
                      // 14 punto boyut
                      fontSize: 14,
                      // Temaya göre ikincil metin rengi
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                // Center kapanışı
                ),
                // 40 piksel dikey boşluk
                const SizedBox(height: 40),

                // E-posta Metin Giriş Kutusu
                CustomTextField(
                  // E-posta kontrolcüsü
                  controller: _emailController,
                  // Etiket başlığı
                  label: 'E-posta Adresi',
                  // İpucu metni
                  hint: 'ornek@email.com',
                  // E-posta zarf ikonu
                  prefixIcon: Icons.email_outlined,
                  // E-posta klavye türü
                  keyboardType: TextInputType.emailAddress,
                // CustomTextField kapanışı
                ),
                // 20 piksel dikey boşluk
                const SizedBox(height: 20),

                // Şifre Metin Giriş Kutusu
                CustomTextField(
                  // Şifre kontrolcüsü
                  controller: _passwordController,
                  // Etiket başlığı
                  label: 'Şifre',
                  // İpucu noktaları
                  hint: '••••••••',
                  // Kilit ikonu
                  prefixIcon: Icons.lock_outline_rounded,
                  // Şifreyi gizleme durumu
                  obscureText: _obscurePassword,
                  // Şifreyi göster/gizle göz ikonu butonu
                  suffixIcon: IconButton(
                    // Duruma göre açık veya kapalı göz ikonu
                    icon: Icon(
                      // Açık veya kapalı göz
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      // Gri ikon rengi
                      color: Colors.grey,
                    // Icon kapanışı
                    ),
                    // Göz butonuna tıklandığında gizleme durumunu tersine çeviriyoruz
                    onPressed: () {
                      // Durumu güncelliyoruz
                      setState(() {
                        // Bayrağı tersine çeviriyoruz
                        _obscurePassword = !_obscurePassword;
                      // setState kapanışı
                      });
                    // onPressed kapanışı
                    },
                  // IconButton kapanışı
                  ),
                // CustomTextField kapanışı
                ),
                // 12 piksel dikey boşluk
                const SizedBox(height: 12),

                // Şifremi Unuttum Bağlantı Butonu (Sağa Hizalı)
                Align(
                  // Sağa hizalama
                  alignment: Alignment.centerRight,
                  // Metin butonu
                  child: TextButton(
                    // Butona basıldığında şifremi unuttum sayfasına geçiyoruz
                    onPressed: () {
                      // Yeni sayfaya yönlendiriyoruz
                      Navigator.of(context).push(
                        // Sayfa rotası
                        MaterialPageRoute(
                          // Şifremi unuttum ekranı
                          builder: (_) => const ForgotPasswordScreen(),
                        // MaterialPageRoute kapanışı
                        ),
                      // push kapanışı
                      );
                    // onPressed kapanışı
                    },
                    // Buton metni
                    child: const Text(
                      // Metin içeriği
                      'Şifremi Unuttum?',
                      // Yeşil vurgulu stil
                      style: TextStyle(
                        // Yeşil renk
                        color: AppColors.primary,
                        // Yarı kalın font
                        fontWeight: FontWeight.w600,
                      // TextStyle kapanışı
                      ),
                    // Text kapanışı
                    ),
                  // TextButton kapanışı
                  ),
                // Align kapanışı
                ),
                // 16 piksel dikey boşluk
                const SizedBox(height: 16),

                // Giriş Yap Ana Butonu
                CustomButton(
                  // Buton metni
                  text: 'Giriş Yap',
                  // Giriş kapısı ikonu
                  icon: Icons.login_rounded,
                  // Tıklama olayını bağlıyoruz
                  onPressed: _onLogin,
                // CustomButton kapanışı
                ),
                // 28 piksel dikey boşluk
                const SizedBox(height: 28),

                // 'veya' Ayırıcı Çizgisi
                Row(
                  // Satır elemanları listesi
                  children: [
                    // Sol çizgi
                    Expanded(
                      // Çizgi bileşeni
                      child: Divider(
                        // Çizgi rengi
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      // Divider kapanışı
                      ),
                    // Expanded kapanışı
                    ),
                    // Ortadaki 'veya' metni
                    Padding(
                      // Yatayda 16 piksel boşluk
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      // Metin bileşeni
                      child: Text(
                        // 'veya' metni
                        'veya',
                        // Metin stili
                        style: TextStyle(
                          // Gri renk
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          // 13 punto boyut
                          fontSize: 13,
                        // TextStyle kapanışı
                        ),
                      // Text kapanışı
                      ),
                    // Padding kapanışı
                    ),
                    // Sağ çizgi
                    Expanded(
                      // Çizgi bileşeni
                      child: Divider(
                        // Çizgi rengi
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      // Divider kapanışı
                      ),
                    // Expanded kapanışı
                    ),
                  // Row çocukları kapanışı
                  ],
                // Row kapanışı
                ),
                // 24 piksel dikey boşluk
                const SizedBox(height: 24),

                // Sosyal Giriş Butonları (Google & Apple)
                Row(
                  // Satır elemanları listesi
                  children: [
                    // Google ile giriş butonu
                    Expanded(
                      // Çerçeveli buton
                      child: OutlinedButton.icon(
                        // Buton stili
                        style: OutlinedButton.styleFrom(
                          // Dikeyde 14 piksel boşluk
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          // 16 piksel yuvarlatma
                          shape: RoundedRectangleBorder(
                            // Köşe yarıçapı
                            borderRadius: BorderRadius.circular(16),
                          // RoundedRectangleBorder kapanışı
                          ),
                          // Kenarlık çizgisi
                          side: BorderSide(
                            // Çerçeve rengi
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          // BorderSide kapanışı
                          ),
                        // OutlinedButton.styleFrom kapanışı
                        ),
                        // Tıklama olayı
                        onPressed: _onLogin,
                        // Google ikonu
                        icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                        // Buton etiketi
                        label: const Text(
                          // Metin
                          'Google',
                          // Yarı kalın font
                          style: TextStyle(fontWeight: FontWeight.w600),
                        // Text kapanışı
                        ),
                      // OutlinedButton.icon kapanışı
                      ),
                    // Expanded kapanışı
                    ),
                    // İki buton arasına 16 piksel yatay boşluk
                    const SizedBox(width: 16),

                    // Apple ile giriş butonu
                    Expanded(
                      // Çerçeveli buton
                      child: OutlinedButton.icon(
                        // Buton stili
                        style: OutlinedButton.styleFrom(
                          // Dikeyde 14 piksel boşluk
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          // 16 piksel yuvarlatma
                          shape: RoundedRectangleBorder(
                            // Köşe yarıçapı
                            borderRadius: BorderRadius.circular(16),
                          // RoundedRectangleBorder kapanışı
                          ),
                          // Kenarlık çizgisi
                          side: BorderSide(
                            // Çerçeve rengi
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          // BorderSide kapanışı
                          ),
                        // OutlinedButton.styleFrom kapanışı
                        ),
                        // Tıklama olayı
                        onPressed: _onLogin,
                        // Apple elma ikonu
                        icon: Icon(
                          // Elma simgesi
                          Icons.apple,
                          // 24 piksel boyut
                          size: 24,
                          // Temaya göre beyaz veya siyah renk
                          color: isDark ? Colors.white : Colors.black,
                        // Icon kapanışı
                        ),
                        // Buton etiketi
                        label: const Text(
                          // Metin
                          'Apple',
                          // Yarı kalın font
                          style: TextStyle(fontWeight: FontWeight.w600),
                        // Text kapanışı
                        ),
                      // OutlinedButton.icon kapanışı
                      ),
                    // Expanded kapanışı
                    ),
                  // Row çocukları kapanışı
                  ],
                // Row kapanışı
                ),
                // 36 piksel dikey boşluk
                const SizedBox(height: 36),

                // Kayıt Ol Sayfasına Yönlendiren Alt Bağlantı
                Row(
                  // Ortaya hizalıyoruz
                  mainAxisAlignment: MainAxisAlignment.center,
                  // Satır elemanları listesi
                  children: [
                    // Soru metni
                    Text(
                      // Metin içeriği
                      'Hesabın yok mu?',
                      // Stil
                      style: TextStyle(
                        // Gri renk
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      // TextStyle kapanışı
                      ),
                    // Text kapanışı
                    ),
                    // Kayıt Ol butonu
                    TextButton(
                      // Butona tıklandığında kayıt ekranını açıyoruz
                      onPressed: () {
                        // Kayıt ekranına yönlendiriyoruz
                        Navigator.of(context).push(
                          // Sayfa rotası
                          MaterialPageRoute(
                            // Kayıt ekranı bileşeni
                            builder: (_) => const RegisterScreen(),
                          // MaterialPageRoute kapanışı
                          ),
                        // push kapanışı
                        );
                      // onPressed kapanışı
                      },
                      // Buton metni
                      child: const Text(
                        // 'Kayıt Ol' metni
                        'Kayıt Ol',
                        // Yeşil ve kalın stil
                        style: TextStyle(
                          // Yeşil renk
                          color: AppColors.primary,
                          // Kalın font
                          fontWeight: FontWeight.bold,
                        // TextStyle kapanışı
                        ),
                      // Text kapanışı
                      ),
                    // TextButton kapanışı
                    ),
                  // Row çocukları kapanışı
                  ],
                // Row kapanışı
                ),
              // Column çocukları kapanışı
              ],
            // Column kapanışı
            ),
          // Form kapanışı
          ),
        // SingleChildScrollView kapanışı
        ),
      // SafeArea kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _LoginScreenState sınıfının kapanış parantezi
}
