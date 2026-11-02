// Flutter temel Material arayüz bileşenlerini içe aktarıyoruz
import 'package:flutter/material.dart';
// Sayfalar arası geçiş ve kabuk yapısı (Shell) sağlayan modern GoRouter paketi
import 'package:go_router/go_router.dart';
// Anasayfa sekmesi ekranını içe aktarıyoruz
import '../screens/anasayfa.dart';
// Profil sekmesi ekranını içe aktarıyoruz
import '../screens/profil.dart';
// Ayarlar sekmesi ekranını içe aktarıyoruz
import '../screens/ayarlar.dart';

// GoRouter yapılandırması:
// Uygulamanın tüm sayfa geçiş ve tab bar mantığını burada merkezi olarak yönetiyoruz
final GoRouter appRouter = GoRouter(
  // Uygulama ilk açıldığında gösterilecek başlangıç rotası (kök dizin)
  initialLocation: '/',
  // Yönlendirme rotaları listesi
  routes: [
    // StatefulShellRoute.indexedStack:
    // Bu yapının en büyük avantajı; sekmeler (tabs) arası geçişte sayfaların durumunu (scroll konumu, girilen veriler)
    // kaybetmemesidir. Sayfalar arkada canlı kalır, IndexedStack mantığıyla gizlenip gösterilir.
    StatefulShellRoute.indexedStack(
      // Kabuk arayüzü oluşturan ve alt sayfa gövdesini bağlayan builder fonksiyonu
      builder: (context, state, navigationShell) {
        // Alt çubuğu (BottomNavigationBar) barındıran ortak kabuk ekranımızı döndürüyoruz
        return AnaGecisEkrani(navigationShell: navigationShell);
      // builder fonksiyonunun kapanışı
      },
      // Her bir sekmenin bağımsız rota dalını tutan liste
      branches: [
        // 1. Dal: Anasayfa sekmesi ve rotaları
        StatefulShellBranch(
          // Anasayfa dalı rotaları
          routes: [
            // Anasayfa kök rotası
            GoRoute(
              // URL yolu
              path: '/',
              // Anasayfa bileşenini ekrana çizen yapıcı fonksiyon
              builder: (context, state) => const Anasayfa(),
            // GoRoute kapanışı
            ),
          // routes listesi kapanışı
          ],
        // StatefulShellBranch kapanışı
        ),
        // 2. Dal: Profil sekmesi ve rotaları
        StatefulShellBranch(
          // Profil dalı rotaları
          routes: [
            // Profil sayfası rotası
            GoRoute(
              // URL yolu
              path: '/profil',
              // Profil bileşenini ekrana çizen yapıcı fonksiyon
              builder: (context, state) => const Profil(),
            // GoRoute kapanışı
            ),
          // routes listesi kapanışı
          ],
        // StatefulShellBranch kapanışı
        ),
        // 3. Dal: Ayarlar sekmesi ve rotaları
        StatefulShellBranch(
          // Ayarlar dalı rotaları
          routes: [
            // Ayarlar sayfası rotası
            GoRoute(
              // URL yolu
              path: '/ayarlar',
              // Ayarlar bileşenini ekrana çizen yapıcı fonksiyon
              builder: (context, state) => const Ayarlar(),
            // GoRoute kapanışı
            ),
          // routes listesi kapanışı
          ],
        // StatefulShellBranch kapanışı
        ),
      // branches listesi kapanışı
      ],
    // StatefulShellRoute.indexedStack kapanışı
    ),
  // routes listesi kapanışı
  ],
// GoRouter kapanışı
);

// Ana Geçiş Ekranı: Scaffold, dinamik AppBar ve BottomNavigationBar bileşenlerini bir araya getirir
class AnaGecisEkrani extends StatelessWidget {
  // StatefulNavigationShell: GoRouter'ın aktif sekme indeksini ve dallarını yöneten özel nesnesi
  final StatefulNavigationShell navigationShell;

  // AnaGecisEkrani sınıfının kurucu metodu
  const AnaGecisEkrani({
    // Widget ağacı anahtarı
    super.key,
    // navigationShell parametresinin zorunlu olduğunu belirtiyoruz
    required this.navigationShell,
  // Kurucu metodun kapanış parantezi
  });

  // Seçili sekmeye göre AppBar başlığını dinamik belirleyen yardımcı fonksiyonumuz
  String _getBaslik(int index) {
    // Sekme indeksine göre başlık seçiyoruz
    switch (index) {
      // 0. indeks Anasayfa başlığı
      case 0:
        return 'Anasayfa';
      // 1. indeks Profil başlığı
      case 1:
        return 'Profil';
      // 2. indeks Ayarlar başlığı
      case 2:
        return 'Ayarlar';
      // Beklenmeyen durumda boş metin
      default:
        return '';
    // switch bloğunun kapanışı
    }
  // _getBaslik fonksiyonunun kapanış parantezi
  }

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Sayfanın temel iskeleti
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Aktif sekmenin indeksine göre dinamik başlık metnini yazdırıyoruz
        title: Text(_getBaslik(navigationShell.currentIndex)),
        // Başlığı ekranda ortalıyoruz
        centerTitle: true,
      // AppBar kapanışı
      ),
      // body olarak doğrudan navigationShell veriyoruz, o anki aktif sekmenin ekranını çizer
      body: navigationShell,
      // Alt kısımdaki klasik alt gezinme çubuğu
      bottomNavigationBar: BottomNavigationBar(
        // Aktif sekmenin indeksini navigationShell nesnesinden alıyoruz
        currentIndex: navigationShell.currentIndex,
        // Kullanıcı bir sekmeye dokunduğunda çalışan olay
        onTap: (int index) {
          // goBranch: İlgili sekmeye geçiş yapar.
          // initialLocation: Eğer zaten o sekmedeysek tekrar tıklandığında alt sayfalardan sekmenin en tepesine dönmesini sağlar
          navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
        // onTap kapanışı
        },
        // Gezinme çubuğunda görünecek butonlar listesi
        items: const [
          // Anasayfa sekmesi öğesi
          BottomNavigationBarItem(
            // Ev ikonu
            icon: Icon(Icons.home),
            // Buton etiketi
            label: 'Anasayfa',
          // BottomNavigationBarItem kapanışı
          ),
          // Profil sekmesi öğesi
          BottomNavigationBarItem(
            // Profil kişi ikonu
            icon: Icon(Icons.person),
            // Buton etiketi
            label: 'Profil',
          // BottomNavigationBarItem kapanışı
          ),
          // Ayarlar sekmesi öğesi
          BottomNavigationBarItem(
            // Ayarlar dişli çark ikonu
            icon: Icon(Icons.settings),
            // Buton etiketi
            label: 'Ayarlar',
          // BottomNavigationBarItem kapanışı
          ),
        // items listesi kapanışı
        ],
      // BottomNavigationBar kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// AnaGecisEkrani sınıfının kapanış parantezi
}
