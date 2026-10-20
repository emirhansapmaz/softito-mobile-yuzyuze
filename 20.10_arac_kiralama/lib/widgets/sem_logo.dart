import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class SemLogo extends StatelessWidget {
  final double fontSize;
  final bool showSubtitle;
  final Color? autoColor;

  const SemLogo({
    super.key,
    this.fontSize = 32,
    this.showSubtitle = false,
    this.autoColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveAutoColor = autoColor ?? (isDark ? AppColors.textLight : AppColors.logoBlack);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: 'SEM ',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: AppColors.primaryBlue,
                ),
              ),
              TextSpan(
                text: 'Auto',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: effectiveAutoColor,
                ),
              ),
            ],
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 6),
          Text(
            'PREMIUM CAR RENTAL',
            style: TextStyle(
              fontSize: fontSize * 0.28,
              letterSpacing: 3.5,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
        ],
      ],
    );
  }
}
