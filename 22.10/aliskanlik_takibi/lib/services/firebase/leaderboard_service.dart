import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';

class LeaderboardUser {
  final UserModel user;
  final int rank;
  final int maxStreak;

  const LeaderboardUser({
    required this.user,
    required this.rank,
    this.maxStreak = 0,
  });
}

class LeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Toplam puana göre ilk 100 kullanıcıyı anlık olarak dinler
  Stream<List<UserModel>> getTopUsersStream() {
    return _firestore
        .collection(AppConstants.usersCollection)
        .orderBy('toplam_puan', descending: true)
        .limit(AppConstants.leaderboardLimit)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(UserModel.fromFirestore).toList());
  }

  /// Belirli bir kullanıcının tüm kullanıcılar arasındaki sırasını ve toplam kullanıcı sayısını getirir
  Future<({int rank, int totalUsers, int userPoints})> getUserRank(String uid) async {
    try {
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();

      if (!userDoc.exists) {
        return (rank: 1, totalUsers: 1, userPoints: 0);
      }

      final userData = UserModel.fromFirestore(userDoc);
      final userPoints = userData.toplamPuan;

      // Kullanıcıdan daha yüksek puana sahip olanların sayısı
      final higherPointsQuery = await _firestore
          .collection(AppConstants.usersCollection)
          .where('toplam_puan', isGreaterThan: userPoints)
          .count()
          .get();

      final totalCountQuery = await _firestore
          .collection(AppConstants.usersCollection)
          .count()
          .get();

      final int rank = (higherPointsQuery.count ?? 0) + 1;
      final int totalUsers = totalCountQuery.count ?? 1;

      return (rank: rank, totalUsers: totalUsers > 0 ? totalUsers : 1, userPoints: userPoints);
    } catch (_) {
      return (rank: 1, totalUsers: 1, userPoints: 0);
    }
  }

  /// Kullanıcının en yüksek streak sayısını habits tablosundan getirir
  Future<int> getUserMaxStreak(String uid) async {
    try {
      final habitsQuery = await _firestore
          .collection(AppConstants.habitsCollection)
          .where('uid', isEqualTo: uid)
          .get();

      int maxStreak = 0;
      for (final doc in habitsQuery.docs) {
        final data = doc.data();
        final streak = (data['aktif_streak'] as num?)?.toInt() ?? 0;
        final longest = (data['en_uzun_streak'] as num?)?.toInt() ?? 0;
        if (streak > maxStreak) maxStreak = streak;
        if (longest > maxStreak) maxStreak = longest;
      }
      return maxStreak;
    } catch (_) {
      return 0;
    }
  }
}
