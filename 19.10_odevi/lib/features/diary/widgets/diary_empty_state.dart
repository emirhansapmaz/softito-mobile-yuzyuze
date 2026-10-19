import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// monolog uygulaması için ilham verici, modern ve estetik boş durum ekranı.
class DiaryEmptyState extends StatelessWidget {
  final VoidCallback onAddPressed;

  const DiaryEmptyState({
    super.key,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 36.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Çift Katmanlı Işıltılı İkon Rozeti
            Stack(
              alignment: Alignment.center,
              children: [
                // Dış Halka / Glow
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                            .withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                // İç Kapsül
                Container(
                  width: 78,
                  height: 78,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    border: Border.all(
                      color: (isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                          .withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary)
                            .withValues(alpha: 0.2),
                        blurRadius: 18,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_stories_rounded,
                    size: 34,
                    color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Edebi Başlık
            Text(
              'Bu Günün Sayfası Henüz Boş',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),

            const SizedBox(height: 10),

            // Edebi Alt Metin
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Zihnindeki anıları ve monoloğunu yazıya dökerek gününü ölümsüzleştir. Bugün seni ne hissettirdi?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.55,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),

            const SizedBox(height: 26),

            // Degrade Dolgulu Modern Aksiyon Butonu
            InkWell(
              onTap: onAddPressed,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkPrimaryGradient
                      : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                          .withValues(alpha: 0.22),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_rounded,
                      size: 17,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Günün Hikayesini Yaz',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
