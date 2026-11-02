// İnternetten çekilen resimleri önbelleğe alarak hızlı yükleyen kütüphane
import 'package:cached_network_image/cached_network_image.dart';
// Flutter temel Material bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Yemek tarifi veri modelini içe aktarıyoruz
import '../../core/models/recipe_model.dart';
// Tema renklerimizi içe aktarıyoruz
import '../../core/theme/app_colors.dart';

// Yemek tariflerini liste ve arama ekranlarında görsel kart olarak sunan tekrar kullanılabilir widget'ımız
class RecipeCard extends StatelessWidget {
  // Kart üzerinde bilgileri gösterilecek yemek tarifi modeli
  final RecipeModel recipe;
  // Karta tıklandığında detay sayfasına yönlendiren olay
  final VoidCallback? onTap;
  // Kalp butonuna tıklandığında favoriyi değiştiren olay
  final VoidCallback? onFavoriteTap;
  // Yemeğin favorilere eklenmiş olup olmadığını belirten bayrak
  final bool isFavorite;

  // RecipeCard sınıfının değişmez kurucu metodu
  const RecipeCard({
    // Widget ağacı anahtarı
    super.key,
    // Yemek tarifi modelinin zorunlu olduğunu belirtiyoruz
    required this.recipe,
    // Tıklama olayı parametresi
    this.onTap,
    // Favori tıklama olayı parametresi
    this.onFavoriteTap,
    // Favori durumu varsayılan false
    this.isFavorite = false,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Aktif temanın koyu olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Kart tasarımı bileşeni
    return Card(
      // Kart köşelerinden içeriğin taşmasını önleyen kırpma modu
      clipBehavior: Clip.antiAlias,
      // Kartlar altına 16 piksel boşluk
      margin: const EdgeInsets.only(bottom: 16),
      // Kartın 20 piksel yuvarlatılmış köşeleri ve kenarlık çizgisi
      shape: RoundedRectangleBorder(
        // 20 piksel köşe yarıçapı
        borderRadius: BorderRadius.circular(20),
        // Temaya göre kenarlık çizgisi rengi
        side: BorderSide(
          // Koyu veya açık tema çerçeve rengi
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        // BorderSide kapanışı
        ),
      // RoundedRectangleBorder kapanışı
      ),
      // Kart gölgesi sıfır
      elevation: 0,
      // Temaya göre kart arka plan rengi
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      // Tıklandığında dalgalanma efekti veren InkWell
      child: InkWell(
        // Tıklama olayını bağlıyoruz
        onTap: onTap,
        // Dalgalanma efektini köşelere hapsediyoruz
        borderRadius: BorderRadius.circular(20),
        // Resim ve metinleri alt alta dizen Column
        child: Column(
          // Elemanları sola hizalıyoruz
          crossAxisAlignment: CrossAxisAlignment.start,
          // Sütun elemanları listesi
          children: [
            // Resim ve üzerindeki rozetleri üst üste bindiren Stack
            Stack(
              // Stack içindeki katmanlar
              children: [
                // Sayfa geçişinde yumuşak görsel animasyonu sağlayan Hero bileşeni
                Hero(
                  // Benzersiz geçiş etiketi
                  tag: 'recipe_image_${recipe.id}',
                  // Görselin 16/9 sinematik oranını koruyan AspectRatio
                  child: AspectRatio(
                    // 16'ya 9 en-boy oranı
                    aspectRatio: 16 / 9,
                    // Önbellekli resim yükleyici
                    child: CachedNetworkImage(
                      // Yemeğin görsel linki
                      imageUrl: recipe.imageUrl,
                      // Kutuyu tam kaplayacak şekilde dolduruyoruz
                      fit: BoxFit.cover,
                      // Resim inerken gösterilen yer tutucu kutu
                      placeholder: (context, url) => Container(
                        // Gri arka plan
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        // Ortada dönen yükleme göstergesi
                        child: const Center(
                          // 2 piksel ince yükleme çizgisi
                          child: CircularProgressIndicator(strokeWidth: 2),
                        // Center kapanışı
                        ),
                      // Container kapanışı
                      ),
                      // Resim linki bozuksa veya internet yoksa gösterilecek yedek kutu
                      errorWidget: (context, url, error) => Container(
                        // Gri arka plan
                        color: isDark ? Colors.grey[800] : Colors.grey[200],
                        // Restoran çatal-bıçak ikonu
                        child: const Icon(
                          // Restoran ikonu
                          Icons.restaurant,
                          // 40 piksel boyut
                          size: 40,
                          // Yeşil ana tema rengi
                          color: AppColors.primary,
                        // Icon kapanışı
                        ),
                      // Container kapanışı
                      ),
                    // CachedNetworkImage kapanışı
                    ),
                  // AspectRatio kapanışı
                  ),
                // Hero kapanışı
                ),

                // Sol üst köşedeki Kalori Rozeti
                Positioned(
                  // Üstten 12 piksel
                  top: 12,
                  // Soldan 12 piksel
                  left: 12,
                  // Yarı şeffaf siyah kutucuk
                  child: Container(
                    // Rozet içi kenar boşlukları
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    // Rozetin yuvarlak ve gölgeli dekorasyonu
                    decoration: BoxDecoration(
                      // Yarı saydam siyah arka plan
                      color: Colors.black.withValues(alpha: 0.65),
                      // 20 piksel yuvarlak köşe
                      borderRadius: BorderRadius.circular(20),
                      // Hafif gölge efekti
                      boxShadow: [
                        // Gölge tanımı
                        BoxShadow(
                          // Hafif siyah gölge
                          color: Colors.black.withValues(alpha: 0.2),
                          // 4 piksel bulanıklık
                          blurRadius: 4,
                        // BoxShadow kapanışı
                        ),
                      // boxShadow listesi kapanışı
                      ],
                    // BoxDecoration kapanışı
                    ),
                    // Ateş ikonu ve kalori metnini yan yana dizen satır
                    child: Row(
                      // Satırın içeriği kadar yer kaplamasını sağlıyoruz
                      mainAxisSize: MainAxisSize.min,
                      // Elemanlar listesi
                      children: [
                        // Turuncu alev ikonu
                        const Icon(
                          // Alev simgesi
                          Icons.local_fire_department_rounded,
                          // 16 piksel boyut
                          size: 16,
                          // Turuncu vurgu rengi
                          color: Colors.orangeAccent,
                        // Icon kapanışı
                        ),
                        // İkon ile metin arasına 4 piksel boşluk
                        const SizedBox(width: 4),
                        // Kalori metni
                        Text(
                          // Kalori değeri ve birimi
                          '${recipe.calories} kcal',
                          // Beyaz ve kalın yazı stili
                          style: const TextStyle(
                            // Beyaz yazı rengi
                            color: Colors.white,
                            // 12 punto boyut
                            fontSize: 12,
                            // Kalın font
                            fontWeight: FontWeight.bold,
                          // TextStyle kapanışı
                          ),
                        // Text kapanışı
                        ),
                      // Row çocukları kapanışı
                      ],
                    // Row kapanışı
                    ),
                  // Container kapanışı
                  ),
                // Positioned kapanışı
                ),

                // Sol alt köşedeki Kategori Rozeti (Düşük Kalorili, Bütçe Dostu vb.)
                Positioned(
                  // Alttan 12 piksel
                  bottom: 12,
                  // Soldan 12 piksel
                  left: 12,
                  // Kategori rozeti kutucuğu
                  child: Container(
                    // İç boşluk
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    // Yeşil ve yuvarlak dekorasyon
                    decoration: BoxDecoration(
                      // Yarı saydam adaçayı yeşili
                      color: AppColors.primary.withValues(alpha: 0.9),
                      // 14 piksel yuvarlatma
                      borderRadius: BorderRadius.circular(14),
                      // Hafif gölge
                      boxShadow: [
                        // Gölge tanımı
                        BoxShadow(
                          // Siyah gölge
                          color: Colors.black.withValues(alpha: 0.2),
                          // 4 piksel bulanıklık
                          blurRadius: 4,
                        // BoxShadow kapanışı
                        ),
                      // boxShadow listesi kapanışı
                      ],
                    // BoxDecoration kapanışı
                    ),
                    // Kategori adı metni
                    child: Text(
                      // Kategori metni
                      recipe.category,
                      // Beyaz ve kalın yazı stili
                      style: const TextStyle(
                        // Beyaz renk
                        color: Colors.white,
                        // 11 punto boyut
                        fontSize: 11,
                        // Kalın font
                        fontWeight: FontWeight.bold,
                      // TextStyle kapanışı
                      ),
                    // Text kapanışı
                    ),
                  // Container kapanışı
                  ),
                // Positioned kapanışı
                ),

                // Sağ üst köşedeki Favori (Kalp) Butonu
                Positioned(
                  // Üstten 12 piksel
                  top: 12,
                  // Sağdan 12 piksel
                  right: 12,
                  // Tıklanabilir şeffaf malzeme
                  child: Material(
                    // Şeffaf arka plan
                    color: Colors.transparent,
                    // Tıklama dalgalanması
                    child: InkWell(
                      // Favori tıklama olayını bağlıyoruz
                      onTap: onFavoriteTap,
                      // Dairesel tıklama alanı
                      borderRadius: BorderRadius.circular(20),
                      // Yuvarlak koyu arka plan kutusu
                      child: Container(
                        // 8 piksel iç boşluk
                        padding: const EdgeInsets.all(8),
                        // Yuvarlak daire kutu dekorasyonu
                        decoration: BoxDecoration(
                          // Yarı saydam siyah arka plan
                          color: Colors.black.withValues(alpha: 0.45),
                          // Daire şekli
                          shape: BoxShape.circle,
                        // BoxDecoration kapanışı
                        ),
                        // Kalp ikonu
                        child: Icon(
                          // Favoriyse dolu kalp, değilse boş kalp
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          // 20 piksel boyut
                          size: 20,
                          // Favoriyse kırmızı, değilse beyaz renk
                          color: isFavorite ? Colors.redAccent : Colors.white,
                        // Icon kapanışı
                        ),
                      // Container kapanışı
                      ),
                    // InkWell kapanışı
                    ),
                  // Material kapanışı
                  ),
                // Positioned kapanışı
                ),
              // Stack çocukları kapanışı
              ],
            // Stack kapanışı
            ),

            // Kartın altındaki yemek bilgileri ve malzeme özeti alanı
            Padding(
              // Her yönden 16 piksel boşluk
              padding: const EdgeInsets.all(16),
              // Bilgileri dikeyde dizen Column
              child: Column(
                // Elemanları sola yaslıyoruz
                crossAxisAlignment: CrossAxisAlignment.start,
                // Sütun elemanları listesi
                children: [
                  // Yemeğin adı / başlığı
                  Text(
                    // Başlık içeriği
                    recipe.name,
                    // En fazla 1 satır
                    maxLines: 1,
                    // Taşarsa sonuna üç nokta koyuyoruz
                    overflow: TextOverflow.ellipsis,
                    // Başlık stili
                    style: const TextStyle(
                      // 18 punto büyük boyut
                      fontSize: 18,
                      // Kalın font
                      fontWeight: FontWeight.bold,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                  // 6 piksel dikey boşluk
                  const SizedBox(height: 6),

                  // Yemeğin kısa açıklaması
                  Text(
                    // Açıklama metni
                    recipe.description,
                    // En fazla 2 satır
                    maxLines: 2,
                    // Taşarsa üç nokta koyuyoruz
                    overflow: TextOverflow.ellipsis,
                    // Açıklama stili
                    style: TextStyle(
                      // 13 punto boyut
                      fontSize: 13,
                      // Temaya göre ikincil metin rengi
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      // Satır yüksekliği
                      height: 1.3,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                  // 12 piksel dikey boşluk
                  const SizedBox(height: 12),

                  // Malzemelerin ilk 3 tanesini gösteren hap (chip) özeti
                  Wrap(
                    // Yatay boşluk 6 piksel
                    spacing: 6,
                    // Alt satıra geçerse dikey boşluk 4 piksel
                    runSpacing: 4,
                    // İlk 3 malzemeyi dönüştürüyoruz
                    children: recipe.ingredients.take(3).map((item) {
                      // Her bir malzeme kutucuğu
                      return Container(
                        // Kutu içi kenar boşlukları
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        // Hafif yeşil arka planlı dekorasyon
                        decoration: BoxDecoration(
                          // Yüzde 10 şeffaflıkta yeşil renk
                          color: AppColors.primary.withValues(alpha: 0.1),
                          // 8 piksel köşe yuvarlatma
                          borderRadius: BorderRadius.circular(8),
                        // BoxDecoration kapanışı
                        ),
                        // Malzeme adı metni
                        child: Text(
                          // Malzeme adı
                          item,
                          // Yeşil ve kibar yazı stili
                          style: const TextStyle(
                            // 11 punto boyut
                            fontSize: 11,
                            // Orta kalınlıkta font
                            fontWeight: FontWeight.w500,
                            // Yeşil yazı rengi
                            color: AppColors.primary,
                          // TextStyle kapanışı
                          ),
                        // Text kapanışı
                        ),
                      // Container kapanışı
                      );
                    // map ve toList kapanışı
                    }).toList()
                      // 3'ten fazla malzeme varsa '+2', '+3' gibi fazlalık kutusu ekliyoruz
                      ..addAll(
                        recipe.ingredients.length > 3
                            ? [
                                // Kalan malzeme sayısını belirten kutu
                                Container(
                                  // Kenar boşlukları
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  // Gri dolgulu kutu
                                  decoration: BoxDecoration(
                                    // Hafif gri arka plan
                                    color: Colors.grey.withValues(alpha: 0.15),
                                    // 8 piksel yuvarlatma
                                    borderRadius: BorderRadius.circular(8),
                                  // BoxDecoration kapanışı
                                  ),
                                  // Kalan adet metni (+X)
                                  child: Text(
                                    // Kalan adet formülü
                                    '+${recipe.ingredients.length - 3}',
                                    // Gri yazı stili
                                    style: const TextStyle(
                                      // 11 punto boyut
                                      fontSize: 11,
                                      // Orta kalın font
                                      fontWeight: FontWeight.w500,
                                      // Gri yazı rengi
                                      color: Colors.grey,
                                    // TextStyle kapanışı
                                    ),
                                  // Text kapanışı
                                  ),
                                // Container kapanışı
                                )
                              ]
                            : [],
                      ),
                  // Wrap kapanışı
                  ),
                // Column çocukları kapanışı
                ],
              // Column kapanışı
              ),
            // Padding kapanışı
            ),
          // Column çocukları kapanışı
          ],
        // Column kapanışı
        ),
      // InkWell kapanışı
      ),
    // Card kapanışı
    );
  // build metodu kapanış parantezi
  }
// RecipeCard sınıfının kapanış parantezi
}
