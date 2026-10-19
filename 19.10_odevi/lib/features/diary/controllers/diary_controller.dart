import 'package:flutter/material.dart';
import '../models/diary_model.dart';

/// Günlük ve takvim mantığını yöneten reaktif kontrolcü.
/// Sayfa düzeyinde setState yerine ValueNotifier dinleyicileri kullanılır.
class DiaryController {
  DiaryController() {
    // Başlangıçta örnek verileri yükle ve bugünü filtrele
    _seedInitialEntries();
    _updateFilteredEntries();
  }

  /// Seçili takvim tarihi
  final ValueNotifier<DateTime> selectedDate =
      ValueNotifier<DateTime>(DateTime.now());

  /// Tüm kayıtlı günlük girdileri
  final ValueNotifier<List<DiaryEntry>> allEntries =
      ValueNotifier<List<DiaryEntry>>([]);

  /// Seçili tarihe göre filtrelenmiş aktif liste
  final ValueNotifier<List<DiaryEntry>> filteredEntries =
      ValueNotifier<List<DiaryEntry>>([]);

  /// Tarih seçimi değiştiğinde çağrılır
  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    _updateFilteredEntries();
  }

  /// Yeni günlük girdisi ekleme
  void addEntry(DiaryEntry entry) {
    final updated = List<DiaryEntry>.from(allEntries.value)..insert(0, entry);
    allEntries.value = updated;
    _updateFilteredEntries();
  }

  /// Bir günlük girdisini güncelleme
  void updateEntry(DiaryEntry updatedEntry) {
    final updatedList = allEntries.value.map((e) {
      return e.id == updatedEntry.id ? updatedEntry : e;
    }).toList();
    allEntries.value = updatedList;
    _updateFilteredEntries();
  }

  /// Bir günlük girdisini silme
  void deleteEntry(String id) {
    final updated = List<DiaryEntry>.from(allEntries.value)
      ..removeWhere((e) => e.id == id);
    allEntries.value = updated;
    _updateFilteredEntries();
  }

  /// Tüm girdileri temizleme
  void clearEntries() {
    allEntries.value = const [];
    _updateFilteredEntries();
  }

  /// Belirli bir tarihte kayıt olup olmadığını kontrol eder (Takvimdeki indikatörler için)
  bool hasEntriesOn(DateTime date) {
    final key = formatDateKey(date);
    return allEntries.value.any((e) => e.dateString == key);
  }

  /// YYYY-MM-DD anahtar biçimi
  static String formatDateKey(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// İki tarihin aynı takvim günü olup olmadığını denetler
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _updateFilteredEntries() {
    final key = formatDateKey(selectedDate.value);
    final filtered =
        allEntries.value.where((entry) => entry.dateString == key).toList();
    filteredEntries.value = List.unmodifiable(filtered);
  }

  /// İlk açılışta kullanıcının estetik tasarımı görebilmesi için başlangıç verileri
  void _seedInitialEntries() {
    final now = DateTime.now();
    final todayKey = formatDateKey(now);
    final yesterdayKey = formatDateKey(now.subtract(const Duration(days: 1)));

    allEntries.value = [
      DiaryEntry(
        id: '1',
        title: 'Yeni Projeye Başlarken',
        content:
            'Bugün dijital günlük projesinin arayüzünü ve mimarisini tasarlamaya başladım. Clean Architecture ve ValueNotifier yapısı harika bir akıcılık sağlıyor.',
        dateString: todayKey,
        timeString: '10:30',
        mood: 'inspired',
      ),
      DiaryEntry(
        id: '2',
        title: 'Öğleden Sonra Kahvesi & Düşünceler',
        content:
            'Sakin bir yağmur eşliğinde kahvemi yudumlarken hedeflerimi gözden geçirdim. Küçük adımların büyük farklar yarattığını hatırlamak iyi hissettirdi.',
        dateString: todayKey,
        timeString: '15:45',
        mood: 'calm',
      ),
      DiaryEntry(
        id: '3',
        title: 'Haftalık Planlama ve Yürüyüş',
        content:
            'Dün akşam sahil kenarında uzun bir yürüyüş yaptım. Zihnimi toparlamak ve haftaya enerjik girmek için harika bir fırsat oldu.',
        dateString: yesterdayKey,
        timeString: '19:20',
        mood: 'peaceful',
      ),
    ];
  }

  /// Bellek sızıntılarını önlemek için dispose
  void dispose() {
    selectedDate.dispose();
    allEntries.dispose();
    filteredEntries.dispose();
  }
}
