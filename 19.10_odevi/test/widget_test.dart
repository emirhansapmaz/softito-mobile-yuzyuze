import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dijital_gunluk/main.dart';
import 'package:dijital_gunluk/features/diary/widgets/diary_card.dart';
import 'package:dijital_gunluk/features/diary/widgets/diary_calendar_bar.dart';
import 'package:dijital_gunluk/features/diary/widgets/diary_logo.dart';
import 'package:dijital_gunluk/features/diary/widgets/month_calendar_dialog.dart';

void main() {
  testWidgets('memonolog ana ekranı ve Instagram tarzı başlık render testi',
      (WidgetTester tester) async {
    // Uygulamayı başlat
    await tester.pumpWidget(const MemonologApp());
    await tester.pumpAndSettle();

    // Instagram tarzı ortalanmış Memonolog logosunu kontrol et
    expect(find.byType(MemonologLogo), findsOneWidget);

    // Takvim şeridinin yüklendiğini kontrol et
    expect(find.byType(DiaryCalendarBar), findsOneWidget);

    // Başlangıç verilerinin (DiaryCard) render edildiğini doğrula
    expect(find.byType(DiaryCard), findsWidgets);

    // FAB butonunun varlığını doğrula
    expect(find.text('Yeni Memonolog'), findsOneWidget);
    expect(find.byIcon(Icons.edit_rounded), findsOneWidget);
  });

  testWidgets('Takvim başlığına basıldığında MonthCalendarDialog açılmalı',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MemonologApp());
    await tester.pumpAndSettle();

    // Takvim başlığındaki takvim ikonuna veya başlığına tıkla
    await tester.tap(find.byIcon(Icons.calendar_month_rounded));
    await tester.pumpAndSettle();

    // MonthCalendarDialog açıldığını doğrula
    expect(find.byType(MonthCalendarDialog), findsOneWidget);
    expect(find.text('Kapat'), findsOneWidget);
    expect(find.text('Bugün'), findsWidgets);

    // Kapat butonuna basarak kapat
    await tester.tap(find.text('Kapat'));
    await tester.pumpAndSettle();

    expect(find.byType(MonthCalendarDialog), findsNothing);
  });

  testWidgets('Günlük kartındaki Düzenle butonuna basıldığında düzenleme modalı açılmalı',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MemonologApp());
    await tester.pumpAndSettle();

    // Karttaki Düzenle butonunu bul ve tıkla
    final editButton = find.text('Düzenle').first;
    expect(editButton, findsOneWidget);
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    // Düzenleme başlığını ve kaydet butonunu doğrula
    expect(find.text('Memonoloğu Düzenle'), findsOneWidget);
    expect(find.text('Değişiklikleri Kaydet'), findsOneWidget);

    // Kapat
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Memonoloğu Düzenle'), findsNothing);
  });
}
