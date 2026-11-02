// Flutter Material tasarım bileşenlerini sağlayan temel kütüphane
import 'package:flutter/material.dart';
// Uygulama sayfaları ve yönlendirme ayarlarını barındıran GoRouter dosyamız
import 'routes/app_router.dart';

// Dart ve Flutter uygulamalarının çalışmaya başladığı ana giriş fonksiyonumuz
void main() {
  // Widget ağacını başlatıp kök widget'ı ekrana bağlayan Flutter fonksiyonu
  runApp(
    // Kök widget olarak MyApp bileşenini başlatıyoruz
    const MyApp(),
  // runApp fonksiyon çağrısının kapanışı
  );
// main fonksiyonunun kapanış parantezi
}

// Uygulamanın genel tema ve GoRouter rota yapılandırmasını yöneten kök widget'ımız
class MyApp extends StatelessWidget {
  // MyApp sınıfının değişmez (const) kurucu metodu
  const MyApp({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // MaterialApp.router: go_router paketini projeye bağlamak için standart MaterialApp yerine bu yapıcıyı kullanıyoruz
    return MaterialApp.router(
      // Sağ üst köşedeki kırmızı 'DEBUG' etiket bandını gizliyoruz
      debugShowCheckedModeBanner: false,
      // Görev yöneticisinde görünecek uygulama başlığımız
      title: 'Softito go_router Örneği',
      // routerConfig: Sayfa yönlendirmelerini ve alt bar geçişlerini app_router.dart dosyasından çekiyoruz
      routerConfig: appRouter,
    // MaterialApp.router kapanışı
    );
  // build metodu kapanış parantezi
  }
// MyApp sınıfının kapanış parantezi
}
