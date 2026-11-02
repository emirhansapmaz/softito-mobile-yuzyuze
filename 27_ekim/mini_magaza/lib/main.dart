// Flutter'ın temel Material bileşenlerini içeren kütüphaneyi içe aktarıyoruz
import 'package:flutter/material.dart';
// Uygulamanın ana açılış sayfası olan ürün listesi ekranını içe aktarıyoruz
import 'screens/urun_listesi_ekrani.dart';

// Dart ve Flutter uygulamalarının çalışmaya başladığı ana giriş fonksiyonumuz
void main() {
  // Widget ağacını başlatıp kök widget'ı ekrana bağlayan Flutter fonksiyonu
  runApp(
    // Kök widget olarak MiniMagazaUygulamasi bileşenini başlatıyoruz
    const MiniMagazaUygulamasi(),
  // runApp fonksiyon çağrısının kapanışı
  );
// main fonksiyonunun kapanış parantezi
}

// Uygulamanın genel tema, başlık ve yönlendirme ayarlarını barındıran kök widget'ımız
class MiniMagazaUygulamasi extends StatelessWidget {
  // MiniMagazaUygulamasi sınıfının değişmez (const) kurucu metodu
  const MiniMagazaUygulamasi({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Kök widget'ın görsel yapısını inşa eden build metodu
  @override
  // BuildContext parametresini alan ve Widget döndüren build fonksiyonu
  Widget build(BuildContext context) {
    // Material Design standartlarını uygulayan kök MaterialApp bileşeni
    return MaterialApp(
      // Sağ üst köşedeki kırmızı 'DEBUG' etiket bandını gizliyoruz
      debugShowCheckedModeBanner: false,
      // Cihazın görev yöneticisinde görünecek uygulama başlığımız
      title: "Mini Mağaza",
      // Uygulamanın genel görsel temasını belirleyen ThemeData yapılandırması
      theme: ThemeData(
        // Modern Material 3 tasarım sistemini aktifleştiriyoruz
        useMaterial3: true,
        // Uygulamanın tüm renk paletini türeteceği tohum (seed) renk ve açık tema ayarı
        colorScheme: ColorScheme.fromSeed(
          // Temel tohum rengi olarak çivit mavisi (Indigo) seçtik
          seedColor: Colors.indigo,
          // Açık (light) parlaklık modu
          brightness: Brightness.light,
        // ColorScheme.fromSeed kapanışı
        ),
      // ThemeData kapanışı
      ),
      // Uygulama ilk açıldığında gösterilecek ana sayfa bileşenimiz
      home: const UrunListesiEkrani(),
    // MaterialApp kapanışı
    );
  // build metodu kapanış parantezi
  }
// MiniMagazaUygulamasi sınıfının kapanış parantezi
}
