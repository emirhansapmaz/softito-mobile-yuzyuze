import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';
import 'masterchef_screen.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _ingredientController = TextEditingController();

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }

  Future<void> _addIngredient(List<String> currentIngredients) async {
    final text = _ingredientController.text.trim();
    if (text.isEmpty) return;

    if (currentIngredients.any((item) => item.toLowerCase() == text.toLowerCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bu malzeme zaten dolabınızda ekli!')),
      );
      return;
    }

    final db = ref.read(databaseServiceProvider);
    await db.addInventoryIngredient('default_user', text);
    _ingredientController.clear();
  }

  Future<void> _removeIngredient(String item) async {
    final db = ref.read(databaseServiceProvider);
    await db.removeInventoryIngredient('default_user', item);
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$item dolabınızdan çıkarıldı.'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final inventoryAsync = ref.watch(userInventoryStreamProvider('default_user'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Evdeki Malzemelerim'),
      ),
      body: SafeArea(
        child: inventoryAsync.when(
          data: (ingredients) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Masterchef Banner Button (Belirgin ve Dikkat Çekici)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4A7C59), Color(0xFF2E5339)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: Colors.amberAccent,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Masterchef Modu',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Dolabındaki malzemelerle sana özel yemek üret!',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MasterchefScreen(
                                  availableIngredients: ingredients,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'Başlat',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Malzeme Ekleme Alanı
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ingredientController,
                          decoration: InputDecoration(
                            hintText: 'Yeni malzeme yaz (Örn: Süt, Un)',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white30 : Colors.black26,
                            ),
                            prefixIcon: const Icon(Icons.kitchen_rounded,
                                color: AppColors.primary),
                            filled: true,
                            fillColor: isDark ? AppColors.cardDark : Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _addIngredient(ingredients),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                        ),
                        onPressed: () => _addIngredient(ingredients),
                        child: const Icon(Icons.add, size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Liste Başlığı & Sayısı
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mevcut Malzemeler (${ingredients.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Malzeme Chip / Liste Gösterimi
                  Expanded(
                    child: ingredients.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.kitchen_outlined,
                                  size: 60,
                                  color: isDark ? Colors.white24 : Colors.black26,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Dolabınızda henüz malzeme bulunmuyor.',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: ingredients.length,
                            itemBuilder: (context, index) {
                              final item = ingredients[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                color: isDark ? AppColors.cardDark : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight,
                                  ),
                                ),
                                child: ListTile(
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.primary.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.eco_rounded,
                                      color: AppColors.primary,
                                      size: 18,
                                    ),
                                  ),
                                  title: Text(
                                    item,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                    onPressed: () => _removeIngredient(item),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Hata: $err')),
        ),
      ),
    );
  }
}
