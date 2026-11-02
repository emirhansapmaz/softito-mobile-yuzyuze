// Değiştirilemezlik ve liste eşitliği kontrolleri için foundation kütüphanesini içeri alıyoruz
import 'package:flutter/foundation.dart';

/// Mentorluk eşleşme talep durumu numaralandırması
enum MatchStatus {
  // Henüz talep gönderilmemiş durum
  none,
  // Talep gönderilmiş onay bekleyen durum
  pending,
  // Eşleşme kabul edilmiş ve mentor atanmış durum
  matched,
} // MatchStatus enum kapanışı

/// Yörünge Platformu - Mentor Veri Modeli
@immutable
class MentorModel {
  // Mentorun benzersiz kimliği
  final String id;
  // Mentorun tam adı ve unvanı
  final String name;
  // Görevi veya uzmanlık rolü
  final String title;
  // Çalıştığı şirket veya kurucusu olduğu kurum
  final String company;
  // Faaliyet gösterdiği dikey sektör (AI, Fintek vb.)
  final String sector;
  // Uzmanlık alanları etiket listesi
  final List<String> expertise;
  // Profil fotoğrafı internet bağlantı adresi
  final String imageUrl;
  // Ana sayfada öne çıkarılan mentor mu bayrağı
  final bool isFeatured;
  // Girişimci ile olan eşleşme talep durumu
  final MatchStatus matchStatus;

  // MentorModel kurucu metodu
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
  }); // Kurucu metod kapanışı

  // İstenilen alanları değiştirerek yeni kopya üreten copyWith metodu
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
    ); // MentorModel dönüşü
  } // copyWith metodu kapanışı

  // İki mentor nesnesinin eşitliğini denetleyen metot
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

  // Özet kodunu üreten getter
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
} // MentorModel sınıfı kapanışı
