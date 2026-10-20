// Flutter materyal arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Durum yönetimi için Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Uygulama tema renklerini içe aktarıyoruz.
import '../../core/theme/app_colors.dart';
// Kategori veri modelini içe aktarıyoruz.
import '../../models/category.dart';
// Araç verilerini, arama, filtreleme ve sıralama mantığını yöneten Provider'ı içe aktarıyoruz.
import '../../providers/vehicle_provider.dart';
// Araç kartı bileşenini içe aktarıyoruz.
import '../../widgets/vehicle_card.dart';
// Araca tıklandığında gidilecek detay ekranını içe aktarıyoruz.
import 'vehicle_detail_screen.dart';

/// Seçilen bir kategoriye ait araçların filtrelenebildiği, aranabildiği ve sıralanabildiği liste ekranı.
class VehicleListScreen extends StatelessWidget {
  /// Görüntülenen kategori nesnesi
  final Category category;

  /// VehicleListScreen kurucu metodu (Constructor)
  const VehicleListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // Koyu tema durumu sorgusu
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    
    // Aktif kategoriye ve filtrelere (arama, sıralama, yakıt, şanzıman) göre araçları çekiyoruz.
    final cars = vehicleProvider.getFilteredCars(category.id);

    return Scaffold(
      appBar: AppBar(
        // Başlıkta kategori adı (örn: "Basic Araçları")
        title: Text(
          '${category.name} Araçları',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Geri butonu
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // Sağ üstte filtreleme ve sıralama modalını açan buton
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => _showFilterBottomSheet(context),
            tooltip: 'Filtrele ve Sırala',
          ),
        ],
      ),
      body: Column(
        children: [
          // ==========================================
          // ARAMA ÇUBUĞU (SearchBar)
          // ==========================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBar(
              hintText: '${category.name} içinde marka/model ara...',
              // Arama büyüteç ikonu
              leading: const Icon(Icons.search_rounded, color: AppColors.primaryBlue),
              // Arama kutusunda yazı varsa temizleme (çarpı) butonu gösteriyoruz.
              trailing: [
                if (vehicleProvider.searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () => vehicleProvider.setSearchQuery(''),
                  ),
              ],
              elevation: const WidgetStatePropertyAll(0),
              backgroundColor: WidgetStatePropertyAll(
                isDark ? AppColors.surfaceDarkElevated : Colors.white,
              ),
              side: WidgetStatePropertyAll(
                BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              // Kullanıcı her harf yazdığında filtrelemeyi anlık tetikliyoruz.
              onChanged: (val) => vehicleProvider.setSearchQuery(val),
            ),
          ),

          // ==========================================
          // LİSTELENEN ARAÇ SAYISI VE AKTİF SIRALAMA BİLGİSİ
          // ==========================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Filtreleme sonucu bulunan araç adedi
                Text(
                  '${cars.length} araç listeleniyor',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                // Hızlı sıralama bilgisi ve tıklanınca filtre modalını açma
                InkWell(
                  onTap: () => _showFilterBottomSheet(context),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_vert_rounded,
                        size: 16,
                        color: isDark ? AppColors.accentBlue : AppColors.primaryBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _getSortLabel(vehicleProvider.selectedSortOption),
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.accentBlue : AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // ARAÇ LİSTESİ VEYA BOŞ DURUM GÖRÜNÜMÜ
          // ==========================================
          Expanded(
            child: cars.isEmpty
                ? Center(
                    // Kriterlere uyan araç bulunamadığında gösterilecek boş durum tasarımı
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Kriterlere uygun araç bulunamadı',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textLight : AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Filtreleri sıfırlayarak tüm araçları yeniden getiren buton
                        TextButton(
                          onPressed: () => vehicleProvider.resetFilters(),
                          child: const Text('Filtreleri Sıfırla'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];
                      // Her bir araç için özel araç kartı üretiyoruz.
                      return VehicleCard(
                        car: car,
                        onTap: () {
                          // Araca tıklandığında detay sayfasına geçiş yapıyoruz.
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => VehicleDetailScreen(car: car),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SIRALAMA ETİKETİ METNİ YARDIMCISI
  // ==========================================
  /// Enum olarak gelen sıralama seçeneğini kullanıcı dostu Türkçe metne dönüştürür.
  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.priceAsc:
        return 'Fiyat: Artan';
      case SortOption.priceDesc:
        return 'Fiyat: Azalan';
      case SortOption.yearDesc:
        return 'Yıl: En Yeni';
      case SortOption.yearAsc:
        return 'Yıl: En Eski';
      case SortOption.kmAsc:
        return 'KM: En Düşük';
      case SortOption.kmDesc:
        return 'KM: En Yüksek';
    }
  }

  // ==========================================
  // FİLTRELEME VE SIRALAMA ALTTAN AÇILIR MENÜSÜ
  // ==========================================
  /// Fiyat, yıl, km sıralamalarını ve vites/yakıt filtrelerini seçtiren BottomSheet modalı.
  void _showFilterBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vp = Provider.of<VehicleProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        // Modal içi seçimlerin anlık değişebilmesi için StatefulBuilder kullanıyoruz.
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Modal tutamağı
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Başlık ve Sıfırla Butonu
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Sıralama ve Filtreleme',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textLight : AppColors.textDark,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Filtreleri sıfırlayıp modalı güncelliyoruz.
                            vp.resetFilters();
                            setModalState(() {});
                          },
                          child: const Text('Sıfırla'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ==========================================
                    // SIRALAMA SEÇENEKLERİ (Chips)
                    // ==========================================
                    Text(
                      'Sıralama Ölçütü',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSortChip(vp, SortOption.priceAsc, 'Fiyat (Artan)', setModalState),
                        _buildSortChip(vp, SortOption.priceDesc, 'Fiyat (Azalan)', setModalState),
                        _buildSortChip(vp, SortOption.yearDesc, 'Yıl (En Yeni)', setModalState),
                        _buildSortChip(vp, SortOption.yearAsc, 'Yıl (En Eski)', setModalState),
                        _buildSortChip(vp, SortOption.kmAsc, 'KM (En Düşük)', setModalState),
                        _buildSortChip(vp, SortOption.kmDesc, 'KM (En Yüksek)', setModalState),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ==========================================
                    // VİTES TİPİ FİLTRESİ
                    // ==========================================
                    Text(
                      'Vites Tipi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Tümü', 'Otomatik', 'Manuel'].map((type) {
                        final isSelected = vp.selectedTransmission == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(type),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                vp.setFilterTransmission(type);
                                setModalState(() {});
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // ==========================================
                    // YAKIT TİPİ FİLTRESİ
                    // ==========================================
                    Text(
                      'Yakıt Tipi',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: ['Tümü', 'Benzin', 'Dizel'].map((fuel) {
                        final isSelected = vp.selectedFuelType == fuel;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(fuel),
                            selected: isSelected,
                            onSelected: (selected) {
                              if (selected) {
                                vp.setFilterFuelType(fuel);
                                setModalState(() {});
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),

                    // ==========================================
                    // FİLTRELERİ UYGULA VE KAPAT BUTONU
                    // ==========================================
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Filtreleri Uygula', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================
  // SIRALAMA ETİKETİ (ChoiceChip) ÜRETİCİSİ
  // ==========================================
  /// Sıralama seçenekleri için seçilebilir etiket (chip) widget'ı oluşturur.
  Widget _buildSortChip(
    VehicleProvider vp,
    SortOption option,
    String label,
    void Function(void Function()) setModalState,
  ) {
    final isSelected = vp.selectedSortOption == option;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          // Sıralama seçeneğini atıyoruz.
          vp.setSortOption(option);
          // Modalı yeniden çiziyoruz.
          setModalState(() {});
        }
      },
    );
  }
}
