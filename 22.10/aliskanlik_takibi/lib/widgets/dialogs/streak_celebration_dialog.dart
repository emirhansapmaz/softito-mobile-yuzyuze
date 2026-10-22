import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../common/custom_button.dart';

class StreakCelebrationDialog extends StatelessWidget {
  final String habitTitle;
  final int streakCount;

  const StreakCelebrationDialog({
    super.key,
    required this.habitTitle,
    required this.streakCount,
  });

  static Future<void> show(
    BuildContext context, {
    required String habitTitle,
    required int streakCount,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => StreakCelebrationDialog(
        habitTitle: habitTitle,
        streakCount: streakCount,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Soft Alev / Streak Rozet Çemberi
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.streakFlame.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.streakFlame.withValues(alpha: 0.35),
                  width: 2,
                ),
              ),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.local_fire_department_rounded,
                      color: AppColors.streakFlame,
                      size: 32,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '$streakCount',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.streakFlame,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Tebrik Başlığı
            Text(
              'Zinciri Kırmadın!',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),

            // Motivasyon Mesajı
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.45,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
                children: [
                  const TextSpan(text: 'Tebrikler! '),
                  TextSpan(
                    text: habitTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const TextSpan(text: ' serin tam '),
                  TextSpan(
                    text: '$streakCount güne ',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.streakFlame,
                    ),
                  ),
                  const TextSpan(text: 'ulaştı! İraden her geçen gün daha da güçleniyor.'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Kapat / Devam Et Butonu
            CustomButton(
              text: 'Böyle Devam Et!',
              height: 48,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
