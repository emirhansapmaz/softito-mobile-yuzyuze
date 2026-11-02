// Flutter'ın temel materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Standart boşluk ve kenarlık yarıçapı değerlerini içeri alıyoruz
import '../../../core/constants/app_spacing.dart';
// BuildContext tema ve tipografi yardımcı uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';

/// Yörünge Platformu - Kozmik Giriş Butonu.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class LoginButton extends StatelessWidget {
  // Butona tıklandığında çalışacak fonksiyon
  final VoidCallback? onPressed;
  // İşlem devam ediyor mu bayrağı (spinner animasyonu için)
  final bool isLoading;
  // Buton üzerindeki metin başlığı (varsayılan: 'Giriş Yap')
  final String title;

  // LoginButton kurucu metodu
  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.title = 'Giriş Yap',
  }); // Kurucu metod kapanışı

  // Arayüzü inşa eden build metodu
  @override
  Widget build(BuildContext context) {
    // Uzay renklerini okuyoruz
    final colors = context.spaceColors;

    // Dış container kutusu ile boyut ve neon gölge sağlıyoruz
    return Container(
      // Genişliği tam yatay yayıyoruz
      width: double.infinity,
      // Buton yüksekliği 52 piksel
      height: 52,
      // Kutu dekorasyonu
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: [
          // Neon ışıma gölgesi
          BoxShadow(
            color: colors.glow.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ), // BoxShadow kapanışı
        ], // boxShadow listesi kapanışı
      ), // BoxDecoration kapanışı
      // Yükseltilmiş buton bileşeni
      child: ElevatedButton(
        // Yükleniyorsa tıklama kapalı
        onPressed: isLoading ? null : onPressed,
        // Buton stilleri
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ), // RoundedRectangleBorder kapanışı
        ), // ElevatedButton.styleFrom kapanışı
        // Yükleniyorsa döner çember, değilse yazı ve ok ikonu
        child: isLoading ? _buildLoader(colors) : _buildButtonContent(context),
      ), // ElevatedButton kapanışı
    ); // Container kapanışı
  } // build metodu kapanışı

  // Dönen yükleniyor çemberi üreten yardımcı metot
  Widget _buildLoader(dynamic colors) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(colors.surface),
      ), // CircularProgressIndicator kapanışı
    ); // SizedBox kapanışı
  } // _buildLoader metodu kapanışı

  // Butonun içindeki başlık metni ve ileri ok simgesi
  Widget _buildButtonContent(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.spaceColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Buton başlık metni
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.surface,
          ), // copyWith kapanışı
        ), // Text kapanışı
        // 8 piksel yatay boşluk
        AppSpacing.gapW8,
        // İleri ok simgesi
        Icon(Icons.arrow_forward_rounded, size: 20, color: colors.surface),
      ], // Row çocukları kapanışı
    ); // Row kapanışı
  } // _buildButtonContent metodu kapanışı
} // LoginButton sınıfı kapanışı
