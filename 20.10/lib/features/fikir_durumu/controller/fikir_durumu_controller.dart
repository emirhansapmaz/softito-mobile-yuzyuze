import 'package:flutter/foundation.dart';
import '../data/mock_fikir_durumu_data.dart';
import '../models/fikir_durumu_model.dart';

/// Yörünge Platformu - Fikir Durumu ve Şirketleşme Paneli Denetleyicisi.
/// 1. Kural: Sadece foundation.dart import edilir.
class FikirDurumuController {
  late final List<FikirDurumuModel> _allIdeas;

  /// Gösterilen aktif fikir durumunu tutan ve dinleyen reaktif bildirimci
  late final ValueNotifier<FikirDurumuModel> currentIdeaNotifier;

  /// Türkiye mevzuatına uygun 6 adımlı şirketleşme yol haritası
  final List<String> legalSteps = const [
    'Avukat Ataması',
    'Şirket Tipi Belirleme (A.Ş. / Ltd.)',
    'MERSİS Kuruluş Başvurusu',
    'Vergi Dairesi & Yoklama Onayı',
    'TÜRKPATENT Marka Tescili',
    'Hissedarlar Sözleşmesi (SHA)',
  ];

  FikirDurumuController({List<FikirDurumuModel>? initialData}) {
    _allIdeas = List<FikirDurumuModel>.from(initialData ?? kMockFikirDurumlari);
    currentIdeaNotifier = ValueNotifier<FikirDurumuModel>(_allIdeas.first);
  }

  /// Tüm fikir durumları listesi
  List<FikirDurumuModel> get allIdeas => List.unmodifiable(_allIdeas);

  /// Aktif incelenen fikri değiştirme
  void switchIdea(String id) {
    final found = _allIdeas.firstWhere(
      (idea) => idea.id == id,
      orElse: () => _allIdeas.first,
    );
    currentIdeaNotifier.value = found;
  }

  /// Bildirimcileri bellekten temizler
  void dispose() {
    currentIdeaNotifier.dispose();
  }
}
