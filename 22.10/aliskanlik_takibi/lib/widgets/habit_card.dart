import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/habit_model.dart';

class HabitCard extends StatelessWidget {
  final HabitModel habit;
  final bool isCompleted;
  final VoidCallback onToggle;
  final VoidCallback? onDelete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.isCompleted,
    required this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Tamamlanma durumuna göre soft renkler ve grileşme
    final cardBgColor = isCompleted
        ? (isDark ? AppColors.surfaceVariantDark.withValues(alpha: 0.5) : AppColors.surfaceVariantLight.withValues(alpha: 0.7))
        : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);

    final textColor = isCompleted
        ? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight);

    final isZararli = habit.tip == HabitType.zararli;

    return Dismissible(
      key: Key('habit_${habit.habitId}_$isCompleted'),
      direction: isCompleted ? DismissDirection.none : DismissDirection.startToEnd,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: AppColors.success, size: 28),
            SizedBox(width: 8),
            Text(
              'Tamamla',
              style: TextStyle(
                color: AppColors.success,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        if (!isCompleted) {
          onToggle();
        }
        return false; // Kartın listeden tamamen uçmasını engeller, durum güncellemesi Stream üzerinden tetiklenir
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCompleted
                ? Colors.transparent
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Checkbox / Tamamlandı Butonu
                GestureDetector(
                  onTap: onToggle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppColors.success
                          : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.success
                            : (isDark ? AppColors.borderDark : AppColors.sageGreen),
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: 14),

                // Başlık & Kategori Bilgisi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.baslik,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                          decorationColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isZararli
                                  ? AppColors.terracottaSoft.withValues(alpha: 0.15)
                                  : AppColors.sageGreen.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isZararli ? 'Bırakma Hedefi' : 'Geliştirme',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isZararli
                                    ? AppColors.terracottaSoft
                                    : (isDark ? AppColors.sageGreen : AppColors.deepSage),
                              ),
                            ),
                          ),
                          if (isZararli && habit.gunlukMaliyet > 0) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${habit.gunlukMaliyet.toStringAsFixed(0)} ₺ / gün',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Streak Rozeti (🔥 X Gün)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? (isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight)
                        : AppColors.streakFlame.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.local_fire_department_rounded,
                        size: 16,
                        color: isCompleted
                            ? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)
                            : AppColors.streakFlame,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.aktifStreak} Gün',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isCompleted
                              ? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)
                              : AppColors.streakFlame,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
