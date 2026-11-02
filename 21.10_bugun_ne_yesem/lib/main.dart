// Flutter Material tasarım bileşenlerini sağlayan kütüphane
import 'package:flutter/material.dart';
// Riverpod durum yönetimi (State Management) kütüphanesini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama geneli sabitleri (uygulama adı vb.) içeren sınıfı içe aktarıyoruz
import 'core/constants/app_constants.dart';
// Açık ve koyu tema yapılandırmalarımızı içeren tema sınıfı
import 'core/theme/app_theme.dart';
// Tema modu durumunu (Açık/Koyu) yöneten Riverpod sağlayıcısı
import 'core/providers/theme_provider.dart';
// Firebase servislerini güvenle başlatan başlatıcı sınıfımız
import 'core/services/firebase_initializer.dart';
// Uygulama ilk açıldığında ekrana gelen açılış (splash) ekranı
import 'features/auth/presentation/splash_screen.dart';

// Asenkron olarak Firebase ve temel servisleri başlatan ana fonksiyonumuz
void main() async {
  // Flutter motoru ve widget bağlayıcılarının hazır olduğundan emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase bağlantısını ve servislerini asenkron olarak ayağa kaldırıyoruz
  await FirebaseInitializer.initialize();
  // runApp ile uygulamayı başlatıyoruz
  runApp(
    // ProviderScope: Riverpod durum ağacının tüm uygulama boyunca çalışmasını sağlayan kök sarmalayıcı
    const ProviderScope(
      // Ana uygulamamız BugunNeYesemApp bileşenini bağlıyoruz
      child: BugunNeYesemApp(),
    // ProviderScope kapanışı
    ),
  // runApp kapanışı
  );
// main fonksiyonunun kapanış parantezi
}

// Riverpod sağlayıcılarını dinleyebilmek için StatelessWidget yerine ConsumerWidget'tan türetiyoruz
class BugunNeYesemApp extends ConsumerWidget {
  // BugunNeYesemApp sınıfının değişmez kurucu metodu
  const BugunNeYesemApp({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Widget ağacını oluşturan ve ref parametresiyle sağlayıcıları okuyan build fonksiyonu
  @override
  // BuildContext ve WidgetRef parametrelerini alıp Widget döndüren build metodu
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch ile aktif tema modunu (Açık, Koyu veya Sistem) reaktif olarak dinliyoruz
    final themeMode = ref.watch(themeModeProvider);

    // Uygulamanın kök MaterialApp bileşeni
    return MaterialApp(
      // Uygulama başlığı (sabitlerden çekiyoruz: Bugün Ne Yesem?)
      title: AppConstants.appName,
      // Sağ üst köşedeki kırmızı debug bandını kaldırıyoruz
      debugShowCheckedModeBanner: false,
      // Uygulamanın açık (light) tema stili
      theme: AppTheme.lightTheme,
      // Uygulamanın koyu (dark) tema stili
      darkTheme: AppTheme.darkTheme,
      // theme_provider'dan gelen aktif tema modunu uyguluyoruz
      themeMode: themeMode,
      // Uygulamanın açılış sayfası (Splash ekranı)
      home: const SplashScreen(),
    // MaterialApp kapanışı
    );
  // build metodu kapanış parantezi
  }
// BugunNeYesemApp sınıfının kapanış parantezi
}
