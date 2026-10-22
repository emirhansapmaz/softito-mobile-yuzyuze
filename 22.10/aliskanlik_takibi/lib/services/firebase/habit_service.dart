import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../core/constants/app_constants.dart';
import '../../models/habit_model.dart';
import '../../models/habit_log_model.dart';
import '../../models/tip_model.dart';

class HabitService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  /// Kullanıcının alışkanlıklar listesini anlık (stream) olarak dinler
  Stream<List<HabitModel>> getHabitsStream(String uid) {
    return _firestore
        .collection(AppConstants.habitsCollection)
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(HabitModel.fromFirestore).toList());
  }

  /// Belirli bir güne ait log kayıtlarını anlık dinler
  Stream<List<HabitLogModel>> getTodayLogsStream() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return _firestore
        .collection(AppConstants.habitLogsCollection)
        .where('tarih', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('tarih', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
        .snapshots()
        .map((snapshot) => snapshot.docs.map(HabitLogModel.fromFirestore).toList());
  }

  /// Yeni alışkanlık ekleme
  Future<void> addHabit({
    required String uid,
    required String baslik,
    required HabitType tip,
    double gunlukMaliyet = 0.0,
  }) async {
    final habitId = _uuid.v4();
    final newHabit = HabitModel(
      habitId: habitId,
      uid: uid,
      baslik: baslik.trim(),
      tip: tip,
      gunlukMaliyet: tip == HabitType.zararli ? gunlukMaliyet : 0.0,
      olusturulmaTarihi: DateTime.now(),
      aktifStreak: 0,
      enUzunStreak: 0,
    );

    await _firestore
        .collection(AppConstants.habitsCollection)
        .doc(habitId)
        .set(newHabit.toMap());
  }

  /// Alışkanlığı tamamlandı olarak işaretle (Streak artışı ve Puanlama)
  /// Geriye güncellenmiş yeni streak sayısını döner.
  Future<int> completeHabit(HabitModel habit) async {
    final newStreak = habit.aktifStreak + 1;
    final newLongest = newStreak > habit.enUzunStreak ? newStreak : habit.enUzunStreak;

    // 1. habit_logs kaydı ekle
    final logId = _uuid.v4();
    final log = HabitLogModel(
      logId: logId,
      habitId: habit.habitId,
      tarih: DateTime.now(),
      tamamlandiMi: true,
    );

    await _firestore
        .collection(AppConstants.habitLogsCollection)
        .doc(logId)
        .set(log.toMap());

    // 2. habits belgesinde streak güncelle
    await _firestore
        .collection(AppConstants.habitsCollection)
        .doc(habit.habitId)
        .update({
      'aktif_streak': newStreak,
      'en_uzun_streak': newLongest,
    });

    // 3. Kullanıcı puanını güncelle (03_ana_ekranlar.md algoritması)
    // Taban puan: 10. Eğer streak >= 10 ise 1.5x çarpan (15 puan).
    final int earnedPoints = newStreak >= AppConstants.streakMultiplierThreshold
        ? (10 * AppConstants.streakMultiplier).round()
        : 10;

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(habit.uid)
        .update({
      'toplam_puan': FieldValue.increment(earnedPoints),
    });

    return newStreak;
  }

  /// Alışkanlık tamamlamasını geri al
  Future<void> uncompleteHabit(HabitModel habit, String logId) async {
    final newStreak = habit.aktifStreak > 0 ? habit.aktifStreak - 1 : 0;

    // 1. Log kaydını sil
    await _firestore
        .collection(AppConstants.habitLogsCollection)
        .doc(logId)
        .delete();

    // 2. Streak'i azalt
    await _firestore
        .collection(AppConstants.habitsCollection)
        .doc(habit.habitId)
        .update({
      'aktif_streak': newStreak,
    });

    // 3. Puanı geri al
    final int deductedPoints = habit.aktifStreak >= AppConstants.streakMultiplierThreshold
        ? (10 * AppConstants.streakMultiplier).round()
        : 10;

    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(habit.uid)
        .update({
      'toplam_puan': FieldValue.increment(-deductedPoints),
    });
  }

  /// Alışkanlığı sil
  Future<void> deleteHabit(String habitId) async {
    await _firestore
        .collection(AppConstants.habitsCollection)
        .doc(habitId)
        .delete();
  }

  /// Bilimsel gerçekler & uyarı bilgileri (Firestore veya varsayılanlar)
  Stream<List<TipModel>> getTipsStream() {
    return _firestore
        .collection(AppConstants.tipsCollection)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return TipModel.defaultTips;
      }
      return snapshot.docs.map(TipModel.fromFirestore).toList();
    });
  }
}
