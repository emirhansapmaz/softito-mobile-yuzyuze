// Flutter Material renk kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';

// Uygulamanın tüm renk paletini tek bir merkezi yerden yönettiğimiz renk sınıfımız
class AppColors {
  // Marka Renkleri - Beslenme, Doğallık ve Mutfak temalı Adaçayı / Zeytin Yeşili Paleti
  // Ana marka rengimiz: Yumuşak Zeytin Yeşili / Orman Adaçayı
  static const Color primary = Color(0xFF4A7C59);
  // Ana rengin açık tonu
  static const Color primaryLight = Color(0xFF6B9B78);
  // Ana rengin koyu tonu
  static const Color primaryDark = Color(0xFF2E5339);
  // İkincil destekleyici renk: Deniz Yeşili / Adaçayı
  static const Color secondary = Color(0xFF8FBC8F);
  // Vurgu ve aksiyon rengi: Sıcak pişmiş toprak / şeftali tonu (butonlar ve rozetler için)
  static const Color accent = Color(0xFFE29578);

  // Açık Tema (Light Theme) Renkleri
  // Açık temada sayfa arka plan rengi
  static const Color backgroundLight = Color(0xFFF7F9F6);
  // Açık temada yüzey rengi
  static const Color surfaceLight = Color(0xFFFFFFFF);
  // Açık temada kart arka plan rengi
  static const Color cardLight = Color(0xFFFFFFFF);
  // Açık temada ana metin yazı rengi
  static const Color textPrimaryLight = Color(0xFF1E2822);
  // Açık temada ikincil soluk metin rengi
  static const Color textSecondaryLight = Color(0xFF637367);
  // Açık temada çerçeve ve ayırıcı çizgi rengi
  static const Color borderLight = Color(0xFFE0E6E1);

  // Koyu Tema (Dark Theme) Renkleri
  // Koyu temada sayfa arka plan rengi
  static const Color backgroundDark = Color(0xFF121814);
  // Koyu temada yüzey rengi
  static const Color surfaceDark = Color(0xFF1C241F);
  // Koyu temada kart arka plan rengi
  static const Color cardDark = Color(0xFF232D27);
  // Koyu temada ana metin yazı rengi (açık beyaz tonu)
  static const Color textPrimaryDark = Color(0xFFF1F5F2);
  // Koyu temada ikincil soluk metin rengi
  static const Color textSecondaryDark = Color(0xFF9EABA1);
  // Koyu temada çerçeve ve ayırıcı çizgi rengi
  static const Color borderDark = Color(0xFF2E3A32);

  // Durum ve Yardımcı Renkler
  // Başarılı işlem ve onay yeşili
  static const Color success = Color(0xFF43A047);
  // Hata ve uyarı kırmızısı
  static const Color error = Color(0xFFE53935);
  // Dikkat ve bekleme sarısı
  static const Color warning = Color(0xFFFFA000);
// AppColors sınıfının kapanış parantezi
}
