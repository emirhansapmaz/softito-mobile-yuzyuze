import 'package:cloud_firestore/cloud_firestore.dart';

class HabitLogModel {
  final String logId;
  final String habitId;
  final DateTime tarih;
  final bool tamamlandiMi;

  const HabitLogModel({
    required this.logId,
    required this.habitId,
    required this.tarih,
    required this.tamamlandiMi,
  });

  Map<String, dynamic> toMap() {
    return {
      'log_id': logId,
      'habit_id': habitId,
      'tarih': Timestamp.fromDate(tarih),
      'tamamlandi_mi': tamamlandiMi,
    };
  }

  factory HabitLogModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime parsedDate;
    if (map['tarih'] is Timestamp) {
      parsedDate = (map['tarih'] as Timestamp).toDate();
    } else if (map['tarih'] is String) {
      parsedDate = DateTime.tryParse(map['tarih']) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return HabitLogModel(
      logId: docId,
      habitId: map['habit_id'] as String? ?? '',
      tarih: parsedDate,
      tamamlandiMi: map['tamamlandi_mi'] as bool? ?? false,
    );
  }

  factory HabitLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return HabitLogModel.fromMap(data, doc.id);
  }
}
