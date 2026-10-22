import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../services/firebase/leaderboard_service.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final _leaderboardService = LeaderboardService();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Liderlik Sıralaması'),
      ),
      body: Column(
        children: [
          // 03_ana_ekranlar.md: "Üst Kısım: Kullanıcının mevcut durumu. Örn: 'X kişi arasında Y. sıradasın.'"
          FutureBuilder<({int rank, int totalUsers, int userPoints})>(
            future: _leaderboardService.getUserRank(_currentUid),
            builder: (context, rankSnapshot) {
              final rankData = rankSnapshot.data ?? (rank: 1, totalUsers: 1, userPoints: 0);

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppColors.surfaceVariantDark, AppColors.surfaceDark]
                        : [
                            AppColors.sageGreen.withValues(alpha: 0.25),
                            AppColors.sereneBlue.withValues(alpha: 0.15),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.sageGreen.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '#${rankData.rank}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.deepSage,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tebrikler! ${rankData.totalUsers} kişi arasında',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${rankData.rank}. Sıradasın',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.deepSage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            '${rankData.userPoints} P',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Liste Başlığı & Açıklaması
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top 100 İrade Tablosu',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                  ),
                ),
                Text(
                  'Puan / Streak',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Liderlik Listesi (StreamBuilder)
          Expanded(
            child: StreamBuilder<List<UserModel>>(
              stream: _leaderboardService.getTopUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data ?? [];
                if (users.isEmpty) {
                  return Center(
                    child: Text(
                      'Henüz sıralamada kimse bulunmuyor.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: users.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final rank = index + 1;
                    final isCurrentUser = user.uid == _currentUid;

                    return _buildLeaderboardTile(
                      context: context,
                      user: user,
                      rank: rank,
                      isCurrentUser: isCurrentUser,
                      isDark: isDark,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTile({
    required BuildContext context,
    required UserModel user,
    required int rank,
    required bool isCurrentUser,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    // İlk 3'e özel podyum renkleri
    Color? badgeColor;
    String? medalEmoji;
    if (rank == 1) {
      badgeColor = const Color(0xFFFFD700); // Altın
      medalEmoji = '🥇';
    } else if (rank == 2) {
      badgeColor = const Color(0xFFC0C0C0); // Gümüş
      medalEmoji = '🥈';
    } else if (rank == 3) {
      badgeColor = const Color(0xFFCD7F32); // Bronz
      medalEmoji = '🥉';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDark ? AppColors.surfaceVariantDark : AppColors.sageGreen.withValues(alpha: 0.16))
            : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentUser
              ? (isDark ? AppColors.sageGreen : AppColors.deepSage)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
          width: isCurrentUser ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Sıralama Numarası veya Madalya
          SizedBox(
            width: 32,
            child: medalEmoji != null
                ? Text(
                    medalEmoji,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  )
                : Text(
                    '$rank',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                    ),
                  ),
          ),
          const SizedBox(width: 12),

          // Avatar
          CircleAvatar(
            radius: 18,
            backgroundColor: badgeColor != null
                ? badgeColor.withValues(alpha: 0.25)
                : (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight),
            child: Text(
              user.adSoyad.isNotEmpty ? user.adSoyad[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Kullanıcı Adı ve İsim
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.adSoyad,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 14,
                          fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w600,
                        ),
                      ),
                    ),
                    if (isCurrentUser) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppColors.deepSage,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'SEN',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '@${user.kullaniciAdi}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // Puan
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${user.toplamPuan} P',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.deepSage,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Toplam Skor',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
