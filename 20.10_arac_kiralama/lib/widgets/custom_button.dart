// Flutter materyal tasarım bileşenlerini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Uygulama renk paletini içeren dosyayı içe aktarıyoruz.
import '../core/theme/app_colors.dart';

/// Uygulama genelinde kullanılan birincil (dolu arka planlı) özel yükseltilmiş buton bileşeni.
/// Yüklenme animasyonu (isLoading), özel ikon, renk ve boyut özelleştirmelerini destekler.
class CustomElevatedButton extends StatelessWidget {
  /// Buton üzerinde görüntülenecek metin
  final String text;
  
  /// Butona tıklandığında tetiklenecek fonksiyon (null ise buton devre dışı kalır)
  final VoidCallback? onPressed;
  
  /// Butonun işlem yaptığını belirten ve dönen çember animasyonu gösteren bayrak
  final bool isLoading;
  
  /// Metnin solunda isteğe bağlı gösterilecek ikon
  final IconData? icon;
  
  /// Butonun arka plan rengi (belirtilmezse varsayılan primaryBlue kullanılır)
  final Color? backgroundColor;
  
  /// Metin ve ikonun rengi (belirtilmezse varsayılan beyaz kullanılır)
  final Color? foregroundColor;
  
  /// Butonun dikey yüksekliği (varsayılan: 52 piksel)
  final double height;
  
  /// Buton köşelerinin yuvarlaklık yarıçapı (varsayılan: 14 piksel)
  final double borderRadius;

  /// CustomElevatedButton kurucu metodu (Constructor)
  const CustomElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Yüklenme durumunda tıklamayı devre dışı bırakıyoruz (null), aksi halde onPressed fonksiyonunu çalıştırıyoruz.
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        // Arka plan rengi veya varsayılan mavi renk
        backgroundColor: backgroundColor ?? AppColors.primaryBlue,
        // Ön plan (yazı/ikon) rengi
        foregroundColor: foregroundColor ?? Colors.white,
        // Devre dışı kaldığında gösterilecek soluk arka plan rengi
        disabledBackgroundColor: AppColors.primaryBlue.withValues(alpha: 0.4),
        // Devre dışı kaldığında gösterilecek soluk yazı rengi
        disabledForegroundColor: Colors.white70,
        // Genişliği tam yatay dolduracak şekilde minimum yükseklik belirliyoruz.
        minimumSize: Size.fromHeight(height),
        // Yuvarlatılmış kenar çizgisi yapısı
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        // Düz ve modern görünüm için gölgeyi sıfırlıyoruz.
        elevation: 0,
      ),
      // Eğer işlem sürüyorsa CircularProgressIndicator, değilse İkon ve Metin içeren Satır gösteriyoruz.
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // İkon belirtilmişse ikonu ve ardından boşluğu ekliyoruz.
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                // Buton metni
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
    );
  }
}

/// Uygulama genelinde ikincil işlemler için kullanılan kenarlıklı (şeffaf zeminli) özel buton bileşeni.
class CustomOutlinedButton extends StatelessWidget {
  /// Buton üzerinde görüntülenecek metin
  final String text;
  
  /// Tıklanma olayı fonksiyonu
  final VoidCallback? onPressed;
  
  /// İsteğe bağlı sol ikon
  final IconData? icon;
  
  /// Çerçeve ve metin rengi (belirtilmezse varsayılan primaryBlue)
  final Color? color;
  
  /// Buton yüksekliği
  final double height;

  /// CustomOutlinedButton kurucu metodu (Constructor)
  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    // Efektif rengi belirliyoruz: parametre verilmişse o, verilmemişse primaryBlue.
    final effectiveColor = color ?? AppColors.primaryBlue;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        // Yazı ve ikon rengi
        foregroundColor: effectiveColor,
        // Çerçeve kenarlık rengi ve 1.5 piksel kalınlığı
        side: BorderSide(color: effectiveColor, width: 1.5),
        // Butonun yatay tam genişlikte ve istenen yükseklikte olmasını sağlıyoruz.
        minimumSize: Size.fromHeight(height),
        // Kenar yuvarlaklığı
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // İsteğe bağlı ikon
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          // Buton yazısı
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
