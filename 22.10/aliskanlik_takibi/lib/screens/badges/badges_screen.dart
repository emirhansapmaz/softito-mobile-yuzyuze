import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../models/badge_model.dart';
import '../../models/habit_model.dart';
import '../../services/firebase/habit_service.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final habitService = HabitService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kupa Dolabı ve Rozetler'),
      ),
      body: StreamBuilder<List<HabitModel>>(
        stream: habitService.getHabitsStream(currentUid),
        builder: (context, snapshot) {
          final habits = snapshot.data ?? [];

          // Kullanıcının en yüksek streak ve toplam tasarruf verisini hesapla
          int userMaxStreak = 0;
          double userTotalSavings = 0.0;

          for (final h in habits) {
            if (h.aktifStreak > userMaxStreak) userMaxStreak = h.aktifStreak;
            if (h.enUzunStreak > userMaxStreak) userMaxStreak = h.enUzunStreak;
            if (h.tip == HabitType.zararli) {
              userTotalSavings += h.toplamTasarruf;
            }
          }

          // Açılmış rozet sayısını bul
          final int unlockedCount = BadgeModel.allBadges.where((b) {
            return b.isUnlocked(maxStreak: userMaxStreak, totalSavings: userTotalSavings);
          }).length;

          final streakBadges = BadgeModel.allBadges
              .where((b) => b.kategori == BadgeCategory.streak)
              .toList();

          final savingBadges = BadgeModel.allBadges
              .where((b) => b.kategori == BadgeCategory.saving)
              .toList();

          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              // Üst Kupa Dolabı Özeti Kartı
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [AppColors.surfaceVariantDark, AppColors.surfaceDark]
                        : [
                            AppColors.sageGreen.withValues(alpha: 0.22),
                            AppColors.terracottaSoft.withValues(alpha: 0.12),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.sageGreen.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.military_tech_rounded,
                          size: 32,
                          color: AppColors.deepSage,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Başarı İlerlemen',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$unlockedCount / ${BadgeModel.allBadges.length} Rozet Açıldı',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.deepSage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Kategori 1: Seri Başarıları
              Text(
                'Seri Başarıları',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildBadgeGrid(
                context: context,
                badges: streakBadges,
                userMaxStreak: userMaxStreak,
                userTotalSavings: userTotalSavings,
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // Kategori 2: Tasarruf Başarıları
              Text(
                'Tasarruf Başarıları',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildBadgeGrid(
                context: context,
                badges: savingBadges,
                userMaxStreak: userMaxStreak,
                userTotalSavings: userTotalSavings,
                isDark: isDark,
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBadgeGrid({
    required BuildContext context,
    required List<BadgeModel> badges,
    required int userMaxStreak,
    required double userTotalSavings,
    required bool isDark,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: badges.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemBuilder: (context, index) {
        final badge = badges[index];
        final isUnlocked = badge.isUnlocked(
          maxStreak: userMaxStreak,
          totalSavings: userTotalSavings,
        );

        return _buildBadgeCard(
          context: context,
          badge: badge,
          isUnlocked: isUnlocked,
          isDark: isDark,
        );
      },
    );
  }

  Widget _buildBadgeCard({
    required BuildContext context,
    required BadgeModel badge,
    required bool isUnlocked,
    required bool isDark,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => _showBadgeDetail(context, badge, isUnlocked, isDark),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnlocked
              ? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight)
              : (isDark ? AppColors.surfaceVariantDark.withValues(alpha: 0.4) : AppColors.surfaceVariantLight.withValues(alpha: 0.5)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked
                ? (isDark ? AppColors.sageGreen.withValues(alpha: 0.5) : AppColors.sageGreen.withValues(alpha: 0.4))
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isUnlocked ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İkon / Kilit Rozeti
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? (isDark ? AppColors.surfaceVariantDark : AppColors.sageGreen.withValues(alpha: 0.18))
                    : (isDark ? AppColors.surfaceDark : AppColors.borderLight.withValues(alpha: 0.5)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isUnlocked ? badge.icon : Icons.lock_outline_rounded,
                  size: 26,
                  color: isUnlocked
                      ? (isDark ? AppColors.sageGreen : AppColors.deepSage)
                      : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Başlık
            Text(
              badge.baslik,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: isUnlocked
                    ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ),
            const SizedBox(height: 4),

            // Kilit Durumu Yazısı
            Text(
              isUnlocked ? 'Kazanıldı' : 'Kilitli',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isUnlocked
                    ? AppColors.success
                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBadgeDetail(
    BuildContext context,
    BadgeModel badge,
    bool isUnlocked,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Row(
          children: [
            Icon(
              isUnlocked ? badge.icon : Icons.lock_rounded,
              color: isUnlocked ? AppColors.deepSage : AppColors.textMutedLight,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                badge.baslik,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              badge.aciklama,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                isUnlocked
                    ? '✓ Bu başarıyı elde ettiniz!'
                    : 'Hedef: ${badge.kategori == BadgeCategory.streak ? "${badge.hedefDeger.toInt()} Gün Seri" : "${badge.hedefDeger.toStringAsFixed(0)} ₺ Tasarruf"}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isUnlocked ? AppColors.success : AppColors.warning,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}
