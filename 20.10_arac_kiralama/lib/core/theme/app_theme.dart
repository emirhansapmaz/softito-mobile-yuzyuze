// Flutter materyal arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Uygulama renk sabitlerini tanımladığımız dosyayı projeye dahil ediyoruz.
import 'app_colors.dart';

/// Uygulamanın Açık (Light) ve Koyu (Dark) temalarını Material 3 standartlarında yapılandıran sınıf.
class AppTheme {
  // ==========================================
  // AÇIK TEMA YAPILANDIRMASI (Light Theme)
  // ==========================================
  static ThemeData get lightTheme {
    // Belirlenen tohum renginden (seedColor) Material 3 renk şemasını türetiyoruz.
    final colorScheme = ColorScheme.fromSeed(
      // Temanın ana tohum rengi olarak birincil mavi rengi belirliyoruz.
      seedColor: AppColors.primaryBlue,
      // Temanın parlaklık modunu 'açık' olarak ayarlıyoruz.
      brightness: Brightness.light,
      // Birincil marka rengini atıyoruz.
      primary: AppColors.primaryBlue,
      // Birincil rengin üzerindeki metin/ikon rengini beyaz yapıyoruz.
      onPrimary: Colors.white,
      // Kart ve diyalog gibi yüzeylerin rengini açık yüzey rengi yapıyoruz.
      surface: AppColors.surfaceLight,
      // Yüzey üzerindeki metin rengini koyu metin rengi olarak ayarlıyoruz.
      onSurface: AppColors.textDark,
      // Hata durumları için hata rengini atıyoruz.
      error: AppColors.error,
      // Hata renginin üzerindeki metin rengini beyaz yapıyoruz.
      onError: Colors.white,
    );

    // Açık temaya ait tüm bileşen stillerini ThemeData nesnesi içinde topluyoruz.
    return ThemeData(
      // Material 3 tasarım dilini etkinleştiriyoruz.
      useMaterial3: true,
      // Yukarıda oluşturulan renk paletini temaya bağlıyoruz.
      colorScheme: colorScheme,
      // Ekranların varsayılan arka plan rengini açık arka plan rengi yapıyoruz.
      scaffoldBackgroundColor: AppColors.backgroundLight,
      // Varsayılan yazı tipini 'Roboto' olarak belirliyoruz.
      fontFamily: 'Roboto',
      
      // Üst uygulama çubuğu (AppBar) görsel stilleri
      appBarTheme: const AppBarTheme(
        // Arka plan rengini açık yüzey rengi yapıyoruz.
        backgroundColor: AppColors.surfaceLight,
        // İkonlar ve başlık metninin rengi
        foregroundColor: AppColors.textDark,
        // Gölgelendirme seviyesini sıfırlayarak düz (flat) bir görünüm elde ediyoruz.
        elevation: 0,
        // Başlığı çubuğun ortasına hizalıyoruz.
        centerTitle: true,
        // Sayfa kaydırıldığında oluşan gölge seviyesi
        scrolledUnderElevation: 1,
        // Başlık metninin tipografi özellikleri
        titleTextStyle: TextStyle(
          color: AppColors.textDark,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      
      // Kart bileşenlerinin (Card) varsayılan görünümü
      cardTheme: CardThemeData(
        // Kart arka plan rengi
        color: AppColors.surfaceLight,
        // Kartın zemin gölgesini sıfırlıyoruz.
        elevation: 0,
        // Kart köşelerine 16 piksel yuvarlaklık ve ince bir kenarlık çizgisi veriyoruz.
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      
      // Yükseltilmiş butonların (ElevatedButton) stilleri
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Buton dolgu rengi
          backgroundColor: AppColors.primaryBlue,
          // Buton üzerindeki yazı ve ikon rengi
          foregroundColor: Colors.white,
          // Buton gölgesi
          elevation: 0,
          // Minimum buton yüksekliği 52 piksel
          minimumSize: const Size(0, 52),
          // Buton kenarlarını 14 piksel yuvarlatıyoruz.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          // Buton içi metin stili
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Çerçeveli butonların (OutlinedButton) stilleri
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          // Çerçeve içi yazı ve ikon rengi
          foregroundColor: AppColors.primaryBlue,
          // Minimum buton yüksekliği
          minimumSize: const Size(0, 52),
          // Buton sınır çizgisi rengi ve kalınlığı
          side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
          // Yuvarlatılmış kenarlık yapısı
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          // Metin font boyutu ve kalınlığı
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Form giriş kutularının (TextField / TextFormField) genel dekorasyon stili
      inputDecorationTheme: InputDecorationTheme(
        // Arka planın renk ile doldurulmasını sağlıyoruz.
        filled: true,
        // Giriş kutusu dolgu rengi beyaz
        fillColor: Colors.white,
        // İç boşluk (padding) değerleri
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        // Varsayılan kenarlık stili
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        // Aktif durumdaki (üzerine tıklanmamış) kenarlık stili
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        // Odaklanılmış (kullanıcı yazarken) kenarlık stili
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
        // Hata durumundaki kenarlık stili
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        // Odaklanılmış ve hatalı durumdaki kenarlık stili
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        // Giriş kutusu etiket metni stili
        labelStyle: const TextStyle(color: AppColors.textMutedLight, fontSize: 14),
        // İpucu (placeholder) metni stili
        hintStyle: const TextStyle(color: AppColors.textMutedLight, fontSize: 14),
      ),
      
      // Filtreleme etiketleri (Chip / ChoiceChip) stili
      chipTheme: ChipThemeData(
        // Varsayılan arka plan rengi
        backgroundColor: Colors.white,
        // Seçildiğinde uygulanacak açık mavi tonu
        selectedColor: AppColors.primaryBlue.withValues(alpha: 0.15),
        // Kenarlık çizgisi
        side: const BorderSide(color: AppColors.borderLight),
        // Kenar yuvarlaklığı
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // Etiket metin özellikleri
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      
      // Açılır pencerelerin (AlertDialog) genel teması
      dialogTheme: DialogThemeData(
        // Açılır pencere arka plan rengi
        backgroundColor: AppColors.surfaceLight,
        // Köşelerin 20 piksel yuvarlatılması
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        // Yükselti gölgesi
        elevation: 8,
      ),
      
      // Alttan açılan menülerin (BottomSheet) teması
      bottomSheetTheme: const BottomSheetThemeData(
        // Zemin rengi
        backgroundColor: AppColors.surfaceLight,
        // Sadece üst köşelerin yuvarlatılması
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }

  // ==========================================
  // KOYU TEMA YAPILANDIRMASI (Dark Theme)
  // ==========================================
  static ThemeData get darkTheme {
    // Koyu tema için renk şemasını türetiyoruz.
    final colorScheme = ColorScheme.fromSeed(
      // Koyu mod için de tohum rengimiz mavi
      seedColor: AppColors.primaryBlue,
      // Parlaklık modunu 'koyu' olarak ayarlıyoruz.
      brightness: Brightness.dark,
      // Koyu temada birincil renk olarak daha açık tonlu vurgu mavisini seçiyoruz.
      primary: AppColors.accentBlue,
      // Birincil renk üzeri metin beyaz
      onPrimary: Colors.white,
      // Yüzey rengi olarak koyu yüzey rengini kullanıyoruz.
      surface: AppColors.surfaceDark,
      // Metin rengini açık gri yapıyoruz.
      onSurface: AppColors.textLight,
      // Hata rengi
      error: AppColors.error,
      // Hata rengi üzeri metin
      onError: Colors.white,
    );

    // Koyu temaya ait tüm bileşen stillerini ThemeData nesnesi içinde topluyoruz.
    return ThemeData(
      // Material 3 tasarım standardını etkinleştiriyoruz.
      useMaterial3: true,
      // Koyu renk paletini bağlıyoruz.
      colorScheme: colorScheme,
      // Koyu arka plan rengi
      scaffoldBackgroundColor: AppColors.backgroundDark,
      // Varsayılan font
      fontFamily: 'Roboto',
      
      // Koyu tema üst çubuk (AppBar) yapılandırması
      appBarTheme: const AppBarTheme(
        // AppBar koyu yüzey rengi
        backgroundColor: AppColors.surfaceDark,
        // İkon ve metin rengi açık renk
        foregroundColor: AppColors.textLight,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 1,
        titleTextStyle: TextStyle(
          color: AppColors.textLight,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
      
      // Koyu tema kart (Card) yapılandırması
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),
      
      // Koyu tema yükseltilmiş buton stilleri
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Koyu tema çerçeveli buton stilleri
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accentBlue,
          minimumSize: const Size(0, 52),
          side: const BorderSide(color: AppColors.accentBlue, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Koyu tema form giriş kutuları stili
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        // Koyu temada bir kademe daha açık gri/antrasit dolgu
        fillColor: AppColors.surfaceDarkElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accentBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        labelStyle: const TextStyle(color: AppColors.textMutedDark, fontSize: 14),
        hintStyle: const TextStyle(color: AppColors.textMutedDark, fontSize: 14),
      ),
      
      // Koyu tema filtre etiketleri stili
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceDarkElevated,
        selectedColor: AppColors.accentBlue.withValues(alpha: 0.25),
        side: const BorderSide(color: AppColors.borderDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textLight),
      ),
      
      // Koyu tema diyalog pencereleri stili
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
      ),
      
      // Koyu tema alt açılır sayfa (BottomSheet) stili
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
    );
  }
}
