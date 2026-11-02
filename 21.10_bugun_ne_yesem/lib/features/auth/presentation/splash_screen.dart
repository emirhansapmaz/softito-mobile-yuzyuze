// Flutter temel Material bileşenlerini içeren kütüphane
import 'package:flutter/material.dart';
// Riverpod tüketici durum bileşenlerini kullanabilmek için gerekli paket
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama geneli sabitleri içe aktarıyoruz
import '../../../core/constants/app_constants.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';
// Açılıştan sonra geçilecek olan ana iskelet ekranı
import '../../home/presentation/main_scaffold_screen.dart';

// Uygulama açılışında marka logosunu ve başlığını gösteren animasyonlu karşılama ekranı
class SplashScreen extends ConsumerStatefulWidget {
  // SplashScreen sınıfının değişmez kurucu metodu
  const SplashScreen({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (State) yöneticisini bağlayan metot
  @override
  // ConsumerState durum nesnesini bağlıyoruz
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
// SplashScreen sınıfının kapanış parantezi
}

// Karşılama ekranının yaşam döngüsünü ve geçiş zamanlamasını yöneten State sınıfımız
class _SplashScreenState extends ConsumerState<SplashScreen> {
  // Widget belleğe ilk yüklendiğinde bir kez çalışan yaşam döngüsü metodu
  @override
  // initState gövdesi
  void initState() {
    // Üst sınıfın initState fonksiyonunu çağırıyoruz
    super.initState();
    // 1.8 saniye sonra ana sayfaya yönlendiren fonksiyonu tetikliyoruz
    _handleNavigation();
  // initState metodunun kapanış parantezi
  }

  // Belirli bir süre bekledikten sonra kullanıcıyı ana ekrana geçiren asenkron fonksiyon
  Future<void> _handleNavigation() async {
    // Logo ve uygulamanın görünmesi için 1800 milisaniye (1.8 sn) bekletiyoruz
    await Future.delayed(const Duration(milliseconds: 1800));
    // Eğer kullanıcı ekranı çoktan terk ettiyse işlemi kesiyoruz
    if (!mounted) return;

    // Karşılama ekranını kapatıp yerine doğrudan ana iskelet ekranını açıyoruz
    Navigator.of(context).pushReplacement(
      // Sayfa geçiş animasyonu ve rotası
      MaterialPageRoute(
        // Hedef ana sayfa bileşeni
        builder: (_) => const MainScaffoldScreen(),
      // MaterialPageRoute kapanışı
      ),
    // pushReplacement kapanışı
    );
  // _handleNavigation metodunun kapanış parantezi
  }

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Sayfanın temel iskeleti
    return Scaffold(
      // Arka plan rengini markamızın adaçayı yeşili yapıyoruz
      backgroundColor: AppColors.primary,
      // İçeriği ekranın tam ortasına hizalayan Center
      body: Center(
        // Logo, başlık ve yükleme ikonunu dikeyde dizen Column
        child: Column(
          // Elemanları dikeyde ortalıyoruz
          mainAxisAlignment: MainAxisAlignment.center,
          // Sütun elemanları listesi
          children: [
            // Logonun arkasındaki yarı saydam yuvarlak kutu
            Container(
              // Her yönden 24 piksel iç boşluk
              padding: const EdgeInsets.all(24),
              // Dairesel dekorasyon
              decoration: BoxDecoration(
                // Yüzde 15 şeffaf beyaz arka plan
                color: Colors.white.withValues(alpha: 0.15),
                // Daire şekli
                shape: BoxShape.circle,
              // BoxDecoration kapanışı
              ),
              // Restoran menü ikonu
              child: const Icon(
                // Menü simgesi
                Icons.restaurant_menu_rounded,
                // 72 piksel büyük boyut
                size: 72,
                // Beyaz ikon rengi
                color: Colors.white,
              // Icon kapanışı
              ),
            // Container kapanışı
            ),
            // Logo ile başlık arasına 24 piksel dikey boşluk
            const SizedBox(height: 24),

            // Uygulama adı metni
            const Text(
              // 'Bugün Ne Yesem?' başlığı
              AppConstants.appName,
              // Başlık stili
              style: TextStyle(
                // 28 punto büyük boyut
                fontSize: 28,
                // Kalın font
                fontWeight: FontWeight.bold,
                // Beyaz yazı rengi
                color: Colors.white,
                // Harfler arasına 0.5 piksel boşluk
                letterSpacing: 0.5,
              // TextStyle kapanışı
              ),
            // Text kapanışı
            ),
            // Başlık ile slogan arasına 8 piksel boşluk
            const SizedBox(height: 8),

            // Slogan metni
            Text(
              // Slogan içeriği
              'Bugünün Lezzeti Ne Olsun?',
              // Slogan stili
              style: TextStyle(
                // 15 punto boyut
                fontSize: 15,
                // Hafif şeffaf beyaz renk
                color: Colors.white.withValues(alpha: 0.85),
                // Harf aralığı
                letterSpacing: 0.2,
              // TextStyle kapanışı
              ),
            // Text kapanışı
            ),
            // Slogan ile yükleme göstergesi arasına 48 piksel dikey boşluk
            const SizedBox(height: 48),

            // Sabit boyutlu yükleme göstergesi kutusu
            const SizedBox(
              // Genişlik 28 piksel
              width: 28,
              // Yükseklik 28 piksel
              height: 28,
              // Dönen dairesel yükleme animasyonu
              child: CircularProgressIndicator(
                // Beyaz dönen çizgi rengi
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                // Çizgi kalınlığı 2.5 piksel
                strokeWidth: 2.5,
              // CircularProgressIndicator kapanışı
              ),
            // SizedBox kapanışı
            ),
          // Column çocukları kapanışı
          ],
        // Column kapanışı
        ),
      // Center kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _SplashScreenState sınıfının kapanış parantezi
}
