import 'package:flutter/material.dart';

/// memonolog uygulaması için samimi, sıcak, keten ve toprak tonlu günlük paleti.
/// Gözü yoran neon ve dijital parıltılar yerine, nostaljik ve samimi bir defter hissiyatı sunar.
class AppColors {
  const AppColors._();

  // --- Aydınlık Tema (Sıcak Krem & Keten Kağıt) ---
  static const Color lightBackground = Color(0xFFFAF7F2); // Sıcak Keten Kağıdı
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFFC06248); // Sıcak Kiremit / Terracotta
  static const Color lightPrimaryGradientEnd = Color(0xFFAC533A);
  static const Color lightSecondary = Color(0xFF756A61);
  static const Color lightAccent = Color(0xFFD69852); // Sıcak Bal / Kehribar
  static const Color lightTextPrimary = Color(0xFF28211D); // Sıcak Koyu Espresso
  static const Color lightTextSecondary = Color(0xFF7C7268);
  static const Color lightBorder = Color(0xFFEAE3D6); // Yumuşak Defter Kenarı
  static const Color lightDivider = Color(0xFFF3ECE0);

  // --- Koyu Tema (Sıcak Gece Kağıdı & Koyu Mocha) ---
  static const Color darkBackground = Color(0xFF181513); // Sıcak Koyu Mocha Kadife
  static const Color darkSurface = Color(0xFF221E1B);
  static const Color darkCardBackground = Color(0xFF292420);
  static const Color darkPrimary = Color(0xFFE28E77); // Yumuşak Sıcak Kiremit
  static const Color darkPrimaryGradientEnd = Color(0xFFD17B63);
  static const Color darkSecondary = Color(0xFFA3968A);
  static const Color darkAccent = Color(0xFFE8B672); // Mum Işığı Kehribarı
  static const Color darkTextPrimary = Color(0xFFF5F0EB); // Sıcak Fildişi
  static const Color darkTextSecondary = Color(0xFFA3988E);
  static const Color darkBorder = Color(0xFF3A332C);
  static const Color darkDivider = Color(0xFF2E2722);

  // --- Ortak & Vurgu Renkleri ---
  static const Color inkDrop = Color(0xFF382F2A);
  static const Color softCream = Color(0xFFFDFBF7);
  static const Color error = Color(0xFFD34538);
  static const Color success = Color(0xFF4A7C59);

  // --- Ruh Hali (Mood) Renkleri (Sıcak & Doğal Toprak Tonları) ---
  static const Color moodHappy = Color(0xFFD68A36); // Sıcak Bal Sarısı
  static const Color moodPeaceful = Color(0xFF5B8266); // Adaçayı Yeşili
  static const Color moodCalm = Color(0xFF547896); // Yağmur Sonrası Mavi
  static const Color moodInspired = Color(0xFF866994); // Tozlu Lavanta
  static const Color moodMelancholic = Color(0xFF707784); // Dingin Taş Grisi
  static const Color moodEnergetic = Color(0xFFC06248); // Sıcak Kiremit

  // --- Doğal Sıcak Degrade Tanımları ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [lightPrimary, lightPrimaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkPrimaryGradient = LinearGradient(
    colors: [darkPrimary, darkPrimaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
