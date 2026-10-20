import 'package:flutter/material.dart';

/// Yörünge Girişimcilik Platformu - Boşluk ve Boyutlandırma Standartları.
/// Ekranlar arasında görsel ritim ve tutarlılık sağlar.
class AppSpacing {
  const AppSpacing._();

  // --- Temel Skaler Değerler ---
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  // --- Kenar Yuvarlaklıkları (BorderRadius) ---
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 16.0;
  static const double radiusLg = 24.0;
  static const double radiusXl = 32.0;
  static const double radiusFull = 999.0;

  // --- Hazır Padding Değerleri ---
  static const EdgeInsets paddingZero = EdgeInsets.zero;
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  static const EdgeInsets paddingHorizontalSm =
      EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  // --- Dikey Boşluklar (Gap Heights) ---
  static const SizedBox gapH4 = SizedBox(height: xs);
  static const SizedBox gapH8 = SizedBox(height: sm);
  static const SizedBox gapH12 = SizedBox(height: 12.0);
  static const SizedBox gapH16 = SizedBox(height: md);
  static const SizedBox gapH24 = SizedBox(height: lg);
  static const SizedBox gapH32 = SizedBox(height: xl);
  static const SizedBox gapH48 = SizedBox(height: xxl);

  // --- Yatay Boşluklar (Gap Widths) ---
  static const SizedBox gapW4 = SizedBox(width: xs);
  static const SizedBox gapW8 = SizedBox(width: sm);
  static const SizedBox gapW12 = SizedBox(width: 12.0);
  static const SizedBox gapW16 = SizedBox(width: md);
  static const SizedBox gapW24 = SizedBox(width: lg);
  static const SizedBox gapW32 = SizedBox(width: xl);
}
