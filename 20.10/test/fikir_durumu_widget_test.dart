import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge_platform/core/theme/app_theme.dart';
import 'package:yorunge_platform/features/fikir_durumu/view/fikir_durumu_view.dart';

void main() {
  testWidgets('FikirDurumuView dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: const FikirDurumuView(),
      ),
    );
    await tester.pumpAndSettle();

    // Başlık ve Proje adı doğrulaması
    expect(find.text('Fikir & Hukuki Durum'), findsOneWidget);
    expect(find.text('VeriFlow SaaS Analitiği'), findsOneWidget);
    expect(find.text('Fikir Onaylandı'), findsOneWidget);

    // Avukat ve Gelir kartları doğrulaması
    expect(find.text('Ücretsiz Hukuki Danışmanınız'), findsOneWidget);
    expect(find.text('Av. İpek Kaya'), findsOneWidget);
    expect(find.text('Aylık Gelir Desteği Taahhüdü'), findsOneWidget);
    expect(find.text('%75'), findsOneWidget);

    // Yol haritası doğrulaması
    expect(find.text('Şirketleşme & Hukuki Yol Haritası'), findsOneWidget);
    expect(find.text('Avukat Ataması'), findsOneWidget);
    expect(find.text('TÜRKPATENT Marka Tescili'), findsOneWidget);

    // CTA butonu
    expect(find.text('Yeni İş Planı Analizi Başlat'), findsOneWidget);
  });
}
