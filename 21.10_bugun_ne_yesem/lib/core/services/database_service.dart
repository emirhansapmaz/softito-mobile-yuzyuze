import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_constants.dart';
import '../models/chef_recipe_model.dart';
import '../models/recipe_model.dart';
import 'firebase_initializer.dart';

class DatabaseService {
  final FirebaseFirestore? _firestore;

  /// Simülatör ve testler için 15 adet zengin, kategorize edilmiş mock veri listesi
  static final List<RecipeModel> defaultSeedRecipes = [
    // 1. Bütçe Dostu
    const RecipeModel(
      id: 'recipe_1',
      name: 'Geleneksel Süzme Mercimek Çorbası',
      description: 'Kırmızı mercimek, havuç ve patatesin tereyağlı nane sosuyla birleşimi.',
      ingredients: ['Kırmızı Mercimek', 'Havuç', 'Patates', 'Soğan', 'Tereyağı', 'Nane'],
      calories: 180,
      servingSuggestion: 'Üzerine kızgın pul biberli tereyağı gezdirerek sunun.',
      pairsWellWith: 'Taze sıkılmış limon dilimleri ve fırınlanmış kıtır krutonlar.',
      imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800',
      category: 'Bütçe Dostu',
    ),
    // 2. Geleneksel
    const RecipeModel(
      id: 'recipe_2',
      name: 'Karnıyarık & Pirinç Pilavı',
      description: 'Fırında közlenmiş patlıcanların leziz kıymalı harçla buluşması.',
      ingredients: ['Patlıcan', 'Kıyma', 'Soğan', 'Domates', 'Biber', 'Sarımsak', 'Pirinç', 'Tereyağı'],
      calories: 520,
      servingSuggestion: 'Ilık olarak, üzerine kıyılmış maydanoz serperek servis yapın.',
      pairsWellWith: 'Közlenmiş biber, buz gibi naneli cacık veya taze yayık ayranı.',
      imageUrl: 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?w=800',
      category: 'Geleneksel',
    ),
    // 3. Pratik
    const RecipeModel(
      id: 'recipe_3',
      name: 'Kremalı Mantarlı Tavuk Sote',
      description: 'Taze mantarlar ve jülyen tavuk parçalarının nefis krema sosuyla dansı.',
      ingredients: ['Tavuk Göğsü', 'Mantar', 'Krema', 'Kekik', 'Sarımsak', 'Zeytinyağı'],
      calories: 450,
      servingSuggestion: 'Taze çekilmiş karabiber ve fesleğen eşliğinde sıcak servis edin.',
      pairsWellWith: 'Fırınlanmış çıtır elma dilim patates veya tereyağlı fettuccine.',
      imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800',
      category: 'Pratik',
    ),
    // 4. Düşük Kalorili
    const RecipeModel(
      id: 'recipe_4',
      name: 'Fırında Somon & Kuşkonmaz Tabağı',
      description: 'Omega-3 deposu taze somon fileto, limon dilimleri ve taze kuşkonmaz.',
      ingredients: ['Somon Fileto', 'Kuşkonmaz', 'Zeytinyağı', 'Limon', 'Dereotu', 'Sarımsak'],
      calories: 340,
      servingSuggestion: 'Buharda pişirilmiş sebzeler ve taze dereotu yapraklarıyla sunun.',
      pairsWellWith: 'Roka-ceviz salatası ve hafif bir avokado püresi.',
      imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800',
      category: 'Düşük Kalorili',
    ),
    // 5. Geleneksel
    const RecipeModel(
      id: 'recipe_5',
      name: 'Kayseri Usulü El Açması Mantı',
      description: 'İncecik açılmış hamur bohçaları, enfes sarımsaklı yoğurt ve sosla.',
      ingredients: ['Un', 'Kıyma', 'Yoğurt', 'Sarımsak', 'Tereyağı', 'Sumak', 'Nane'],
      calories: 580,
      servingSuggestion: 'Bol sarımsaklı süzme yoğurt ve sumak serpiştirerek servis ediniz.',
      pairsWellWith: 'Taze mevsim yeşillikleri salatası ve geleneksel şalgam suyu.',
      imageUrl: 'https://images.unsplash.com/photo-1625944525533-473f1a3d54e7?w=800',
      category: 'Geleneksel',
    ),
    // 6. Düşük Kalorili
    const RecipeModel(
      id: 'recipe_6',
      name: 'Zeytinyağlı Ege Çanak Enginarı',
      description: 'Garnitürlü taze çanak enginarlar, dereotu ve sızma zeytinyağıyla.',
      ingredients: ['Enginar', 'Havuç', 'Bezelye', 'Patates', 'Dereotu', 'Zeytinyağı', 'Limon'],
      calories: 190,
      servingSuggestion: 'Oda sıcaklığında veya soğuk, bol zeytinyağı ve dereotu ile sunulur.',
      pairsWellWith: 'Fırınlanmış ekşi mayalı köy ekmeği ve beyaz peynir dilimleri.',
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800',
      category: 'Düşük Kalorili',
    ),
    // 7. Bütçe Dostu & Pratik
    const RecipeModel(
      id: 'recipe_7',
      name: 'Bol Domatesli Köy Menemeni',
      description: 'Bahçe domatesleri, tatlı sivri biberler ve taze köy yumurtalarıyla.',
      ingredients: ['Yumurta', 'Domates', 'Biber', 'Tereyağı', 'Tuz', 'Karabiber'],
      calories: 260,
      servingSuggestion: 'Bakır tavada fokurdarken, taze ekmek eşliğinde sofraya getirin.',
      pairsWellWith: 'Tulum peyniri, siyah zeytin ve demli çay.',
      imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800',
      category: 'Bütçe Dostu',
    ),
    // 8. Düşük Kalorili
    const RecipeModel(
      id: 'recipe_8',
      name: 'Kinoa & Avokadolu Detoks Salatası',
      description: 'Haşlanmış kinoa, olgun avokado küpleri, nar taneleri ve ceviz.',
      ingredients: ['Kinoa', 'Avokado', 'Roka', 'Nar', 'Ceviz', 'Zeytinyağı', 'Limon'],
      calories: 220,
      servingSuggestion: 'Üzerine balsamik sos gezdirerek soğuk servis yapın.',
      pairsWellWith: 'Maden suyu veya taze elma-zencefil suyu.',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
      category: 'Düşük Kalorili',
    ),
    // 9. Bütçe Dostu
    const RecipeModel(
      id: 'recipe_9',
      name: 'Fesleğenli Domates Soslu Penne',
      description: 'İtalyan usulü domates ve fesleğen sosuyla lezzetlenmiş penne makarna.',
      ingredients: ['Penne Makarna', 'Domates Püresi', 'Fesleğen', 'Sarımsak', 'Zeytinyağı', 'Parmesan'],
      calories: 380,
      servingSuggestion: 'Sıcak makarnanın üzerine rendelenmiş peynir serpip servis edin.',
      pairsWellWith: 'Sarımsaklı çıtır ekmek dilimleri ve roka salatası.',
      imageUrl: 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=800',
      category: 'Bütçe Dostu',
    ),
    // 10. Pratik & Düşük Kalorili
    const RecipeModel(
      id: 'recipe_10',
      name: 'Izgara Tavuk Göğsü & Renkli Biberler',
      description: 'Biberiye ve kekikle marine edilmiş yumuşacık ızgara tavuk dilimleri.',
      ingredients: ['Tavuk Göğsü', 'Kapya Biber', 'Yeşil Biber', 'Kekik', 'Biberiye', 'Zeytinyağı'],
      calories: 310,
      servingSuggestion: 'Izgara izleriyle sıcak tabakta limon eşliğinde sunulur.',
      pairsWellWith: 'Yoğurtlu kabak mezesi veya fırınlanmış patates.',
      imageUrl: 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=800',
      category: 'Pratik',
    ),
    // 11. Bütçe Dostu
    const RecipeModel(
      id: 'recipe_11',
      name: 'Geleneksel Mercimek Köftesi',
      description: 'İnce bulgur, kırmızı mercimek, taze soğan ve bol maydanozlu lezzet şöleni.',
      ingredients: ['Kırmızı Mercimek', 'İnce Bulgur', 'Soğan', 'Salça', 'Taze Soğan', 'Maydanoz', 'Limon'],
      calories: 290,
      servingSuggestion: 'Gevrek marul yaprakları ve limon dilimleriyle servis edilir.',
      pairsWellWith: 'Kornişon turşu ve naneli ayran.',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      category: 'Bütçe Dostu',
    ),
    // 12. Düşük Kalorili
    const RecipeModel(
      id: 'recipe_12',
      name: 'Fırında Çıtır Karnabahar & Yoğurt Sos',
      description: 'Zerdeçal, toz biber ve zeytinyağıyla harmanlanıp fırınlanmış karnabahar lokmaları.',
      ingredients: ['Karnabahar', 'Zeytinyağı', 'Zerdeçal', 'Toz Biber', 'Sarımsaklı Yoğurt'],
      calories: 160,
      servingSuggestion: 'Fırından çıkar çıkmaz sarımsaklı süzme yoğurt dip sosla sunun.',
      pairsWellWith: 'Fırın tavuk veya hafif mercimek çorbası.',
      imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800',
      category: 'Düşük Kalorili',
    ),
    // 13. Pratik
    const RecipeModel(
      id: 'recipe_13',
      name: 'Ballı Hardallı Tavuk Salatası',
      description: 'Tavuk göğsü dilimleri, göbek marul, mısır ve ballı hardal sos.',
      ingredients: ['Tavuk Göğsü', 'Göbek Marul', 'Mısır', 'Bal', 'Hardal', 'Zeytinyağı'],
      calories: 330,
      servingSuggestion: 'Sosunu tam servis anında ilave edip harmanlayın.',
      pairsWellWith: 'Taze limonlu soğuk maden suyu.',
      imageUrl: 'https://images.unsplash.com/photo-1505253758473-96b3015f21c9?w=800',
      category: 'Pratik',
    ),
    // 14. Geleneksel
    const RecipeModel(
      id: 'recipe_14',
      name: 'Izgara Kasap Köfte & Fasulye Piyazı',
      description: 'Özel baharat harçlı ızgara köfteler, tahinli ve sumaklı fasulye piyazı.',
      ingredients: ['Kıyma', 'Kuru Fasulye', 'Soğan', 'Maydanoz', 'Tahin', 'Sumak', 'Zeytinyağı'],
      calories: 490,
      servingSuggestion: 'Közlenmiş domates ve biber eşliğinde sıcak sıcak servis yapın.',
      pairsWellWith: 'Köpüklü yayık ayranı ve tırnak pide.',
      imageUrl: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=800',
      category: 'Geleneksel',
    ),
    // 15. Pratik
    const RecipeModel(
      id: 'recipe_15',
      name: 'Fırınlanmış Sebzeli Omlet Dilimleri',
      description: 'Renkli biberler, mantar ve kaşar peyniriyle fırında kabaran puf omlet.',
      ingredients: ['Yumurta', 'Süt', 'Mantar', 'Kapya Biber', 'Kaşar Peyniri', 'Dereotu'],
      calories: 270,
      servingSuggestion: 'Kare dilimler halinde kesip taze dereotuyla süsleyin.',
      pairsWellWith: 'Çeri domatesler, salatalık ve taze sıkılmış portakal suyu.',
      imageUrl: 'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=800',
      category: 'Pratik',
    ),
  ];

  // In-Memory Fallback State (Çevrimdışı / Demo için reaktif ve kalıcı kontroller)
  static final Set<String> _localFavoriteIds = {'recipe_1', 'recipe_4', 'recipe_7'};
  static final List<String> _localInventory = [
    'Yumurta',
    'Domates',
    'Biber',
    'Peynir',
    'Zeytinyağı',
    'Makarna',
    'Tavuk Göğsü',
    'Soğan',
    'Sarımsak',
    'Mantar',
    'Kırmızı Mercimek',
    'Patates',
    'Havuç',
    'Limon',
  ];
  static final List<ChefRecipeModel> _localChefRecipes = [
    ChefRecipeModel(
      id: 'chef_init_1',
      userId: 'default_user',
      name: 'Şefin Özel Sebzeli Menemeni',
      ingredients: ['Yumurta', 'Domates', 'Biber', 'Zeytinyağı'],
      calories: 310,
      steps: '1. Zeytinyağında ince kıyılmış biberleri soteleyin.\n2. Küp domatesleri ekleyip suyunu çekene kadar pişirin.\n3. Yumurtaları kırıp hafifçe karıştırarak 3 dakika kısık ateşte tutun.',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
  ];
  static final List<RecipeModel> _allRecipes = List<RecipeModel>.from(defaultSeedRecipes);

  // Stream Controllers for local state updates
  static final _chefRecipesStreamController = StreamController<List<ChefRecipeModel>>.broadcast();
  static final _favoritesStreamController = StreamController<List<String>>.broadcast();
  static final _inventoryStreamController = StreamController<List<String>>.broadcast();
  static final _recipesStreamController = StreamController<List<RecipeModel>>.broadcast();

  DatabaseService({FirebaseFirestore? firestore})
      : _firestore = FirebaseInitializer.isInitialized
            ? (firestore ?? FirebaseFirestore.instance)
            : null;

  // Collection References
  CollectionReference<Map<String, dynamic>>? get _recipesRef =>
      _firestore?.collection(AppConstants.recipesCollection);

  CollectionReference<Map<String, dynamic>>? get _favoritesRef =>
      _firestore?.collection(AppConstants.userFavoritesCollection);

  CollectionReference<Map<String, dynamic>>? get _inventoryRef =>
      _firestore?.collection(AppConstants.userInventoryCollection);

  CollectionReference<Map<String, dynamic>>? get _chefRecipesRef =>
      _firestore?.collection(AppConstants.chefRecipesCollection);

  // ==================== RECIPES (HAZIR YEMEKLER) ====================

  /// Tüm hazır yemekleri Stream olarak dinler
  Stream<List<RecipeModel>> streamRecipes() async* {
    if (_recipesRef == null) {
      yield List<RecipeModel>.from(_allRecipes);
      yield* _recipesStreamController.stream;
      return;
    }
    yield* _recipesRef!.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) return List<RecipeModel>.from(_allRecipes);
      return snapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
    }).handleError((_) => List<RecipeModel>.from(_allRecipes));
  }

  /// Tüm hazır yemekleri getirir
  Future<List<RecipeModel>> getRecipes() async {
    if (_recipesRef == null) return List<RecipeModel>.from(_allRecipes);
    try {
      final snapshot = await _recipesRef!.get();
      if (snapshot.docs.isEmpty) return List<RecipeModel>.from(_allRecipes);
      return snapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
    } catch (_) {
      return List<RecipeModel>.from(_allRecipes);
    }
  }

  /// Gümüş Kubbe Algoritması: Rastgele yemek seçer (Random)
  Future<RecipeModel> getRandomRecipe() async {
    final recipes = await getRecipes();
    final list = recipes.isNotEmpty ? recipes : _allRecipes;
    final randomIndex = Random().nextInt(list.length);
    return list[randomIndex];
  }

  /// Arama ve kategori filtreleme algoritması
  Future<List<RecipeModel>> searchRecipes(String query, {String? category}) async {
    final cleanQuery = query.trim().toLowerCase();
    final allRecipes = await getRecipes();

    return allRecipes.where((recipe) {
      final matchesCategory = category == null ||
          category == 'Tümü' ||
          recipe.category.toLowerCase() == category.toLowerCase();

      if (!matchesCategory) return false;
      if (cleanQuery.isEmpty) return true;

      final nameMatches = recipe.name.toLowerCase().contains(cleanQuery);
      final ingredientMatches = recipe.ingredients.any(
        (item) => item.toLowerCase().contains(cleanQuery),
      );
      final descMatches = recipe.description.toLowerCase().contains(cleanQuery);
      return nameMatches || ingredientMatches || descMatches;
    }).toList();
  }

  // ==================== FAVORITES ====================

  Stream<List<String>> streamFavoriteRecipeIds(String userId) async* {
    if (_favoritesRef == null) {
      yield _localFavoriteIds.toList();
      yield* _favoritesStreamController.stream;
      return;
    }
    yield* _favoritesRef!
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc.data()['recipeId'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    }).handleError((_) => _localFavoriteIds.toList());
  }

  Future<List<RecipeModel>> getFavoriteRecipes(String userId) async {
    final ids = await getFavoriteIds(userId);
    final all = await getRecipes();
    return all.where((recipe) => ids.contains(recipe.id)).toList();
  }

  Future<List<String>> getFavoriteIds(String userId) async {
    if (_favoritesRef == null) return _localFavoriteIds.toList();
    try {
      final snapshot =
          await _favoritesRef!.where('userId', isEqualTo: userId).get();
      if (snapshot.docs.isEmpty) return _localFavoriteIds.toList();
      return snapshot.docs
          .map((doc) => doc.data()['recipeId'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    } catch (_) {
      return _localFavoriteIds.toList();
    }
  }

  Future<bool> toggleFavorite(String userId, String recipeId) async {
    if (_favoritesRef != null) {
      try {
        final query = await _favoritesRef!
            .where('userId', isEqualTo: userId)
            .where('recipeId', isEqualTo: recipeId)
            .limit(1)
            .get();

        if (query.docs.isNotEmpty) {
          await _favoritesRef!.doc(query.docs.first.id).delete();
          _localFavoriteIds.remove(recipeId);
          _favoritesStreamController.add(_localFavoriteIds.toList());
          return false;
        } else {
          await _favoritesRef!.add({
            'userId': userId,
            'recipeId': recipeId,
            'createdAt': FieldValue.serverTimestamp(),
          });
          _localFavoriteIds.add(recipeId);
          _favoritesStreamController.add(_localFavoriteIds.toList());
          return true;
        }
      } catch (_) {}
    }

    // Local toggle
    if (_localFavoriteIds.contains(recipeId)) {
      _localFavoriteIds.remove(recipeId);
      _favoritesStreamController.add(_localFavoriteIds.toList());
      return false;
    } else {
      _localFavoriteIds.add(recipeId);
      _favoritesStreamController.add(_localFavoriteIds.toList());
      return true;
    }
  }

  Future<bool> isFavorite(String userId, String recipeId) async {
    final ids = await getFavoriteIds(userId);
    return ids.contains(recipeId);
  }

  // ==================== INVENTORY ====================

  Stream<List<String>> streamInventory(String userId) async* {
    if (_inventoryRef == null) {
      yield List<String>.from(_localInventory);
      yield* _inventoryStreamController.stream;
      return;
    }
    yield* _inventoryRef!.doc(userId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return List<String>.from(_localInventory);
      final list = doc.data()!['ingredients'] as List<dynamic>?;
      return list?.map((e) => e.toString()).toList() ?? List<String>.from(_localInventory);
    }).handleError((_) => List<String>.from(_localInventory));
  }

  Future<List<String>> getInventory(String userId) async {
    if (_inventoryRef == null) return List<String>.from(_localInventory);
    try {
      final doc = await _inventoryRef!.doc(userId).get();
      if (!doc.exists || doc.data() == null) return List<String>.from(_localInventory);
      final list = doc.data()!['ingredients'] as List<dynamic>?;
      return list?.map((e) => e.toString()).toList() ?? List<String>.from(_localInventory);
    } catch (_) {
      return List<String>.from(_localInventory);
    }
  }

  Future<void> addInventoryIngredient(String userId, String ingredient) async {
    final clean = ingredient.trim();
    if (clean.isEmpty) return;

    final existingIndex = _localInventory
        .indexWhere((item) => item.trim().toLowerCase() == clean.toLowerCase());
    if (existingIndex == -1) {
      _localInventory.insert(0, clean);
      _inventoryStreamController.add(List<String>.from(_localInventory));
    }

    if (_inventoryRef != null) {
      try {
        await _inventoryRef!.doc(userId).set({
          'userId': userId,
          'ingredients': FieldValue.arrayUnion([clean]),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (_) {}
    }
  }

  Future<void> removeInventoryIngredient(String userId, String ingredient) async {
    final clean = ingredient.trim().toLowerCase();
    _localInventory.removeWhere(
        (item) => item.trim().toLowerCase() == clean);
    _inventoryStreamController.add(List<String>.from(_localInventory));

    if (_inventoryRef != null) {
      try {
        await _inventoryRef!.doc(userId).update({
          'ingredients': FieldValue.arrayRemove([ingredient.trim()]),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } catch (_) {}
    }
  }

  // ==================== CHEF RECIPES (MASTERCHEF) ====================

  Stream<List<ChefRecipeModel>> streamChefRecipes(String userId) async* {
    if (_chefRecipesRef == null) {
      yield List<ChefRecipeModel>.from(_localChefRecipes);
      yield* _chefRecipesStreamController.stream;
      return;
    }
    yield* _chefRecipesRef!
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return List<ChefRecipeModel>.from(_localChefRecipes);
      final list = snapshot.docs
          .map((doc) => ChefRecipeModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    }).handleError((_) => List<ChefRecipeModel>.from(_localChefRecipes));
  }

  Future<List<ChefRecipeModel>> getChefRecipes(String userId) async {
    if (_chefRecipesRef == null) return _localChefRecipes;
    try {
      final snapshot =
          await _chefRecipesRef!.where('userId', isEqualTo: userId).get();
      if (snapshot.docs.isEmpty) return _localChefRecipes;
      final list = snapshot.docs
          .map((doc) => ChefRecipeModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return list;
    } catch (_) {
      return _localChefRecipes;
    }
  }

  Future<void> addChefRecipe(ChefRecipeModel recipe) async {
    _localChefRecipes.insert(0, recipe);
    _chefRecipesStreamController.add(List<ChefRecipeModel>.from(_localChefRecipes));

    // Ana yemekler havuzuna da Masterchef kategorisiyle anında ekle
    final asRecipe = RecipeModel(
      id: recipe.id,
      name: recipe.name,
      description: recipe.steps,
      ingredients: recipe.ingredients,
      calories: recipe.calories,
      servingSuggestion: 'Şefin kendi özel atölye sunumu ile sıcak servis edilir.',
      pairsWellWith: 'Günün çorbası ve taze mevsim salatası.',
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      category: 'Masterchef',
    );
    _allRecipes.insert(0, asRecipe);
    _recipesStreamController.add(List<RecipeModel>.from(_allRecipes));

    if (_chefRecipesRef != null) {
      try {
        await _chefRecipesRef!.doc(recipe.id.isEmpty ? null : recipe.id).set({
          'userId': recipe.userId,
          'name': recipe.name,
          'ingredients': recipe.ingredients,
          'calories': recipe.calories,
          'steps': recipe.steps,
          'createdAt': Timestamp.fromDate(recipe.createdAt),
        });
      } catch (_) {}
    }
  }

  Future<void> deleteChefRecipe(String recipeId) async {
    _localChefRecipes.removeWhere((r) => r.id == recipeId);
    _chefRecipesStreamController.add(List<ChefRecipeModel>.from(_localChefRecipes));

    _allRecipes.removeWhere((r) => r.id == recipeId);
    _recipesStreamController.add(List<RecipeModel>.from(_allRecipes));

    if (_chefRecipesRef != null) {
      try {
        await _chefRecipesRef!.doc(recipeId).delete();
      } catch (_) {}
    }
  }
}
