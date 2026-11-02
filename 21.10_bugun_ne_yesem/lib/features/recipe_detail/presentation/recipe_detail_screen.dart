// İnternetten çekilen resimleri önbelleğe alan kütüphaneyi içe aktarıyoruz
import 'package:cached_network_image/cached_network_image.dart';
// Flutter temel Material bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Riverpod tüketici durum bileşenleri kütüphanesi
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Yemek tarifi veri modelini içe aktarıyoruz
import '../../../core/models/recipe_model.dart';
// Veritabanı servisi sağlayıcısını içe aktarıyoruz
import '../../../core/providers/database_provider.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';

// Bir yemeğin görselini, kalorisini, malzemelerini ve 'yanında iyi gider' önerilerini gösteren detay ekranı
class RecipeDetailScreen extends ConsumerStatefulWidget {
  // Detayları gösterilecek tarif modeli
  final RecipeModel recipe;

  // RecipeDetailScreen sınıfının değişmez kurucu metodu
  const RecipeDetailScreen({
    // Widget ağacı anahtarı
    super.key,
    // Tarif modelinin zorunlu parametre olduğunu belirtiyoruz
    required this.recipe,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum yöneticisini bağlayan metot
  @override
  // ConsumerState nesnesi döndürüyoruz
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
// RecipeDetailScreen sınıfının kapanış parantezi
}

// Favori kontrolünü ve sayfa detaylarını yöneten State sınıfımız
class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  // Yemeğin favorilerde olup olmadığını tutan bayrak
  bool _isFavorite = false;
  // Favori durumu veritabanından çekilirken yükleniyor gösteren bayrak
  bool _isLoadingFav = true;

  // Widget ilk yüklendiğinde favori kontrolü yapan yaşam döngüsü metodu
  @override
  // initState gövdesi
  void initState() {
    // Üst sınıfın initState metodunu çağırıyoruz
    super.initState();
    // Favori durumunu kontrol eden fonksiyonu tetikliyoruz
    _checkFavoriteStatus();
  // initState metodunun kapanış parantezi
  }

  // Veritabanından bu yemeğin favori olup olmadığını asenkron sorgulayan fonksiyon
  Future<void> _checkFavoriteStatus() async {
    // Veritabanı servisini okuyoruz
    final db = ref.read(databaseServiceProvider);
    // Favori durumunu sorguluyoruz
    final fav = await db.isFavorite('default_user', widget.recipe.id);
    // Ekran kapandıysa işlemi kesiyoruz
    if (!mounted) return;
    // Durumu güncelliyoruz
    setState(() {
      // Favori durumunu atıyoruz
      _isFavorite = fav;
      // Yüklemeyi kapatıyoruz
      _isLoadingFav = false;
    // setState kapanışı
    });
  // _checkFavoriteStatus metodunun kapanış parantezi
  }

  // Kalp butonuna tıklandığında favoriyi ekleyen veya çıkaran fonksiyon
  Future<void> _toggleFavorite() async {
    // Veritabanı servisini okuyoruz
    final db = ref.read(databaseServiceProvider);
    // Favoriyi tersine çeviriyoruz (toggle)
    final isNowFav = await db.toggleFavorite('default_user', widget.recipe.id);
    // Ekran hala canlı değilse işlem yapmıyoruz
    if (!mounted) return;
    // Ekranı güncelliyoruz
    setState(() {
      // Yeni favori durumunu atıyoruz
      _isFavorite = isNowFav;
    // setState kapanışı
    });

    // Kullanıcıya bilgilendirme SnackBar'ı gösteriyoruz
    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar bileşeni
      SnackBar(
        // Duruma göre bildirim mesajı
        content: Text(
          isNowFav
              ? '${widget.recipe.name} favorilerinize eklendi!'
              : '${widget.recipe.name} favorilerden çıkarıldı.',
        ),
        // 1 saniye ekranda kalsın
        duration: const Duration(seconds: 1),
      // SnackBar kapanışı
      ),
    // showSnackBar kapanışı
    );
  // _toggleFavorite metodunun kapanış parantezi
  }

  // 'Yanında iyi gider' kural bazlı akıllı eşleştirme algoritması
  List<Map<String, dynamic>> _getPairingRecommendations(RecipeModel recipe) {
    // Tarif adını küçük harfe çeviriyoruz
    final name = recipe.name.toLowerCase();
    // Çorba ve mercimek türleri için eşleştirmeler
    if (name.contains('çorba') || name.contains('mercimek')) {
      // Çorbaya özel eşlikçiler listesi
      return [
        {'name': 'Kıtır Ekmek / Kruton', 'icon': Icons.bakery_dining_rounded, 'desc': 'Fırınlanmış baharatlı küp ekmekler'},
        {'name': 'Taze Sıkılmış Limon', 'icon': Icons.eco_rounded, 'desc': 'Asiditesiyle çorbanın lezzetini katlar'},
        {'name': 'Közlenmiş Acı Biber', 'icon': Icons.local_fire_department, 'desc': 'Hafif acı dokunuşuyla mükemmel uyum'},
      ];
    // Mantı ve makarna türleri için eşleştirmeler
    } else if (name.contains('mantı') || name.contains('makarna')) {
      // Hamur işine özel eşlikçiler listesi
      return [
        {'name': 'Naneli Yayık Ayranı', 'icon': Icons.local_drink_rounded, 'desc': 'Buz gibi ferahlatıcı geleneksel tat'},
        {'name': 'Mevsim Çoban Salatası', 'icon': Icons.dinner_dining_rounded, 'desc': 'Taze domates ve salatalık ferahlığı'},
        {'name': 'Kızgın Tereyağı & Sumak', 'icon': Icons.flare_rounded, 'desc': 'Karakteristik ekstra sos dokunuşu'},
      ];
    // Balık ve somon türleri için eşleştirmeler
    } else if (name.contains('somon') || name.contains('balık')) {
      // Balığa özel eşlikçiler listesi
      return [
        {'name': 'Roka & Kırmızı Soğan Salatası', 'icon': Icons.spa_rounded, 'desc': 'Somonun yağ dengesini mükemmel ayarlar'},
        {'name': 'Buharda Sebze Tabağı', 'icon': Icons.grass_rounded, 'desc': 'Havuç, brokoli ve taze limon dilimleri'},
        {'name': 'Fırında Elma Dilim Patates', 'icon': Icons.lunch_dining_rounded, 'desc': 'Kekikli çıtır lezzet'},
      ];
    // Diğer tüm etli ve sebzeli yemekler için eşleştirmeler
    } else {
      // Genel eşlikçiler listesi
      return [
        {'name': 'Naneli Ev Cacığı', 'icon': Icons.local_cafe_rounded, 'desc': 'Süzme yoğurt ve kıtır salatalık ferahlığı'},
        {'name': 'Tane Tane Tereyağlı Pilav', 'icon': Icons.rice_bowl_rounded, 'desc': 'Yemeğin doyurucu ve klasik tamamlayıcısı'},
        {'name': 'Mevsim Yeşillikleri', 'icon': Icons.eco_rounded, 'desc': 'Zeytinyağı ve limon soslu taze yeşillikler'},
      ];
    // if-else kapanışı
    }
  // _getPairingRecommendations metodunun kapanış parantezi
  }

  // Ekranın görsel ağacını inşa eden build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Kolay erişim için widget içindeki tarifi alıyoruz
    final recipe = widget.recipe;
    // Temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Eşlikçi önerileri listesini oluşturuyoruz
    final pairings = _getPairingRecommendations(recipe);

    // Sayfa iskeleti
    return Scaffold(
      // Özel kaydırılabilir efektli CustomScrollView
      body: CustomScrollView(
        // Kayan parçalar (slivers) listesi
        slivers: [
          // Genişleyen görsel başlık çubuğu (SliverAppBar)
          SliverAppBar(
            // Genişletilmiş tepe yüksekliği (280 piksel)
            expandedHeight: 280,
            // Yukarı kaydırıldığında AppBar ekranda sabit kalsın
            pinned: true,
            // Arka plan rengi
            backgroundColor: AppColors.primary,
            // Başlık ve ikon rengi
            foregroundColor: Colors.white,
            // Sol üst köşedeki geri dön butonu
            leading: IconButton(
              // Yuvarlak yarı saydam buton kutusu
              icon: Container(
                // 6 piksel iç boşluk
                padding: const EdgeInsets.all(6),
                // Yuvarlak dekorasyon
                decoration: BoxDecoration(
                  // Yarı saydam siyah renk
                  color: Colors.black.withValues(alpha: 0.4),
                  // Daire şekli
                  shape: BoxShape.circle,
                // BoxDecoration kapanışı
                ),
                // Geri ok ikonu
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              // Container kapanışı
              ),
              // Tıklandığında önceki ekrana dönüyoruz
              onPressed: () => Navigator.of(context).pop(),
            // IconButton kapanışı
            ),
            // Sağ üstteki favori ekleme/çıkarma butonu
            actions: [
              // Buton bileşeni
              IconButton(
                // Yuvarlak buton kutusu
                icon: Container(
                  // 6 piksel iç boşluk
                  padding: const EdgeInsets.all(6),
                  // Daire dekorasyonu
                  decoration: BoxDecoration(
                    // Yarı saydam siyah renk
                    color: Colors.black.withValues(alpha: 0.4),
                    // Daire şekli
                    shape: BoxShape.circle,
                  // BoxDecoration kapanışı
                  ),
                  // Yükleniyorsa dönen animasyon, bittiyse kalp ikonu
                  child: _isLoadingFav
                      // Yükleme animasyonu kutusu
                      ? const SizedBox(
                          // Genişlik 20 piksel
                          width: 20,
                          // Yükseklik 20 piksel
                          height: 20,
                          // 2 piksel çizgi kalınlığı
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      // Kalp ikonu
                      : Icon(
                          // Favoriyse dolu kalp, değilse boş kalp
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          // Favoriyse kırmızı, değilse beyaz renk
                          color: _isFavorite ? Colors.redAccent : Colors.white,
                          // 20 piksel boyut
                          size: 20,
                        // Icon kapanışı
                        ),
                // Container kapanışı
                ),
                // Tıklandığında favoriyi değiştiriyoruz
                onPressed: _toggleFavorite,
              // IconButton kapanışı
              ),
              // Sağ kenardan 8 piksel boşluk
              const SizedBox(width: 8),
            // actions listesi kapanışı
            ],
            // Genişleyip daralan arka plan görsel alanı
            flexibleSpace: FlexibleSpaceBar(
              // Arka plan Stack bileşeni
              background: Stack(
                // Katmanları tam ekrana yayıyoruz
                fit: StackFit.expand,
                // Katmanlar listesi
                children: [
                  // Yumuşak geçiş animasyonu Hero bileşeni
                  Hero(
                    // Ana sayfadaki görselle aynı geçiş etiketi
                    tag: 'recipe_image_${recipe.id}',
                    // Önbellekli resim yükleyici
                    child: CachedNetworkImage(
                      // Yemeğin resim URL adresi
                      imageUrl: recipe.imageUrl,
                      // Kutuyu tam kaplama modu
                      fit: BoxFit.cover,
                      // Hata durumunda restoran ikonu
                      errorWidget: (context, url, error) => Container(
                        // Koyu gri arka plan
                        color: Colors.grey[700],
                        // Beyaz çatal-bıçak ikonu
                        child: const Icon(Icons.restaurant, size: 60, color: Colors.white),
                      // Container kapanışı
                      ),
                    // CachedNetworkImage kapanışı
                    ),
                  // Hero kapanışı
                  ),
                  // Resmin üstüne ve altına karartma gradyanı çeken DecoratedBox
                  DecoratedBox(
                    // Karartma gradyanı dekorasyonu
                    decoration: BoxDecoration(
                      // Doğrusal gradyan
                      gradient: LinearGradient(
                        // Yukarıdan aşağıya yön
                        begin: Alignment.topCenter,
                        // Aşağıda bitiş
                        end: Alignment.bottomCenter,
                        // Karartma renkleri
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      // LinearGradient kapanışı
                      ),
                    // BoxDecoration kapanışı
                    ),
                  // DecoratedBox kapanışı
                  ),
                  // Resmin altındaki Kalori Rozeti ve Yemek Başlığı
                  Positioned(
                    // Alttan 20 piksel
                    bottom: 20,
                    // Soldan 20 piksel
                    left: 20,
                    // Sağdan 20 piksel
                    right: 20,
                    // Kalori ve başlığı dizen Column
                    child: Column(
                      // Sola yaslama
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Elemanlar
                      children: [
                        // Yeşil Kalori Rozeti Kutusu
                        Container(
                          // İç boşluk
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          // Yuvarlatılmış köşe dekorasyonu
                          decoration: BoxDecoration(
                            // Yeşil ana tema rengi
                            color: AppColors.primary,
                            // 12 piksel yuvarlatma
                            borderRadius: BorderRadius.circular(12),
                          // BoxDecoration kapanışı
                          ),
                          // İkon ve kalori metni satırı
                          child: Row(
                            // Boyutu kadar yer kaplasın
                            mainAxisSize: MainAxisSize.min,
                            // Elemanlar
                            children: [
                              // Alev ikonu
                              const Icon(Icons.local_fire_department, size: 16, color: Colors.white),
                              // 4 piksel boşluk
                              const SizedBox(width: 4),
                              // Kalori metni
                              Text(
                                // Değer ve birim
                                '${recipe.calories} Kalori',
                                // Beyaz ve kalın stil
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              // Text kapanışı
                              ),
                            // Row çocukları kapanışı
                            ],
                          // Row kapanışı
                          ),
                        // Container kapanışı
                        ),
                        // 8 piksel dikey boşluk
                        const SizedBox(height: 8),

                        // Yemeğin Adı Metni
                        Text(
                          // Yemek başlığı
                          recipe.name,
                          // Büyük beyaz başlık stili
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        // Text kapanışı
                        ),
                      // Column çocukları kapanışı
                      ],
                    // Column kapanışı
                    ),
                  // Positioned kapanışı
                  ),
                // Stack çocukları kapanışı
                ],
              // Stack kapanışı
              ),
            // FlexibleSpaceBar kapanışı
            ),
          // SliverAppBar kapanışı
          ),

          // Yemek Detayları İçerik Alanı
          SliverToBoxAdapter(
            // Kenar boşlukları
            child: Padding(
              // Her yönden 20 piksel boşluk
              padding: const EdgeInsets.all(20),
              // Detay bölümlerini dizen Column
              child: Column(
                // Sola hizalama
                crossAxisAlignment: CrossAxisAlignment.start,
                // Elemanlar listesi
                children: [
                  // 1. Bölüm: Tarif Açıklaması Başlığı
                  Text(
                    // Başlık metni
                    'Tarif Açıklaması',
                    // Stil özellikleri
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  // Text kapanışı
                  ),
                  // 8 piksel boşluk
                  const SizedBox(height: 8),

                  // Açıklama Paragrafı
                  Text(
                    // Açıklama içeriği
                    recipe.description,
                    // Stil özellikleri
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                  // Text kapanışı
                  ),
                  // 24 piksel dikey boşluk
                  const SizedBox(height: 24),

                  // 2. Bölüm: Malzemeler Listesi Başlığı
                  Text(
                    // Başlık ve malzeme adedi
                    'Malzemeler (${recipe.ingredients.length})',
                    // Stil
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  // Text kapanışı
                  ),
                  // 12 piksel dikey boşluk
                  const SizedBox(height: 12),

                  // Malzeme Çiplerini (Chips) saran Wrap bileşeni
                  Wrap(
                    // Yatay boşluk 8 piksel
                    spacing: 8,
                    // Dikey boşluk 8 piksel
                    runSpacing: 8,
                    // Malzemeleri Chip'e dönüştürüyoruz
                    children: recipe.ingredients.map((item) {
                      // Onay ikonlu malzeme çipi
                      return Chip(
                        // Sol onay işareti dairesi
                        avatar: const CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          radius: 10,
                          child: Icon(Icons.check, size: 12, color: Colors.white),
                        ),
                        // Malzeme adı
                        label: Text(
                          item,
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        // Arka plan rengi
                        backgroundColor: isDark
                            ? AppColors.cardDark
                            : AppColors.backgroundLight,
                        // 12 piksel yuvarlatılmış köşeler
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                      // Chip kapanışı
                      );
                    // map ve toList kapanışı
                    }).toList(),
                  // Wrap kapanışı
                  ),
                  // 28 piksel dikey boşluk
                  const SizedBox(height: 28),

                  // 3. Bölüm: Servis Önerisi Kartı
                  Container(
                    // Genişliği tam yayıyoruz
                    width: double.infinity,
                    // 16 piksel iç boşluk
                    padding: const EdgeInsets.all(16),
                    // Yeşil çerçeveli kutu dekorasyonu
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    // Başlık ve açıklamayı dizen Column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Servis ikonu ve başlığı
                        const Row(
                          children: [
                            Icon(Icons.room_service_rounded, color: AppColors.primary, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Servis Önerisi',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        // 8 piksel boşluk
                        const SizedBox(height: 8),
                        // Öneri metni
                        Text(
                          recipe.servingSuggestion.isNotEmpty
                              ? recipe.servingSuggestion
                              : 'Taze ve sıcak servis edilmesi önerilir.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  // Container kapanışı
                  ),
                  // 20 piksel dikey boşluk
                  const SizedBox(height: 20),

                  // 4. Bölüm: 'YANINDA İYİ GİDER' EŞLEŞTİRME VE TAVSİYELERİ KARTI
                  Container(
                    // Genişliği tam yayıyoruz
                    width: double.infinity,
                    // 18 piksel iç boşluk
                    padding: const EdgeInsets.all(18),
                    // Sıcak şeftali tonlu kutu dekorasyonu
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    // İçerikleri dizen Column
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kadeh ikonu ve başlık
                        const Row(
                          children: [
                            Icon(Icons.wine_bar_rounded, color: AppColors.accent, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Yanında İyi Gider Eşleştirmesi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        // 8 piksel boşluk
                        const SizedBox(height: 8),
                        // Eşlikçi açıklaması
                        Text(
                          recipe.pairsWellWith.isNotEmpty
                              ? recipe.pairsWellWith
                              : 'Yanında taze sıkılmış mevsim içecekleri önerilir.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // 24 piksel ayırıcı çizgi
                        const Divider(height: 24),
                        // Tamamlayıcı Şef Önerileri Alt Başlığı
                        const Text(
                          'Tamamlayıcı Şef Önerileri:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // 10 piksel boşluk
                        const SizedBox(height: 10),

                        // Tamamlayıcı mini kartların listesi
                        ...pairings.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                // Mini ikon kutusu
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(item['icon'] as IconData, size: 16, color: AppColors.accent),
                                ),
                                const SizedBox(width: 10),
                                // Öneri adı ve açıklaması sütunu
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] as String,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      Text(
                                        item['desc'] as String,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  // Container kapanışı
                  ),
                  // 36 piksel alt boşluk
                  const SizedBox(height: 36),
                // Column çocukları kapanışı
                ],
              // Column kapanışı
              ),
            // Padding kapanışı
            ),
          // SliverToBoxAdapter kapanışı
          ),
        // slivers listesi kapanışı
        ],
      // CustomScrollView kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _RecipeDetailScreenState sınıfının kapanış parantezi
}
