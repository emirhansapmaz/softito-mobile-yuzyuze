// Flutter materyal tasarım kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Durum yönetimi için Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Tema renk paletini içe aktarıyoruz.
import '../../core/theme/app_colors.dart';
// Kategori veri modelini içe aktarıyoruz.
import '../../models/category.dart';
// Kullanıcı oturum ve profil Provider'ını içe aktarıyoruz.
import '../../providers/auth_provider.dart';
// Tema modu Provider'ını içe aktarıyoruz.
import '../../providers/theme_provider.dart';
// Araç ve filo verilerini yöneten Provider'ı içe aktarıyoruz.
import '../../providers/vehicle_provider.dart';
// Logo bileşenini içe aktarıyoruz.
import '../../widgets/sem_logo.dart';
// Çıkış yapıldığında dönülecek giriş ekranını içe aktarıyoruz.
import '../auth/login_screen.dart';
// Kategoriye tıklandığında açılacak araç listesi ekranını içe aktarıyoruz.
import 'vehicle_list_screen.dart';

/// Müşterinin giriş yaptıktan sonra karşılaştığı ana sayfa ekranı.
/// Kişiselleştirilmiş karşılama, kampanya bannerı ve araç kategorilerini ızgara (Grid) biçiminde listeler.
class CustomerMainScreen extends StatelessWidget {
  /// CustomerMainScreen kurucu metodu (Constructor)
  const CustomerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Koyu tema modunda mıyız kontrol ediyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Gerekli provider nesnelerini dinliyoruz.
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final vehicleProvider = Provider.of<VehicleProvider>(context);

    // Provider'dan kategorileri alıyoruz.
    final categories = vehicleProvider.categories;
    // Giriş yapmış kullanıcının tam adını veya varsayılan metni alıyoruz.
    final userName = authProvider.currentUser?.fullName ?? 'Değerli Müşterimiz';

    return Scaffold(
      // Üst AppBar: Logo, Tema Değiştirme ve Çıkış Yap Butonları
      appBar: AppBar(
        title: const SemLogo(fontSize: 22),
        actions: [
          // Açık / Koyu tema geçiş butonu
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Temayı Değiştir',
          ),
          // Güvenli oturum kapatma (Çıkış) butonu
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              // Oturumu sıfırlıyoruz.
              authProvider.logout();
              // Tüm sayfa geçmişini silerek kullanıcıyı giriş ekranına yönlendiriyoruz.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            tooltip: 'Çıkış Yap',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==========================================
              // KULLANICI KARŞILAMA VE GİRİŞ METNİ
              // ==========================================
              Text(
                'Merhaba, $userName 👋',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Bugün hangi araçla yola çıkmak istersiniz?',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
              ),
              const SizedBox(height: 20),

              // ==========================================
              // ÖZEL KAMPANYA / 250 KM AVANTAJ BANNERI
              // ==========================================
              _buildPromoBanner(isDark),
              const SizedBox(height: 28),

              // ==========================================
              // ARAÇ KATEGORİLERİ BAŞLIĞI VE SAYISI
              // ==========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Araç Kategorileri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  Text(
                    '${categories.length} Kategori',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ==========================================
              // KATEGORİLER IZGARA LİSTESİ (GridView)
              // ==========================================
              GridView.builder(
                // SingleChildScrollView içinde düzgün kayması için shrinkWrap açıyoruz.
                shrinkWrap: true,
                // Kendi iç kaydırmasını kapatıp sayfa kaydırmasını kullanıyoruz.
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Yan yana 2 kart
                  crossAxisSpacing: 14, // Yatay boşluk
                  mainAxisSpacing: 14, // Dikey boşluk
                  childAspectRatio: 0.95, // Kart en-boy oranı
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  // İlgili kategorideki toplam araç sayısını sorguluyoruz.
                  final carCount = vehicleProvider.getCarCountForCategory(cat.id);
                  return _buildCategoryCard(context, cat, carCount, isDark);
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // GRADYANLI PROMOSYON BANNERI METODU
  // ==========================================
  /// 250 KM kuralını ve özel avantajları duyuran şık bir gradyan kart çizer.
  Widget _buildPromoBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Koyu veya açık temaya özel mavi renk geçişi (gradyan)
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0D47A1), const Color(0xFF1976D2)]
              : [const Color(0xFF0066FF), const Color(0xFF3385FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        // Mavi ışıltılı gölgelendirme
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 'ÖZEL AVANTAJ' küçük rozeti
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'ÖZEL AVANTAJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1,
                  ),
                ),
              ),
              // Sağ üstteki beyaz araba ikonu
              const Icon(
                Icons.directions_car_filled_rounded,
                color: Colors.white70,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Banner Ana Başlığı
          const Text(
            'Günlük 250 KM Sürüş Hakkı',
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          // Banner Açıklaması
          const Text(
            'Şehirler arası seyahatlerde rota mesafesi hesaplanarak aşılan her 250 km için ekstra gün tarifesi uygulanır.',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12.5,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TEKİL KATEGORİ KARTI OLUŞTURUCU
  // ==========================================
  /// Kategorinin ikonu, araç sayısı, adı ve açıklamasını kart olarak gösterir; tıklandığında araç listesini açar.
  Widget _buildCategoryCard(BuildContext context, Category cat, int carCount, bool isDark) {
    // Kategoriye özgü simgeyi alıyoruz.
    final iconData = _getCategoryIcon(cat.id);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      color: isDark ? AppColors.surfaceDarkElevated : Colors.white,
      child: InkWell(
        // Karta dokunulduğunda ilgili kategorinin araç listeleme ekranına geçiyoruz.
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VehicleListScreen(category: cat),
            ),
          );
        },
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Üst Satır: Kategori İkonu ve Mevcut Araç Sayısı Rozeti
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(iconData, color: AppColors.primaryBlue, size: 26),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$carCount Araç',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textLight : AppColors.textDark,
                      ),
                    ),
                  ),
                ],
              ),
              // Alt Kısım: Kategori Adı ve Kısa Açıklaması
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cat.name,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cat.description,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // KATEGORİ İKON SEÇİCİ YARDIMCISI
  // ==========================================
  /// Kategori ID'sine göre uygun Material ikonunu döndürür.
  IconData _getCategoryIcon(String catId) {
    switch (catId) {
      case 'basic':
        return Icons.directions_car_rounded;
      case 'basic_plus':
        return Icons.commute_rounded;
      case 'flex':
        return Icons.electric_car_rounded;
      case 'flex_plus':
        return Icons.airport_shuttle_rounded;
      case 'lux':
        return Icons.stars_rounded;
      case 'ultra_lux':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.directions_car_filled_rounded;
    }
  }
}
