// Flutter materyal arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Uygulama renk paletini içe aktarıyoruz.
import '../core/theme/app_colors.dart';
// Araç veri modelini içe aktarıyoruz.
import '../models/car.dart';

/// Araç listesi ekranında her bir aracı kart şeklinde görselleştiren bileşen.
/// Araç resmi, müsaitlik rozeti, üretim yılı, tam adı, günlük kiralama bedeli ve teknik özellik etiketlerini barındırır.
class VehicleCard extends StatelessWidget {
  /// Kartta görüntülenecek araç nesnesi
  final Car car;
  
  /// Karta tıklandığında (araç detayına gitmek için) tetiklenecek fonksiyon
  final VoidCallback onTap;

  /// VehicleCard kurucu metodu (Constructor)
  const VehicleCard({
    super.key,
    required this.car,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Koyu tema modunda mıyız sorguluyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      // Kartlar arası dış kenar boşluğu
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Köşelerden taşan resimlerin taşmasını önlemek için kırpma modu
      clipBehavior: Clip.antiAlias,
      // 18 piksel yuvarlatılmış köşeler ve tema uyumlu kenarlık çizgisi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      // Tıklanma dalgalanma efekti (ripple) için InkWell bileşeni
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // ARAÇ GÖRSELİ VE ÜZERİNDEKİ ROZETLER
            // ==========================================
            Stack(
              children: [
                // İnternet üzerinden yüklenen araç fotoğrafı
                Image.network(
                  car.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // İnternet hatası veya görsel yüklenemediğinde gösterilecek yer tutucu alan
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 180,
                      color: isDark ? AppColors.surfaceDarkElevated : Colors.grey.shade300,
                      child: const Center(
                        child: Icon(Icons.directions_car, size: 60, color: Colors.grey),
                      ),
                    );
                  },
                ),
                
                // Sağ Üst Rozet: Müsaitlik Durumu (Yeşil: Müsait, Kırmızı: Kirada)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: car.isAvailable
                          ? AppColors.success.withValues(alpha: 0.9)
                          : AppColors.error.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      car.isAvailable ? 'Müsait' : 'Kirada',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                
                // Sol Üst Rozet: Aracın Model Yılı (örn: 2023)
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${car.year}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ==========================================
            // ARAÇ DETAYLARI VE FİYATLANDIRMA
            // ==========================================
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Araç Adı ve Günlük Fiyat Satırı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Araç Marka ve Model Adı
                      Expanded(
                        child: Text(
                          car.fullName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textLight : AppColors.textDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Günlük Kiralama Fiyatı (örn: 1250 ₺ / gün)
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '${car.dailyPrice.toStringAsFixed(0)} ₺',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            TextSpan(
                              text: ' / gün',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ==========================================
                  // ÖZELLİK ETİKETLERİ (KM, Şanzıman, Yakıt Türü)
                  // ==========================================
                  Row(
                    children: [
                      // Kilometre Rozeti
                      _buildFeatureBadge(
                        Icons.speed_rounded,
                        '${(car.kilometer / 1000).toStringAsFixed(1)} bin km',
                        isDark,
                      ),
                      const SizedBox(width: 8),
                      // Vites Tipi Rozeti (Otomatik / Manuel)
                      _buildFeatureBadge(
                        Icons.settings_suggest_rounded,
                        car.transmission,
                        isDark,
                      ),
                      const SizedBox(width: 8),
                      // Yakıt Tipi Rozeti (Benzin / Dizel vb.)
                      _buildFeatureBadge(
                        Icons.local_gas_station_rounded,
                        car.fuelType,
                        isDark,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Araç özellikleri için küçük ikonlu rozet üreten yardımcı metot
  Widget _buildFeatureBadge(IconData icon, String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Küçük özellik ikonu
          Icon(icon, size: 14, color: AppColors.primaryBlue),
          const SizedBox(width: 4),
          // Özellik metni
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textLight : AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
