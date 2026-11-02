// Flutter'ın temel arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';

/// Yörünge Girişimcilik Platformu - Boşluk ve Boyutlandırma Standartları.
/// Ekranlar arasında görsel ritim ve tutarlılık sağlar.
class AppSpacing {
  // Sınıfın doğrudan new/örneklenmesini önlemek için özel kurucu metot
  const AppSpacing._();

  // --- Temel Skaler Değerler ---
  // Çok çok küçük boşluk (2 piksel)
  static const double xxs = 2.0;
  // Ekstra küçük boşluk (4 piksel)
  static const double xs = 4.0;
  // Küçük boşluk (8 piksel)
  static const double sm = 8.0;
  // Orta boşluk (16 piksel)
  static const double md = 16.0;
  // Geniş boşluk (24 piksel)
  static const double lg = 24.0;
  // Ekstra geniş boşluk (32 piksel)
  static const double xl = 32.0;
  // Dev boşluk (48 piksel)
  static const double xxl = 48.0;

  // --- Kenar Yuvarlaklıkları (BorderRadius) ---
  // Ekstra küçük köşe yuvarlaklığı (4 piksel)
  static const double radiusXs = 4.0;
  // Küçük köşe yuvarlaklığı (8 piksel)
  static const double radiusSm = 8.0;
  // Orta köşe yuvarlaklığı (16 piksel)
  static const double radiusMd = 16.0;
  // Geniş köşe yuvarlaklığı (24 piksel)
  static const double radiusLg = 24.0;
  // Ekstra geniş köşe yuvarlaklığı (32 piksel)
  static const double radiusXl = 32.0;
  // Tam yuvarlak kapsül köşesi (999 piksel)
  static const double radiusFull = 999.0;

  // --- Hazır Padding Değerleri ---
  // Sıfır iç boşluk
  static const EdgeInsets paddingZero = EdgeInsets.zero;
  // Her taraftan 4 piksel iç boşluk
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  // Her taraftan 8 piksel iç boşluk
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  // Her taraftan 16 piksel iç boşluk
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  // Her taraftan 24 piksel iç boşluk
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);
  // Her taraftan 32 piksel iç boşluk
  static const EdgeInsets paddingAllXl = EdgeInsets.all(xl);

  // Yatayda 8 piksel iç boşluk
  static const EdgeInsets paddingHorizontalSm =
      EdgeInsets.symmetric(horizontal: sm);
  // Yatayda 16 piksel iç boşluk
  static const EdgeInsets paddingHorizontalMd =
      EdgeInsets.symmetric(horizontal: md);
  // Yatayda 24 piksel iç boşluk
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);

  // Dikeyde 8 piksel iç boşluk
  static const EdgeInsets paddingVerticalSm =
      EdgeInsets.symmetric(vertical: sm);
  // Dikeyde 16 piksel iç boşluk
  static const EdgeInsets paddingVerticalMd =
      EdgeInsets.symmetric(vertical: md);
  // Dikeyde 24 piksel iç boşluk
  static const EdgeInsets paddingVerticalLg =
      EdgeInsets.symmetric(vertical: lg);

  // --- Dikey Boşluklar (Gap Heights) ---
  // 4 piksel dikey boşluk kutusu
  static const SizedBox gapH4 = SizedBox(height: xs);
  // 8 piksel dikey boşluk kutusu
  static const SizedBox gapH8 = SizedBox(height: sm);
  // 12 piksel dikey boşluk kutusu
  static const SizedBox gapH12 = SizedBox(height: 12.0);
  // 16 piksel dikey boşluk kutusu
  static const SizedBox gapH16 = SizedBox(height: md);
  // 24 piksel dikey boşluk kutusu
  static const SizedBox gapH24 = SizedBox(height: lg);
  // 32 piksel dikey boşluk kutusu
  static const SizedBox gapH32 = SizedBox(height: xl);
  // 48 piksel dikey boşluk kutusu
  static const SizedBox gapH48 = SizedBox(height: xxl);

  // --- Yatay Boşluklar (Gap Widths) ---
  // 4 piksel yatay boşluk kutusu
  static const SizedBox gapW4 = SizedBox(width: xs);
  // 8 piksel yatay boşluk kutusu
  static const SizedBox gapW8 = SizedBox(width: sm);
  // 12 piksel yatay boşluk kutusu
  static const SizedBox gapW12 = SizedBox(width: 12.0);
  // 16 piksel yatay boşluk kutusu
  static const SizedBox gapW16 = SizedBox(width: md);
  // 24 piksel yatay boşluk kutusu
  static const SizedBox gapW24 = SizedBox(width: lg);
  // 32 piksel yatay boşluk kutusu
  static const SizedBox gapW32 = SizedBox(width: xl);
} // AppSpacing sınıfı kapanışı
