import 'package:flutter/material.dart';

/// Doğa ve huzuru çağrıştıran soft, pastel ve minimalist renk paleti.
/// Neon ve aşırı yapay zeka görünümlerinden kaçınılmıştır.
class AppColors {
  AppColors._();

  // Ana Pastel & Toprak Tonları
  static const Color sageGreen = Color(0xFF8FA89B);        // Adaçayı yeşili (Ana aksan rengi)
  static const Color softOlive = Color(0xFFA5B899);        // Sakin açık zeytin yeşili
  static const Color deepSage = Color(0xFF5B7567);         // Koyu adaçayı (Vurgulu butonlar ve başlıklar)
  static const Color earthBrown = Color(0xFF967E76);       // Sıcak toprak/vizon tonu
  static const Color terracottaSoft = Color(0xFFD4A373);   // Yumuşak kiremit/terakota
  static const Color sereneBlue = Color(0xFF90A8B8);       // Dingin gri-mavi

  // Arka Plan ve Yüzeyler (Aydınlık Tema)
  static const Color backgroundLight = Color(0xFFF9F8F6);  // Sıcak kırık beyaz / keten
  static const Color surfaceLight = Color(0xFFFFFFFF);     // Saf beyaz kart yüzeyi
  static const Color surfaceVariantLight = Color(0xFFF2EFEA);// Hafif sıcak gri kart arkaplanı
  static const Color borderLight = Color(0xFFE4DFD7);      // İnce, soft kenarlık

  // Arka Plan ve Yüzeyler (Karanlık Tema)
  static const Color backgroundDark = Color(0xFF1E2220);   // Koyu adaçayı füme
  static const Color surfaceDark = Color(0xFF282D2A);      // Koyu kart yüzeyi
  static const Color surfaceVariantDark = Color(0xFF333A36);
  static const Color borderDark = Color(0xFF3F4742);

  // Metin Renkleri
  static const Color textPrimaryLight = Color(0xFF2C332D); // Koyu taş grisi / antrasit
  static const Color textSecondaryLight = Color(0xFF6E756F);// Yumuşak ikincil metin
  static const Color textMutedLight = Color(0xFF9FA6A0);    // Silik metin
  
  static const Color textPrimaryDark = Color(0xFFEAEFEC);  // Kırık beyaz metin
  static const Color textSecondaryDark = Color(0xFFA5ACA7);
  static const Color textMutedDark = Color(0xFF707772);

  // Durum Renkleri (Soft & Pastel)
  static const Color success = Color(0xFF7BAE7F);          // Yumuşak başarı yeşili
  static const Color warning = Color(0xFFE3B06C);          // Yumuşak uyarı sarısı
  static const Color danger = Color(0xFFD97D73);           // Pastel silme/hata kırmızısı
  static const Color dangerLight = Color(0xFFFDECEB);      // Kırmızı arka plan tint'i
  static const Color streakFlame = Color(0xFFE08E58);      // Sıcak pastel alev turuncusu
}
