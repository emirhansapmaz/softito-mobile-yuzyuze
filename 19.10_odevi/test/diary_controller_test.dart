import 'package:flutter_test/flutter_test.dart';
import 'package:dijital_gunluk/features/diary/controllers/diary_controller.dart';
import 'package:dijital_gunluk/features/diary/models/diary_model.dart';

void main() {
  group('DiaryController Testleri', () {
    late DiaryController controller;

    setUp(() {
      controller = DiaryController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta tohum veriler doğru yüklenmeli ve bugüne göre filtrelenmeli', () {
      expect(controller.allEntries.value.isNotEmpty, true);
      expect(controller.filteredEntries.value.isNotEmpty, true);
    });

    test('Tarih değiştirildiğinde filtrelenmiş liste reaktif güncellenmeli', () {
      // Henüz girdisi olmayan 10 gün sonrasına git
      final futureDate = DateTime.now().add(const Duration(days: 10));
      controller.changeDate(futureDate);

      expect(controller.filteredEntries.value.isEmpty, true);
      expect(controller.hasEntriesOn(futureDate), false);
    });

    test('Yeni günlük eklendiğinde filtreye anında yansımalı', () {
      final now = DateTime.now();
      final todayKey = DiaryController.formatDateKey(now);

      final initialCount = controller.filteredEntries.value.length;

      final newEntry = DiaryEntry(
        id: 'test_123',
        title: 'Birim Test Günlüğü',
        content: 'Bu bir test içeriğidir.',
        dateString: todayKey,
        timeString: '14:00',
        mood: 'happy',
      );

      controller.addEntry(newEntry);

      expect(controller.filteredEntries.value.length, initialCount + 1);
      expect(controller.filteredEntries.value.first.id, 'test_123');
      expect(controller.hasEntriesOn(now), true);
    });

    test('Günlük güncellendiğinde (updateEntry) yeni değerler yansımalı', () {
      final currentEntries = controller.filteredEntries.value;
      expect(currentEntries.isNotEmpty, true);

      final target = currentEntries.first;
      final updated = target.copyWith(
        title: 'Güncellenmiş Başlık',
        content: 'Güncellenmiş içerik metni.',
        mood: 'energetic',
      );

      controller.updateEntry(updated);

      final refreshed =
          controller.filteredEntries.value.firstWhere((e) => e.id == target.id);
      expect(refreshed.title, 'Güncellenmiş Başlık');
      expect(refreshed.content, 'Güncellenmiş içerik metni.');
      expect(refreshed.mood, 'energetic');
    });

    test('Günlük silindiğinde listeden ve filtreden kaldırılmalı', () {
      final currentEntries = controller.filteredEntries.value;
      if (currentEntries.isNotEmpty) {
        final targetId = currentEntries.first.id;
        final initialLength = controller.filteredEntries.value.length;

        controller.deleteEntry(targetId);

        expect(controller.filteredEntries.value.length, initialLength - 1);
        expect(
          controller.filteredEntries.value.any((e) => e.id == targetId),
          false,
        );
      }
    });

    test('clearEntries tüm listeyi temizlemeli', () {
      controller.clearEntries();
      expect(controller.allEntries.value.isEmpty, true);
      expect(controller.filteredEntries.value.isEmpty, true);
    });
  });
}
