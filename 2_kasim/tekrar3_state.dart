// Not: setState() metodu çağrıldığında o anki State nesnesinin build() metodu baştan aşağı tekrar çalışır.
// Scaffold, AppBar, alt butonlar ve ekrandaki 20 tane container varsa hepsi gereksiz yere baştan çizilir.
// Bu yüzden tüm sayfayı değil, sadece değişen küçük bir widget'ı güncellemek için ValueNotifier gibi hafif çözümler tercih edilir.

// Flutter'ın temel Material bileşenlerini içeren kütüphaneyi içe aktarıyoruz
import 'package:flutter/material.dart';
// Sayfalar arası geçiş ve modern yönlendirmeler için go_router kütüphanesi
import 'package:go_router/go_router.dart';

// SepetKontrolu: Singleton tasarım deseni ile oluşturulmuş sepet yönetim sınıfımız.
// Amacı: Uygulamanın herhangi bir ekranından aynı sepet örneğine erişip ürün adedini anlık yönetebilmek.
class SepetKontrolu {
  // Singleton: Sınıfın tek bir statik örneğini oluşturup dışarıya sunuyoruz
  static final SepetKontrolu ornek = SepetKontrolu._dahili();

  // Private constructor (gizli yapıcı metot): Dışarıdan 'new SepetKontrolu()' denmesini engelliyoruz
  SepetKontrolu._dahili();

  // ValueNotifier: Sayfa baştan çizilmeden sadece bu sayıyı dinleyen widget yenilensin diye tanımladık
  final ValueNotifier<int> urunSayisi = ValueNotifier<int>(0);

  // Sepete ürün eklendiğinde adedi 1 artıran fonksiyon
  void sepeteEkle() {
    // ValueNotifier içindeki değeri bir artırıp dinleyicileri tetikliyoruz
    urunSayisi.value++;
  // sepeteEkle metodunun kapanış parantezi
  }

  // Sepeti boşaltmak ve sayıyı sıfırlamak için kullandığımız fonksiyon
  void sepetSifirla() {
    // Değeri doğrudan 0 yapıyoruz
    urunSayisi.value = 0;
  // sepetSifirla metodunun kapanış parantezi
  }
// SepetKontrolu sınıfının kapanış parantezi
}

// Uygulamanın tüm rota yapılandırmasını yönettiğimiz ana GoRouter nesnesi
final GoRouter uygulamaRotalari = GoRouter(
  // Uygulama ilk açıldığında doğrudan yönlendirileceği başlangıç konumu
  initialLocation: '/vitrin',
  // Uygulama rotaları listesi
  routes: [
    // ShellRoute: Alt gezinme çubuğu (Bottom Navigation) ekranda sabit kalsın, sekmeye tıklayınca
    // sadece ortadaki içerik değişsin diye bu kabuk yönlendiriciyi kullanıyoruz
    ShellRoute(
      // Kabuk ekranın gövdesini ve gelen alt ekranı bağlayan builder fonksiyonu
      builder: (BuildContext context, GoRouterState state, Widget child) {
        // Ana kasa ekranımıza o anki aktif sekmenin gövdesini iletiyoruz
        return AnaKasaEkrani(ekranGovdesi: child);
      // ShellRoute builder kapanışı
      },
      // Kabuk içinde gösterilecek alt rotalar listesi
      routes: [
        // Vitrin ekranı rotası
        GoRoute(
          // URL yolu
          path: '/vitrin',
          // Ekrana VitrinEkrani bileşenini çizen yapıcı metot
          builder: (context, state) => const VitrinEkrani(),
        // GoRoute kapanışı
        ),
        // Kullanıcı profil ekranı rotası
        GoRoute(
          // URL yolu
          path: '/profil',
          // Ekrana ProfilEkrani bileşenini çizen yapıcı metot
          builder: (context, state) => const ProfilEkrani(),
        // GoRoute kapanışı
        ),
      // Alt rotalar listesi kapanışı
      ],
    // ShellRoute kapanışı
    ),
  // routes listesi kapanışı
  ],
// GoRouter yapılandırması kapanışı
);

// Ana Kasa Ekranı: Alt gezinme çubuğunu ve seçilen sayfa gövdesini bir arada tutan iskelet widget
class AnaKasaEkrani extends StatelessWidget {
  // Seçili sekmenin içeriğini temsil eden gövde widget'ı
  final Widget ekranGovdesi;

  // AnaKasaEkrani sınıfının kurucu metodu
  const AnaKasaEkrani({
    // Widget ağacı anahtarı
    super.key,
    // Ekrana basılacak gövde içeriğinin zorunlu olduğunu belirtiyoruz
    required this.ekranGovdesi,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel yapısını inşa eden build metodu
  @override
  // BuildContext parametresini alan ve Widget döndüren build fonksiyonu
  Widget build(BuildContext context) {
    // Sayfanın temel iskeletini sağlayan Scaffold bileşeni
    return Scaffold(
      // Gövdeye o anki seçili sekmenin ekranını yerleştiriyoruz
      body: ekranGovdesi,
      // Ekranın alt kısmındaki modern Material 3 gezinme çubuğu
      bottomNavigationBar: NavigationBar(
        // Aktif rotaya bakarak hangi sekmenin seçili olacağını belirleyen yardımcı metot
        selectedIndex: _aktifIndexiBul(context),
        // Kullanıcı bir sekmeye dokunduğunda çalışan tetikleyici
        onDestinationSelected: (yeniIndeks) {
          // İlk sekmeye tıklandıysa vitrin ekranına yönlendiriyoruz
          if (yeniIndeks == 0) context.go('/vitrin');
          // İkinci sekmeye tıklandıysa profil ekranına yönlendiriyoruz
          if (yeniIndeks == 1) context.go('/profil');
        // onDestinationSelected kapanışı
        },
        // Gezinme çubuğunda yer alan sekme hedefleri listesi
        destinations: [
          // Vitrin sekmesi tanımı
          const NavigationDestination(
            // Vitrin mağaza ikonu
            icon: Icon(Icons.store),
            // Sekme altındaki etiket metni
            label: 'Vitrin',
          // NavigationDestination kapanışı
          ),
          // Profil sekmesi tanımı (üzerinde dinamik sepet rozeti var)
          NavigationDestination(
            // ValueListenableBuilder: Sepetteki urunSayisi değiştikçe sadece buradaki rozeti günceller,
            // böylece tüm ekranın gereksiz yere baştan çizilmesini (rebuild) engeller
            icon: ValueListenableBuilder<int>(
              // Dinlenecek olan reaktif ValueNotifier nesnemiz
              valueListenable: SepetKontrolu.ornek.urunSayisi,
              // Değer değiştikçe sadece rozet kısmını yeniden çizen builder fonksiyonu
              builder: (context, urunSayisi, child) {
                // İkon üzerine adet sayısı balonu koyan Badge bileşeni
                return Badge(
                  // Rozet içinde gösterilecek metin (güncel sepet adedi)
                  label: Text('$urunSayisi'),
                  // Sepette en az 1 ürün varsa rozeti göster, yoksa gizle
                  isLabelVisible: urunSayisi > 0,
                  // Rozetin sarıldığı temel profil ikonu
                  child: const Icon(Icons.person),
                // Badge kapanışı
                );
              // ValueListenableBuilder builder kapanışı
              },
            // ValueListenableBuilder kapanışı
            ),
            // Profil sekmesi altındaki etiket metni
            label: 'Profil',
          // NavigationDestination kapanışı
          ),
        // destinations listesi kapanışı
        ],
      // NavigationBar kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// AnaKasaEkrani sınıfının kapanış parantezi
}

// O anki URL adresine bakıp alt çubuktaki aktif sekme indeksini (0 veya 1) bulan yardımcı fonksiyon
int _aktifIndexiBul(BuildContext context) {
  // GoRouter'dan o an ekranda açık olan sayfanın URI adresini metin olarak alıyoruz
  final String konum = GoRouterState.of(context).uri.toString();
  // Eğer sayfa adresi '/profil' ile başlıyorsa 1. sekme seçilidir
  if (konum.startsWith('/profil')) return 1;
  // Diğer durumlarda varsayılan olarak 0. sekme (Vitrin) seçilidir
  return 0;
// _aktifIndexiBul fonksiyonunun kapanış parantezi
}

// Vitrin Ekranı: Kullanıcının sepete ürün ekleyebildiği vitrin sayfası
class VitrinEkrani extends StatelessWidget {
  // VitrinEkrani sınıfının kurucu metodu
  const VitrinEkrani({
    // Widget anahtarı
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext parametresini alan ve Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Sayfa iskeleti
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlık metni
        title: const Text('Canlı Vitrin (ValueNotifier)'),
      // AppBar kapanışı
      ),
      // İçeriği ekranın tam ortasına hizalayan Center widget'ı
      body: Center(
        // İkonlu ve yükseltilmiş buton bileşeni
        child: ElevatedButton.icon(
          // Butona tıklandığında çalışan tıklama olayı
          onPressed: () {
            // Singleton sepet nesnesindeki urunSayisi değerini 1 artıran fonksiyonu tetikliyoruz
            SepetKontrolu.ornek.sepeteEkle();
          // onPressed kapanışı
          },
          // Butonun solundaki sepet ikonu
          icon: const Icon(Icons.add_shopping_cart),
          // Buton üzerindeki açıklama metni
          label: const Text('Sepete Ürün Ekle (+1)'),
        // ElevatedButton.icon kapanışı
        ),
      // Center kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// VitrinEkrani sınıfının kapanış parantezi
}

// Profil Ekranı: Kullanıcı profilini ve sepet sıfırlama butonunu barındıran ekran
class ProfilEkrani extends StatelessWidget {
  // ProfilEkrani sınıfının kurucu metodu
  const ProfilEkrani({
    // Widget anahtarı
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext parametresini alan ve Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Sayfa iskeleti
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlık metni
        title: const Text('Kullanıcı Profili'),
      // AppBar kapanışı
      ),
      // İçeriği ortalayan Center bileşeni
      body: Center(
        // Metin butonu bileşeni
        child: TextButton(
          // Butona basıldığında sepet sayısını sıfırlıyoruz
          onPressed: () => SepetKontrolu.ornek.sepetSifirla(),
          // Buton metni
          child: const Text('Sepeti Temizle (0 Yap)'),
        // TextButton kapanışı
        ),
      // Center kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// ProfilEkrani sınıfının kapanış parantezi
}
