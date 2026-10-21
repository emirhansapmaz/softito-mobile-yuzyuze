import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/recipe_card.dart';
import '../../recipe_detail/presentation/recipe_detail_screen.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allRecipesAsync = ref.watch(recipesStreamProvider);
    final favoriteIdsAsync = ref.watch(userFavoritesStreamProvider('default_user'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favori Tariflerim'),
      ),
      body: Column(
        children: [
          // 04.3. Canlı Arama Çubuğu (Search Bar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() => _searchQuery = val.trim());
              },
              decoration: InputDecoration(
                hintText: 'Favorilerinde yemek veya malzeme ara...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: isDark ? AppColors.cardDark : Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Reaktif Favoriler Listesi ve Metin Bazlı Filtreleme
          Expanded(
            child: allRecipesAsync.when(
              data: (allRecipes) {
                return favoriteIdsAsync.when(
                  data: (favoriteIds) {
                    // Kullanıcının favorilediği tarifleri filtrele
                    final userFavorites = allRecipes
                        .where((r) => favoriteIds.contains(r.id))
                        .toList();

                    // Search bar ile contains filtreleme
                    final filteredList = userFavorites.where((recipe) {
                      if (_searchQuery.isEmpty) return true;
                      final q = _searchQuery.toLowerCase();
                      final matchesName = recipe.name.toLowerCase().contains(q);
                      final matchesIngredient = recipe.ingredients
                          .any((item) => item.toLowerCase().contains(q));
                      final matchesDesc =
                          recipe.description.toLowerCase().contains(q);
                      return matchesName || matchesIngredient || matchesDesc;
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border_rounded,
                              size: 64,
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isEmpty
                                  ? 'Henüz favori tarifiniz yok.'
                                  : '"$_searchQuery" ile eşleşen favori bulunamadı.',
                              style: TextStyle(
                                fontSize: 15,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final recipe = filteredList[index];
                        return RecipeCard(
                          recipe: recipe,
                          isFavorite: true,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    RecipeDetailScreen(recipe: recipe),
                              ),
                            );
                          },
                          onFavoriteTap: () async {
                            final db = ref.read(databaseServiceProvider);
                            await db.toggleFavorite(
                                'default_user', recipe.id);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    '${recipe.name} favorilerden çıkarıldı.'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Center(child: Text('Favoriler yüklenemedi: $err')),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Tarifler yüklenemedi: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
