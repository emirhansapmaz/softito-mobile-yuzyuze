import 'package:cloud_firestore/cloud_firestore.dart';

class TipModel {
  final String id;
  final String icerik;
  final String kategori;

  const TipModel({
    required this.id,
    required this.icerik,
    required this.kategori,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'icerik': icerik,
      'kategori': kategori,
    };
  }

  factory TipModel.fromMap(Map<String, dynamic> map, String docId) {
    return TipModel(
      id: docId,
      icerik: map['icerik'] as String? ?? '',
      kategori: map['kategori'] as String? ?? 'genel',
    );
  }

  factory TipModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return TipModel.fromMap(data, doc.id);
  }

  /// Firestore henüz doldurulmadıysa veya offline ise kullanılacak bilimsel gerçekler
  static const List<TipModel> defaultTips = [
    TipModel(
      id: 'tip_1',
      icerik: 'Sigarayı bıraktıktan 20 dakika sonra kalp atış hızınız ve kan basıncınız normale döner.',
      kategori: 'sigara',
    ),
    TipModel(
      id: 'tip_2',
      icerik: 'Sigarasız geçen 48 saat sonra koku ve tat alma duyularınız belirgin şekilde keskinleşir.',
      kategori: 'sigara',
    ),
    TipModel(
      id: 'tip_3',
      icerik: 'Sigarayı bıraktıktan 72 saat sonra akciğer bronşları gevşer, nefes alıp vermek hissedilir derecede kolaylaşır.',
      kategori: 'sigara',
    ),
    TipModel(
      id: 'tip_4',
      icerik: 'Alkol tüketimini bıraktıktan 1 hafta sonra uyku kaliteniz artar ve derin REM uykusu süresi uzar.',
      kategori: 'alkol',
    ),
    TipModel(
      id: 'tip_5',
      icerik: 'Sigarayı bıraktıktan 1 ay sonra öksürük ve nefes darlığı nöbetleri büyük oranda azalır.',
      kategori: 'sigara',
    ),
    TipModel(
      id: 'tip_6',
      icerik: 'Alkolü bıraktıktan 1 ay sonra karaciğerdeki yağlanma %15 oranında gerilemeye başlar.',
      kategori: 'alkol',
    ),
    TipModel(
      id: 'tip_7',
      icerik: 'Sigarasız geçen 1 yılın ardından koroner kalp hastalığı riski yarı yarıya iner.',
      kategori: 'sigara',
    ),
  ];
}
