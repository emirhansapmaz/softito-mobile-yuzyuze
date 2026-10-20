import 'package:flutter/foundation.dart';

/// Yörünge Platformu - 8 Adımlı Girişim Analizi ve İş Planı Modeli
@immutable
class AnalizModel {
  final String ideaSummary; // 1. Adım: İş Fikri Özeti
  final String teamDetails; // 2. Adım: Ekip ve Yetkinlikler
  final String traction; // 3. Adım: Çekiş ve Büyüme Göstergeleri
  final String innovation; // 4. Adım: Yenilikçi Çözüm ve Teknoloji
  final String planTables; // 5. Adım: Finansal Tablolar ve Bütçe Planı
  final String marketAnalysis; // 6. Adım: Pazar Büyüklüğü ve Hedef Kitle
  final String brandPositioning; // 7. Adım: Marka Konumlandırma ve Go-to-Market
  final bool isCompleted; // 8. Adım: Nihai Onay ve Tamamlanma Durumu

  const AnalizModel({
    this.ideaSummary = '',
    this.teamDetails = '',
    this.traction = '',
    this.innovation = '',
    this.planTables = '',
    this.marketAnalysis = '',
    this.brandPositioning = '',
    this.isCompleted = false,
  });

  AnalizModel copyWith({
    String? ideaSummary,
    String? teamDetails,
    String? traction,
    String? innovation,
    String? planTables,
    String? marketAnalysis,
    String? brandPositioning,
    bool? isCompleted,
  }) {
    return AnalizModel(
      ideaSummary: ideaSummary ?? this.ideaSummary,
      teamDetails: teamDetails ?? this.teamDetails,
      traction: traction ?? this.traction,
      innovation: innovation ?? this.innovation,
      planTables: planTables ?? this.planTables,
      marketAnalysis: marketAnalysis ?? this.marketAnalysis,
      brandPositioning: brandPositioning ?? this.brandPositioning,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory AnalizModel.fromJson(Map<String, dynamic> json) {
    return AnalizModel(
      ideaSummary: json['ideaSummary'] as String? ?? '',
      teamDetails: json['teamDetails'] as String? ?? '',
      traction: json['traction'] as String? ?? '',
      innovation: json['innovation'] as String? ?? '',
      planTables: json['planTables'] as String? ?? '',
      marketAnalysis: json['marketAnalysis'] as String? ?? '',
      brandPositioning: json['brandPositioning'] as String? ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ideaSummary': ideaSummary,
      'teamDetails': teamDetails,
      'traction': traction,
      'innovation': innovation,
      'planTables': planTables,
      'marketAnalysis': marketAnalysis,
      'brandPositioning': brandPositioning,
      'isCompleted': isCompleted,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalizModel &&
          runtimeType == other.runtimeType &&
          ideaSummary == other.ideaSummary &&
          teamDetails == other.teamDetails &&
          traction == other.traction &&
          innovation == other.innovation &&
          planTables == other.planTables &&
          marketAnalysis == other.marketAnalysis &&
          brandPositioning == other.brandPositioning &&
          isCompleted == other.isCompleted;

  @override
  int get hashCode =>
      ideaSummary.hashCode ^
      teamDetails.hashCode ^
      traction.hashCode ^
      innovation.hashCode ^
      planTables.hashCode ^
      marketAnalysis.hashCode ^
      brandPositioning.hashCode ^
      isCompleted.hashCode;
}
