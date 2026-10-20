import 'package:flutter/foundation.dart';
import '../data/mock_mentor_data.dart';
import '../models/mentor_model.dart';

/// Yörünge Platformu - Mentor Modülü Denetleyicisi.
/// 1. Kural: Sadece foundation.dart import edilir, harici paket bulunmaz.
class MentorController {
  late final List<MentorModel> _allMentors;

  /// Filtrelenmiş ve gösterilecek mentorların listesi
  late final ValueNotifier<List<MentorModel>> mentorsNotifier;

  /// Arama sorgusu bildirimcisi
  final ValueNotifier<String> searchQueryNotifier = ValueNotifier<String>('');

  /// Seçili sektör bildirimcisi (Varsayılan: 'Tümü')
  final ValueNotifier<String> selectedSectorNotifier =
      ValueNotifier<String>('Tümü');

  /// Mevcut sektör listesi
  final List<String> sectors = const [
    'Tümü',
    'Yapay Zeka',
    'Fintek',
    'SaaS',
    'Oyun',
    'E-ticaret',
    'Sağlık',
    'İklim',
  ];

  MentorController({List<MentorModel>? initialMentors}) {
    _allMentors = List<MentorModel>.from(initialMentors ?? kMockMentors);
    mentorsNotifier = ValueNotifier<List<MentorModel>>(List.unmodifiable(_allMentors));
  }

  /// Öne çıkan mentorlar listesi
  List<MentorModel> get featuredMentors =>
      _allMentors.where((m) => m.isFeatured).toList(growable: false);

  /// Arama metnine göre filtreleme
  void search(String query) {
    searchQueryNotifier.value = query;
    _applyFilters();
  }

  /// Sektöre göre filtreleme
  void filterBySector(String sector) {
    selectedSectorNotifier.value = sector;
    _applyFilters();
  }

  /// Filtreleri ve arama kriterlerini uygulayarak `mentorsNotifier`'ı günceller
  void _applyFilters() {
    final query = searchQueryNotifier.value.trim().toLowerCase();
    final sector = selectedSectorNotifier.value;

    final filtered = _allMentors.where((mentor) {
      final matchesSector = sector == 'Tümü' || mentor.sector == sector;
      final matchesQuery = query.isEmpty ||
          mentor.name.toLowerCase().contains(query) ||
          mentor.company.toLowerCase().contains(query) ||
          mentor.title.toLowerCase().contains(query) ||
          mentor.expertise.any((e) => e.toLowerCase().contains(query));

      return matchesSector && matchesQuery;
    }).toList();

    mentorsNotifier.value = List.unmodifiable(filtered);
  }

  /// Eşleşme talebi gönderme (`none` -> `pending`)
  void requestMatch(String mentorId) {
    final index = _allMentors.indexWhere((m) => m.id == mentorId);
    if (index == -1) return;

    final mentor = _allMentors[index];
    if (mentor.matchStatus == MatchStatus.none) {
      _allMentors[index] = mentor.copyWith(matchStatus: MatchStatus.pending);
      _applyFilters();
    }
  }

  /// Bildirimcileri bellekten temizler
  void dispose() {
    mentorsNotifier.dispose();
    searchQueryNotifier.dispose();
    selectedSectorNotifier.dispose();
  }
}
