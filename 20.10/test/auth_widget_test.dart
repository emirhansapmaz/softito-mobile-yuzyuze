import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge_platform/core/theme/app_theme.dart';
import 'package:yorunge_platform/features/auth/view/auth_view.dart';
import 'package:yorunge_platform/features/auth/widget/logout_button.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('AuthView renders logo, roles, inputs and responds to role selection', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const AuthView(),
      ),
    );
    await tester.pumpAndSettle();

    // Başlık ve logo kontrolü
    expect(find.text('YÖRÜNGE'), findsOneWidget);
    expect(find.text('Girişimcilik ve Yatırım Ekosistemi'), findsOneWidget);

    // 3 rol kartı kontrolü
    expect(find.text('Girişimci'), findsOneWidget);
    expect(find.text('Mentor'), findsOneWidget);
    expect(find.text('Yatırımcı'), findsOneWidget);

    // Form alanları ve buton
    expect(find.text('E-Posta Adresi'), findsOneWidget);
    expect(find.text('Şifre'), findsOneWidget);
    expect(find.text('Yörüngeye Bağlan'), findsOneWidget);

    // Mentor rolüne dokunulduğunda email alanının senkronize olması
    await tester.tap(find.text('Mentor'));
    await tester.pumpAndSettle();
    expect(find.text('mentor@yorunge.com'), findsOneWidget);

    // Yatırımcı rolüne dokunulduğunda email alanının senkronize olması
    await tester.tap(find.text('Yatırımcı'));
    await tester.pumpAndSettle();
    expect(find.text('yatirimci@yorunge.com'), findsOneWidget);
  });

  testWidgets('LogoutButton opens dialog and logs out on confirmation', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            actions: const [LogoutButton()],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Logout ikonuna dokun
    await tester.tap(find.byType(LogoutButton));
    await tester.pumpAndSettle();

    // Dialog açıldı mı
    expect(find.text('Oturumu Kapat'), findsOneWidget);
    expect(find.text('Vazgeç'), findsOneWidget);
    expect(find.text('Çıkış Yap'), findsOneWidget);

    // Çıkış Yap'a bas ve AuthView'a yönlendirmeyi doğrula
    await tester.tap(find.text('Çıkış Yap'));
    await tester.pumpAndSettle();

    expect(find.byType(AuthView), findsOneWidget);
  });
}
