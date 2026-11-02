// Flutter Material arayüz bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Riverpod durum yönetimi paketini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Veritabanı ve favori akışı sağlayıcılarını içe aktarıyoruz
import '../../../core/providers/database_provider.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';
// Yemek kartı bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/recipe_card.dart';
// Yemek detay ekranını içe aktarıyoruz
import '../../recipe_detail/presentation/recipe_detail_screen.dart';

// Kullanıcının beğendiği favori yemek tariflerini listeleyen ve içinde arama yaptıran ekran bileşenimiz
class FavoritesScreen extends ConsumerStatefulWidget {
  // FavoritesScreen sınıfının değişmez kurucu metodu
  const FavoritesScreen({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (State) yöneticisini bağlayan metot
  @override
  // ConsumerState nesnesi döndürüyoruz
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
// FavoritesScreen sınıfının kapanış parantezi
}

// Favoriler ekranında arama metnini dinleyen ve listeyi filtreleyen State sınıfımız
class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  // Arama metin kutusu kontrolcüsü
  final _searchController = TextEditingController();
  // Anlık yazılan arama sorgusu
  String _searchQuery = '';

  // Kontrolcüyü bellekten temizleyen yaşam döngüsü metodu
  @override
  // dispose gövdesi
  void dispose() {
    // Arama kontrolcüsünü bellekten siliyoruz
    _searchController.dispose();
    // Üst sınıfın dispose metodunu çağırıyoruz
    super.dispose();
  // dispose metodunun kapanış parantezi
  }

  // Ekranın görsel ağacını inşa eden build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Tüm hazır yemekler akışını Riverpod üzerinden dinliyoruz
    final allRecipesAsync = ref.watch(recipesStreamProvider);
    // Giriş yapmış kullanıcının favori ID'lerini canlı dinliyoruz
    final favoriteIdsAsync = ref.watch(userFavoritesStreamProvider('default_user'));

    // Sayfa iskeleti
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlık metni
        title: const Text('Favori Tariflerim'),
      // AppBar kapanışı
      ),
      // Arama çubuğu ve listeyi dizen Column
      child: Column(
        // Sütun elemanları listesi
        children: [
          // 04.3. Canlı Arama Çubuğu (Search Bar) Alanı
          Padding(
            // Yatayda 20, dikeyde 8 piksel boşluk
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            // Metin giriş kutusu TextField
            child: TextField(
              // Kontrolcüyü bağlıyoruz
              controller: _searchController,
              // Kullanıcı her harf yazdığında arama sorgusunu güncelliyoruz
              onChanged: (val) {
                // Durumu yeniliyoruz
                setState(() => _searchQuery = val.trim());
              // onChanged kapanışı
              },
              // Arama kutusu dekorasyonu
              decoration: InputDecoration(
                // Silik ipucu metni
                hintText: 'Favorilerinde yemek veya malzeme ara...',
                // İpucu stili
                hintStyle: TextStyle(
                  // 14 punto boyut
                  fontSize: 14,
                  // Temaya göre hafif silik renk
                  color: isDark ? Colors.white38 : Colors.black38,
                // TextStyle kapanışı
                ),
                // Büyüteç arama ikonu
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                // Arama kutusu doluysa çarpı (temizle) butonu gösteriyoruz
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        // Çarpı ikonu
                        icon: const Icon(Icons.clear, size: 20),
                        // Butona basıldığında kutuyu ve sorguyu temizliyoruz
                        onPressed: () {
                          // Metin kutusunu sıfırlıyoruz
                          _searchController.clear();
                          // Sorguyu boşaltıyoruz
                          setState(() => _searchQuery = '');
                        // onPressed kapanışı
                        },
                      // IconButton kapanışı
                      )
                    : null,
                // Arka planı dolgulu yapıyoruz
                filled: true,
                // Temaya göre kart rengi veya beyaz
                fillColor: isDark ? AppColors.cardDark : Colors.white,
                // İçerik kenar boşlukları
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                // Temel kenarlık çizgisi
                border: OutlineInputBorder(
                  // 16 piksel yuvarlatma
                  borderRadius: BorderRadius.circular(16),
                  // Kenarlık rengi
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                // Etkin kenarlık çizgisi
                enabledBorder: OutlineInputBorder(
                  // 16 piksel yuvarlatma
                  borderRadius: BorderRadius.circular(16),
                  // Kenarlık rengi
                  borderSide: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              // InputDecoration kapanışı
              ),
            // TextField kapanışı
            ),
          // Padding kapanışı
          ),
          // 8 piksel dikey boşluk
          const SizedBox(height: 8),

          // Reaktif Favoriler Listesi ve Metin Bazlı Filtreleme Alanı
          Expanded(
            // Tüm yemeklerin yüklenme durumunu kontrol ediyoruz
            child: allRecipesAsync.when(
              // Yemekler geldiyse favori ID'lerin durumuna bakıyoruz
              data: (allRecipes) {
                // Favori ID akışını kontrol ediyoruz
                return favoriteIdsAsync.when(
                  // İki veri de başarıyla geldiyse listeyi çiziyoruz
                  data: (favoriteIds) {
                    // Kullanıcının favorilediği tarifleri ID eşleşmesiyle çekiyoruz
                    final userFavorites = allRecipes
                        .where((r) => favoriteIds.contains(r.id))
                        .toList();

                    // Arama çubuğuna yazılan metne göre isim, malzeme ve açıklamada filtreleme yapıyoruz
                    final filteredList = userFavorites.where((recipe) {
                      // Arama boşsa tüm favorileri gösteriyoruz
                      if (_searchQuery.isEmpty) return true;
                      // Arama kelimesini küçük harfe çeviriyoruz
                      final q = _searchQuery.toLowerCase();
                      // Yemek adında aranan metin var mı
                      final matchesName = recipe.name.toLowerCase().contains(q);
                      // Malzemelerden herhangi birinde aranan metin var mı
                      final matchesIngredient = recipe.ingredients
                          .any((item) => item.toLowerCase().contains(q));
                      // Açıklamada aranan metin var mı
                      final matchesDesc =
                          recipe.description.toLowerCase().contains(q);
                      // Koşullardan biri uyuyorsa listeye dahil ediyoruz
                      return matchesName || matchesIngredient || matchesDesc;
                    // where ve toList kapanışı
                    }).toList();

                    // Eğer filtrelenmiş favori listesi boşsa uyarı ekranı gösteriyoruz
                    if (filteredList.isEmpty) {
                      // Ortalanmış içerik
                      return Center(
                        // İkon ve metni dizen Column
                        child: Column(
                          // Dikeyde ortalama
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Elemanlar
                          children: [
                            // Boş kalp ikonu
                            Icon(
                              Icons.favorite_border_rounded,
                              size: 64,
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            // 16 piksel boşluk
                            const SizedBox(height: 16),
                            // Bilgilendirme metni
                            Text(
                              // Duruma göre metin
                              _searchQuery.isEmpty
                                  ? 'Henüz favori tarifiniz yok.'
                                  : '"$_searchQuery" ile eşleşen favori bulunamadı.',
                              // Metin stili
                              style: TextStyle(
                                fontSize: 15,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                              ),
                            // Text kapanışı
                            ),
                          // Column çocukları kapanışı
                          ],
                        // Column kapanışı
                        ),
                      // Center kapanışı
                      );
                    // if filteredList.isEmpty kapanışı
                    }

                    // Favori tarifleri performanslı bir dikey listede çiziyoruz
                    return ListView.builder(
                      // Liste kenar boşlukları
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      // Toplam favori adedi
                      itemCount: filteredList.length,
                      // Eleman yapıcı fonksiyon
                      itemBuilder: (context, index) {
                        // Sıradaki yemek tarifi
                        final recipe = filteredList[index];
                        // Yemek kartı bileşeni
                        return RecipeCard(
                          // Tarif modeli
                          recipe: recipe,
                          // Favori durumu aktif (dolu kalp)
                          isFavorite: true,
                          // Karta tıklandığında detay ekranına geçiyoruz
                          onTap: () {
                            // Detay ekranına yönlendiriyoruz
                            Navigator.of(context).push(
                              // Sayfa rotası
                              MaterialPageRoute(
                                // Detay sayfası bileşeni
                                builder: (_) =>
                                    RecipeDetailScreen(recipe: recipe),
                              // MaterialPageRoute kapanışı
                              ),
                            // push kapanışı
                            );
                          // onTap kapanışı
                          },
                          // Kalp butonuna tıklandığında favorilerden çıkarıyoruz
                          onFavoriteTap: () async {
                            // Veritabanı servisini okuyoruz
                            final db = ref.read(databaseServiceProvider);
                            // Favoriyi siliyoruz
                            await db.toggleFavorite('default_user', recipe.id);
                            // Ekran açıksa SnackBar gösteriyoruz
                            if (!context.mounted) return;
                            // SnackBar bildirimi
                            ScaffoldMessenger.of(context).showSnackBar(
                              // SnackBar bileşeni
                              SnackBar(
                                // Çıkarıldı mesajı
                                content: Text(
                                    '${recipe.name} favorilerden çıkarıldı.'),
                                // 1 saniye ekranda kalsın
                                duration: const Duration(seconds: 1),
                              // SnackBar kapanışı
                              ),
                            // showSnackBar kapanışı
                            );
                          // onFavoriteTap kapanışı
                          },
                        // RecipeCard kapanışı
                        );
                      // itemBuilder kapanışı
                      },
                    // ListView.builder kapanışı
                    );
                  // data favoriteIds kapanışı
                  },
                  // Favori ID'leri yüklenirken
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  // Favori ID'leri yüklenirken hata çıkarsa
                  error: (err, stack) =>
                      Center(child: Text('Favoriler yüklenemedi: $err')),
                // favoriteIdsAsync.when kapanışı
                );
              // data allRecipes kapanışı
              },
              // Yemek havuzu yüklenirken
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              // Yemek havuzu yüklenirken hata çıkarsa
              error: (err, stack) =>
                  Center(child: Text('Tarifler yüklenemedi: $err')),
            // allRecipesAsync.when kapanışı
            ),
          // Expanded kapanışı
          ),
        // Column çocukları kapanışı
        ],
      // Column kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _FavoritesScreenState sınıfının kapanış parantezi
}
