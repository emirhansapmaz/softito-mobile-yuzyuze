// Asenkron veri akışlarını yönetmek için Dart async kütüphanesini içe aktarıyoruz
import 'dart:async';
// Rastgele yemek seçimi (Gümüş Kubbe algoritması) için rastgele sayı üreteci kütüphanesi
import 'dart:math';
// Firestore bulut veritabanı işlemlerini yürüten resmi kütüphane
import 'package:cloud_firestore/cloud_firestore.dart';
// Uygulama geneli koleksiyon ve anahtar sabitleri
import '../constants/app_constants.dart';
// Şef tarifleri veri modelini içe aktarıyoruz
import '../models/chef_recipe_model.dart';
// Standart yemek tarifleri veri modelini içe aktarıyoruz
import '../models/recipe_model.dart';
// Firebase bağlantı kontrol sınıfımız
import 'firebase_initializer.dart';

// Tarifler, favoriler, buzdolabı envanteri ve şef atölyesi verilerini yöneten ana servisimiz
class DatabaseService {
  // Firebase Firestore örneği (Firebase kapalıysa null olabilir)
  final FirebaseFirestore? _firestore;

  // Simülatör ve testler için 15 adet zengin, kategorize edilmiş mock veri listesi
  static final List<RecipeModel> defaultSeedRecipes = [
    // 1. Tarif: Bütçe Dostu - Mercimek Çorbası
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_1',
      // Yemek başlığı
      name: 'Geleneksel Süzme Mercimek Çorbası',
      // Tarif açıklaması
      description: 'Kırmızı mercimek, havuç ve patatesin tereyağlı nane sosuyla birleşimi.',
      // Malzemeler listesi
      ingredients: ['Kırmızı Mercimek', 'Havuç', 'Patates', 'Soğan', 'Tereyağı', 'Nane'],
      // Kalori değeri
      calories: 180,
      // Sunum tavsiyesi
      servingSuggestion: 'Üzerine kızgın pul biberli tereyağı gezdirerek sunun.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Taze sıkılmış limon dilimleri ve fırınlanmış kıtır krutonlar.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=800',
      // Kategori etiketi
      category: 'Bütçe Dostu',
    // 1. RecipeModel kapanışı
    ),
    // 2. Tarif: Geleneksel - Karnıyarık
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_2',
      // Yemek başlığı
      name: 'Karnıyarık & Pirinç Pilavı',
      // Tarif açıklaması
      description: 'Fırında közlenmiş patlıcanların leziz kıymalı harçla buluşması.',
      // Malzemeler listesi
      ingredients: ['Patlıcan', 'Kıyma', 'Soğan', 'Domates', 'Biber', 'Sarımsak', 'Pirinç', 'Tereyağı'],
      // Kalori değeri
      calories: 520,
      // Sunum tavsiyesi
      servingSuggestion: 'Ilık olarak, üzerine kıyılmış maydanoz serperek servis yapın.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Közlenmiş biber, buz gibi naneli cacık veya taze yayık ayranı.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1541518763669-27fef04b14ea?w=800',
      // Kategori etiketi
      category: 'Geleneksel',
    // 2. RecipeModel kapanışı
    ),
    // 3. Tarif: Pratik - Tavuk Sote
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_3',
      // Yemek başlığı
      name: 'Kremalı Mantarlı Tavuk Sote',
      // Tarif açıklaması
      description: 'Taze mantarlar ve jülyen tavuk parçalarının nefis krema sosuyla dansı.',
      // Malzemeler listesi
      ingredients: ['Tavuk Göğsü', 'Mantar', 'Krema', 'Kekik', 'Sarımsak', 'Zeytinyağı'],
      // Kalori değeri
      calories: 450,
      // Sunum tavsiyesi
      servingSuggestion: 'Taze çekilmiş karabiber ve fesleğen eşliğinde sıcak servis edin.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Fırınlanmış çıtır elma dilim patates veya tereyağlı fettuccine.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=800',
      // Kategori etiketi
      category: 'Pratik',
    // 3. RecipeModel kapanışı
    ),
    // 4. Tarif: Düşük Kalorili - Fırında Somon
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_4',
      // Yemek başlığı
      name: 'Fırında Somon & Kuşkonmaz Tabağı',
      // Tarif açıklaması
      description: 'Omega-3 deposu taze somon fileto, limon dilimleri ve taze kuşkonmaz.',
      // Malzemeler listesi
      ingredients: ['Somon Fileto', 'Kuşkonmaz', 'Zeytinyağı', 'Limon', 'Dereotu', 'Sarımsak'],
      // Kalori değeri
      calories: 340,
      // Sunum tavsiyesi
      servingSuggestion: 'Buharda pişirilmiş sebzeler ve taze dereotu yapraklarıyla sunun.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Roka-ceviz salatası ve hafif bir avokado püresi.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=800',
      // Kategori etiketi
      category: 'Düşük Kalorili',
    // 4. RecipeModel kapanışı
    ),
    // 5. Tarif: Geleneksel - Mantı
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_5',
      // Yemek başlığı
      name: 'Kayseri Usulü El Açması Mantı',
      // Tarif açıklaması
      description: 'İncecik açılmış hamur bohçaları, enfes sarımsaklı yoğurt ve sosla.',
      // Malzemeler listesi
      ingredients: ['Un', 'Kıyma', 'Yoğurt', 'Sarımsak', 'Tereyağı', 'Sumak', 'Nane'],
      // Kalori değeri
      calories: 580,
      // Sunum tavsiyesi
      servingSuggestion: 'Bol sarımsaklı süzme yoğurt ve sumak serpiştirerek servis ediniz.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Taze mevsim yeşillikleri salatası ve geleneksel şalgam suyu.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1625944525533-473f1a3d54e7?w=800',
      // Kategori etiketi
      category: 'Geleneksel',
    // 5. RecipeModel kapanışı
    ),
    // 6. Tarif: Düşük Kalorili - Enginar
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_6',
      // Yemek başlığı
      name: 'Zeytinyağlı Ege Çanak Enginarı',
      // Tarif açıklaması
      description: 'Garnitürlü taze çanak enginarlar, dereotu ve sızma zeytinyağıyla.',
      // Malzemeler listesi
      ingredients: ['Enginar', 'Havuç', 'Bezelye', 'Patates', 'Dereotu', 'Zeytinyağı', 'Limon'],
      // Kalori değeri
      calories: 190,
      // Sunum tavsiyesi
      servingSuggestion: 'Oda sıcaklığında veya soğuk, bol zeytinyağı ve dereotu ile sunulur.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Fırınlanmış ekşi mayalı köy ekmeği ve beyaz peynir dilimleri.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=800',
      // Kategori etiketi
      category: 'Düşük Kalorili',
    // 6. RecipeModel kapanışı
    ),
    // 7. Tarif: Bütçe Dostu - Menemen
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_7',
      // Yemek başlığı
      name: 'Bol Domatesli Köy Menemeni',
      // Tarif açıklaması
      description: 'Bahçe domatesleri, tatlı sivri biberler ve taze köy yumurtalarıyla.',
      // Malzemeler listesi
      ingredients: ['Yumurta', 'Domates', 'Biber', 'Tereyağı', 'Tuz', 'Karabiber'],
      // Kalori değeri
      calories: 260,
      // Sunum tavsiyesi
      servingSuggestion: 'Bakır tavada fokurdarken, taze ekmek eşliğinde sofraya getirin.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Tulum peyniri, siyah zeytin ve demli çay.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=800',
      // Kategori etiketi
      category: 'Bütçe Dostu',
    // 7. RecipeModel kapanışı
    ),
    // 8. Tarif: Geleneksel - Köfte & Piyaz
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_14',
      // Yemek başlığı
      name: 'Izgara Kasap Köfte & Fasulye Piyazı',
      // Tarif açıklaması
      description: 'Özel baharat harçlı ızgara köfteler, tahinli ve sumaklı fasulye piyazı.',
      // Malzemeler listesi
      ingredients: ['Kıyma', 'Kuru Fasulye', 'Soğan', 'Maydanoz', 'Tahin', 'Sumak', 'Zeytinyağı'],
      // Kalori değeri
      calories: 490,
      // Sunum tavsiyesi
      servingSuggestion: 'Közlenmiş domates ve biber eşliğinde sıcak sıcak servis yapın.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Köpüklü yayık ayranı ve tırnak pide.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=800',
      // Kategori etiketi
      category: 'Geleneksel',
    // 8. RecipeModel kapanışı
    ),
    // 9. Tarif: Pratik - Fırın Omlet
    const RecipeModel(
      // Benzersiz tarif kimliği
      id: 'recipe_15',
      // Yemek başlığı
      name: 'Fırınlanmış Sebzeli Omlet Dilimleri',
      // Tarif açıklaması
      description: 'Renkli biberler, mantar ve kaşar peyniriyle fırında kabaran puf omlet.',
      // Malzemeler listesi
      ingredients: ['Yumurta', 'Süt', 'Mantar', 'Kapya Biber', 'Kaşar Peyniri', 'Dereotu'],
      // Kalori değeri
      calories: 270,
      // Sunum tavsiyesi
      servingSuggestion: 'Kare dilimler halinde kesip taze dereotuyla süsleyin.',
      // Eşlikçi yiyecek önerisi
      pairsWellWith: 'Çeri domatesler, salatalık ve taze sıkılmış portakal suyu.',
      // Resim linki
      imageUrl: 'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=800',
      // Kategori etiketi
      category: 'Pratik',
    // 9. RecipeModel kapanışı
    ),
  // defaultSeedRecipes listesi kapanışı
  ];

  // Çevrimdışı ve Demo ortamı için bellekte tuttuğumuz favori ID kümesi
  static final Set<String> _localFavoriteIds = {'recipe_1', 'recipe_4', 'recipe_7'};

  // Buzdolabında varsayılan olarak bulunan temel gıda malzemeleri listemiz
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
  // _localInventory listesi kapanışı
  ];

  // Yerel ortamda kayıtlı şef tarifleri listemiz
  static final List<ChefRecipeModel> _localChefRecipes = [
    // Varsayılan şef tarifi
    ChefRecipeModel(
      // Tarif ID
      id: 'chef_init_1',
      // Ekleyen kullanıcı ID
      userId: 'default_user',
      // Tarif adı
      name: 'Şefin Özel Sebzeli Menemeni',
      // Malzemeler
      ingredients: ['Yumurta', 'Domates', 'Biber', 'Zeytinyağı'],
      // Kalori
      calories: 310,
      // Yapılış adımları
      steps: '1. Zeytinyağında ince kıyılmış biberleri soteleyin.\n2. Küp domatesleri ekleyip suyunu çekene kadar pişirin.\n3. Yumurtaları kırıp hafifçe karıştırarak 3 dakika kısık ateşte tutun.',
      // Eklenme tarihi
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    // ChefRecipeModel kapanışı
    ),
  // _localChefRecipes listesi kapanışı
  ];

  // Uygulama geneli aktif tüm hazır yemek listesi havuzumuz
  static final List<RecipeModel> _allRecipes = List<RecipeModel>.from(defaultSeedRecipes);

  // Yerel durum değişikliklerini ekranlara anında yaymak için Broadcast StreamController nesnelerimiz
  static final _chefRecipesStreamController = StreamController<List<ChefRecipeModel>>.broadcast();
  static final _favoritesStreamController = StreamController<List<String>>.broadcast();
  static final _inventoryStreamController = StreamController<List<String>>.broadcast();
  static final _recipesStreamController = StreamController<List<RecipeModel>>.broadcast();

  // DatabaseService kurucu metodu
  DatabaseService({
    // İsteğe bağlı Firestore örneği
    FirebaseFirestore? firestore,
  // Kurucu gövdesi
  }) : _firestore = FirebaseInitializer.isInitialized
            // Firebase çalışıyorsa örneği alıyoruz
            ? (firestore ?? FirebaseFirestore.instance)
            // Çalışmıyorsa null atıyoruz
            : null;

  // Koleksiyon Referansı Getter'ları
  // Yemekler koleksiyonu referansı
  CollectionReference<Map<String, dynamic>>? get _recipesRef =>
      _firestore?.collection(AppConstants.recipesCollection);

  // Favoriler koleksiyonu referansı
  CollectionReference<Map<String, dynamic>>? get _favoritesRef =>
      _firestore?.collection(AppConstants.userFavoritesCollection);

  // Envanter koleksiyonu referansı
  CollectionReference<Map<String, dynamic>>? get _inventoryRef =>
      _firestore?.collection(AppConstants.userInventoryCollection);

  // Şef tarifleri koleksiyonu referansı
  CollectionReference<Map<String, dynamic>>? get _chefRecipesRef =>
      _firestore?.collection(AppConstants.chefRecipesCollection);

  // ==================== RECIPES (HAZIR YEMEKLER) ====================

  // Tüm hazır yemekleri Stream olarak canlı dinleyen fonksiyon
  Stream<List<RecipeModel>> streamRecipes() async* {
    // Firestore bağlı değilse yerel listeden yayın yapıyoruz
    if (_recipesRef == null) {
      // İlk listeyi yayına veriyoruz
      yield List<RecipeModel>.from(_allRecipes);
      // controller üzerindeki güncellemeleri dinletiyoruz
      yield* _recipesStreamController.stream;
      // Akışı tamamlıyoruz
      return;
    // if kontrolü kapanışı
    }
    // Firestore canlı snapshot dinleyicisini bağlayıp modellere dönüştürüyoruz
    yield* _recipesRef!.snapshots().map((snapshot) {
      // Bulutta kayıt yoksa yerel listeyi dönüyoruz
      if (snapshot.docs.isEmpty) return List<RecipeModel>.from(_allRecipes);
      // Dokümanları RecipeModel nesnelerine çevirip dönüyoruz
      return snapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
    // Hata durumunda yerel listeyi dönüyoruz
    }).handleError((_) => List<RecipeModel>.from(_allRecipes));
  // streamRecipes metodunun kapanış parantezi
  }

  // Tüm hazır yemekleri tek seferlik asenkron çeken fonksiyon
  Future<List<RecipeModel>> getRecipes() async {
    // Firestore yoksa yerel listeyi dönüyoruz
    if (_recipesRef == null) return List<RecipeModel>.from(_allRecipes);
    // Hata yakalama bloğu
    try {
      // Dokümanları Firestore'dan çekiyoruz
      final snapshot = await _recipesRef!.get();
      // Boşsa yerel listeyi dönüyoruz
      if (snapshot.docs.isEmpty) return List<RecipeModel>.from(_allRecipes);
      // Haritadan modellere çeviriyoruz
      return snapshot.docs
          .map((doc) => RecipeModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
    // Hata durumunda güvenli yedek listeyi dönüyoruz
    } catch (_) {
      return List<RecipeModel>.from(_allRecipes);
    // try-catch kapanışı
    }
  // getRecipes metodunun kapanış parantezi
  }

  // Gümüş Kubbe Algoritması: Rastgele günün yemeğini seçen fonksiyon
  Future<RecipeModel> getRandomRecipe() async {
    // Önce mevcut yemek listesini çekiyoruz
    final recipes = await getRecipes();
    // Liste doluysa onu, boşsa varsayılan havuzu alıyoruz
    final list = recipes.isNotEmpty ? recipes : _allRecipes;
    // Liste uzunluğuna göre rastgele bir indeks seçiyoruz
    final randomIndex = Random().nextInt(list.length);
    // Rastgele seçilen yemeği dönüyoruz
    return list[randomIndex];
  // getRandomRecipe metodunun kapanış parantezi
  }

  // Arama metni ve kategori filtresine göre tarifleri filtreleyen arama fonksiyonumuz
  Future<List<RecipeModel>> searchRecipes(String query, {String? category}) async {
    // Arama kelimesindeki boşlukları temizleyip küçük harfe çeviriyoruz
    final cleanQuery = query.trim().toLowerCase();
    // Tüm tarif havuzunu çekiyoruz
    final allRecipes = await getRecipes();

    // Filtre kriterlerine uyan tarifleri döndürüyoruz
    return allRecipes.where((recipe) {
      // Kategori kontrolü: Belirtilmemişse, 'Tümü' ise veya eşitse eşleşir
      final matchesCategory = category == null ||
          category == 'Tümü' ||
          recipe.category.toLowerCase() == category.toLowerCase();

      // Kategori uymuyorsa doğrudan eliyoruz
      if (!matchesCategory) return false;
      // Arama kutusu boşsa kategoriye uyanı kabul ediyoruz
      if (cleanQuery.isEmpty) return true;

      // Yemek adı eşleşiyor mu kontrolü
      final nameMatches = recipe.name.toLowerCase().contains(cleanQuery);
      // Malzemelerden herhangi biri eşleşiyor mu kontrolü
      final ingredientMatches = recipe.ingredients.any(
        (item) => item.toLowerCase().contains(cleanQuery),
      );
      // Açıklama metni eşleşiyor mu kontrolü
      final descMatches = recipe.description.toLowerCase().contains(cleanQuery);
      // Üçünden biri tutuyorsa tarifi listeye alıyoruz
      return nameMatches || ingredientMatches || descMatches;
    // where filtresi kapanışı ve toList
    }).toList();
  // searchRecipes metodunun kapanış parantezi
  }

  // ==================== FAVORITES (FAVORİLER) ====================

  // Kullanıcının favorilediği tarif ID'lerini canlı dinleyen Stream
  Stream<List<String>> streamFavoriteRecipeIds(String userId) async* {
    // Firestore yoksa yerel favorileri yayına veriyoruz
    if (_favoritesRef == null) {
      // İlk listeyi yayına veriyoruz
      yield _localFavoriteIds.toList();
      // Stream controller üzerinden gelen güncellemeleri yayınlıyoruz
      yield* _favoritesStreamController.stream;
      // Fonksiyondan çıkıyoruz
      return;
    // if kontrolü kapanışı
    }
    // Firestore üzerinde userId'ye göre favori dokümanlarını dinliyoruz
    yield* _favoritesRef!
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Dokümanlardan 'recipeId' alanlarını toplayıp liste yapıyoruz
      return snapshot.docs
          .map((doc) => doc.data()['recipeId'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    // Hata durumunda yerel listeyi dönüyoruz
    }).handleError((_) => _localFavoriteIds.toList());
  // streamFavoriteRecipeIds metodunun kapanış parantezi
  }

  // Kullanıcının favorilediği tüm tariflerin tam nesne listesini getiren fonksiyon
  Future<List<RecipeModel>> getFavoriteRecipes(String userId) async {
    // Önce kullanıcının favorilediği ID'leri çekiyoruz
    final ids = await getFavoriteIds(userId);
    // Tüm tarif havuzunu alıyoruz
    final all = await getRecipes();
    // Sadece ID'si favorilerde olanları filtreleyip dönüyoruz
    return all.where((recipe) => ids.contains(recipe.id)).toList();
  // getFavoriteRecipes metodunun kapanış parantezi
  }

  // Kullanıcının favori ID listesini tek seferlik getiren fonksiyon
  Future<List<String>> getFavoriteIds(String userId) async {
    // Firestore yoksa yerel listeyi dönüyoruz
    if (_favoritesRef == null) return _localFavoriteIds.toList();
    // Hata yakalama try bloğu
    try {
      // Veritabanından kullanıcıya ait favori kayıtlarını çekiyoruz
      final snapshot = await _favoritesRef!.where('userId', isEqualTo: userId).get();
      // Boşsa yerel listeyi dönüyoruz
      if (snapshot.docs.isEmpty) return _localFavoriteIds.toList();
      // ID'leri filtreleyip dönüyoruz
      return snapshot.docs
          .map((doc) => doc.data()['recipeId'] as String? ?? '')
          .where((id) => id.isNotEmpty)
          .toList();
    // Hata olursa yerel favorileri dönüyoruz
    } catch (_) {
      return _localFavoriteIds.toList();
    // try-catch kapanışı
    }
  // getFavoriteIds metodunun kapanış parantezi
  }

  // Bir yemeği favorilere ekleyen veya favorilerden çıkaran (toggle) fonksiyonumuz
  Future<bool> toggleFavorite(String userId, String recipeId) async {
    // Firestore aktifse veritabanında işlem yapıyoruz
    if (_favoritesRef != null) {
      // Hata yakalama try bloğu
      try {
        // İlgili kullanıcı ve tarif eşleşmesini arıyoruz
        final query = await _favoritesRef!
            .where('userId', isEqualTo: userId)
            .where('recipeId', isEqualTo: recipeId)
            .limit(1)
            .get();

        // Eğer zaten favorilerdeyse siliyoruz
        if (query.docs.isNotEmpty) {
          // Dokümanı Firestore'dan siliyoruz
          await _favoritesRef!.doc(query.docs.first.id).delete();
          // Yerel listeden de çıkartıyoruz
          _localFavoriteIds.remove(recipeId);
          // Canlı dinleyicileri güncelliyoruz
          _favoritesStreamController.add(_localFavoriteIds.toList());
          // Artık favori olmadığı için false dönüyoruz
          return false;
        // Favorilerde yoksa yeni doküman olarak ekliyoruz
        } else {
          // Firestore'a yeni favori kaydı ekliyoruz
          await _favoritesRef!.add({
            // Kullanıcı ID
            'userId': userId,
            // Tarif ID
            'recipeId': recipeId,
            // Sunucu zaman damgası
            'createdAt': FieldValue.serverTimestamp(),
          // add parametreleri kapanışı
          });
          // Yerel listeye ekliyoruz
          _localFavoriteIds.add(recipeId);
          // Dinleyicileri güncelliyoruz
          _favoritesStreamController.add(_localFavoriteIds.toList());
          // Favorilere eklendiği için true dönüyoruz
          return true;
        // if-else kapanışı
        }
      // Hata durumunu yakalıyoruz
      } catch (_) {}
    // if _favoritesRef kapanışı
    }

    // Firestore kapalıysa yerel toggle işlemi yapıyoruz
    if (_localFavoriteIds.contains(recipeId)) {
      // Yerelden siliyoruz
      _localFavoriteIds.remove(recipeId);
      // Yayına yeni listeyi veriyoruz
      _favoritesStreamController.add(_localFavoriteIds.toList());
      // Çıkarıldı (false)
      return false;
    // Yoksa ekliyoruz
    } else {
      // Yerel listeye ekliyoruz
      _localFavoriteIds.add(recipeId);
      // Yayına yeni listeyi veriyoruz
      _favoritesStreamController.add(_localFavoriteIds.toList());
      // Eklendi (true)
      return true;
    // if-else kapanışı
    }
  // toggleFavorite metodunun kapanış parantezi
  }

  // Belirli bir tarifin kullanıcının favorilerinde olup olmadığını kontrol eden fonksiyon
  Future<bool> isFavorite(String userId, String recipeId) async {
    // Favori ID'lerini çekiyoruz
    final ids = await getFavoriteIds(userId);
    // İçerip içermediğini boolean dönüyoruz
    return ids.contains(recipeId);
  // isFavorite metodunun kapanış parantezi
  }

  // ==================== INVENTORY (BUZDOLABI ENVANTERİ) ====================

  // Kullanıcının buzdolabındaki malzemeleri canlı dinleyen Stream
  Stream<List<String>> streamInventory(String userId) async* {
    // Firestore kapalıysa yerel malzemeleri yayına veriyoruz
    if (_inventoryRef == null) {
      // İlk envanteri veriyoruz
      yield List<String>.from(_localInventory);
      // Stream controller dinleyicisini bağlıyoruz
      yield* _inventoryStreamController.stream;
      // Çıkıyoruz
      return;
    // if kontrolü kapanışı
    }
    // Kullanıcının envanter dokümanını anlık dinliyoruz
    yield* _inventoryRef!.doc(userId).snapshots().map((doc) {
      // Doküman yoksa yerel envanteri dönüyoruz
      if (!doc.exists || doc.data() == null) return List<String>.from(_localInventory);
      // 'ingredients' alanını liste olarak okuyoruz
      final list = doc.data()!['ingredients'] as List<dynamic>?;
      // String listesine çevirip dönüyoruz
      return list?.map((e) => e.toString()).toList() ?? List<String>.from(_localInventory);
    // Hata durumunda yerel listeyi dönüyoruz
    }).handleError((_) => List<String>.from(_localInventory));
  // streamInventory metodunun kapanış parantezi
  }

  // Kullanıcının envanterini tek seferlik çeken fonksiyon
  Future<List<String>> getInventory(String userId) async {
    // Firestore yoksa yerel listeyi dönüyoruz
    if (_inventoryRef == null) return List<String>.from(_localInventory);
    // Hata yakalama try bloğu
    try {
      // Kullanıcının envanter dokümanını çekiyoruz
      final doc = await _inventoryRef!.doc(userId).get();
      // Doküman yoksa yerel listeyi dönüyoruz
      if (!doc.exists || doc.data() == null) return List<String>.from(_localInventory);
      // Malzemeler listesini alıyoruz
      final list = doc.data()!['ingredients'] as List<dynamic>?;
      // String listesi yapıp dönüyoruz
      return list?.map((e) => e.toString()).toList() ?? List<String>.from(_localInventory);
    // Hata olursa yerel listeyi dönüyoruz
    } catch (_) {
      return List<String>.from(_localInventory);
    // try-catch kapanışı
    }
  // getInventory metodunun kapanış parantezi
  }

  // Buzdolabına yeni bir malzeme ekleyen fonksiyon
  Future<void> addInventoryIngredient(String userId, String ingredient) async {
    // Malzeme adındaki gereksiz boşlukları temizliyoruz
    final clean = ingredient.trim();
    // Boş metin geldiyse işlem yapmıyoruz
    if (clean.isEmpty) return;

    // Aynı malzeme daha önce eklenmiş mi kontrol ediyoruz
    final existingIndex = _localInventory
        .indexWhere((item) => item.trim().toLowerCase() == clean.toLowerCase());
    // Eğer yoksa yerel listenin en başına ekliyoruz
    if (existingIndex == -1) {
      // Listenin başına ekliyoruz
      _localInventory.insert(0, clean);
      // Dinleyicilere güncel listeyi bildiriyoruz
      _inventoryStreamController.add(List<String>.from(_localInventory));
    // if kontrolü kapanışı
    }

    // Firestore varsa bulut veritabanını güncelliyoruz
    if (_inventoryRef != null) {
      // Hata yakalama try bloğu
      try {
        // arrayUnion ile malzemeyi listeye benzersiz şekilde ekliyoruz
        await _inventoryRef!.doc(userId).set({
          // Kullanıcı ID
          'userId': userId,
          // Malzemeler listesine ekleme işlemi
          'ingredients': FieldValue.arrayUnion([clean]),
          // Güncellenme zaman damgası
          'updatedAt': FieldValue.serverTimestamp(),
        // merge: true ile diğer alanları koruyoruz
        }, SetOptions(merge: true));
      // Hata durumunu yutuyoruz
      } catch (_) {}
    // if _inventoryRef kapanışı
    }
  // addInventoryIngredient metodunun kapanış parantezi
  }

  // Buzdolabından bir malzemeyi silen fonksiyon
  Future<void> removeInventoryIngredient(String userId, String ingredient) async {
    // Silinecek malzemeyi küçük harfe çeviriyoruz
    final clean = ingredient.trim().toLowerCase();
    // Yerel listeden eşleşen malzemeyi siliyoruz
    _localInventory.removeWhere((item) => item.trim().toLowerCase() == clean);
    // Dinleyicilere güncel listeyi yayınlıyoruz
    _inventoryStreamController.add(List<String>.from(_localInventory));

    // Firestore varsa buluttan da siliyoruz
    if (_inventoryRef != null) {
      // Hata yakalama try bloğu
      try {
        // arrayRemove ile malzemeyi diziden çıkartıyoruz
        await _inventoryRef!.doc(userId).update({
          // Diziden silme operasyonu
          'ingredients': FieldValue.arrayRemove([ingredient.trim()]),
          // Güncellenme zamanı
          'updatedAt': FieldValue.serverTimestamp(),
        // update kapanışı
        });
      // Hata durumunu yakalıyoruz
      } catch (_) {}
    // if _inventoryRef kapanışı
    }
  // removeInventoryIngredient metodunun kapanış parantezi
  }

  // ==================== CHEF RECIPES (ŞEF ATÖLYESİ - MASTERCHEF) ====================

  // Kullanıcının eklediği şef tariflerini canlı dinleyen Stream
  Stream<List<ChefRecipeModel>> streamChefRecipes(String userId) async* {
    // Firestore yoksa yerel şef tariflerini dönüyoruz
    if (_chefRecipesRef == null) {
      // İlk listeyi veriyoruz
      yield List<ChefRecipeModel>.from(_localChefRecipes);
      // Stream controller dinleyicisini bağlıyoruz
      yield* _chefRecipesStreamController.stream;
      // Çıkıyoruz
      return;
    // if kontrolü kapanışı
    }
    // Firestore'da kullanıcının şef tariflerini dinliyoruz
    yield* _chefRecipesRef!
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      // Kayıt yoksa yerel listeyi veriyoruz
      if (snapshot.docs.isEmpty) return List<ChefRecipeModel>.from(_localChefRecipes);
      // Dokümanları ChefRecipeModel nesnelerine dönüştürüyoruz
      final list = snapshot.docs
          .map((doc) => ChefRecipeModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
      // En yeni tarifler en üstte görünsün diye tarihe göre tersten sıralıyoruz
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      // Sıralı listeyi dönüyoruz
      return list;
    // Hata durumunda yerel listeyi dönüyoruz
    }).handleError((_) => List<ChefRecipeModel>.from(_localChefRecipes));
  // streamChefRecipes metodunun kapanış parantezi
  }

  // Kullanıcının şef tariflerini tek seferlik getiren fonksiyon
  Future<List<ChefRecipeModel>> getChefRecipes(String userId) async {
    // Firestore yoksa yerel listeyi dönüyoruz
    if (_chefRecipesRef == null) return _localChefRecipes;
    // Hata yakalama try bloğu
    try {
      // Dokümanları çekiyoruz
      final snapshot = await _chefRecipesRef!.where('userId', isEqualTo: userId).get();
      // Boşsa yerel listeyi dönüyoruz
      if (snapshot.docs.isEmpty) return _localChefRecipes;
      // Modellere dönüştürüyoruz
      final list = snapshot.docs
          .map((doc) => ChefRecipeModel.fromMap(doc.data(), documentId: doc.id))
          .toList();
      // Tarihe göre sıralıyoruz
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      // Listeyi dönüyoruz
      return list;
    // Hata durumunda yerel listeyi dönüyoruz
    } catch (_) {
      return _localChefRecipes;
    // try-catch kapanışı
    }
  // getChefRecipes metodunun kapanış parantezi
  }

  // Yeni bir şef tarifi oluşturan ve ana tarifler havuzuna ekleyen fonksiyon
  Future<void> addChefRecipe(ChefRecipeModel recipe) async {
    // Yerel şef tariflerinin en başına ekliyoruz
    _localChefRecipes.insert(0, recipe);
    // Dinleyicilere bildiriyoruz
    _chefRecipesStreamController.add(List<ChefRecipeModel>.from(_localChefRecipes));

    // Ana yemekler havuzuna da Masterchef kategorisiyle anında ekliyoruz
    final asRecipe = RecipeModel(
      // Tarif ID
      id: recipe.id,
      // Tarif adı
      name: recipe.name,
      // Açıklama olarak yapılış adımlarını veriyoruz
      description: recipe.steps,
      // Malzemeler
      ingredients: recipe.ingredients,
      // Kalori
      calories: recipe.calories,
      // Sunum önerisi
      servingSuggestion: 'Şefin kendi özel atölye sunumu ile sıcak servis edilir.',
      // Eşlikçi önerisi
      pairsWellWith: 'Günün çorbası ve taze mevsim salatası.',
      // Görsel linki
      imageUrl: 'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
      // Özel Masterchef kategorisi
      category: 'Masterchef',
    // RecipeModel kapanışı
    );
    // Ana tarif listesinin başına ekliyoruz
    _allRecipes.insert(0, asRecipe);
    // Tarif dinleyicilerine haber veriyoruz
    _recipesStreamController.add(List<RecipeModel>.from(_allRecipes));

    // Firestore aktifse buluta yazıyoruz
    if (_chefRecipesRef != null) {
      // Hata yakalama try bloğu
      try {
        // Dokümanı Firestore'a kaydediyoruz
        await _chefRecipesRef!.doc(recipe.id.isEmpty ? null : recipe.id).set({
          // Kullanıcı ID
          'userId': recipe.userId,
          // Tarif adı
          'name': recipe.name,
          // Malzemeler
          'ingredients': recipe.ingredients,
          // Kalori
          'calories': recipe.calories,
          // Adımlar
          'steps': recipe.steps,
          // Zaman damgası
          'createdAt': Timestamp.fromDate(recipe.createdAt),
        // set parametreleri kapanışı
        });
      // Hata durumunu yutuyoruz
      } catch (_) {}
    // if _chefRecipesRef kapanışı
    }
  // addChefRecipe metodunun kapanış parantezi
  }

  // Eklenmiş bir şef tarifini silen fonksiyon
  Future<void> deleteChefRecipe(String recipeId) async {
    // Yerel listeden tarif ID'sine göre çıkartıyoruz
    _localChefRecipes.removeWhere((r) => r.id == recipeId);
    // Dinleyicilere güncellemeyi bildiriyoruz
    _chefRecipesStreamController.add(List<ChefRecipeModel>.from(_localChefRecipes));

    // Ana tarif listesinden de çıkartıyoruz
    _allRecipes.removeWhere((r) => r.id == recipeId);
    // Tarif dinleyicilerine bildiriyoruz
    _recipesStreamController.add(List<RecipeModel>.from(_allRecipes));

    // Firestore aktifse buluttan siliyoruz
    if (_chefRecipesRef != null) {
      // Hata yakalama try bloğu
      try {
        // Dokümanı Firestore'dan siliyoruz
        await _chefRecipesRef!.doc(recipeId).delete();
      // Hata durumunu yakalıyoruz
      } catch (_) {}
    // if _chefRecipesRef kapanışı
    }
  // deleteChefRecipe metodunun kapanış parantezi
  }
// DatabaseService sınıfının kapanış parantezi
}
