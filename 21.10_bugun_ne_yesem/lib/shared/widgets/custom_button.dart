// Flutter Material arayüz bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../core/theme/app_colors.dart';

// Uygulama genelinde standart buton stilini korumak için tasarladığımız özelleştirilmiş buton bileşenimiz
class CustomButton extends StatelessWidget {
  // Buton üzerinde görünecek metin
  final String text;
  // Butona tıklandığında çalışacak olay fonksiyonu (null ise buton pasifleşir)
  final VoidCallback? onPressed;
  // İşlem devam ederken buton üzerinde yükleme ikonu dönsün mü
  final bool isLoading;
  // Metnin soluna eklenebilecek opsiyonel ikon
  final IconData? icon;
  // Butonun içi boş çerçeveli (outlined) mi yoksa dolgulu mu olacağını belirten bayrak
  final bool isOutlined;
  // İsteğe bağlı özel arka plan rengi
  final Color? backgroundColor;
  // İsteğe bağlı özel yazı/ikon rengi
  final Color? textColor;

  // CustomButton sınıfının değişmez kurucu metodu
  const CustomButton({
    // Widget ağacı anahtarı
    super.key,
    // Buton metninin zorunlu olduğunu belirtiyoruz
    required this.text,
    // Tıklama olayı parametresi
    this.onPressed,
    // Yükleme durumu varsayılan false
    this.isLoading = false,
    // Opsiyonel ikon parametresi
    this.icon,
    // Çerçeveli stil varsayılan false
    this.isOutlined = false,
    // Özel arka plan rengi parametresi
    this.backgroundColor,
    // Özel yazı rengi parametresi
    this.textColor,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext parametresini alan ve Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Geçerli arka plan rengini belirliyoruz (özel renk verilmişse o, yoksa outlined durumuna göre)
    final effectiveBg = backgroundColor ??
        (isOutlined ? Colors.transparent : AppColors.primary);
    // Geçerli yazı rengini belirliyoruz (özel renk verilmişse o, yoksa outlined durumuna göre)
    final effectiveText = textColor ??
        (isOutlined ? AppColors.primary : Colors.white);

    // Butonun genişliğini ve yüksekliğini sabitleyen SizedBox
    return SizedBox(
      // Buton yüksekliği 54 piksel
      height: 54,
      // Genişliği ebeveyn kutuyu tam kaplayacak şekilde yapıyoruz
      width: double.infinity,
      // Temel ElevatedButton bileşeni
      child: ElevatedButton(
        // Butonun görsel stil ayarları
        style: ElevatedButton.styleFrom(
          // Arka plan rengi
          backgroundColor: effectiveBg,
          // İçerik (metin ve ikon) rengi
          foregroundColor: effectiveText,
          // Çerçeveliyse gölge sıfır, dolguluysa 2 piksel gölge
          elevation: isOutlined ? 0 : 2,
          // Gölge rengine hafif şeffaflık veriyoruz
          shadowColor: AppColors.primary.withValues(alpha: 0.3),
          // Buton köşelerini 16 piksel yuvarlatıyoruz
          shape: RoundedRectangleBorder(
            // 16 piksel köşe yarıçapı
            borderRadius: BorderRadius.circular(16),
            // Çerçeveli moddaysa kenarlık çizgisi ekliyoruz
            side: isOutlined
                // Çerçeve rengi ve 1.5 piksel kalınlık
                ? BorderSide(color: backgroundColor ?? AppColors.primary, width: 1.5)
                // Dolgulu modda çerçeveyi kaldırıyoruz
                : BorderSide.none,
          // RoundedRectangleBorder kapanışı
          ),
        // ElevatedButton.styleFrom kapanışı
        ),
        // Yükleme sırasında tıklamayı engelliyoruz (null), değilse onPressed çalışır
        onPressed: isLoading ? null : onPressed,
        // Yükleniyorsa dönen animasyon, bittiyse metin ve ikon satırı gösteriyoruz
        child: isLoading
            // Dönen yükleme animasyonu kutusu
            ? const SizedBox(
                // Genişlik 24 piksel
                width: 24,
                // Yükseklik 24 piksel
                height: 24,
                // Beyaz renkli dönen yükleme göstergesi
                child: CircularProgressIndicator(
                  // Çizgi kalınlığı 2.5 piksel
                  strokeWidth: 2.5,
                  // Beyaz renk animasyonu
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                // CircularProgressIndicator kapanışı
                ),
              // SizedBox kapanışı
              )
            // İkon ve metni ortalayan yatay Row
            : Row(
                // İçeriği yatayda ortalıyoruz
                mainAxisAlignment: MainAxisAlignment.center,
                // Satır elemanları listesi
                children: [
                  // İkon verilmişse ikonu ve aradaki 8 piksel boşluğu çiziyoruz
                  if (icon != null) ...[
                    // İkon bileşeni
                    Icon(icon, size: 20, color: effectiveText),
                    // 8 piksel yatay boşluk
                    const SizedBox(width: 8),
                  ],
                  // Buton metni
                  Text(
                    // Metin içeriği
                    text,
                    // Metin stili
                    style: TextStyle(
                      // 16 punto boyut
                      fontSize: 16,
                      // Yarı kalın font
                      fontWeight: FontWeight.w600,
                      // Yazı rengi
                      color: effectiveText,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                // Row çocukları kapanışı
                ],
              // Row kapanışı
              ),
      // ElevatedButton kapanışı
      ),
    // SizedBox kapanışı
    );
  // build metodu kapanış parantezi
  }
// CustomButton sınıfının kapanış parantezi
}
