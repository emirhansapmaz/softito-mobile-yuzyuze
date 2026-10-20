import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge_platform/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Full app journey: Auth login -> Shell navigation -> Fikir Durumu', (WidgetTester tester) async {
    await tester.pumpWidget(const YorungeApp());
    await tester.pumpAndSettle();

    // AuthView Kontrolleri
    expect(find.text('YÖRÜNGE'), findsOneWidget);
    expect(find.text('Yörüngeye Bağlan'), findsOneWidget);

    // Giriş butonuna bas ve oturum açılmasını bekle
    final loginBtnFinder = find.text('Yörüngeye Bağlan');
    await tester.ensureVisible(loginBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(loginBtnFinder);
    await tester.pump(); // Spinner durumunu tetikle
    await tester.pump(const Duration(milliseconds: 1100)); // Future.delayed geçişi
    await tester.pumpAndSettle(); // ShellView geçişi

    // 1. Sekme: Mentor
    expect(find.text('Yörünge Platformu'), findsOneWidget);
    expect(find.text('Öne Çıkan Mentorlar'), findsOneWidget);

    // 2. Sekme: Yatırımcılar
    await tester.tap(find.text('Yatırımcılar'));
    await tester.pumpAndSettle();
    expect(find.text('Yatırımcı Ağı'), findsOneWidget);

    // 3. Sekme: Programlar
    await tester.tap(find.text('Programlar'));
    await tester.pumpAndSettle();
    expect(find.text('Destek Programları'), findsOneWidget);

    // 4. Sekme: Topluluk
    await tester.tap(find.text('Topluluk'));
    await tester.pumpAndSettle();
    expect(find.text('Girişimci Topluluğu'), findsOneWidget);
    expect(find.text('Paylaş'), findsOneWidget);

    // AppBar üzerindeki "Fikir Durumu" rozetine tıklayarak FikirDurumuView ekranına geçiş
    expect(find.text('Fikir Durumu'), findsOneWidget);
    await tester.tap(find.text('Fikir Durumu'));
    await tester.pumpAndSettle();

    expect(find.text('Fikir & Hukuki Durum'), findsOneWidget);
    expect(find.text('Şirketleşme & Hukuki Yol Haritası'), findsOneWidget);

    // Shell ekranına geri dön
    await tester.pageBack();
    await tester.pumpAndSettle();

    // Oturumu kapat butonuna dokun ve doğrula
    await tester.tap(find.byTooltip('Oturumu Kapat'));
    await tester.pumpAndSettle();

    expect(find.text('Oturumu Kapat'), findsOneWidget);
    await tester.tap(find.text('Çıkış Yap'));
    await tester.pumpAndSettle();

    // Başarıyla AuthView'a dönüldü
    expect(find.text('YÖRÜNGE'), findsOneWidget);
    expect(find.text('Yörüngeye Bağlan'), findsOneWidget);
  });
}
