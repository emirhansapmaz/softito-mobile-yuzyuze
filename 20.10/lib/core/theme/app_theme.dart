// Flutter materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Uygulama renk sabitleri ve SpaceColors uzantısını içeri alıyoruz
import '../constants/app_colors.dart';
// Standart boşluk ve kenarlık yarıçapı değerlerini içeri alıyoruz
import '../constants/app_spacing.dart';

/// Yörünge Girişimcilik Platformu - Çift Tema Sistemi:
/// 1. "Derin Uzay" (Dark Theme)
/// 2. "Şafak Fırlatışı" (Light Theme)
class AppTheme {
  // Sınıfın dışarıdan örneklenmesini engelleyen gizli kurucu
  const AppTheme._();

  /// "Derin Uzay" Teması (Dark Mode)
  static ThemeData get darkTheme {
    // Koyu temayı oluşturup döndürüyoruz
    return ThemeData(
      // Material 3 tasarım standardını etkinleştiriyoruz
      useMaterial3: true,
      // Parlaklık modunu koyu olarak ayarlıyoruz
      brightness: Brightness.dark,
      // Sayfa arka plan rengi derin uzay siyahı
      scaffoldBackgroundColor: AppColors.darkBackground,
      // Özel uzay renklerimizi tema uzantısı olarak bağlıyoruz
      extensions: const <ThemeExtension<dynamic>>[
        SpaceColors.dark,
      ], // extensions kapanışı
      // Koyu renk şeması yapılandırması
      colorScheme: const ColorScheme.dark(
        primary: AppColors.darkPrimary,
        secondary: AppColors.darkSecondary,
        surface: AppColors.darkSurface,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.darkTextPrimary,
        outline: AppColors.darkBorder,
        error: AppColors.error,
      ), // ColorScheme.dark kapanışı
      // Üst uygulama çubuğu (AppBar) koyu teması
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ), // AppBarTheme kapanışı
      // Kart bileşenleri koyu teması
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: const BorderSide(color: AppColors.darkBorder, width: 1.0),
        ), // RoundedRectangleBorder kapanışı
      ), // CardThemeData kapanışı
      // Buton bileşenleri koyu teması
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: Colors.black,
          elevation: 0,
          padding: AppSpacing.paddingHorizontalLg + AppSpacing.paddingVerticalSm,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ), // RoundedRectangleBorder kapanışı
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ), // TextStyle kapanışı
        ), // ElevatedButton.styleFrom kapanışı
      ), // ElevatedButtonThemeData kapanışı
      // Form giriş kutuları (Input) koyu teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: AppSpacing.paddingAllMd,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ), // OutlineInputBorder kapanışı
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.darkBorder),
        ), // OutlineInputBorder kapanışı
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide:
              const BorderSide(color: AppColors.darkPrimary, width: 1.5),
        ), // OutlineInputBorder kapanışı
        hintStyle: const TextStyle(
          color: AppColors.darkTextSecondary,
          fontSize: 14,
        ), // TextStyle kapanışı
      ), // InputDecorationTheme kapanışı
      // Tipografi metin teması
      textTheme: _darkTextTheme,
    ); // ThemeData kapanışı
  } // darkTheme getter kapanışı

  /// "Şafak Fırlatışı" Teması (Light Mode)
  static ThemeData get lightTheme {
    // Açık temayı oluşturup döndürüyoruz
    return ThemeData(
      // Material 3 tasarım standardını etkinleştiriyoruz
      useMaterial3: true,
      // Parlaklık modunu açık olarak ayarlıyoruz
      brightness: Brightness.light,
      // Açık arka plan rengi şafak göğü
      scaffoldBackgroundColor: AppColors.lightBackground,
      // Özel uzay renklerimizi tema uzantısı olarak bağlıyoruz
      extensions: const <ThemeExtension<dynamic>>[
        SpaceColors.light,
      ], // extensions kapanışı
      // Açık renk şeması yapılandırması
      colorScheme: const ColorScheme.light(
        primary: AppColors.lightPrimary,
        secondary: AppColors.lightSecondary,
        surface: AppColors.lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary,
        outline: AppColors.lightBorder,
        error: AppColors.error,
      ), // ColorScheme.light kapanışı
      // Üst uygulama çubuğu açık teması
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ), // AppBarTheme kapanışı
      // Kart bileşenleri açık teması
      cardTheme: CardThemeData(
        color: AppColors.lightCardBackground,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: const BorderSide(color: AppColors.lightBorder, width: 1.0),
        ), // RoundedRectangleBorder kapanışı
      ), // CardThemeData kapanışı
      // Buton bileşenleri açık teması
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: AppSpacing.paddingHorizontalLg + AppSpacing.paddingVerticalSm,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ), // RoundedRectangleBorder kapanışı
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ), // TextStyle kapanışı
        ), // ElevatedButton.styleFrom kapanışı
      ), // ElevatedButtonThemeData kapanışı
      // Form kutuları açık teması
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightSurface,
        contentPadding: AppSpacing.paddingAllMd,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ), // OutlineInputBorder kapanışı
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.lightBorder),
        ), // OutlineInputBorder kapanışı
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide:
              const BorderSide(color: AppColors.lightPrimary, width: 1.5),
        ), // OutlineInputBorder kapanışı
        hintStyle: const TextStyle(
          color: AppColors.lightTextSecondary,
          fontSize: 14,
        ), // TextStyle kapanışı
      ), // InputDecorationTheme kapanışı
      // Tipografi metin teması
      textTheme: _lightTextTheme,
    ); // ThemeData kapanışı
  } // lightTheme getter kapanışı

  // --- Derin Uzay Tipografi Koleksiyonu ---
  static const TextTheme _darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: AppColors.darkTextPrimary,
      letterSpacing: -0.8,
    ), // TextStyle kapanışı
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.darkTextPrimary,
      letterSpacing: -0.4,
    ), // TextStyle kapanışı
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.darkTextPrimary,
      letterSpacing: -0.2,
    ), // TextStyle kapanışı
    titleMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextPrimary,
    ), // TextStyle kapanışı
    bodyLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextPrimary,
      height: 1.5,
    ), // TextStyle kapanışı
    bodyMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.darkTextSecondary,
      height: 1.4,
    ), // TextStyle kapanışı
    labelLarge: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.darkPrimary,
      letterSpacing: 0.3,
    ), // TextStyle kapanışı
  ); // _darkTextTheme kapanışı

  // --- Şafak Fırlatışı Tipografi Koleksiyonu ---
  static const TextTheme _lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: AppColors.lightTextPrimary,
      letterSpacing: -0.8,
    ), // TextStyle kapanışı
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
      letterSpacing: -0.4,
    ), // TextStyle kapanışı
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.lightTextPrimary,
      letterSpacing: -0.2,
    ), // TextStyle kapanışı
    titleMedium: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.lightTextPrimary,
    ), // TextStyle kapanışı
    bodyLarge: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextPrimary,
      height: 1.5,
    ), // TextStyle kapanışı
    bodyMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: AppColors.lightTextSecondary,
      height: 1.4,
    ), // TextStyle kapanışı
    labelLarge: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      color: AppColors.lightPrimary,
      letterSpacing: 0.3,
    ), // TextStyle kapanışı
  ); // _lightTextTheme kapanışı
} // AppTheme sınıfı kapanışı
