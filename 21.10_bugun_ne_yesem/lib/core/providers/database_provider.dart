// Riverpod durum yönetimi paketini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Şef tarifleri veri modelini içe aktarıyoruz
import '../models/chef_recipe_model.dart';
// Yemek tarifi veri modelini içe aktarıyoruz
import '../models/recipe_model.dart';
// Veritabanı servisini içe aktarıyoruz
import '../services/database_service.dart';

// Veritabanı servisini (DatabaseService) sağlayan ana Provider
final databaseServiceProvider = Provider<DatabaseService>((ref) {
  // DatabaseService örneğini oluşturup döndürüyoruz
  return DatabaseService();
// databaseServiceProvider kapanışı
});

// Tüm hazır yemekleri canlı dinleyen Stream Provider sağlayıcımız
final recipesStreamProvider = StreamProvider<List<RecipeModel>>((ref) {
  // Veritabanı servisini okuyoruz
  final db = ref.watch(databaseServiceProvider);
  // Yemekleri canlı dinleyen akışı başlatıyoruz
  return db.streamRecipes();
// recipesStreamProvider kapanışı
});

// Kullanıcının favori tarif ID'lerini dinleyen parametreli (family) Stream Provider
final userFavoritesStreamProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  // Veritabanı servisini okuyoruz
  final db = ref.watch(databaseServiceProvider);
  // Verilen userId'ye ait favori ID'leri dinleyen akışı döndürüyoruz
  return db.streamFavoriteRecipeIds(userId);
// userFavoritesStreamProvider kapanışı
});

// Kullanıcının buzdolabındaki malzemeleri dinleyen parametreli Stream Provider
final userInventoryStreamProvider =
    StreamProvider.family<List<String>, String>((ref, userId) {
  // Veritabanı servisini okuyoruz
  final db = ref.watch(databaseServiceProvider);
  // Kullanıcının buzdolabı malzemelerini canlı dinliyoruz
  return db.streamInventory(userId);
// userInventoryStreamProvider kapanışı
});

// Kullanıcının Masterchef atölyesinde oluşturduğu tarifleri dinleyen Stream Provider
final chefRecipesStreamProvider =
    StreamProvider.family<List<ChefRecipeModel>, String>((ref, userId) {
  // Veritabanı servisini okuyoruz
  final db = ref.watch(databaseServiceProvider);
  // Şef tarifleri akışını başlatıyoruz
  return db.streamChefRecipes(userId);
// chefRecipesStreamProvider kapanışı
});

// Arama metnini hafızada tutan ve yöneten Riverpod Notifier sınıfımız
class RecipeSearchQueryNotifier extends Notifier<String> {
  // Başlangıç durumunda arama sorgusunu boş metin olarak belirliyoruz
  @override
  // Boş arama metni
  String build() => '';

  // Kullanıcı arama kutusuna yazı yazdıkça sorguyu güncelleyen fonksiyon
  void setQuery(String newQuery) {
    // State'e yeni arama metnini atıyoruz
    state = newQuery;
  // setQuery metodunun kapanış parantezi
  }

  // Arama metnini sıfırlayan / temizleyen fonksiyon
  void clear() {
    // State'i boş metin yapıyoruz
    state = '';
  // clear metodunun kapanış parantezi
  }
// RecipeSearchQueryNotifier sınıfının kapanış parantezi
}

// Arama sorgusu durumunu uygulamanın geneline sunan NotifierProvider
final recipeSearchQueryProvider =
    NotifierProvider<RecipeSearchQueryNotifier, String>(RecipeSearchQueryNotifier.new);

// Arama metnine göre anlık olarak filtrelenmiş hazır yemekleri sağlayan hesaplanmış (computed) Provider
final filteredRecipesProvider = Provider<AsyncValue<List<RecipeModel>>>((ref) {
  // Arama sorgusunu küçük harfe çevirip boşluklarını temizleyerek dinliyoruz
  final query = ref.watch(recipeSearchQueryProvider).trim().toLowerCase();
  // Canlı yemek listesi sağlayıcısını dinliyoruz
  final recipesAsync = ref.watch(recipesStreamProvider);

  // Veri başarıyla geldiğinde filtreleme mantığını çalıştırıyoruz
  return recipesAsync.whenData((recipes) {
    // Arama kutusu boşsa tüm yemekleri doğrudan döndürüyoruz
    if (query.isEmpty) return recipes;
    // Arama kelimesine uyan tarifleri filtreliyoruz
    return recipes.where((recipe) {
      // Yemek adında aranan kelime geçiyor mu
      final matchesName = recipe.name.toLowerCase().contains(query);
      // Malzemeler listesinde aranan kelime geçiyor mu
      final matchesIng = recipe.ingredients
          .any((item) => item.toLowerCase().contains(query));
      // Açıklama metninde aranan kelime geçiyor mu
      final matchesDesc = recipe.description.toLowerCase().contains(query);
      // Üçünden biri uyuyorsa tarifi listeye alıyoruz
      return matchesName || matchesIng || matchesDesc;
    // where filtresi ve toList kapanışı
    }).toList();
  // whenData kapanışı
  });
// filteredRecipesProvider kapanışı
});
