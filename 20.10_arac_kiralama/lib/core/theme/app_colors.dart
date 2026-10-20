// Flutter materyal tasarım bileşenlerini ve renk sınıflarını içe aktarıyoruz.
import 'package:flutter/material.dart';

/// Uygulama genelinde kullanılan renk paletini ve tema renk sabitlerini barındıran sınıf.
/// Bu sınıf sayesinde renkler merkezi bir yerden yönetilir ve tutarlılık sağlanır.
class AppColors {
  // ==========================================
  // MARKA RENKLERİ (Brand Colors)
  // ==========================================
  
  /// Uygulamanın ana marka mavisi (özellikle butonlar, aktif sekmeler ve vurgular için)
  static const Color primaryBlue = Color(0xFF0066FF);
  
  /// Birincil rengin daha koyu tonu (gradyanlar veya hover durumları için)
  static const Color primaryDarkBlue = Color(0xFF0044AA);
  
  /// Vurgu mavisi (özellikle koyu temada daha yüksek kontrast sağlamak için)
  static const Color accentBlue = Color(0xFF3385FF);
  
  // ==========================================
  // AÇIK TEMA NÖTR RENKLERİ (Neutral Colors - Light)
  // ==========================================
  
  /// Logo ve koyu metinlerde kullanılan siyah tonu
  static const Color logoBlack = Color(0xFF1A1A1A);
  
  /// Açık temada ekranların genel arka plan rengi
  static const Color backgroundLight = Color(0xFFF8F9FC);
  
  /// Açık temada kart, dialog ve form alanlarının yüzey/kart rengi (beyaz)
  static const Color surfaceLight = Color(0xFFFFFFFF);
  
  /// Açık temada okunabilirliği yüksek koyu ana metin rengi
  static const Color textDark = Color(0xFF1F2937);
  
  /// Açık temada ikincil metinler, ipuçları ve alt başlıklar için soluk gri renk
  static const Color textMutedLight = Color(0xFF6B7280);
  
  /// Açık temada bileşen sınırları ve ayırıcı çizgiler için kullanılan açık gri
  static const Color borderLight = Color(0xFFE5E7EB);
  
  // ==========================================
  // KOYU TEMA NÖTR RENKLERİ (Neutral Colors - Dark)
  // ==========================================
  
  /// Koyu tema için ana ekran arka plan rengi
  static const Color backgroundDark = Color(0xFF121418);
  
  /// Koyu temada kart, bottom sheet ve dialog arka plan yüzey rengi
  static const Color surfaceDark = Color(0xFF1B1E24);
  
  /// Koyu temada giriş kutuları ve yükseltilmiş kartlar için bir ton açık yüzey rengi
  static const Color surfaceDarkElevated = Color(0xFF242830);
  
  /// Koyu temada yüksek okunabilirlik sağlayan açık ana metin rengi
  static const Color textLight = Color(0xFFF3F4F6);
  
  /// Koyu temada ikincil metinler ve açıklamalar için kullanılan soluk gri
  static const Color textMutedDark = Color(0xFF9CA3AF);
  
  /// Koyu temada çerçeveler ve ayırıcı çizgiler için sınır rengi
  static const Color borderDark = Color(0xFF2D333B);
  
  // ==========================================
  // DURUM RENKLERİ (Status Colors)
  // ==========================================
  
  /// Başarılı işlemler, onay durumları ve aktif/müsait araç göstergeleri için yeşil
  static const Color success = Color(0xFF10B981);
  
  /// Uyarı durumları, beklemedeki talepler ve dikkat çekici alanlar için turuncu/sarı
  static const Color warning = Color(0xFFF59E0B);
  
  /// Hata bildirimleri, iptal durumları ve zorunlu alan uyarıları için kırmızı
  static const Color error = Color(0xFFEF4444);
  
  /// Bilgilendirme mesajları ve ipuçları için bilgi mavisi
  static const Color info = Color(0xFF3B82F6);
}
