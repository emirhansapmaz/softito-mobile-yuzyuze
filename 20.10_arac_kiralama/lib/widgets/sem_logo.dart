// Flutter materyal tasarım kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Uygulama renk sabitlerini içe aktarıyoruz.
import '../core/theme/app_colors.dart';

/// SEM Auto markasına ait tipografik logo bileşeni.
/// 'SEM' kısmını mavi, 'Auto' kısmını tema duyarlı siyah/beyaz renkte çizer.
class SemLogo extends StatelessWidget {
  /// Logo metninin ana font boyutu (varsayılan: 32 piksel)
  final double fontSize;
  
  /// 'PREMIUM CAR RENTAL' alt başlığının gösterilip gösterilmeyeceğini belirleyen bayrak
  final bool showSubtitle;
  
  /// 'Auto' kelimesinin özel rengi (belirtilmezse temaya göre otomatik seçilir)
  final Color? autoColor;

  /// SemLogo kurucu metodu (Constructor)
  const SemLogo({
    super.key,
    this.fontSize = 32,
    this.showSubtitle = false,
    this.autoColor,
  });

  @override
  Widget build(BuildContext context) {
    // Koyu tema modunda mıyız kontrol ediyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 'Auto' kelimesi için geçerli rengi belirliyoruz: Koyu temada açık renk, açık temada logo siyahı.
    final effectiveAutoColor = autoColor ?? (isDark ? AppColors.textLight : AppColors.logoBlack);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Farklı renk ve stillerdeki metin parçalarını birleştirmek için RichText kullanıyoruz.
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              // 'SEM ' parçası: Kalın (w900) ve marka mavisi renginde
              TextSpan(
                text: 'SEM ',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: AppColors.primaryBlue,
                ),
              ),
              // 'Auto' parçası: Kalın (w700) ve temaya göre siyah/beyaz renkte
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
        // Alt başlık bayrağı true ise logonun altına 'PREMIUM CAR RENTAL' sloganını ekliyoruz.
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
