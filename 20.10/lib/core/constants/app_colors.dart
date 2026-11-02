// Flutter'ın temel arayüz ve renk kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';

/// Yörünge Girişimcilik Platformu - Renk Paleti ve SpaceColors Tema Uzantısı.
/// "Derin Uzay" (Dark) ve "Şafak Fırlatışı" (Light) temalarına özel kozmik tonlar içerir.
class AppColors {
  // Sınıfın dışarıdan örneklenmesini engellemek için gizli kurucu metot
  const AppColors._();

  // --- Derin Uzay (Dark Mode) Renkleri ---
  // Sonsuz Uzay Siyahı arka plan rengi
  static const Color darkBackground = Color(0xFF0A0D14);
  // Yörünge İstasyonu Yüzeyi rengi
  static const Color darkSurface = Color(0xFF121724);
  // Kozmik Kapsül Kartı arka plan rengi
  static const Color darkCardBackground = Color(0xFF171F32);
  // İyon İtki Turkuazı birincil tema rengi
  static const Color darkPrimary = Color(0xFF00F0FF);
  // Kozmik Morötesi gradyan bitiş rengi
  static const Color darkPrimaryGradientEnd = Color(0xFF7000FF);
  // Roket İtici Alevi ikincil rengi
  static const Color darkSecondary = Color(0xFFFF5E00);
  // Süpernova Altını vurgu rengi
  static const Color darkAccent = Color(0xFFFFB800);
  // Yıldız Işığı Beyazı ana metin rengi
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  // Nebula Grisi ikincil metin rengi
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  // Yörünge Hattı sınır ve kenarlık rengi
  static const Color darkBorder = Color(0xFF26324D);
  // Neon Halesi ışıma efekti rengi
  static const Color darkGlow = Color(0x6600F0FF);

  // --- Şafak Fırlatışı (Light Mode) Renkleri ---
  // Şafak Göğü açık arka plan rengi
  static const Color lightBackground = Color(0xFFF4F7FB);
  // Fırlatma Üssü Yüzeyi beyaz yüzey rengi
  static const Color lightSurface = Color(0xFFFFFFFF);
  // Beyaz Kapsül Kartı kart arka plan rengi
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  // Fırlatma Mavisi birincil tema rengi
  static const Color lightPrimary = Color(0xFF0066FF);
  // Şafak Alacakaranlığı gradyan bitiş rengi
  static const Color lightPrimaryGradientEnd = Color(0xFF5B21B6);
  // Güneş Doğuşu Turuncusu ikincil rengi
  static const Color lightSecondary = Color(0xFFEA580C);
  // Roket Kıvılcımı vurgu rengi
  static const Color lightAccent = Color(0xFFD97706);
  // Gece Sonu Laciverti ana metin rengi
  static const Color lightTextPrimary = Color(0xFF0F172A);
  // Fırlatma Dumanı Grisi ikincil metin rengi
  static const Color lightTextSecondary = Color(0xFF64748B);
  // Atmosfer Tabakası Çizgisi kenarlık rengi
  static const Color lightBorder = Color(0xFFE2E8F0);
  // Şafak Halesi açık ışıma rengi
  static const Color lightGlow = Color(0x330066FF);

  // --- Sistem & Durum Renkleri ---
  // Başarılı Yörüngeye Giriş yeşil durum rengi
  static const Color success = Color(0xFF10B981);
  // Telemetri Uyarısı amber uyarı rengi
  static const Color warning = Color(0xFFF59E0B);
  // Kritik Yörünge Sapması kırmızı hata rengi
  static const Color error = Color(0xFFEF4444);
  // Yıldız Partikülü beyaz rengi
  static const Color starWhite = Color(0xFFFFFFFF);
} // AppColors sınıfı kapanışı

/// Material 3 ThemeExtension mekanizması ile UI katmanına aktarılan tema renkleri.
/// Kod içinde `context.spaceColors` üzerinden erişilir.
@immutable
class SpaceColors extends ThemeExtension<SpaceColors> {
  // Arka plan rengi
  final Color background;
  // Yüzey rengi
  final Color surface;
  // Kart arka plan rengi
  final Color cardBackground;
  // Ana birincil tema rengi
  final Color primary;
  // Gradyan geçişinin bittiği renk
  final Color primaryGradientEnd;
  // İkincil renk
  final Color secondary;
  // Vurgu rengi
  final Color accent;
  // Ana metin rengi
  final Color textPrimary;
  // İkincil soluk metin rengi
  final Color textSecondary;
  // Çerçeve ve kenarlık çizgisi rengi
  final Color border;
  // Neon parlama efekti rengi
  final Color glow;
  // Başarı durum rengi
  final Color success;
  // Uyarı durum rengi
  final Color warning;
  // Hata durum rengi
  final Color error;
  // Arka plan yıldız partikül rengi
  final Color starColor;

  // SpaceColors kurucu metodu
  const SpaceColors({
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.primary,
    required this.primaryGradientEnd,
    required this.secondary,
    required this.accent,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.glow,
    required this.success,
    required this.warning,
    required this.error,
    required this.starColor,
  }); // Kurucu metod kapanışı

  /// "Derin Uzay" Teması Renk Kümesi (Koyu Tema)
  static const SpaceColors dark = SpaceColors(
    background: AppColors.darkBackground,
    surface: AppColors.darkSurface,
    cardBackground: AppColors.darkCardBackground,
    primary: AppColors.darkPrimary,
    primaryGradientEnd: AppColors.darkPrimaryGradientEnd,
    secondary: AppColors.darkSecondary,
    accent: AppColors.darkAccent,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    border: AppColors.darkBorder,
    glow: AppColors.darkGlow,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    starColor: AppColors.starWhite,
  ); // dark kapanışı

  /// "Şafak Fırlatışı" Teması Renk Kümesi (Açık Tema)
  static const SpaceColors light = SpaceColors(
    background: AppColors.lightBackground,
    surface: AppColors.lightSurface,
    cardBackground: AppColors.lightCardBackground,
    primary: AppColors.lightPrimary,
    primaryGradientEnd: AppColors.lightPrimaryGradientEnd,
    secondary: AppColors.lightSecondary,
    accent: AppColors.lightAccent,
    textPrimary: AppColors.lightTextPrimary,
    textSecondary: AppColors.lightTextSecondary,
    border: AppColors.lightBorder,
    glow: AppColors.lightGlow,
    success: AppColors.success,
    warning: AppColors.warning,
    error: AppColors.error,
    starColor: AppColors.lightPrimary,
  ); // light kapanışı

  /// Birincil kozmik degrade gradyanı üreten getter
  LinearGradient get primaryGradient => LinearGradient(
        // Başlangıç ve bitiş renkleri
        colors: [primary, primaryGradientEnd],
        // Sol üstten başlasın
        begin: Alignment.topLeft,
        // Sağ altta bitsin
        end: Alignment.bottomRight,
      ); // primaryGradient kapanışı

  // İstenilen renkleri ezerek yeni kopya oluşturan copyWith metodu
  @override
  SpaceColors copyWith({
    Color? background,
    Color? surface,
    Color? cardBackground,
    Color? primary,
    Color? primaryGradientEnd,
    Color? secondary,
    Color? accent,
    Color? textPrimary,
    Color? textSecondary,
    Color? border,
    Color? glow,
    Color? success,
    Color? warning,
    Color? error,
    Color? starColor,
  }) {
    // Yeni nesneyi güncellenen veya eski değerlerle üretiyoruz
    return SpaceColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardBackground: cardBackground ?? this.cardBackground,
      primary: primary ?? this.primary,
      primaryGradientEnd: primaryGradientEnd ?? this.primaryGradientEnd,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      border: border ?? this.border,
      glow: glow ?? this.glow,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      starColor: starColor ?? this.starColor,
    ); // SpaceColors dönüşü
  } // copyWith metodu kapanışı

  // İki tema rengi arasında yumuşak geçiş sağlayan lineer interpolasyon metodu
  @override
  SpaceColors lerp(ThemeExtension<SpaceColors>? other, double t) {
    // Karşılaştırılan nesne SpaceColors değilse mevcut nesneyi dön
    if (other is! SpaceColors) return this;
    // Renkleri t katsayısına göre yumuşakça harmanlıyoruz
    return SpaceColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryGradientEnd:
          Color.lerp(primaryGradientEnd, other.primaryGradientEnd, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      border: Color.lerp(border, other.border, t)!,
      glow: Color.lerp(glow, other.glow, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      error: Color.lerp(error, other.error, t)!,
      starColor: Color.lerp(starColor, other.starColor, t)!,
    ); // SpaceColors dönüşü
  } // lerp metodu kapanışı
} // SpaceColors sınıfı kapanışı
