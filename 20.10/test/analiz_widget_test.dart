import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge_platform/core/theme/app_theme.dart';
import 'package:yorunge_platform/features/analiz/view/analiz_view.dart';

void main() {
  testWidgets('AnalizView stepper and form interaction smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const AnalizView(),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Adım doğrulaması
    expect(find.text('8 Adımlı İş Planı Analizi'), findsOneWidget);
    expect(find.text('1. İş Fikri Özeti'), findsOneWidget);
    expect(find.text('İleri & Kaydet'), findsOneWidget);

    // İleri butonuna basış
    await tester.tap(find.text('İleri & Kaydet'));
    await tester.pumpAndSettle();

    // 2. Adım doğrulaması
    expect(find.text('2. Kurucu Ekip & Yetkinlikler'), findsOneWidget);
    expect(find.text('Geri'), findsOneWidget);

    // Geri butonuna basış
    await tester.tap(find.text('Geri'));
    await tester.pumpAndSettle();
    expect(find.text('1. İş Fikri Özeti'), findsOneWidget);
  });
}
