// Rastgele yıldız konumları üretmek için matematik kütüphanesini içeri alıyoruz
import 'dart:math' as math;
// Flutter temel materyal tasarım kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// BuildContext yardımcı uzantılarını içeri alıyoruz
import '../extensions/context_extensions.dart';

/// Yörünge Platformu - Derin Uzay & Şafak Fırlatışı Yıldız Alanı Arka Planı.
/// 2. Kural: Renkler doğrudan `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class StarfieldBackground extends StatelessWidget {
  // Arka plan üzerine bindirilecek ön plan widget'ı
  final Widget? child;
  // Ekranda çizilecek toplam rastgele yıldız sayısı (varsayılan: 70)
  final int starCount;

  // StarfieldBackground kurucu metodu
  const StarfieldBackground({
    super.key,
    this.child,
    this.starCount = 70,
  }); // Kurucu metod kapanışı

  // Arayüzü inşa eden build metodu
  @override
  Widget build(BuildContext context) {
    // Uzay renklerimizi tema uzantısından alıyoruz
    final colors = context.spaceColors;
    // Koyu tema modunda mıyız kontrol ediyoruz
    final isDark = context.isDarkMode;

    // Arka plan rengini boyayan ColoredBox döndürüyoruz
    return ColoredBox(
      color: colors.background,
      // Yıldızları özel olarak tuval üzerine çizen CustomPaint
      child: CustomPaint(
        painter: _StarfieldPainter(
          starColor: colors.starColor,
          glowColor: colors.glow,
          starCount: starCount,
          isDark: isDark,
        ), // _StarfieldPainter kapanışı
        // Ön plan çocuğu veya tam yayılan boş kutu
        child: child ?? const SizedBox.expand(),
      ), // CustomPaint kapanışı
    ); // ColoredBox kapanışı
  } // build metodu kapanışı
} // StarfieldBackground sınıfı kapanışı

/// Yıldızları ve kozmik ışıltıyı tuvale çizen CustomPainter sınıfı
class _StarfieldPainter extends CustomPainter {
  // Yıldız partiküllerinin rengi
  final Color starColor;
  // Nebula ışıma rengi
  final Color glowColor;
  // Çizilecek yıldız adedi
  final int starCount;
  // Koyu mod bayrağı
  final bool isDark;

  // Ressam kurucu metodu
  const _StarfieldPainter({
    required this.starColor,
    required this.glowColor,
    required this.starCount,
    required this.isDark,
  }); // Kurucu metod kapanışı

  // Tuval üzerine çizim yapan paint metodu
  @override
  void paint(Canvas canvas, Size size) {
    // İlk olarak arka plan nebula ışıltısını çiziyoruz
    _drawNebulaGlow(canvas, size);
    // Ardından üzerine yıldız partiküllerini serpiştiriyoruz
    _drawStars(canvas, size);
  } // paint metodu kapanışı

  // Sağ üst köşeden yayılan nebula ışımasını çizen yardımcı fonksiyon
  void _drawNebulaGlow(Canvas canvas, Size size) {
    // Ekran boyutunu kapsayan dikdörtgen alan
    final rect = Offset.zero & size;
    // Dairesel gradyan fırçası oluşturuyoruz
    final glowPaint = Paint()
      ..shader = RadialGradient(
        // Işımanın merkez noktası (sağ üst)
        center: const Alignment(0.6, -0.7),
        // Yarıçap katsayısı
        radius: 1.1,
        // Renk geçişleri
        colors: [
          glowColor.withValues(alpha: isDark ? 0.22 : 0.08),
          Colors.transparent,
        ], // Renk listesi kapanışı
      ).createShader(rect); // RadialGradient kapanışı

    // Tuvale nebula dikdörtgenini çiziyoruz
    canvas.drawRect(rect, glowPaint);
  } // _drawNebulaGlow metodu kapanışı

  // Rastgele koordinatlarda dairesel yıldızlar çizen yardımcı fonksiyon
  void _drawStars(Canvas canvas, Size size) {
    // Sabit tohum (seed: 42) ile rastgele sayı üreteci (her çizimde yıldızlar yer değiştirmesin)
    final random = math.Random(42);
    // Yıldız fırçası
    final starPaint = Paint()..color = starColor;

    // Belirlenen yıldız sayısı kadar döngü
    for (int i = 0; i < starCount; i++) {
      // X ekseninde rastgele koordinat
      final dx = random.nextDouble() * size.width;
      // Y ekseninde rastgele koordinat
      final dy = random.nextDouble() * size.height;
      // 0.5 ile 2.1 piksel arası rastgele yarıçap
      final radius = (random.nextDouble() * 1.6) + 0.5;
      // Yıldızın parlaklık saydamlığı
      final alpha = (random.nextDouble() * 0.5) + (isDark ? 0.35 : 0.15);

      // Fırça opaklığını ayarla
      starPaint.color = starColor.withValues(alpha: alpha);
      // Tuvale yıldız dairesini çiz
      canvas.drawCircle(Offset(dx, dy), radius, starPaint);
    } // for döngüsü sonu
  } // _drawStars metodu kapanışı

  // Çizimin yeniden tetiklenip tetiklenmeyeceğini belirleyen metot
  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) {
    // Renkler veya mod değiştiyse tuvali yeniden çiz
    return oldDelegate.starColor != starColor ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.isDark != isDark;
  } // shouldRepaint metodu kapanışı
} // _StarfieldPainter sınıfı kapanışı
