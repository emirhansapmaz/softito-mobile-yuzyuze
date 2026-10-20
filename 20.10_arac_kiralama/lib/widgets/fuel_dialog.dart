// Flutter materyal tasarım kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Renk paleti dosyasını içe aktarıyoruz.
import '../core/theme/app_colors.dart';
// Sahte veri kaynağını içe aktarıyoruz.
import '../data/mock_data.dart';
// Yakıt fiyat veri modelini içe aktarıyoruz.
import '../models/fuel_price.dart';

/// 3 büyük akaryakıt firmasının (Opet, Petrol Ofisi, Shell) güncel benzin, dizel ve LPG fiyatlarını gösteren açılır pencere (AlertDialog) bileşeni.
class FuelPriceDialog extends StatelessWidget {
  /// FuelPriceDialog kurucu metodu (Constructor)
  const FuelPriceDialog({super.key});

  /// Diyaloğu ekranda açan statik yardımcı metot
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const FuelPriceDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Koyu tema modunda mıyız kontrol ediyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // MockData'daki güncel yakıt fiyatları listesi
    final fuelPrices = MockData.fuelPrices;

    return AlertDialog(
      // Köşeleri 20 piksel yuvarlatıyoruz.
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      // Temaya uygun arka plan rengi
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      actionsPadding: const EdgeInsets.all(16),
      
      // ==========================================
      // DİYALOG BAŞLIK ALANI (İkon ve Başlık Metinleri)
      // ==========================================
      title: Row(
        children: [
          // Akaryakıt pompası ikonu kutusu
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_gas_station_rounded,
              color: AppColors.primaryBlue,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          // Başlık ve alt başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Güncel Yakıt Fiyatları',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                Text(
                  '3 Lider Akaryakıt Şirketi (TL/Lt)',
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

      // ==========================================
      // DİYALOG İÇERİK ALANI (Firma Kartları ve Bilgi Notu)
      // ==========================================
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              // Her bir yakıt firması için kart oluşturup listeliyoruz.
              ...fuelPrices.map((fp) => _buildCompanyCard(context, fp, isDark)),
              const SizedBox(height: 8),
              // Alt bilgilendirme kutusu (Yakıt teslimat politikası uyarısı)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDarkElevated : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: AppColors.primaryBlue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Araç teslimatında yakıt seviyesi kontrol edilmektedir.',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ==========================================
      // DİYALOG KAPATMA AKSİYONU
      // ==========================================
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Kapat',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }

  /// Belirli bir akaryakıt firmasının fiyatlarını gösteren kart bileşenini oluşturur.
  Widget _buildCompanyCard(BuildContext context, FuelPrice fp, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Firma Adı ve Canlı Veri Rozeti Satırı
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Firmanın marka rengini gösteren renk noktası
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _getColorFromHex(fp.brandColorHex),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Firma Adı (Opet, Shell vb.)
                  Text(
                    fp.companyName,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                ],
              ),
              // "Canlı Mock" bilgi etiketi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Canlı Mock',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 3 Yakıt Türünün Fiyat Sütunları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPriceItem('Benzin', '${fp.gasolinePrice.toStringAsFixed(2)} ₺', isDark),
              _buildPriceItem('Dizel', '${fp.dieselPrice.toStringAsFixed(2)} ₺', isDark),
              _buildPriceItem('LPG', '${fp.lpgPrice.toStringAsFixed(2)} ₺', isDark),
            ],
          ),
        ],
      ),
    );
  }

  /// Yakıt türü adı ve litre fiyatını alt alta gösteren sütun bileşeni
  Widget _buildPriceItem(String title, String price, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Yakıt türü başlığı (Benzin, Dizel, LPG)
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        // Fiyat değeri
        Text(
          price,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
      ],
    );
  }

  /// Hex renk metnini (örn: '#0047BA') Flutter Color nesnesine dönüştüren yardımcı fonksiyon
  Color _getColorFromHex(String hex) {
    final buffer = StringBuffer();
    // 6 veya 7 karakter ise opaklık (ff) ekliyoruz.
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    // Varsa başındaki '#' işaretini kaldırıyoruz.
    buffer.write(hex.replaceFirst('#', ''));
    // 16 tabanında tamsayıya çevirerek Color nesnesi üretiyoruz.
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
