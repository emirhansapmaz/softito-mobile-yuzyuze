// Flutter materyal tasarım kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Uygulama çapında durum yönetimi (State Management) sağlayan Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Türkçe tarih ve saat formatlama desteği için intl yerelleştirme fonksiyonunu içe aktarıyoruz.
import 'package:intl/date_symbol_data_local.dart';
// Uygulamanın Material 3 standartlarındaki açık ve koyu tema yapılandırmalarını içe aktarıyoruz.
import 'core/theme/app_theme.dart';
// Kullanıcı oturumu, giriş/çıkış ve rol yönetimini üstlenen AuthProvider'ı içe aktarıyoruz.
import 'providers/auth_provider.dart';
// Açık / Koyu tema tercihini yöneten ThemeProvider'ı içe aktarıyoruz.
import 'providers/theme_provider.dart';
// Araç filosu, filtreleme, kiralama ve admin operasyonlarını yöneten VehicleProvider'ı içe aktarıyoruz.
import 'providers/vehicle_provider.dart';
// Uygulama açılışında ilk gösterilecek olan animasyonlu Splash ekranını içe aktarıyoruz.
import 'screens/splash/splash_screen.dart';

/// Flutter uygulamasının ana giriş noktası (Entry Point).
void main() async {
  // Flutter motorunun (engine) widget ağacından önce tam olarak başlatıldığından emin oluyoruz.
  WidgetsFlutterBinding.ensureInitialized();
  
  // Takvim ve tarih gösterimlerinde Türkçe (tr_TR) dil desteğini aktif ediyoruz.
  await initializeDateFormatting('tr_TR', null);
  
  // Uygulamayı tüm ekranlardan erişilebilecek Provider'lar ile sarmalayarak başlatıyoruz.
  runApp(
    MultiProvider(
      providers: [
        // Tema sağlayıcısı: Açık/koyu mod değişimini yönetir.
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // Kimlik doğrulama sağlayıcısı: Oturum ve kullanıcı rollerini yönetir.
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Araç ve kiralama sağlayıcısı: Filo ve rezervasyon verilerini yönetir.
        ChangeNotifierProvider(create: (_) => VehicleProvider()),
      ],
      // Ana uygulama widget'ını başlatıyoruz.
      child: const SemAutoApp(),
    ),
  );
}

/// Uygulamanın kök widget'ı (Root Widget).
/// MaterialApp yapılandırmasını, temaları ve başlangıç rotasını belirler.
class SemAutoApp extends StatelessWidget {
  /// SemAutoApp kurucu metodu (Constructor)
  const SemAutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Aktif tema durumunu dinliyoruz.
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      // Uygulamanın işletim sistemindeki başlığı
      title: 'SEM Auto',
      // Sağ üstteki hata ayıklama (Debug) şeridini gizliyoruz.
      debugShowCheckedModeBanner: false,
      // Açık tema yapılandırması
      theme: AppTheme.lightTheme,
      // Koyu tema yapılandırması
      darkTheme: AppTheme.darkTheme,
      // Seçili tema modu (Sistem, Açık veya Koyu)
      themeMode: themeProvider.themeMode,
      // İlk açılış ekranı olarak SplashScreen'i atıyoruz.
      home: const SplashScreen(),
    );
  }
}
