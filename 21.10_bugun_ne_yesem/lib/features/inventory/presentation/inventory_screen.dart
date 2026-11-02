// Flutter Material arayüz bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Riverpod reaktif durum yönetimi paketini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Veritabanı ve envanter akışı sağlayıcılarını içe aktarıyoruz
import '../../../core/providers/database_provider.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';
// Malzemelere göre yemek üreten Masterchef ekranını içe aktarıyoruz
import 'masterchef_screen.dart';

// Kullanıcının evdeki buzdolabı malzemelerini yönettiği ve Masterchef modunu başlattığı ekran bileşeni
class InventoryScreen extends ConsumerStatefulWidget {
  // InventoryScreen sınıfının değişmez kurucu metodu
  const InventoryScreen({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (State) yöneticisini bağlayan metot
  @override
  // ConsumerState nesnesi döndürüyoruz
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
// InventoryScreen sınıfının kapanış parantezi
}

// Malzeme ekleme/silme ve metin kutusu kontrolünü sağlayan State sınıfımız
class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  // Yeni malzeme metin giriş kutusu kontrolcüsü
  final _ingredientController = TextEditingController();

  // Kontrolcüyü bellekten temizleyen dispose yaşam döngüsü metodu
  @override
  // dispose gövdesi
  void dispose() {
    // Malzeme kontrolcüsünü bellekten siliyoruz
    _ingredientController.dispose();
    // Üst sınıfın dispose fonksiyonunu çağırıyoruz
    super.dispose();
  // dispose metodunun kapanış parantezi
  }

  // Listeye yeni bir gıda malzemesi ekleyen fonksiyonumuz
  Future<void> _addIngredient(List<String> currentIngredients) async {
    // Metin kutusundaki yazıyı alıp boşluklarını temizliyoruz
    final text = _ingredientController.text.trim();
    // Boşsa işlem yapmıyoruz
    if (text.isEmpty) return;

    // Aynı malzeme zaten listede var mı kontrolü yapıyoruz
    if (currentIngredients.any((item) => item.toLowerCase() == text.toLowerCase())) {
      // Zaten varsa kullanıcıyı SnackBar ile uyarıyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar bileşeni
        const SnackBar(content: Text('Bu malzeme zaten dolabınızda ekli!')),
      // showSnackBar kapanışı
      );
      // Fonksiyondan çıkıyoruz
      return;
    // if kontrolü kapanışı
    }

    // Veritabanı servisini okuyoruz
    final db = ref.read(databaseServiceProvider);
    // Yeni malzemeyi veritabanına ve yerel listeye kaydediyoruz
    await db.addInventoryIngredient('default_user', text);
    // Metin giriş kutusunu temizliyoruz
    _ingredientController.clear();
  // _addIngredient metodunun kapanış parantezi
  }

  // Buzdolabından bir malzemeyi silen fonksiyonumuz
  Future<void> _removeIngredient(String item) async {
    // Veritabanı servisini okuyoruz
    final db = ref.read(databaseServiceProvider);
    // Malzemeyi siliyoruz
    await db.removeInventoryIngredient('default_user', item);
    // Ekran hala canlıysa kullanıcıya silindi bildirimi gösteriyoruz
    if (mounted) {
      // Varsa önceki bildirimi gizliyoruz
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      // Yeni yüzen SnackBar gösteriyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar bileşeni
        SnackBar(
          // Silindi mesajı
          content: Text('$item dolabınızdan çıkarıldı.'),
          // 2 saniye kalsın
          duration: const Duration(seconds: 2),
          // Yüzen (floating) mod
          behavior: SnackBarBehavior.floating,
          // 10 piksel yuvarlak köşeler
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        // SnackBar kapanışı
        ),
      // showSnackBar kapanışı
      );
    // if mounted kapanışı
    }
  // _removeIngredient metodunun kapanış parantezi
  }

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Kullanıcının dolaptaki malzemelerini Riverpod üzerinden canlı dinliyoruz
    final inventoryAsync = ref.watch(userInventoryStreamProvider('default_user'));

    // Sayfa iskeleti
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlık metni
        title: const Text('Evdeki Malzemelerim'),
      // AppBar kapanışı
      ),
      // Ekran çentiğinin altına taşmayı önleyen SafeArea
      body: SafeArea(
        // Malzeme listesi durumunu yöneten when bloğu
        child: inventoryAsync.when(
          // Malzemeler başarıyla geldiyse arayüzü çiziyoruz
          data: (ingredients) {
            // Kenar boşlukları
            return Padding(
              // Yatayda 20, dikeyde 8 piksel boşluk
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              // Elemanları dikeyde dizen Column
              child: Column(
                // Sola yaslama
                crossAxisAlignment: CrossAxisAlignment.start,
                // Sütun elemanları listesi
                children: [
                  // Masterchef Banner Tanıtım Kartı
                  Container(
                    // Genişliği tam yayıyoruz
                    width: double.infinity,
                    // 18 piksel iç boşluk
                    padding: const EdgeInsets.all(18),
                    // Koyu yeşil gradyan dekorasyonu
                    decoration: BoxDecoration(
                      // Doğrusal renk geçişi
                      gradient: const LinearGradient(
                        // Koyu yeşil tonları
                        colors: [Color(0xFF4A7C59), Color(0xFF2E5339)],
                        // Sol üstten başlama
                        begin: Alignment.topLeft,
                        // Sağ altta bitiş
                        end: Alignment.bottomRight,
                      // LinearGradient kapanışı
                      ),
                      // 22 piksel yuvarlatma
                      borderRadius: BorderRadius.circular(22),
                      // Yeşil gölge
                      boxShadow: [
                        // Gölge tanımı
                        BoxShadow(
                          // Yüzde 30 şeffaf yeşil gölge
                          color: AppColors.primary.withValues(alpha: 0.3),
                          // 12 piksel bulanıklık
                          blurRadius: 12,
                          // 6 piksel aşağı kayma
                          offset: const Offset(0, 6),
                        // BoxShadow kapanışı
                        ),
                      // boxShadow listesi kapanışı
                      ],
                    // BoxDecoration kapanışı
                    ),
                    // İkon, metin ve butonu dizen satır
                    child: Row(
                      // Satır elemanları listesi
                      children: [
                        // Sol sarı parıltı ikonu kutusu
                        Container(
                          // 12 piksel iç boşluk
                          padding: const EdgeInsets.all(12),
                          // Yuvarlak dekorasyon
                          decoration: BoxDecoration(
                            // Yarı saydam beyaz arka plan
                            color: Colors.white.withValues(alpha: 0.2),
                            // Daire
                            shape: BoxShape.circle,
                          // BoxDecoration kapanışı
                          ),
                          // Sarı yıldız ikonu
                          child: const Icon(
                            // Yıldız simgesi
                            Icons.auto_awesome_rounded,
                            // Sarı vurgu rengi
                            color: Colors.amberAccent,
                            // 28 piksel boyut
                            size: 28,
                          // Icon kapanışı
                          ),
                        // Container kapanışı
                        ),
                        // 16 piksel yatay boşluk
                        const SizedBox(width: 16),

                        // Başlık ve açıklama sütunu
                        Expanded(
                          // Sütun bileşeni
                          child: Column(
                            // Sola yaslama
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Elemanlar
                            children: [
                              // Kart başlığı
                              const Text(
                                // 'Masterchef Modu' metni
                                'Masterchef Modu',
                                // Beyaz ve kalın stil
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              // Text kapanışı
                              ),
                              // 4 piksel boşluk
                              const SizedBox(height: 4),
                              // Kart açıklaması
                              Text(
                                // Açıklama metni
                                'Dolabındaki malzemelerle sana özel yemek üret!',
                                // Stil
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              // Text kapanışı
                              ),
                            // Column çocukları kapanışı
                            ],
                          // Column kapanışı
                          ),
                        // Expanded kapanışı
                        ),

                        // Masterchef Başlat Butonu
                        ElevatedButton(
                          // Buton stili
                          style: ElevatedButton.styleFrom(
                            // Beyaz arka plan
                            backgroundColor: Colors.white,
                            // Koyu yeşil yazı rengi
                            foregroundColor: AppColors.primaryDark,
                            // 14 piksel yuvarlatma
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            // Buton iç boşluğu
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          // ElevatedButton.styleFrom kapanışı
                          ),
                          // Butona tıklandığında Masterchef oluşturma ekranına geçiyoruz
                          onPressed: () {
                            // Masterchef ekranına geçiş yapıyoruz
                            Navigator.of(context).push(
                              // Sayfa rotası
                              MaterialPageRoute(
                                // Ekran bileşeni (mevcut malzemeleri aktarıyoruz)
                                builder: (_) => MasterchefScreen(
                                  availableIngredients: ingredients,
                                ),
                              // MaterialPageRoute kapanışı
                              ),
                            // push kapanışı
                            );
                          // onPressed kapanışı
                          },
                          // Buton metni
                          child: const Text(
                            // 'Başlat' etiketi
                            'Başlat',
                            // Kalın font
                            style: TextStyle(fontWeight: FontWeight.bold),
                          // Text kapanışı
                          ),
                        // ElevatedButton kapanışı
                        ),
                      // Row çocukları kapanışı
                      ],
                    // Row kapanışı
                    ),
                  // Container kapanışı
                  ),
                  // 24 piksel dikey boşluk
                  const SizedBox(height: 24),

                  // Yeni Malzeme Ekleme Metin Kutusu ve Butonu Satırı
                  Row(
                    // Satır elemanları listesi
                    children: [
                      // Metin giriş kutusu alanı
                      Expanded(
                        // TextField bileşeni
                        child: TextField(
                          // Kontrolcü
                          controller: _ingredientController,
                          // Dekorasyon
                          decoration: InputDecoration(
                            // İpucu metni
                            hintText: 'Yeni malzeme yaz (Örn: Süt, Un)',
                            // İpucu stili
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white30 : Colors.black26,
                            ),
                            // Sol mutfak ikonu
                            prefixIcon: const Icon(Icons.kitchen_rounded, color: AppColors.primary),
                            // Dolgulu mod
                            filled: true,
                            // Koyu veya beyaz arka plan
                            fillColor: isDark ? AppColors.cardDark : Colors.white,
                            // İç boşluk
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            // Temel kenarlık
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              ),
                            ),
                            // Etkin kenarlık
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(
                                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                              ),
                            ),
                          // InputDecoration kapanışı
                          ),
                          // Klavyede 'Bitti/Gönder' basıldığında ekliyoruz
                          onSubmitted: (_) => _addIngredient(ingredients),
                        // TextField kapanışı
                        ),
                      // Expanded kapanışı
                      ),
                      // 10 piksel yatay boşluk
                      const SizedBox(width: 10),

                      // Ekle (+) İkon Butonu
                      ElevatedButton(
                        // Buton stili
                        style: ElevatedButton.styleFrom(
                          // Yeşil ana tema rengi
                          backgroundColor: AppColors.primary,
                          // Beyaz ikon rengi
                          foregroundColor: Colors.white,
                          // 16 piksel yuvarlatma
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          // İç boşluk
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        // ElevatedButton.styleFrom kapanışı
                        ),
                        // Tıklandığında malzemeyi ekliyoruz
                        onPressed: () => _addIngredient(ingredients),
                        // Artı (+) ikonu
                        child: const Icon(Icons.add, size: 24),
                      // ElevatedButton kapanışı
                      ),
                    // Row çocukları kapanışı
                    ],
                  // Row kapanışı
                  ),
                  // 20 piksel dikey boşluk
                  const SizedBox(height: 20),

                  // Liste Başlığı ve Malzeme Sayısı
                  Row(
                    // İki yana yaslama
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Satır elemanları listesi
                    children: [
                      // Başlık metni
                      Text(
                        // Toplam adetli başlık
                        'Mevcut Malzemeler (${ingredients.length})',
                        // Stil
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      // Text kapanışı
                      ),
                    // Row çocukları kapanışı
                    ],
                  // Row kapanışı
                  ),
                  // 8 piksel dikey boşluk
                  const SizedBox(height: 8),

                  // Malzeme Listesi Gösterimi Alanı
                  Expanded(
                    // Malzeme yoksa boş durum uyarısı gösteriyoruz
                    child: ingredients.isEmpty
                        // Ortalanmış boş ekran
                        ? Center(
                            // İkon ve metin sütunu
                            child: Column(
                              // Ortaya hizalama
                              mainAxisAlignment: MainAxisAlignment.center,
                              // Elemanlar
                              children: [
                                // Mutfak buzdolabı ikonu
                                Icon(
                                  Icons.kitchen_outlined,
                                  size: 60,
                                  color: isDark ? Colors.white24 : Colors.black26,
                                ),
                                // 12 piksel boşluk
                                const SizedBox(height: 12),
                                // Uyarı metni
                                Text(
                                  'Dolabınızda henüz malzeme bulunmuyor.',
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ),
                                ),
                              // Column çocukları kapanışı
                              ],
                            // Column kapanışı
                            ),
                          // Center kapanışı
                          )
                        // Malzemeler varsa liste olarak diziyoruz
                        : ListView.builder(
                            // Toplam malzeme adedi
                            itemCount: ingredients.length,
                            // Eleman yapıcı
                            itemBuilder: (context, index) {
                              // Sıradaki malzeme adı
                              final item = ingredients[index];
                              // Kart bileşeni
                              return Card(
                                // Alttan 8 piksel boşluk
                                margin: const EdgeInsets.only(bottom: 8),
                                // Temaya göre kart rengi
                                color: isDark ? AppColors.cardDark : Colors.white,
                                // 14 piksel yuvarlatma
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  side: BorderSide(
                                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                  ),
                                ),
                                // Malzeme liste satırı
                                child: ListTile(
                                  // Sol yaprak ikonu
                                  leading: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 18),
                                  ),
                                  // Malzeme adı
                                  title: Text(
                                    item,
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                  ),
                                  // Sağdaki kırmızı silme çöp kutusu butonu
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                    // Tıklandığında malzemeyi siliyoruz
                                    onPressed: () => _removeIngredient(item),
                                  ),
                                // ListTile kapanışı
                                ),
                              // Card kapanışı
                              );
                            // itemBuilder kapanışı
                            },
                          // ListView.builder kapanışı
                          ),
                  // Expanded kapanışı
                  ),
                // Column çocukları kapanışı
                ],
              // Column kapanışı
              ),
            // Padding kapanışı
            );
          // data kapanışı
          },
          // Yükleniyor durumu
          loading: () => const Center(child: CircularProgressIndicator()),
          // Hata durumu
          error: (err, stack) => Center(child: Text('Hata: $err')),
        // inventoryAsync.when kapanışı
        ),
      // SafeArea kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _InventoryScreenState sınıfının kapanış parantezi
}
