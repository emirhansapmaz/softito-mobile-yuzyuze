import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/category.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/vehicle_card.dart';
import 'vehicle_detail_screen.dart';

class VehicleListScreen extends StatelessWidget {
  final Category category;

  const VehicleListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vehicleProvider = Provider.of<VehicleProvider>(context);
    final cars = vehicleProvider.getFilteredCars(category.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${category.name} Araçları',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
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
          // Arama Çubuğu
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SearchBar(
              hintText: '${category.name} içinde marka/model ara...',
              leading: const Icon(Icons.search_rounded, color: AppColors.primaryBlue),
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
              onChanged: (val) => vehicleProvider.setSearchQuery(val),
            ),
          ),

          // Aktif Filtre Bilgisi ve Sayı
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${cars.length} araç listeleniyor',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
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

          // Araç Listesi
          Expanded(
            child: cars.isEmpty
                ? Center(
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
                      return VehicleCard(
                        car: car,
                        onTap: () {
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

  // Filtreleme ve Sıralama BottomSheet
  void _showFilterBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vp = Provider.of<VehicleProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
                            vp.resetFilters();
                            setModalState(() {});
                          },
                          child: const Text('Sıfırla'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sıralama Seçenekleri
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

                    // Vites Tipi
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

                    // Yakıt Tipi
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

                    // Uygula Butonu
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
          vp.setSortOption(option);
          setModalState(() {});
        }
      },
    );
  }
}
