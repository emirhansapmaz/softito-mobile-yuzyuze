// Flutter Material arayüz bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Modern Google yazı tiplerini kullanabilmek için google_fonts paketi
import 'package:google_fonts/google_fonts.dart';
// Renk paleti sabitlerimizi içeren sınıfı içe aktarıyoruz
import 'app_colors.dart';

// Açık ve Koyu tema şablonlarımızı merkezi olarak tanımladığımız tema sınıfımız
class AppTheme {
  // Açık tema (Light Theme) özelliklerini döndüren getter
  static ThemeData get lightTheme {
    // Plus Jakarta Sans yazı tipinin font ailesi adını alıyoruz
    final fontName = GoogleFonts.plusJakartaSans().fontFamily;

    // Material 3 standartlarında açık tema nesnesi oluşturup dönüyoruz
    return ThemeData(
      // Modern Material 3 tasarım dilini aktifleştiriyoruz
      useMaterial3: true,
      // Açık tema parlaklık modu
      brightness: Brightness.light,
      // Varsayılan yazı tipi ailesi
      fontFamily: fontName,
      // Açık tema renk şeması yapılandırması
      colorScheme: const ColorScheme.light(
        // Ana renk: Adaçayı yeşili
        primary: AppColors.primary,
        // Ana renk üzerindeki metin rengi: Beyaz
        onPrimary: Colors.white,
        // İkincil renk
        secondary: AppColors.secondary,
        // İkincil renk üzerindeki metin rengi: Beyaz
        onSecondary: Colors.white,
        // Yüzey rengi
        surface: AppColors.surfaceLight,
        // Yüzey üzerindeki metin rengi
        onSurface: AppColors.textPrimaryLight,
        // Hata rengi
        error: AppColors.error,
        // Hata üzerindeki yazı rengi
        onError: Colors.white,
      // ColorScheme.light kapanışı
      ),
      // Sayfa arka plan rengi
      scaffoldBackgroundColor: AppColors.backgroundLight,
      // Üst başlık çubuğu (AppBar) açık tema ayarları
      appBarTheme: const AppBarTheme(
        // AppBar arka plan rengi
        backgroundColor: AppColors.backgroundLight,
        // AppBar başlık ve ikon rengi
        foregroundColor: AppColors.textPrimaryLight,
        // Gölge yüksekliği sıfır
        elevation: 0,
        // Başlığı ekranda ortalıyoruz
        centerTitle: true,
        // Kaydırma sırasında oluşan gölgeyi sıfırlıyoruz
        scrolledUnderElevation: 0,
      // AppBarTheme kapanışı
      ),
      // Kart bileşenleri açık tema ayarları
      cardTheme: CardThemeData(
        // Kart arka plan rengi
        color: AppColors.cardLight,
        // Kart gölgesi sıfır
        elevation: 0,
        // 20 piksel yuvarlatılmış köşeler ve ince çerçeve çizgisi
        shape: RoundedRectangleBorder(
          // 20 piksel köşe yuvarlatma
          borderRadius: BorderRadius.circular(20),
          // 1 piksel kalınlığında açık gri kenarlık
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        // RoundedRectangleBorder kapanışı
        ),
      // CardThemeData kapanışı
      ),
      // Yükseltilmiş buton (ElevatedButton) stil şablonu
      elevatedButtonTheme: ElevatedButtonThemeData(
        // Buton genel stil ayarları
        style: ElevatedButton.styleFrom(
          // Buton arka plan rengi
          backgroundColor: AppColors.primary,
          // Buton yazı ve ikon rengi
          foregroundColor: Colors.white,
          // Gölge sıfır
          elevation: 0,
          // Yatayda 24, dikeyde 16 piksel buton iç boşluğu
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // 16 piksel yuvarlatılmış köşeler
          shape: RoundedRectangleBorder(
            // Köşe yarıçapı
            borderRadius: BorderRadius.circular(16),
          // RoundedRectangleBorder kapanışı
          ),
          // Buton üzerindeki metin stili
          textStyle: const TextStyle(
            // 16 punto boyut
            fontSize: 16,
            // Yarı kalın font
            fontWeight: FontWeight.w600,
          // TextStyle kapanışı
          ),
        // ElevatedButton.styleFrom kapanışı
        ),
      // ElevatedButtonThemeData kapanışı
      ),
      // Metin giriş kutuları (TextField) varsayılan açık tema dekorasyonu
      inputDecorationTheme: InputDecorationTheme(
        // Kutunun içi dolgulu olsun
        filled: true,
        // Beyaz arka plan rengi
        fillColor: Colors.white,
        // Kutu içi kenar boşlukları
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // Temel çerçeve stili
        border: OutlineInputBorder(
          // 16 piksel köşe yuvarlatma
          borderRadius: BorderRadius.circular(16),
          // Açık gri kenar çizgisi
          borderSide: const BorderSide(color: AppColors.borderLight),
        // OutlineInputBorder kapanışı
        ),
        // Etkin (odaklanılmamış) durumdaki kenarlık
        enabledBorder: OutlineInputBorder(
          // 16 piksel köşe yuvarlatma
          borderRadius: BorderRadius.circular(16),
          // Açık gri kenar çizgisi
          borderSide: const BorderSide(color: AppColors.borderLight),
        // OutlineInputBorder kapanışı
        ),
        // Kutunun içine tıklandığında (odaklandığında) beliren yeşil kenarlık
        focusedBorder: const OutlineInputBorder(
          // 16 piksel köşe yuvarlatma
          borderRadius: BorderRadius.all(Radius.circular(16)),
          // 2 piksel kalınlığında ana yeşil kenar çizgisi
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        // OutlineInputBorder kapanışı
        ),
        // Hata durumunda beliren kırmızı kenarlık
        errorBorder: const OutlineInputBorder(
          // 16 piksel köşe yuvarlatma
          borderRadius: BorderRadius.all(Radius.circular(16)),
          // Kırmızı kenarlık çizgisi
          borderSide: BorderSide(color: AppColors.error),
        // OutlineInputBorder kapanışı
        ),
      // InputDecorationTheme kapanışı
      ),
    // ThemeData kapanışı
    );
  // lightTheme getter kapanışı
  }

  // Koyu tema (Dark Theme) özelliklerini döndüren getter
  static ThemeData get darkTheme {
    // Plus Jakarta Sans yazı tipinin font ailesi adını alıyoruz
    final fontName = GoogleFonts.plusJakartaSans().fontFamily;

    // Material 3 standartlarında koyu tema nesnesi oluşturup dönüyoruz
    return ThemeData(
      // Modern Material 3 tasarım sistemini aktifleştiriyoruz
      useMaterial3: true,
      // Koyu tema parlaklık modu
      brightness: Brightness.dark,
      // Varsayılan font ailesi
      fontFamily: fontName,
      // Koyu tema renk şeması yapılandırması
      colorScheme: const ColorScheme.dark(
        // Koyu temada açık adaçayı yeşili
        primary: AppColors.primaryLight,
        // Ana renk üzerindeki metin rengi: Siyah
        onPrimary: Colors.black,
        // İkincil renk
        secondary: AppColors.secondary,
        // İkincil renk üzerindeki metin: Siyah
        onSecondary: Colors.black,
        // Koyu yüzey rengi
        surface: AppColors.surfaceDark,
        // Açık renkli yüzey metinleri
        onSurface: AppColors.textPrimaryDark,
        // Hata kırmızısı
        error: AppColors.error,
        // Hata üzerindeki metin: Beyaz
        onError: Colors.white,
      // ColorScheme.dark kapanışı
      ),
      // Koyu sayfa arka plan rengi
      scaffoldBackgroundColor: AppColors.backgroundDark,
      // Üst bilgi çubuğu (AppBar) koyu tema ayarları
      appBarTheme: const AppBarTheme(
        // Koyu arka plan
        backgroundColor: AppColors.backgroundDark,
        // Açık renkli başlık ve ikonlar
        foregroundColor: AppColors.textPrimaryDark,
        // Gölge sıfır
        elevation: 0,
        // Başlığı ortalıyoruz
        centerTitle: true,
        // Kaydırma gölgesini sıfırlıyoruz
        scrolledUnderElevation: 0,
      // AppBarTheme kapanışı
      ),
      // Kart bileşenleri koyu tema ayarları
      cardTheme: CardThemeData(
        // Koyu kart arka plan rengi
        color: AppColors.cardDark,
        // Gölge sıfır
        elevation: 0,
        // 20 piksel yuvarlatılmış köşeler ve koyu gri kenar çizgisi
        shape: RoundedRectangleBorder(
          // 20 piksel köşe yuvarlatma
          borderRadius: BorderRadius.circular(20),
          // 1 piksel koyu kenarlık
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        // RoundedRectangleBorder kapanışı
        ),
      // CardThemeData kapanışı
      ),
      // Koyu tema yükseltilmiş buton şablonu
      elevatedButtonTheme: ElevatedButtonThemeData(
        // Buton stili
        style: ElevatedButton.styleFrom(
          // Açık adaçayı yeşili arka plan
          backgroundColor: AppColors.primaryLight,
          // Siyah yazı rengi
          foregroundColor: Colors.black,
          // Gölge sıfır
          elevation: 0,
          // Yatayda 24, dikeyde 16 piksel boşluk
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // 16 piksel köşe yuvarlatma
          shape: RoundedRectangleBorder(
            // Köşe yarıçapı
            borderRadius: BorderRadius.circular(16),
          // RoundedRectangleBorder kapanışı
          ),
          // Metin stili
          textStyle: const TextStyle(
            // 16 punto boyut
            fontSize: 16,
            // Yarı kalın font
            fontWeight: FontWeight.w600,
          // TextStyle kapanışı
          ),
        // ElevatedButton.styleFrom kapanışı
        ),
      // ElevatedButtonThemeData kapanışı
      ),
      // Koyu tema metin giriş kutusu şablonu
      inputDecorationTheme: InputDecorationTheme(
        // İçi dolgulu
        filled: true,
        // Koyu yüzey dolgu rengi
        fillColor: AppColors.surfaceDark,
        // Kutu içi kenar boşlukları
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // Temel çerçeve stili
        border: OutlineInputBorder(
          // 16 piksel köşe yuvarlatma
          borderRadius: BorderRadius.circular(16),
          // Koyu çerçeve çizgisi
          borderSide: const BorderSide(color: AppColors.borderDark),
        // OutlineInputBorder kapanışı
        ),
        // Etkin durumdaki koyu çerçeve
        enabledBorder: OutlineInputBorder(
          // 16 piksel köşe yuvarlatma
          borderRadius: BorderRadius.circular(16),
          // Koyu kenar çizgisi
          borderSide: const BorderSide(color: AppColors.borderDark),
        // OutlineInputBorder kapanışı
        ),
        // Tıklandığında açık yeşil parlayan kenarlık
        focusedBorder: const OutlineInputBorder(
          // 16 piksel köşe yuvarlatma
          borderRadius: BorderRadius.all(Radius.circular(16)),
          // 2 piksel kalınlığında açık yeşil çerçeve
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2),
        // OutlineInputBorder kapanışı
        ),
        // Hata durumunda kırmızı çerçeve
        errorBorder: const OutlineInputBorder(
          // 16 piksel köşe yuvarlatma
          borderRadius: BorderRadius.all(Radius.circular(16)),
          // Kırmızı kenar çizgisi
          borderSide: BorderSide(color: AppColors.error),
        // OutlineInputBorder kapanışı
        ),
      // InputDecorationTheme kapanışı
      ),
    // ThemeData kapanışı
    );
  // darkTheme getter kapanışı
  }
// AppTheme sınıfının kapanış parantezi
}
