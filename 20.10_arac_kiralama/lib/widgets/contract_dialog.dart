// Flutter materyal tasarım kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Uygulama renk paletini içe aktarıyoruz.
import '../core/theme/app_colors.dart';
// Kullanıcı sözleşmesi metnini barındıran MockData sınıfını içe aktarıyoruz.
import '../data/mock_data.dart';
// Özel buton bileşenlerini içe aktarıyoruz.
import 'custom_button.dart';

/// Kullanıcıya kiralama öncesinde sözleşme metnini alttan açılır pencere (BottomSheet) olarak gösteren sınıf.
class ContractDialog {
  /// Sözleşme penceresini ekranda açar ve kullanıcının onaylayıp (true) onaylamadığını (false/null) döndürür.
  static Future<bool?> show(BuildContext context) {
    // Koyu tema kontrolü
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return showModalBottomSheet<bool>(
      context: context,
      // Sayfa yüksekliğinin dinamik ayarlanabilmesi için kaydırılabilir yapıyı açıyoruz.
      isScrollControlled: true,
      // Dış kenarların şeffaf olması (yuvarlatılmış köşelerin düzgün görünmesi için)
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          // Ekran yüksekliğinin %82'sini kaplayacak şekilde boyutlandırıyoruz.
          height: MediaQuery.of(context).size.height * 0.82,
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // ==========================================
              // ÜST TUTAMAK ÇUBUĞU (Modal Drag Handle)
              // ==========================================
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              // ==========================================
              // DİYALOG BAŞLIK ALANI
              // ==========================================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    // Sözleşme ikonu kutusu
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.description_outlined,
                        color: AppColors.primaryBlue,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Başlık ve alt başlık metinleri
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kullanıcı Sözleşmesi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textLight : AppColors.textDark,
                            ),
                          ),
                          Text(
                            'Kiralama ve hizmet koşulları',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Kapatma (Çarpı) butonu: false döndürerek kapatır.
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
              ),

              // Başlık ile metin arasındaki ayırıcı çizgi
              const Divider(height: 24),

              // ==========================================
              // KAYDIRILABİLİR SÖZLEŞME METNİ
              // ==========================================
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDarkElevated : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    // Mock veriden gelen sözleşme metnini basıyoruz.
                    child: Text(
                      MockData.userAgreementText,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.6,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ),

              // ==========================================
              // ALT AKSİYON BUTONLARI (Vazgeç / Onaylıyorum)
              // ==========================================
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                  child: Row(
                    children: [
                      // Vazgeç Butonu: false değeri ile pencereyi kapatır.
                      Expanded(
                        child: CustomOutlinedButton(
                          text: 'Vazgeç',
                          onPressed: () => Navigator.of(context).pop(false),
                          height: 48,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Onaylıyorum Butonu: true değeri ile sözleşmeyi kabul ettirir.
                      Expanded(
                        child: CustomElevatedButton(
                          text: 'Onaylıyorum',
                          onPressed: () => Navigator.of(context).pop(true),
                          height: 48,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
