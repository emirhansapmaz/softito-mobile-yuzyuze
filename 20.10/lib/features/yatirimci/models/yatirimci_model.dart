import 'package:flutter/foundation.dart';

/// Yörünge Platformu - Yatırımcı Veri Modeli
@immutable
class YatirimciModel {
  final String id;
  final String name;
  final String type; // Şirket, Holding, Melek Yatırımcı, VC
  final String investmentStage; // Ön Tohum, Tohum, Seri A, Seri B+
  final String ticketSize; // Örn: "$50K - $500K"
  final List<String> targetSectors;
  final String description;
  final String websiteUrl;

  const YatirimciModel({
    required this.id,
    required this.name,
    required this.type,
    required this.investmentStage,
    required this.ticketSize,
    required this.targetSectors,
    required this.description,
    required this.websiteUrl,
  });

  YatirimciModel copyWith({
    String? id,
    String? name,
    String? type,
    String? investmentStage,
    String? ticketSize,
    List<String>? targetSectors,
    String? description,
    String? websiteUrl,
  }) {
    return YatirimciModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      investmentStage: investmentStage ?? this.investmentStage,
      ticketSize: ticketSize ?? this.ticketSize,
      targetSectors: targetSectors ?? this.targetSectors,
      description: description ?? this.description,
      websiteUrl: websiteUrl ?? this.websiteUrl,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YatirimciModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          investmentStage == other.investmentStage &&
          ticketSize == other.ticketSize &&
          listEquals(targetSectors, other.targetSectors) &&
          description == other.description &&
          websiteUrl == other.websiteUrl;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      investmentStage.hashCode ^
      ticketSize.hashCode ^
      targetSectors.hashCode ^
      description.hashCode ^
      websiteUrl.hashCode;
}
