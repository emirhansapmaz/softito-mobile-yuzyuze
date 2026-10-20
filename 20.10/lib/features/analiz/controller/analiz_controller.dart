import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_analiz_data.dart';
import '../models/analiz_model.dart';

/// Yörünge Platformu - 8 Adımlı Girişim Analizi Denetleyicisi.
/// 1. Kural: Saf foundation.dart import edilir, UI bulunmaz.
class AnalizController {
  static const String _draftStorageKey = 'yorunge_analiz_draft_v1';

  /// Aktif adım indeksi (0 - 7 arası, toplam 8 adım)
  final ValueNotifier<int> currentStepNotifier = ValueNotifier<int>(0);

  /// Form veri modelini tutan ve dinleyen reaktif bildirimci
  late final ValueNotifier<AnalizModel> formNotifier;

  /// Adım başlıkları listesi
  final List<String> stepTitles = const [
    'Fikir Özeti',
    'Kurucu Ekip',
    'Çekiş & Büyüme',
    'İnovasyon',
    'Finansal Tablo',
    'Pazar Analizi',
    'Konumlandırma',
    'Nihai İnceleme',
  ];

  AnalizController({AnalizModel? initialData}) {
    formNotifier = ValueNotifier<AnalizModel>(initialData ?? kEmptyAnalizData);
  }

  /// Aktif adım indeksi
  int get currentStep => currentStepNotifier.value;

  /// Aktif form verisi
  AnalizModel get currentForm => formNotifier.value;

  /// Bir sonraki adıma geçer ve taslağı otomatik kaydeder
  void nextStep() {
    if (currentStepNotifier.value < 7) {
      currentStepNotifier.value += 1;
      saveDraft();
    } else {
      // 8. Adımda tamamlandı olarak işaretle
      updateField(isCompleted: true);
      saveDraft();
    }
  }

  /// Bir önceki adıma döner
  void previousStep() {
    if (currentStepNotifier.value > 0) {
      currentStepNotifier.value -= 1;
    }
  }

  /// Belirli bir adıma doğrudan geçiş
  void goToStep(int step) {
    if (step >= 0 && step <= 7) {
      currentStepNotifier.value = step;
    }
  }

  /// Form alanlarını kısmi veya tam olarak günceller
  void updateField({
    String? ideaSummary,
    String? teamDetails,
    String? traction,
    String? innovation,
    String? planTables,
    String? marketAnalysis,
    String? brandPositioning,
    bool? isCompleted,
  }) {
    formNotifier.value = formNotifier.value.copyWith(
      ideaSummary: ideaSummary,
      teamDetails: teamDetails,
      traction: traction,
      innovation: innovation,
      planTables: planTables,
      marketAnalysis: marketAnalysis,
      brandPositioning: brandPositioning,
      isCompleted: isCompleted,
    );
  }

  /// Form verisini JSON olarak yerel belleğe (SharedPreferences) kaydeder
  Future<void> saveDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(formNotifier.value.toJson());
      await prefs.setString(_draftStorageKey, jsonString);
    } catch (e) {
      debugPrint('Taslak kaydedilirken hata oluştu: $e');
    }
  }

  /// Yerel bellekten kayıtlı taslağı yükler
  Future<void> loadDraft() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_draftStorageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final Map<String, dynamic> decoded =
            jsonDecode(jsonString) as Map<String, dynamic>;
        formNotifier.value = AnalizModel.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('Taslak yüklenirken hata oluştu: $e');
    }
  }

  /// Formu ve taslağı sıfırlar
  Future<void> resetForm() async {
    formNotifier.value = kEmptyAnalizData;
    currentStepNotifier.value = 0;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftStorageKey);
    } catch (e) {
      debugPrint('Taslak temizlenirken hata oluştu: $e');
    }
  }

  /// Bildirimcileri bellekten temizler
  void dispose() {
    currentStepNotifier.dispose();
    formNotifier.dispose();
  }
}
