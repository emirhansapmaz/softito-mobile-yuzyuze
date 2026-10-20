import 'package:flutter/foundation.dart';

/// Mentorluk eşleşme talep durumu
enum MatchStatus {
  none,
  pending,
  matched,
}

/// Yörünge Platformu - Mentor Veri Modeli
@immutable
class MentorModel {
  final String id;
  final String name;
  final String title;
  final String company;
  final String sector;
  final List<String> expertise;
  final String imageUrl;
  final bool isFeatured;
  final MatchStatus matchStatus;

  const MentorModel({
    required this.id,
    required this.name,
    required this.title,
    required this.company,
    required this.sector,
    required this.expertise,
    required this.imageUrl,
    this.isFeatured = false,
    this.matchStatus = MatchStatus.none,
  });

  MentorModel copyWith({
    String? id,
    String? name,
    String? title,
    String? company,
    String? sector,
    List<String>? expertise,
    String? imageUrl,
    bool? isFeatured,
    MatchStatus? matchStatus,
  }) {
    return MentorModel(
      id: id ?? this.id,
      name: name ?? this.name,
      title: title ?? this.title,
      company: company ?? this.company,
      sector: sector ?? this.sector,
      expertise: expertise ?? this.expertise,
      imageUrl: imageUrl ?? this.imageUrl,
      isFeatured: isFeatured ?? this.isFeatured,
      matchStatus: matchStatus ?? this.matchStatus,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MentorModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          title == other.title &&
          company == other.company &&
          sector == other.sector &&
          listEquals(expertise, other.expertise) &&
          imageUrl == other.imageUrl &&
          isFeatured == other.isFeatured &&
          matchStatus == other.matchStatus;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      title.hashCode ^
      company.hashCode ^
      sector.hashCode ^
      expertise.hashCode ^
      imageUrl.hashCode ^
      isFeatured.hashCode ^
      matchStatus.hashCode;
}
