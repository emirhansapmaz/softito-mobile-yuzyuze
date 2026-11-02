// Flutter'ın temel arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Standart boşluk ve kenarlık yarıçapı değerlerini içeri alıyoruz
import '../constants/app_spacing.dart';
// BuildContext yardımcı uzantılarını (context.spaceColors vs.) içeri alıyoruz
import '../extensions/context_extensions.dart';

/// Yörünge Platformu - Kozmik Parıltılı Kapsül Kartı.
/// 2. Kural: Sabit renk ve stil kullanılmaz, `context.spaceColors` kullanılır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class GlowCard extends StatelessWidget {
  // Kartın içerisine yerleştirilecek alt bileşen
  final Widget child;
  // Karta tıklandığında tetiklenecek fonksiyon
  final VoidCallback? onTap;
  // Kart içi kenar boşlukları (padding)
  final EdgeInsetsGeometry? padding;
  // Kart dışı kenar boşlukları (margin)
  final EdgeInsetsGeometry? margin;
  // Kart köşelerinin yuvarlaklık yarıçapı
  final BorderRadius? borderRadius;
  // Dış neon ışıma efektinin aktif olup olmadığını belirten bayrak
  final bool hasGlow;

  // GlowCard kurucu metodu
  const GlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.hasGlow = true,
  }); // Kurucu metod kapanışı

  // Arayüzü çizen build metodu
  @override
  Widget build(BuildContext context) {
    // Aktif tema renklerimizi uzantıdan çekiyoruz
    final colors = context.spaceColors;
    // Özel yarıçap belirtilmemişse standart 16 piksel yuvarlaklık kullanıyoruz
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd);

    // Dış container kutusunu döndürüyoruz
    return Container(
      // Dış kenar boşluğu
      margin: margin,
      // Dekorasyon ve gölge efektleri
      decoration: _buildDecoration(colors, effectiveRadius),
      // Tıklanma dalgalanma efekti için şeffaf zeminli Material bileşeni
      child: Material(
        color: Colors.transparent,
        // Tıklama algılayıcı InkWell
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: Padding(
            padding: padding ?? AppSpacing.paddingAllMd,
            child: child,
          ), // Padding kapanışı
        ), // InkWell kapanışı
      ), // Material kapanışı
    ); // Container kapanışı
  } // build metodu kapanışı

  // Kartın kutu dekorasyonunu ve neon ışıma gölgesini üreten yardımcı metot
  BoxDecoration _buildDecoration(dynamic colors, BorderRadius radius) {
    return BoxDecoration(
      // Kart arka plan rengi
      color: colors.cardBackground,
      // Yuvarlatılmış köşe yarıçapı
      borderRadius: radius,
      // Kenarlık çizgisi
      border: Border.all(
        // Parıltı açıksa iyon turkuazı/mavi, kapalıysa normal sınır çizgisi
        color: hasGlow ? colors.primary.withValues(alpha: 0.35) : colors.border,
        width: 1.0,
      ), // Border.all kapanışı
      // Kutu gölgeleri
      boxShadow: [
        // Parıltı bayrağı açıksa neon halesi ekliyoruz
        if (hasGlow)
          BoxShadow(
            color: colors.glow,
            blurRadius: 16.0,
            spreadRadius: -2.0,
            offset: const Offset(0, 4),
          ), // BoxShadow kapanışı
      ], // boxShadow listesi kapanışı
    ); // BoxDecoration kapanışı
  } // _buildDecoration metodu kapanışı
} // GlowCard sınıfı kapanışı
