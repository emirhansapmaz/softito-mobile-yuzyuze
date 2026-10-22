import 'package:cloud_firestore/cloud_firestore.dart';

enum HabitType {
  saglikli,
  zararli;

  static HabitType fromString(String? value) {
    if (value == 'zararli') return HabitType.zararli;
    return HabitType.saglikli;
  }

  String toDbString() {
    switch (this) {
      case HabitType.zararli:
        return 'zararli';
      case HabitType.saglikli:
        return 'saglikli';
    }
  }
}

class HabitModel {
  final String habitId;
  final String uid;
  final String baslik;
  final HabitType tip;
  final double gunlukMaliyet;
  final DateTime olusturulmaTarihi;
  final int aktifStreak;
  final int enUzunStreak;

  const HabitModel({
    required this.habitId,
    required this.uid,
    required this.baslik,
    required this.tip,
    this.gunlukMaliyet = 0.0,
    required this.olusturulmaTarihi,
    this.aktifStreak = 0,
    this.enUzunStreak = 0,
  });

  /// 03_ana_ekranlar.md: (Geçen Gün) x (Günlük Harcama)
  /// Alışkanlığın oluşturulduğu tarihten bugüne kadar geçen gün sayısı üzerinden hesaplanır.
  double get toplamTasarruf {
    if (tip != HabitType.zararli || gunlukMaliyet <= 0) return 0.0;
    
    final now = DateTime.now();
    // Gün farkı hesaplama (en az aktifStreak veya oluşturulduğu tarihten bugüne geçen gün)
    final diffDays = now.difference(olusturulmaTarihi).inDays;
    final days = diffDays > aktifStreak ? diffDays : aktifStreak;
    final totalDays = days > 0 ? days : 1; // Başlangıç günü için en az 1 günlük oran
    
    return totalDays * gunlukMaliyet;
  }

  Map<String, dynamic> toMap() {
    return {
      'habit_id': habitId,
      'uid': uid,
      'baslik': baslik,
      'tip': tip.toDbString(),
      'gunluk_maliyet': gunlukMaliyet,
      'olusturulma_tarihi': Timestamp.fromDate(olusturulmaTarihi),
      'aktif_streak': aktifStreak,
      'en_uzun_streak': enUzunStreak,
    };
  }

  factory HabitModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parsedDate;
    if (map['olusturulma_tarihi'] is Timestamp) {
      parsedDate = (map['olusturulma_tarihi'] as Timestamp).toDate();
    } else if (map['olusturulma_tarihi'] is String) {
      parsedDate = DateTime.tryParse(map['olusturulma_tarihi']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return HabitModel(
      habitId: docId,
      uid: map['uid'] as String? ?? '',
      baslik: map['baslik'] as String? ?? '',
      tip: HabitType.fromString(map['tip'] as String?),
      gunlukMaliyet: (map['gunluk_maliyet'] as num?)?.toDouble() ?? 0.0,
      olusturulmaTarihi: parsedDate,
      aktifStreak: (map['aktif_streak'] as num?)?.toInt() ?? 0,
      enUzunStreak: (map['en_uzun_streak'] as num?)?.toInt() ?? 0,
    );
  }

  factory HabitModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return HabitModel.fromMap(data, doc.id);
  }

  HabitModel copyWith({
    String? habitId,
    String? uid,
    String? baslik,
    HabitType? tip,
    double? gunlukMaliyet,
    DateTime? olusturulmaTarihi,
    int? aktifStreak,
    int? enUzunStreak,
  }) {
    return HabitModel(
      habitId: habitId ?? this.habitId,
      uid: uid ?? this.uid,
      baslik: baslik ?? this.baslik,
      tip: tip ?? this.tip,
      gunlukMaliyet: gunlukMaliyet ?? this.gunlukMaliyet,
      olusturulmaTarihi: olusturulmaTarihi ?? this.olusturulmaTarihi,
      aktifStreak: aktifStreak ?? this.aktifStreak,
      enUzunStreak: enUzunStreak ?? this.enUzunStreak,
    );
  }
}
