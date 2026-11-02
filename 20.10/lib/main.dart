// Flutter'ın temel materyal arayüz kütüphanesini içeri aktarıyoruz
import 'package:flutter/material.dart';
// Uygulamanın Material 3 standartlarındaki açık ve koyu tema yapılandırmalarını içeri alıyoruz
import 'core/theme/app_theme.dart';
// Çift tema yönetimini sağlayan Singleton ThemeController sınıfımız
import 'core/theme/theme_controller.dart';
// Uygulama ilk açıldığında gösterilecek olan kimlik doğrulama / giriş ekranı
import 'features/auth/view/auth_view.dart';

// Flutter uygulamasının ana başlangıç noktası olan main fonksiyonu
void main() {
  // Widget ağacı ayağa kalkmadan önce Flutter motoru bağlamının hazır olduğundan emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();
  // Kök widget'ımız olan YorungeApp'i ekrana basarak uygulamayı başlatıyoruz
  runApp(const YorungeApp());
} // main fonksiyonu kapanışı

/// Yörünge Girişimcilik Platformu - Kök Uygulama Bileşeni.
/// `ValueListenableBuilder` ile çift tema ("Derin Uzay" & "Şafak Fırlatışı") reaktif yönetilir.
class YorungeApp extends StatelessWidget {
  // Sabit kurucu metodumuz
  const YorungeApp({super.key});

  // Arayüzü inşa eden build metodu
  @override
  Widget build(BuildContext context) {
    // Tema değişikliğini anlık dinlemek için ValueListenableBuilder kullanıyoruz
    return ValueListenableBuilder<ThemeMode>(
      // Dinleyeceğimiz tema modu notifier'ı
      valueListenable: ThemeController.instance.themeModeNotifier,
      // Tema modu değiştikçe çalışan kurucu fonksiyon
      builder: (context, currentMode, _) {
        // MaterialApp kök bileşenini döndürüyoruz
        return MaterialApp(
          // Uygulamanın işletim sistemi düzeyindeki başlığı
          title: 'Yörünge Girişimcilik Platformu',
          // Sağ üstteki hata ayıklama debug bandını gizliyoruz
          debugShowCheckedModeBanner: false,
          // Gündüz modu / Şafak fırlatışı teması
          theme: AppTheme.lightTheme,
          // Gece modu / Derin uzay teması
          darkTheme: AppTheme.darkTheme,
          // O an seçili olan aktif tema modu
          themeMode: currentMode,
          // İlk açılacak başlangıç ekranı (Kimlik doğrulama ekranı)
          home: const AuthView(),
        ); // MaterialApp kapanışı
      }, // builder callback kapanışı
    ); // ValueListenableBuilder kapanışı
  } // build metodu kapanışı
} // YorungeApp sınıfı kapanışı
