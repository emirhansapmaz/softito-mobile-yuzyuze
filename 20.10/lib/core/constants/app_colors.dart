import 'package:flutter/material.dart';

/// Yörünge Girişimcilik Platformu - Renk Paleti ve SpaceColors Tema Uzantısı.
/// "Derin Uzay" (Dark) ve "Şafak Fırlatışı" (Light) temalarına özel kozmik tonlar içerir.
class AppColors {
  const AppColors._();

  // --- Derin Uzay (Dark Mode) Renkleri ---
  static const Color darkBackground = Color(0xFF0A0D14); // Sonsuz Uzay Siyahı
  static const Color darkSurface = Color(0xFF121724); // Yörünge İstasyonu Yüzeyi
  static const Color darkCardBackground = Color(0xFF171F32); // Kozmik Kapsül Kartı
  static const Color darkPrimary = Color(0xFF00F0FF); // İyon İtki Turkuazı
  static const Color darkPrimaryGradientEnd = Color(0xFF7000FF); // Kozmik Morötesi
  static const Color darkSecondary = Color(0xFFFF5E00); // Roket İtici Alevi
  static const Color darkAccent = Color(0xFFFFB800); // Süpernova Altını
  static const Color darkTextPrimary = Color(0xFFF1F5F9); // Yıldız Işığı Beyazı
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Nebula Grisi
  static const Color darkBorder = Color(0xFF26324D); // Yörünge Hattı
  static const Color darkGlow = Color(0x6600F0FF); // Neon Halesi

  // --- Şafak Fırlatışı (Light Mode) Renkleri ---
  static const Color lightBackground = Color(0xFFF4F7FB); // Şafak Göğü
  static const Color lightSurface = Color(0xFFFFFFFF); // Fırlatma Üssü Yüzeyi
  static const Color lightCardBackground = Color(0xFFFFFFFF); // Beyaz Kapsül Kartı
  static const Color lightPrimary = Color(0xFF0066FF); // Fırlatma Mavisi
  static const Color lightPrimaryGradientEnd = Color(0xFF5B21B6); // Şafak Alacakaranlığı
  static const Color lightSecondary = Color(0xFFEA580C); // Güneş Doğuşu Turuncusu
  static const Color lightAccent = Color(0xFFD97706); // Roket Kıvılcımı
  static const Color lightTextPrimary = Color(0xFF0F172A); // Gece Sonu Laciverti
  static const Color lightTextSecondary = Color(0xFF64748B); // Fırlatma Dumanı Grisi
  static const Color lightBorder = Color(0xFFE2E8F0); // Atmosfer Tabakası Çizgisi
  static const Color lightGlow = Color(0x330066FF); // Şafak Halesi

  // --- Sistem & Durum Renkleri ---
  static const Color success = Color(0xFF10B981); // Başarılı Yörüngeye Giriş (Yeşil)
  static const Color warning = Color(0xFFF59E0B); // Telemetri Uyarısı (Amber)
  static const Color error = Color(0xFFEF4444); // Kritik Yörünge Sapması (Kırmızı)
  static const Color starWhite = Color(0xFFFFFFFF); // Yıldız Partikülü
}

/// Material 3 ThemeExtension mekanizması ile UI katmanına aktarılan tema renkleri.
/// Kod içinde `context.spaceColors` üzerinden erişilir.
@immutable
class SpaceColors extends ThemeExtension<SpaceColors> {
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color primary;
  final Color primaryGradientEnd;
  final Color secondary;
  final Color accent;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final Color glow;
  final Color success;
  final Color warning;
  final Color error;
  final Color starColor;

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
  });

  /// "Derin Uzay" Teması Renk Kümesi
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
  );

  /// "Şafak Fırlatışı" Teması Renk Kümesi
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
  );

  /// Birincil kozmik degrade
  LinearGradient get primaryGradient => LinearGradient(
        colors: [primary, primaryGradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

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
    );
  }

  @override
  SpaceColors lerp(ThemeExtension<SpaceColors>? other, double t) {
    if (other is! SpaceColors) return this;
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
    );
  }
}
