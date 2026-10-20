import 'package:flutter/foundation.dart';
import '../data/mock_yatirimci_data.dart';
import '../models/yatirimci_model.dart';

/// Yörünge Platformu - Yatırımcı Modülü Denetleyicisi.
/// 1. Kural: Sadece foundation.dart import edilir.
class YatirimciController {
  late final List<YatirimciModel> _allYatirimcilar;

  /// Filtrelenmiş yatırımcılar listesi
  late final ValueNotifier<List<YatirimciModel>> yatirimcilarNotifier;

  /// Seçili yatırımcı türü bildirimcisi (Varsayılan: 'Tümü')
  final ValueNotifier<String> selectedTypeNotifier =
      ValueNotifier<String>('Tümü');

  /// Seçili yatırım aşaması bildirimcisi (Varsayılan: 'Tümü')
  final ValueNotifier<String> selectedStageNotifier =
      ValueNotifier<String>('Tümü');

  /// Mevcut yatırımcı türleri
  final List<String> types = const [
    'Tümü',
    'Şirket',
    'Holding',
    'Melek Yatırımcı',
    'VC',
  ];

  /// Mevcut yatırım aşamaları
  final List<String> stages = const [
    'Tümü',
    'Ön Tohum',
    'Tohum',
    'Seri A',
    'Seri B+',
  ];

  YatirimciController({List<YatirimciModel>? initialData}) {
    _allYatirimcilar =
        List<YatirimciModel>.from(initialData ?? kMockYatirimcilar);
    yatirimcilarNotifier =
        ValueNotifier<List<YatirimciModel>>(List.unmodifiable(_allYatirimcilar));
  }

  /// Yatırımcı türü ve aşama filtrelerini birlikte uygular
  void filter({String? type, String? stage}) {
    if (type != null) {
      selectedTypeNotifier.value = type;
    }
    if (stage != null) {
      selectedStageNotifier.value = stage;
    }

    final activeType = selectedTypeNotifier.value;
    final activeStage = selectedStageNotifier.value;

    final filtered = _allYatirimcilar.where((item) {
      final matchesType = activeType == 'Tümü' || item.type == activeType;
      final matchesStage =
          activeStage == 'Tümü' || item.investmentStage == activeStage;
      return matchesType && matchesStage;
    }).toList();

    yatirimcilarNotifier.value = List.unmodifiable(filtered);
  }

  /// Yatırımcının web sitesini açma eylemi (mock simülasyon)
  void openWebsite(String url) {
    debugPrint('Yatırımcı web sitesi yönlendiriliyor: $url');
  }

  /// Bildirimcileri bellekten temizler
  void dispose() {
    yatirimcilarNotifier.dispose();
    selectedTypeNotifier.dispose();
    selectedStageNotifier.dispose();
  }
}
