import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// memonolog (memory + monolog) uygulaması için samimi, sıcak tipografik logo.
/// 'memo' (hafıza) ve 'nolog' (iç ses) kelimelerinin birleşimini
/// sıcak kiremit ve espresso mürekkep tonlarıyla, doğal ve samimi bir dengede sunar.
class MemonologLogo extends StatelessWidget {
  final double fontSize;
  final bool isDarkOverride;

  const MemonologLogo({
    super.key,
    this.fontSize = 28,
    this.isDarkOverride = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark || isDarkOverride;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        RichText(
          text: TextSpan(
            children: [
              // 1. Kısım: 'memo' (Hafıza / Anı) - Sıcak, samimi terracotta tonu
              TextSpan(
                text: 'memo',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.5,
                  color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                ),
              ),
              // 2. Kısım: 'nolog' (Monolog / İç Ses) - Sıcak espresso mürekkep tonu
              TextSpan(
                text: 'nolog',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.7,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 3),
        // Doğal balmumu mührü / sıcak mürekkep damlası efekti
        Container(
          width: fontSize * 0.20,
          height: fontSize * 0.20,
          margin: const EdgeInsets.only(left: 1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
            boxShadow: [
              BoxShadow(
                color: (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                    .withValues(alpha: 0.35),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Geriye dönük uyumluluk için alias tanımları
typedef MonologLogo = MemonologLogo;
typedef DiaryLogo = MemonologLogo;
