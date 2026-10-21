import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chef_recipe_model.dart';
import '../models/recipe_model.dart';
import '../services/database_service.dart';

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  return DatabaseService();
});

/// Tüm hazır yemekleri dinleyen Stream Provider
final recipesStreamProvider = StreamProvider<List<RecipeModel>>((ref) {
  final db = ref.watch(databaseServiceProvider);
  return db.streamRecipes();
});

/// Kullanıcının favori tarif ID'lerini dinleyen Stream Provider
final userFavoritesStreamProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final db = ref.watch(databaseServiceProvider);
  return db.streamFavoriteRecipeIds(userId);
});

/// Kullanıcının evdeki malzemelerini dinleyen Stream Provider
final userInventoryStreamProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  final db = ref.watch(databaseServiceProvider);
  return db.streamInventory(userId);
});

/// Kullanıcının Masterchef yemeklerini dinleyen Stream Provider
final chefRecipesStreamProvider =
    StreamProvider.family<List<ChefRecipeModel>, String>((ref, userId) {
  final db = ref.watch(databaseServiceProvider);
  return db.streamChefRecipes(userId);
});

/// Arama metnini yöneten Riverpod Notifier
class RecipeSearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void setQuery(String newQuery) {
    state = newQuery;
  }

  void clear() {
    state = '';
  }
}

/// Arama sorgusu Provider'ı
final recipeSearchQueryProvider =
    NotifierProvider<RecipeSearchQueryNotifier, String>(RecipeSearchQueryNotifier.new);

/// Arama metnine göre filtrelenmiş hazır yemekler provider'ı
final filteredRecipesProvider = Provider<AsyncValue<List<RecipeModel>>>((ref) {
  final query = ref.watch(recipeSearchQueryProvider).trim().toLowerCase();
  final recipesAsync = ref.watch(recipesStreamProvider);

  return recipesAsync.whenData((recipes) {
    if (query.isEmpty) return recipes;
    return recipes.where((recipe) {
      final matchesName = recipe.name.toLowerCase().contains(query);
      final matchesIng = recipe.ingredients
          .any((item) => item.toLowerCase().contains(query));
      final matchesDesc = recipe.description.toLowerCase().contains(query);
      return matchesName || matchesIng || matchesDesc;
    }).toList();
  });
});
