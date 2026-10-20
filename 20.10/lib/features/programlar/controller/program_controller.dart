import 'package:flutter/foundation.dart';
import '../data/mock_program_data.dart';
import '../models/program_model.dart';

/// Yörünge Platformu - Destek Programları Denetleyicisi.
/// 1. Kural: Sadece foundation.dart import edilir, harici paket bulunmaz.
class ProgramController {
  late final List<ProgramModel> _allProgramlar;

  /// Filtrelenmiş programlar listesi
  late final ValueNotifier<List<ProgramModel>> programlarNotifier;

  /// Seçili kategori bildirimcisi (Varsayılan: 'Tümü')
  final ValueNotifier<String> selectedCategoryNotifier =
      ValueNotifier<String>('Tümü');

  /// Destek programı kategorileri
  final List<String> categories = const [
    'Tümü',
    'Hibe',
    'Devlet Desteği',
    'Yurtdışı',
    'Özel Fon',
    'Kuluçka',
  ];

  ProgramController({List<ProgramModel>? initialData}) {
    _allProgramlar = List<ProgramModel>.from(initialData ?? kMockProgramlar);
    programlarNotifier =
        ValueNotifier<List<ProgramModel>>(List.unmodifiable(_allProgramlar));
  }

  /// Kategoriye göre filtreleme
  void filterByCategory(String category) {
    selectedCategoryNotifier.value = category;

    if (category == 'Tümü') {
      programlarNotifier.value = List.unmodifiable(_allProgramlar);
      return;
    }

    final filtered =
        _allProgramlar.where((p) => p.category == category).toList();
    programlarNotifier.value = List.unmodifiable(filtered);
  }

  /// Program son başvuru tarihini takvime ekleme simülasyonu
  void addToCalendar(ProgramModel program) {
    debugPrint(
      'Takvime eklendi: ${program.title} (Son Tarih: ${program.deadline})',
    );
  }

  /// Bildirimcileri bellekten temizler
  void dispose() {
    programlarNotifier.dispose();
    selectedCategoryNotifier.dispose();
  }
}
