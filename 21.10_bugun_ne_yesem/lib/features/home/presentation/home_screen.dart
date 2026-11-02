// Flutter temel Material bileşenler kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Riverpod reaktif durum yönetimi paketini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama geneli sabitleri içe aktarıyoruz
import '../../../core/constants/app_constants.dart';
// Yemek tarifi veri modelini içe aktarıyoruz
import '../../../core/models/recipe_model.dart';
// Veritabanı ve canlı yemek akışı sağlayıcılarını içe aktarıyoruz
import '../../../core/providers/database_provider.dart';
// Tema sağlayıcısını içe aktarıyoruz
import '../../../core/providers/theme_provider.dart';
// Tema renklerimizi içe aktarıyoruz
import '../../../core/theme/app_colors.dart';
// Ortak buton bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/custom_button.dart';
// Yemek kartı bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/recipe_card.dart';
// Yemek detay ekranını içe aktarıyoruz
import '../../recipe_detail/presentation/recipe_detail_screen.dart';
// Uygulama ayarları ekranını içe aktarıyoruz
import 'app_settings_screen.dart';

// Ana vitrin ekranı: Gümüş servis kubbesi (Cloche) ve tarif listesini sunan durumlu widget
class HomeScreen extends ConsumerStatefulWidget {
  // HomeScreen sınıfının değişmez kurucu metodu
  const HomeScreen({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum yöneticisini bağlayan metot
  @override
  // ConsumerState nesnesi döndürüyoruz
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
// HomeScreen sınıfının kapanış parantezi
}

// Gümüş kubbe animasyonlarını, rastgele yemek seçimini ve kategori filtrelerini yöneten State sınıfımız
class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  // Kubbe animasyonunu zamanlayan kontrolcü
  late AnimationController _clocheController;
  // Kubbenin sağa-sola titreme (wobble) animasyonu
  late Animation<double> _shakeAnimation;
  // Kubbenin yukarı kalkma (lift) animasyonu
  late Animation<double> _liftAnimation;

  // Seçim işleminin o an sürüp sürmediğini belirten durum bayrağı
  bool _isChoosing = false;
  // Kubbenin altından çıkan şanslı yemek tarifi modeli
  RecipeModel? _revealedRecipe;
  // Kullanıcının seçtiği kategori filtresi (varsayılan: Tümü)
  String _selectedCategory = 'Tümü';

  // Widget ilk yüklendiğinde animasyonları ve dinleyicileri kuran initState metodu
  @override
  // initState gövdesi
  void initState() {
    // Üst sınıfın initState metodunu çağırıyoruz
    super.initState();
    // 2200 milisaniye (2.2 saniye) sürecek animasyon kontrolcüsünü başlatıyoruz
    _clocheController = AnimationController(
      // TickerProvider olarak bu State sınıfını bağlıyoruz
      vsync: this,
      // Animasyon süresi 2.2 saniye
      duration: const Duration(milliseconds: 2200),
    // AnimationController kapanışı
    );

    // Titreme (Shake / Wobble) Animasyonu: Sürenin ilk %0 ile %60'ı arasında çalışır
    _shakeAnimation = TweenSequence<double>([
      // Sola hafif yatış
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.15), weight: 15),
      // Sağa yatış
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.15), weight: 20),
      // Tekrar sola yatış
      TweenSequenceItem(tween: Tween(begin: 0.15, end: -0.12), weight: 20),
      // Hafif sağa yatış
      TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.10), weight: 20),
      // Merkeze dönüş
      TweenSequenceItem(tween: Tween(begin: 0.10, end: 0.0), weight: 25),
    // animate çağrısı
    ]).animate(
      // Eğri animasyonunu bağlıyoruz
      CurvedAnimation(
        // Üst kontrolcü
        parent: _clocheController,
        // İlk yüzde 60'lık zaman dilimi
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      // CurvedAnimation kapanışı
      ),
    // animate kapanışı
    );

    // Kubbenin Yukarı Kalkması (Lift / Open): Sürenin %60 ile %100'ü arasında yukarı -70 piksel kayar
    _liftAnimation = Tween<double>(begin: 0.0, end: -70.0).animate(
      // Eğri animasyonunu bağlıyoruz
      CurvedAnimation(
        // Üst kontrolcü
        parent: _clocheController,
        // Son yüzde 40'lık zaman dilimi (hafif zıplama efektiyle)
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
      // CurvedAnimation kapanışı
      ),
    // animate kapanışı
    );

    // Animasyon tamamlandığında sürpriz yemeği modal pencerede açan durum dinleyicisi
    _clocheController.addStatusListener((status) {
      // Animasyon tamamen bittiyse
      if (status == AnimationStatus.completed) {
        // Çıkan yemek boş değilse modal pencereyi açıyoruz
        if (_revealedRecipe != null) {
          // Modal pencereyi ekrana getiren metot
          _showRevealedRecipeDialog(_revealedRecipe!);
        // if kontrolü kapanışı
        }
      // if completed kapanışı
      }
    // addStatusListener kapanışı
    });
  // initState metodunun kapanış parantezi
  }

  // Bellek sızıntısını önlemek için animasyon kontrolcüsünü serbest bırakan dispose metodu
  @override
  // dispose gövdesi
  void dispose() {
    // Animasyon kontrolcüsünü bellekten siliyoruz
    _clocheController.dispose();
    // Üst sınıfın dispose metodunu çağırıyoruz
    super.dispose();
  // dispose metodunun kapanış parantezi
  }

  // Gümüş Kubbe ve Rastgele Yemek Seçimi Algoritması (Kendimi Şanslı Hissediyorum)
  Future<void> _handleLuckySelection() async {
    // Zaten bir seçim devam ediyorsa tekrar tıklanmasını önlüyoruz
    if (_isChoosing) return;

    // Durumu güncelleyip yükleme durumuna geçiyoruz
    setState(() {
      // Seçim yapılıyor bayrağını açıyoruz
      _isChoosing = true;
      // Eski seçilen yemeği sıfırlıyoruz
      _revealedRecipe = null;
    // setState kapanışı
    });

    // Animasyonu sıfırlayıp baştan başlatıyoruz
    _clocheController.reset();
    // Animasyonu ileri doğru oynatıyoruz
    _clocheController.forward();

    // Veritabanından rastgele yemek çekme try bloğu
    try {
      // Veritabanı servisini okuyoruz
      final db = ref.read(databaseServiceProvider);
      // Gümüş Kubbe algoritmasıyla rastgele bir yemek seçiyoruz
      final randomRecipe = await db.getRandomRecipe();
      // Ekran hala canlı değilse işlemi kesiyoruz
      if (!mounted) return;

      // Seçilen yemeği değişkene atıyoruz
      setState(() {
        // Yeni şanslı yemek
        _revealedRecipe = randomRecipe;
      // setState kapanışı
      });
    // Hata durumunu yakalıyoruz
    } catch (e) {
      // Ekran kapandıysa çıkıyoruz
      if (!mounted) return;
      // Seçim durumunu kapatıyoruz
      setState(() => _isChoosing = false);
    // try-catch kapanışı
    }
  // _handleLuckySelection metodunun kapanış parantezi
  }

  // Kubbenin altından çıkan şanslı yemeği alt modal pencere (BottomSheet) olarak gösteren fonksiyon
  void _showRevealedRecipeDialog(RecipeModel recipe) {
    // Alt açılır modal pencereyi tetikliyoruz
    showModalBottomSheet(
      // Geçerli bağlam
      context: context,
      // Tam içeriğe göre boyutlanması için scroll kontrolünü açıyoruz
      isScrollControlled: true,
      // Arka planı şeffaf yapıyoruz
      backgroundColor: Colors.transparent,
      // Modal gövdesini inşa eden builder fonksiyonu
      builder: (ctx) {
        // Temanın koyu modda olup olmadığını kontrol ediyoruz
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        // Modal içerik kutusu
        return Container(
          // Her yönden 24 piksel iç boşluk
          padding: const EdgeInsets.all(24),
          // Üst köşeleri yuvarlak kart dekorasyonu
          decoration: BoxDecoration(
            // Koyu veya açık yüzey rengi
            color: isDark ? AppColors.surfaceDark : Colors.white,
            // Üst köşeleri 28 piksel yuvarlatıyoruz
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            // Gölge efekti
            boxShadow: [
              // Siyah gölge
              BoxShadow(
                // Şeffaf siyah gölge
                color: Colors.black.withValues(alpha: 0.3),
                // 20 piksel bulanıklık
                blurRadius: 20,
              // BoxShadow kapanışı
              ),
            // boxShadow listesi kapanışı
            ],
          // BoxDecoration kapanışı
          ),
          // İçerikleri dikeyde dizen Column
          child: Column(
            // Boyutunu içeriği kadar sınırlandırıyoruz
            mainAxisSize: MainAxisSize.min,
            // Elemanlar listesi
            children: [
              // Modal pencerenin tepesindeki tutamaç çizgisi
              Container(
                // Genişlik 48 piksel
                width: 48,
                // Kalınlık 5 piksel
                height: 5,
                // Gri yuvarlak çizgi dekorasyonu
                decoration: BoxDecoration(
                  // Yarı saydam gri renk
                  color: Colors.grey.withValues(alpha: 0.4),
                  // 10 piksel köşe yuvarlatma
                  borderRadius: BorderRadius.circular(10),
                // BoxDecoration kapanışı
                ),
              // Container kapanışı
              ),
              // 16 piksel dikey boşluk
              const SizedBox(height: 16),

              // Başlık ve tebrik satırı
              const Row(
                // Ortaya hizalama
                mainAxisAlignment: MainAxisAlignment.center,
                // Elemanlar listesi
                children: [
                  // Yıldız parıltısı ikonu
                  Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
                  // 8 piksel yatay boşluk
                  SizedBox(width: 8),
                  // Başlık metni
                  Text(
                    // Başlık içeriği
                    'Şanslı Menünüz Belli Oldu!',
                    // Başlık stili
                    style: TextStyle(
                      // 20 punto boyut
                      fontSize: 20,
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
              // 16 piksel dikey boşluk
              const SizedBox(height: 16),

              // Seçilen yemeğin detay kartı
              RecipeCard(
                // Şanslı tarif modeli
                recipe: recipe,
                // Favori durumu
                isFavorite: false,
                // Karta tıklandığında detay sayfasına geçiş
                onTap: () {
                  // Modal pencereyi kapatıyoruz
                  Navigator.of(ctx).pop();
                  // Tarif detay ekranına geçiyoruz
                  Navigator.of(context).push(
                    // Sayfa rotası
                    MaterialPageRoute(
                      // Tarif detay sayfası bileşeni
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    // MaterialPageRoute kapanışı
                    ),
                  // push kapanışı
                  );
                // onTap kapanışı
                },
              // RecipeCard kapanışı
              ),
              // 12 piksel dikey boşluk
              const SizedBox(height: 12),

              // Tarifi İncele Aksiyon Butonu
              CustomButton(
                // Buton metni
                text: 'Tarifi Hemen İncele',
                // Menü ikonu
                icon: Icons.restaurant_menu_rounded,
                // Tıklandığında detay ekranına geçiyoruz
                onPressed: () {
                  // Modal pencereyi kapatıyoruz
                  Navigator.of(ctx).pop();
                  // Detay sayfasına geçiş yapıyoruz
                  Navigator.of(context).push(
                    // Sayfa rotası
                    MaterialPageRoute(
                      // Tarif detay sayfası
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    // MaterialPageRoute kapanışı
                    ),
                  // push kapanışı
                  );
                // onPressed kapanışı
                },
              // CustomButton kapanışı
              ),
              // 12 piksel dikey boşluk
              const SizedBox(height: 12),
            // Column çocukları kapanışı
            ],
          // Column kapanışı
          ),
        // Container kapanışı
        );
      // builder kapanışı
      },
    // Modal pencere kapandığında çalışan temizleme bloğu
    ).whenComplete(() {
      // Ekran hala açıksa animasyonu ve durumları sıfırlıyoruz
      if (mounted) {
        // Durumu yeniliyoruz
        setState(() {
          // Seçim sürecini kapatıyoruz
          _isChoosing = false;
        // setState kapanışı
        });
        // Kubbe animasyonunu ilk kapalı haline döndürüyoruz
        _clocheController.reset();
      // if mounted kapanışı
      }
    // whenComplete kapanışı
    });
  // _showRevealedRecipeDialog metodunun kapanış parantezi
  }

  // Ekranın görsel ağacını inşa eden build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Canlı hazır yemek listesini Riverpod üzerinden dinliyoruz
    final recipesAsync = ref.watch(recipesStreamProvider);

    // Sayfa iskeleti
    return Scaffold(
      // Üst başlık çubuğu (AppBar)
      appBar: AppBar(
        // Başlık ve logo satırı
        title: Row(
          // Elemanlar listesi
          children: [
            // Logonun yeşil kutucuğu
            Container(
              // 6 piksel iç boşluk
              padding: const EdgeInsets.all(6),
              // Yuvarlatılmış köşe dekorasyonu
              decoration: BoxDecoration(
                // Yüzde 12 şeffaf yeşil arka plan
                color: AppColors.primary.withValues(alpha: 0.12),
                // 10 piksel köşe yuvarlatma
                borderRadius: BorderRadius.circular(10),
              // BoxDecoration kapanışı
              ),
              // Mutfak tencere ikonu
              child: const Icon(
                // Mutfak simgesi
                Icons.soup_kitchen_rounded,
                // Yeşil renk
                color: AppColors.primary,
                // 22 piksel boyut
                size: 22,
              // Icon kapanışı
              ),
            // Container kapanışı
            ),
            // İkon ile başlık arasına 10 piksel boşluk
            const SizedBox(width: 10),
            // Uygulama başlık metni
            const Text(
              // Başlık içeriği
              AppConstants.appName,
              // Kalın ve 18 punto yazı stili
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            // Text kapanışı
            ),
          // Row çocukları kapanışı
          ],
        // Row kapanışı
        ),
        // Sağ üstteki aksiyon butonları
        actions: [
          // 1. Hızlı Tema Değiştirme Butonu (Güneş / Ay ikonu)
          IconButton(
            // Buton ipucu metni
            tooltip: isDark ? 'Açık Temaya Geç' : 'Koyu Temaya Geç',
            // Duruma göre güneş veya ay ikonu
            icon: Icon(
              // Güneş veya ay
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              // Sarı veya yeşil renk
              color: isDark ? Colors.amber : AppColors.primary,
            // Icon kapanışı
            ),
            // Tıklandığında temayı tersine çeviriyoruz
            onPressed: () {
              // themeModeProvider notifier üzerinden temayı değiştiriyoruz
              ref.read(themeModeProvider.notifier).toggleTheme();
            // onPressed kapanışı
            },
          // IconButton kapanışı
          ),
          // 2. Uygulama Ayarları Ekranı Butonu
          IconButton(
            // İpucu metni
            tooltip: 'Uygulama Ayarları',
            // Ayarlar ayar ikonu
            icon: const Icon(
              // Ayar çarkı simgesi
              Icons.tune_rounded,
              // Yeşil renk
              color: AppColors.primary,
            // Icon kapanışı
            ),
            // Tıklandığında ayarlar sayfasına geçiyoruz
            onPressed: () {
              // Ayarlar sayfasına yönlendiriyoruz
              Navigator.of(context).push(
                // Sayfa rotası
                MaterialPageRoute(
                  // Uygulama ayarları ekranı bileşeni
                  builder: (_) => const AppSettingsScreen(),
                // MaterialPageRoute kapanışı
                ),
              // push kapanışı
              );
            // onPressed kapanışı
            },
          // IconButton kapanışı
          ),
          // Sağ kenardan 8 piksel boşluk
          const SizedBox(width: 8),
        // actions listesi kapanışı
        ],
      // AppBar kapanışı
      ),
      // Kaydırılabilir dikey sayfa gövdesi
      body: SingleChildScrollView(
        // Kenar boşlukları
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        // İçerikleri alt alta dizen Column
        child: Column(
          // Elemanları sola hizalıyoruz
          crossAxisAlignment: CrossAxisAlignment.start,
          // Sütun elemanları listesi
          children: [
            // GÜMÜŞ SERVİS KUBBESİ (SILVER CLOCHE) KART ALANI
            Container(
              // Genişliği tam yayıyoruz
              width: double.infinity,
              // 24 piksel iç boşluk
              padding: const EdgeInsets.all(24),
              // Gradyanlı zarif kutu dekorasyonu
              decoration: BoxDecoration(
                // Arka plan renk geçişi (Gradyan)
                gradient: LinearGradient(
                  // Temaya göre renk tonları
                  colors: isDark
                      ? [const Color(0xFF1E2822), const Color(0xFF2E3D33)]
                      : [const Color(0xFFE8F0EA), const Color(0xFFF3F7F4)],
                  // Sol üstten başlama
                  begin: Alignment.topLeft,
                  // Sağ altta bitme
                  end: Alignment.bottomRight,
                // LinearGradient kapanışı
                ),
                // 24 piksel yuvarlatılmış köşeler
                borderRadius: BorderRadius.circular(24),
                // Çerçeve çizgisi
                border: Border.all(
                  // Yüzde 25 şeffaf yeşil kenarlık
                  color: AppColors.primary.withValues(alpha: 0.25),
                  // 1.5 piksel kalınlık
                  width: 1.5,
                // Border.all kapanışı
                ),
                // Gölge efektleri
                boxShadow: [
                  // Yumuşak kart gölgesi
                  BoxShadow(
                    // Yüzde 8 şeffaf yeşil gölge
                    color: AppColors.primary.withValues(alpha: 0.08),
                    // 16 piksel bulanıklık
                    blurRadius: 16,
                    // Dikeyde 8 piksel kayma
                    offset: const Offset(0, 8),
                  // BoxShadow kapanışı
                  ),
                // boxShadow listesi kapanışı
                ],
              // BoxDecoration kapanışı
              ),
              // Kubbe ve butonları dizen Column
              child: Column(
                // Elemanlar listesi
                children: [
                  // Gümüş Kubbe ve Alt Tabak Görsel Etkileşim Alanı
                  SizedBox(
                    // 180 piksel sabit yükseklik
                    height: 180,
                    // Üst üste binen tabak, kubbe ve parıltı Stack'i
                    child: Stack(
                      // Ortaya hizalama
                      alignment: Alignment.center,
                      // Katmanlar listesi
                      children: [
                        // 1. Katman: Alt Sunum Tepsisi / Servis Tabağı
                        Positioned(
                          // Alttan 12 piksel
                          bottom: 12,
                          // Tepsi kutucuğu
                          child: Container(
                            // Genişlik 190 piksel
                            width: 190,
                            // Yükseklik 14 piksel
                            height: 14,
                            // Metalik gümüş gradyan dekorasyonu
                            decoration: BoxDecoration(
                              // Gümüş metal geçişi
                              gradient: const LinearGradient(
                                // Metal renkleri
                                colors: [Color(0xFFCFD8DC), Color(0xFFECEFF1), Color(0xFF90A4AE)],
                              // LinearGradient kapanışı
                              ),
                              // 10 piksel köşe yuvarlatma
                              borderRadius: BorderRadius.circular(10),
                              // Tepsi alt gölgesi
                              boxShadow: [
                                // Gölge tanımı
                                BoxShadow(
                                  // Şeffaf siyah gölge
                                  color: Colors.black.withValues(alpha: 0.2),
                                  // 8 piksel bulanıklık
                                  blurRadius: 8,
                                  // 4 piksel aşağı kayma
                                  offset: const Offset(0, 4),
                                // BoxShadow kapanışı
                                ),
                              // boxShadow listesi kapanışı
                              ],
                            // BoxDecoration kapanışı
                            ),
                          // Container kapanışı
                          ),
                        // Positioned kapanışı
                        ),

                        // 2. Katman: Kubbe Açılırken Ortaya Çıkan Sürpriz Yemek İkonu & Yazısı
                        if (_isChoosing)
                          Positioned(
                            // Alttan 24 piksel
                            bottom: 24,
                            // Opaklık animasyonu
                            child: AnimatedOpacity(
                              // 300 milisaniye geçiş süresi
                              duration: const Duration(milliseconds: 300),
                              // Kubbe yarıdan fazla açıldıysa görünür yapıyoruz
                              opacity: _clocheController.value > 0.5 ? 1.0 : 0.0,
                              // İkon ve metin sütunu
                              child: Column(
                                // Boyutu içeriği kadar
                                mainAxisSize: MainAxisSize.min,
                                // Elemanlar
                                children: [
                                  // Restoran ikonu
                                  const Icon(
                                    // Menü simgesi
                                    Icons.restaurant_menu_rounded,
                                    // 42 piksel boyut
                                    size: 42,
                                    // Yeşil renk
                                    color: AppColors.primary,
                                  // Icon kapanışı
                                  ),
                                  // 2 piksel boşluk
                                  const SizedBox(height: 2),
                                  // Çıkan yemeğin adı
                                  Text(
                                    // Yemek adı veya hazırlık metni
                                    _revealedRecipe?.name ?? 'Lezzet Hazırlanıyor...',
                                    // Stil özellikleri
                                    style: const TextStyle(
                                      // Kalın font
                                      fontWeight: FontWeight.bold,
                                      // 12 punto boyut
                                      fontSize: 12,
                                      // Koyu yeşil renk
                                      color: AppColors.primaryDark,
                                    // TextStyle kapanışı
                                    ),
                                  // Text kapanışı
                                  ),
                                // Column çocukları kapanışı
                                ],
                              // Column kapanışı
                              ),
                            // AnimatedOpacity kapanışı
                            ),
                          // Positioned kapanışı
                          ),

                        // 3. Katman: Gümüş Kubbe (Titreme ve Yukarı Kalkma Animasyonu)
                        AnimatedBuilder(
                          // Animasyon kontrolcüsünü bağlıyoruz
                          animation: _clocheController,
                          // Animasyon değiştikçe yeniden çizen builder fonksiyonu
                          builder: (context, child) {
                            // Yukarı kalkma hareketini uyguluyoruz
                            return Transform.translate(
                              // Dikeyde _liftAnimation değeri kadar yukarı kaydırıyoruz
                              offset: Offset(0, _liftAnimation.value),
                              // Titreme dönme hareketini uyguluyoruz
                              child: Transform.rotate(
                                // Açıyı _shakeAnimation değeri kadar döndürüyoruz
                                angle: _shakeAnimation.value,
                                // Gümüş kubbe metalik küresi
                                child: Container(
                                  // Genişlik 150 piksel
                                  width: 150,
                                  // Yükseklik 130 piksel
                                  height: 130,
                                  // Radyal gümüş metalik parıltı dekorasyonu
                                  decoration: BoxDecoration(
                                    // Merkezden dışa doğru metalik gradyan
                                    gradient: const RadialGradient(
                                      // Parlama, gövde ve derinlik renkleri
                                      colors: [
                                        Color(0xFFFFFFFF), // Parlama
                                        Color(0xFFCFD8DC), // Gümüş gövde
                                        Color(0xFF78909C), // Metalik derinlik
                                      ],
                                      // Parlama merkezinin sol üstte olması
                                      center: Alignment(-0.2, -0.3),
                                      // Yarıçap oranı
                                      radius: 0.85,
                                    // RadialGradient kapanışı
                                    ),
                                    // Dairesel kubbe formu
                                    shape: BoxShape.circle,
                                    // Metal gölgesi
                                    boxShadow: [
                                      // Gölge tanımı
                                      BoxShadow(
                                        // Şeffaf siyah gölge
                                        color: Colors.black.withValues(alpha: 0.25),
                                        // 16 piksel bulanıklık
                                        blurRadius: 16,
                                        // 8 piksel aşağı kayma
                                        offset: const Offset(0, 8),
                                      // BoxShadow kapanışı
                                      ),
                                    // boxShadow listesi kapanışı
                                    ],
                                  // BoxDecoration kapanışı
                                  ),
                                  // Kubbe üzerindeki tutamaç ve sofra ikonu
                                  child: Stack(
                                    // Ortaya hizalama
                                    alignment: Alignment.center,
                                    // Elemanlar
                                    children: [
                                      // Kubbenin tepesindeki metalik tutacak
                                      Positioned(
                                        // Üstten 10 piksel
                                        top: 10,
                                        // Tutacak kutusu
                                        child: Container(
                                          // Genişlik 26 piksel
                                          width: 26,
                                          // Yükseklik 16 piksel
                                          height: 16,
                                          // Tutacak dekorasyonu
                                          decoration: BoxDecoration(
                                            // Açık gümüş renk
                                            color: const Color(0xFFECEFF1),
                                            // 8 piksel yuvarlatma
                                            borderRadius: BorderRadius.circular(8),
                                            // İnce kenarlık
                                            border: Border.all(color: Colors.blueGrey.shade300),
                                          // BoxDecoration kapanışı
                                          ),
                                        // Container kapanışı
                                        ),
                                      // Positioned kapanışı
                                      ),
                                      // Kubbe ortasındaki sofra kapağı ikonu
                                      const Icon(
                                        // Sofra simgesi
                                        Icons.dinner_dining_rounded,
                                        // 52 piksel boyut
                                        size: 52,
                                        // Koyu metal rengi
                                        color: Color(0xFF37474F),
                                      // Icon kapanışı
                                      ),
                                    // Stack çocukları kapanışı
                                    ],
                                  // Stack kapanışı
                                  ),
                                // Container kapanışı
                                ),
                              // Transform.rotate kapanışı
                              ),
                            // Transform.translate kapanışı
                            );
                          // AnimatedBuilder builder kapanışı
                          },
                        // AnimatedBuilder kapanışı
                        ),
                      // Stack çocukları kapanışı
                      ],
                    // Stack kapanışı
                    ),
                  // SizedBox kapanışı
                  ),
                  // 12 piksel dikey boşluk
                  const SizedBox(height: 12),

                  // Soru başlığı metni
                  const Text(
                    // Başlık içeriği
                    'Bugün Ne Yiyeceğine Karar Veremedin mi?',
                    // Metni ortalıyoruz
                    textAlign: TextAlign.center,
                    // Stil özellikleri
                    style: TextStyle(
                      // 18 punto boyut
                      fontSize: 18,
                      // Kalın font
                      fontWeight: FontWeight.bold,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                  // 6 piksel dikey boşluk
                  const SizedBox(height: 6),

                  // Açıklama metni (seçim sürerken dinamik değişir)
                  Text(
                    // Duruma göre açıklama metni
                    _isChoosing
                        ? 'Gümüş kubbe açılıyor, günün lezzeti seçiliyor...'
                        : 'Gümüş servis kubbesini kaldır, günün leziz sürprizini hemen keşfet!',
                    // Metni ortalıyoruz
                    textAlign: TextAlign.center,
                    // Açıklama stili
                    style: TextStyle(
                      // 13 punto boyut
                      fontSize: 13,
                      // Temaya göre ikincil metin rengi
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    // TextStyle kapanışı
                    ),
                  // Text kapanışı
                  ),
                  // 20 piksel dikey boşluk
                  const SizedBox(height: 20),

                  // 'Kendimi Şanslı Hissediyorum' Ana Butonu
                  CustomButton(
                    // Buton metni
                    text: _isChoosing ? 'Kubbe Açılıyor...' : 'Kendimi Şanslı Hissediyorum',
                    // Şans zarları ikonu
                    icon: Icons.casino_rounded,
                    // Yükleme durumu
                    isLoading: _isChoosing,
                    // Yeşil ana renk
                    backgroundColor: AppColors.primary,
                    // Tıklama olayını bağlıyoruz
                    onPressed: _handleLuckySelection,
                  // CustomButton kapanışı
                  ),
                // Column çocukları kapanışı
                ],
              // Column kapanışı
              ),
            // Container kapanışı
            ),
            // 32 piksel dikey boşluk
            const SizedBox(height: 32),

            // Öne Çıkan Tarifler Başlığı ve Tarif Adedi Satırı
            Row(
              // İki uca yaslıyoruz
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // Satır elemanları listesi
              children: [
                // Bölüm başlığı
                const Text(
                  // Başlık metni
                  'Öne Çıkan Tarifler',
                  // Başlık stili
                  style: TextStyle(
                    // 18 punto boyut
                    fontSize: 18,
                    // Kalın font
                    fontWeight: FontWeight.bold,
                  // TextStyle kapanışı
                  ),
                // Text kapanışı
                ),
                // Toplam tarif sayısı etiketi
                Text(
                  // Tarif sayısı metni
                  '15 Tarif',
                  // Stil özellikleri
                  style: TextStyle(
                    // 13 punto boyut
                    fontSize: 13,
                    // Temaya göre renk
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    // Yarı kalın font
                    fontWeight: FontWeight.w600,
                  // TextStyle kapanışı
                  ),
                // Text kapanışı
                ),
              // Row çocukları kapanışı
              ],
            // Row kapanışı
            ),
            // 12 piksel dikey boşluk
            const SizedBox(height: 12),

            // Kategori Filtre Butonları (Yatay Kaydırılabilir)
            SingleChildScrollView(
              // Yatay kaydırma ekseni
              scrollDirection: Axis.horizontal,
              // Butonları yan yana dizen satır
              child: Row(
                // Kategori isimlerini dönüştürüyoruz
                children: [
                  'Tümü',
                  'Masterchef',
                  'Düşük Kalorili',
                  'Bütçe Dostu',
                  'Pratik',
                  'Geleneksel',
                ].map((category) {
                  // Bu kategorinin seçili olup olmadığını kontrol ediyoruz
                  final isSelected = _selectedCategory == category;
                  // Sağa 8 piksel boşluk veriyoruz
                  return Padding(
                    // Sağ kenar boşluğu
                    padding: const EdgeInsets.only(right: 8),
                    // Seçilebilir filtre çipi (FilterChip)
                    child: FilterChip(
                      // Çip etiketi
                      label: Text(category),
                      // Seçili olma durumu
                      selected: isSelected,
                      // Seçiliykenki arka plan rengi
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      // Onay işareti rengi
                      checkmarkColor: AppColors.primary,
                      // Çip metin stili
                      labelStyle: TextStyle(
                        // Seçiliyse yeşil, değilse açık/koyu yazı rengi
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? Colors.white70 : Colors.black87),
                        // Seçiliyse kalın font
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        // 13 punto boyut
                        fontSize: 13,
                      // TextStyle kapanışı
                      ),
                      // Çip köşe ve kenarlık tasarımı
                      shape: RoundedRectangleBorder(
                        // 14 piksel yuvarlatma
                        borderRadius: BorderRadius.circular(14),
                        // Kenar çizgisi
                        side: BorderSide(
                          // Seçiliyse yeşil, değilse gri çerçeve
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
                        // BorderSide kapanışı
                        ),
                      // RoundedRectangleBorder kapanışı
                      ),
                      // Çipe tıklandığında kategoriyi güncelliyoruz
                      onSelected: (selected) {
                        // Durumu güncelliyoruz
                        setState(() {
                          // Yeni seçilen kategori
                          _selectedCategory = category;
                        // setState kapanışı
                        });
                      // onSelected kapanışı
                      },
                    // FilterChip kapanışı
                    ),
                  // Padding kapanışı
                  );
                // map ve toList kapanışı
                }).toList(),
              // Row çocukları kapanışı
              ),
            // SingleChildScrollView kapanışı
            ),
            // 16 piksel dikey boşluk
            const SizedBox(height: 16),

            // Canlı Yemek Listesi Akışını Ekran Durumuna Göre Çizen Bölüm
            recipesAsync.when(
              // 1. Durum: Veriler başarıyla geldiyse
              data: (recipes) {
                // Seçilen kategoriye göre tarifleri filtreliyoruz
                final displayRecipes = recipes.where((r) {
                  // 'Tümü' seçildiyse hepsini gösteriyoruz
                  if (_selectedCategory == 'Tümü') return true;
                  // Kategori isimlerini küçük harfle karşılaştırıyoruz
                  return r.category.toLowerCase() ==
                      _selectedCategory.toLowerCase();
                // where ve toList kapanışı
                }).toList();

                // Eğer o kategoride henüz tarif yoksa bilgilendirme metni gösteriyoruz
                if (displayRecipes.isEmpty) {
                  // 24 piksel boşluklu kutu
                  return Padding(
                    // Boşluk
                    padding: const EdgeInsets.all(24),
                    // Ortalanmış metin
                    child: Center(
                      // Bilgi metni
                      child: Text(
                        // Uyarı içeriği
                        'Bu kategoride henüz tarif bulunmuyor.',
                        // Stil özellikleri
                        style: TextStyle(
                          // Gri metin rengi
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        // TextStyle kapanışı
                        ),
                      // Text kapanışı
                      ),
                    // Center kapanışı
                    ),
                  // Padding kapanışı
                  );
                // if displayRecipes.isEmpty kapanışı
                }

                // Filtrelenmiş tarifleri kartlar halinde alt alta dizen Column
                return Column(
                  // Her tarifi RecipeCard bileşenine çeviriyoruz
                  children: displayRecipes.map((recipe) {
                    // Yemek kartı bileşeni
                    return RecipeCard(
                      // Tarif modeli
                      recipe: recipe,
                      // Favori durumu
                      isFavorite: false,
                      // Karta tıklandığında detay sayfasına geçiyoruz
                      onTap: () {
                        // Detay sayfasına yönlendirme
                        Navigator.of(context).push(
                          // Sayfa rotası
                          MaterialPageRoute(
                            // Tarif detay sayfası bileşeni
                            builder: (_) => RecipeDetailScreen(recipe: recipe),
                          // MaterialPageRoute kapanışı
                          ),
                        // push kapanışı
                        );
                      // onTap kapanışı
                      },
                      // Favori butonuna tıklandığında favoriyi değiştiren asenkron fonksiyon
                      onFavoriteTap: () async {
                        // Veritabanı servisini okuyoruz
                        final db = ref.read(databaseServiceProvider);
                        // Favoriyi tersine çeviriyoruz (toggle)
                        final isNowFav =
                            await db.toggleFavorite('default_user', recipe.id);
                        // Ekran hala açıksa kullanıcıya bildirim basıyoruz
                        if (!context.mounted) return;
                        // SnackBar gösterimi
                        ScaffoldMessenger.of(context).showSnackBar(
                          // SnackBar bileşeni
                          SnackBar(
                            // Eklendi veya çıkarıldı mesajı
                            content: Text(
                              isNowFav
                                  ? '${recipe.name} favorilere eklendi!'
                                  : '${recipe.name} favorilerden çıkarıldı.',
                            ),
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
                  // map ve toList kapanışı
                  }).toList(),
                // Column kapanışı
                );
              // data kapanışı
              },
              // 2. Durum: Veriler sunucudan yüklenirken dönen yükleme göstergesi
              loading: () => const Center(
                // 32 piksel boşluk
                child: Padding(
                  // Boşluk
                  padding: EdgeInsets.all(32),
                  // Yükleme animasyonu
                  child: CircularProgressIndicator(),
                // Padding kapanışı
                ),
              // Center kapanışı
              ),
              // 3. Durum: Veri çekilirken bir hata oluştuysa
              error: (err, stack) => Center(
                // Hata mesajı metni
                child: Text('Tarifler yüklenirken hata: $err'),
              // Center kapanışı
              ),
            // recipesAsync.when kapanışı
            ),
          // Column çocukları kapanışı
          ],
        // Column kapanışı
        ),
      // SingleChildScrollView kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _HomeScreenState sınıfının kapanış parantezi
}
