// Flutter widget test kütüphanesini içe aktarıyoruz.
import 'package:flutter_test/flutter_test.dart';
// Test ortamında MultiProvider kurmak için Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Test edilecek ana uygulama widget'ını içe aktarıyoruz.
import 'package:sem_auto/main.dart';
// Test için gerekli olan Provider sınıflarını içe aktarıyoruz.
import 'package:sem_auto/providers/auth_provider.dart';
import 'package:sem_auto/providers/theme_provider.dart';
import 'package:sem_auto/providers/vehicle_provider.dart';
// Test edilecek logo bileşenini içe aktarıyoruz.
import 'package:sem_auto/widgets/sem_logo.dart';

/// SemAuto mobil uygulamasının temel duman (smoke) testlerini barındıran fonksiyon.
void main() {
  testWidgets('SemAutoApp smoke test', (WidgetTester tester) async {
    // 1. Uygulamayı gerekli tüm sağlayıcılar (Providers) ile test ortamında çizdiriyoruz.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => VehicleProvider()),
        ],
        child: const SemAutoApp(),
      ),
    );

    // 2. İlk karede Splash ekranının ve SEM Logo bileşeninin ekranda çizildiğini doğruluyoruz.
    expect(find.byType(SemLogo), findsWidgets);

    // 3. Splash ekranındaki 2.5 saniyelik zamanlayıcıyı (Timer) geçecek şekilde sanal zamanı ilerletiyoruz.
    await tester.pump(const Duration(milliseconds: 2600));
    // Tüm animasyon ve sayfa geçişlerinin tamamlanmasını bekliyoruz.
    await tester.pumpAndSettle();

    // 4. Geçiş sonrasında açılan Giriş Yap (Login) ekranında da logonun bulunduğunu doğruluyoruz.
    expect(find.byType(SemLogo), findsWidgets);
  });
}
