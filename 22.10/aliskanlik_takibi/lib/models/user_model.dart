import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String adSoyad;
  final String kullaniciAdi;
  final String email;
  final String telefon;
  final DateTime kayitTarihi;
  final int toplamPuan;

  const UserModel({
    required this.uid,
    required this.adSoyad,
    required this.kullaniciAdi,
    required this.email,
    this.telefon = '',
    required this.kayitTarihi,
    this.toplamPuan = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'ad_soyad': adSoyad,
      'kullanici_adi': kullaniciAdi,
      'email': email,
      'telefon': telefon,
      'kayit_tarihi': Timestamp.fromDate(kayitTarihi),
      'toplam_puan': toplamPuan,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    DateTime parsedDate;
    if (map['kayit_tarihi'] is Timestamp) {
      parsedDate = (map['kayit_tarihi'] as Timestamp).toDate();
    } else if (map['kayit_tarihi'] is String) {
      parsedDate = DateTime.tryParse(map['kayit_tarihi']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return UserModel(
      uid: documentId,
      adSoyad: map['ad_soyad'] as String? ?? '',
      kullaniciAdi: map['kullanici_adi'] as String? ?? '',
      email: map['email'] as String? ?? '',
      telefon: map['telefon'] as String? ?? '',
      kayitTarihi: parsedDate,
      toplamPuan: (map['toplam_puan'] as num?)?.toInt() ?? 0,
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return UserModel.fromMap(data, doc.id);
  }

  UserModel copyWith({
    String? uid,
    String? adSoyad,
    String? kullaniciAdi,
    String? email,
    String? telefon,
    DateTime? kayitTarihi,
    int? toplamPuan,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      adSoyad: adSoyad ?? this.adSoyad,
      kullaniciAdi: kullaniciAdi ?? this.kullaniciAdi,
      email: email ?? this.email,
      telefon: telefon ?? this.telefon,
      kayitTarihi: kayitTarihi ?? this.kayitTarihi,
      toplamPuan: toplamPuan ?? this.toplamPuan,
    );
  }
}
