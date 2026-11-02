// Flutter Material temel bileşenler kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Riverpod durum yönetimi paketini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';
// Favoriler ekranını içe aktarıyoruz
import '../../favorites/presentation/favorites_screen.dart';
// Şef tarifleri ekranını içe aktarıyoruz
import '../../inventory/presentation/chef_recipes_screen.dart';
// Buzdolabı / Malzemeler ekranını içe aktarıyoruz
import '../../inventory/presentation/inventory_screen.dart';
// Profil ve ayarlar ekranını içe aktarıyoruz
import '../../profile/presentation/profile_screen.dart';
// Ana sayfa vitrin ekranını içe aktarıyoruz
import 'home_screen.dart';

// 5 ana sekmeyi barındıran ve alt gezinme çubuğuyla ekranlar arası geçiş sağlayan ana kabuk widget'ımız
class MainScaffoldScreen extends ConsumerStatefulWidget {
  // MainScaffoldScreen sınıfının değişmez kurucu metodu
  const MainScaffoldScreen({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (State) yöneticisini bağlayan metot
  @override
  // ConsumerState nesnesi döndürüyoruz
  ConsumerState<MainScaffoldScreen> createState() => _MainScaffoldScreenState();
// MainScaffoldScreen sınıfının kapanış parantezi
}

// Seçili sekme indeksini ve sayfaların IndexedStack içinde canlı kalmasını yöneten State sınıfımız
class _MainScaffoldScreenState extends ConsumerState<MainScaffoldScreen> {
  // O an seçili olan sekmenin indeksi (varsayılan: 0 - Ana Sayfa)
  int _currentIndex = 0;

  // Alt barda yer alan 5 farklı ekranın değişmez listesi
  final List<Widget> _pages = const [
    // 0. İndeks: Ana sayfa (Gümüş kubbe ve tarif listesi)
    HomeScreen(),
    // 1. İndeks: Favoriler sayfası
    FavoritesScreen(),
    // 2. İndeks: Buzdolabı ve malzemeler sayfası
    InventoryScreen(),
    // 3. İndeks: Şef atölyesi ve özel tarifler sayfası
    ChefRecipesScreen(),
    // 4. İndeks: Kullanıcı profili sayfası
    ProfileScreen(),
  // _pages listesi kapanışı
  ];

  // Ekranın görsel ağacını inşa eden build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sayfanın temel iskeleti
    return Scaffold(
      // IndexedStack: Sekmeler arası geçiş yapıldığında sayfaların scroll konumunu ve durumunu korur
      body: IndexedStack(
        // Aktif olarak gösterilecek sekmenin indeksi
        index: _currentIndex,
        // Sekme sayfaları listesi
        children: _pages,
      // IndexedStack kapanışı
      ),
      // Üstünde ince bir çizgi olan alt gezinme çubuğu kutusu
      bottomNavigationBar: Container(
        // Çubuk kutusunun üst kenarlık dekorasyonu
        decoration: BoxDecoration(
          // Kenarlık çizgisi
          border: Border(
            // Sadece üst kenara çizgi çekiyoruz
            top: BorderSide(
              // Temaya göre kenarlık rengi
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              // 1 piksel çizgi kalınlığı
              width: 1,
            // BorderSide kapanışı
            ),
          // Border kapanışı
          ),
        // BoxDecoration kapanışı
        ),
        // Alt gezinme çubuğunun etiket stil şablonu
        child: NavigationBarTheme(
          // Tema verisi
          data: NavigationBarThemeData(
            // Etiket metin stilini seçili olma durumuna göre çözen özellik
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              // Sekmenin seçili olup olmadığını kontrol ediyoruz
              final isSelected = states.contains(WidgetState.selected);
              // Duruma göre metin stilini dönüyoruz
              return TextStyle(
                // 11 punto kompakt boyut
                fontSize: 11,
                // Seçiliyse kalın, değilse orta kalın font
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                // Seçiliyse yeşil, değilse gri metin rengi
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
                // Harf aralığı
                letterSpacing: -0.2,
              // TextStyle kapanışı
              );
            // resolveWith kapanışı
            }),
          // NavigationBarThemeData kapanışı
          ),
          // Modern Material 3 NavigationBar bileşeni
          child: NavigationBar(
            // Aktif sekmenin indeksi
            selectedIndex: _currentIndex,
            // Gölge yüksekliği sıfır
            elevation: 0,
            // Temaya göre arka plan rengi
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            // Seçili sekmenin arkasındaki hafif yeşil hap rengi
            indicatorColor: AppColors.primary.withValues(alpha: 0.18),
            // Sekme etiketlerini her zaman göster moduna alıyoruz
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            // Kullanıcı bir sekmeye dokunduğunda indeksi güncelliyoruz
            onDestinationSelected: (index) {
              // Ekranı güncellemek için setState çağırıyoruz
              setState(() {
                // Yeni indeksi atıyoruz
                _currentIndex = index;
              // setState kapanışı
              });
            // onDestinationSelected kapanışı
            },
            // Gezinme çubuğundaki 5 hedef sekme listesi
            destinations: const [
              // 1. Hedef: Ana Sayfa
              NavigationDestination(
                // Seçili değilkenki boş ev ikonu
                icon: Icon(Icons.home_outlined),
                // Seçiliykenki dolu yeşil ev ikonu
                selectedIcon:
                    Icon(Icons.home_rounded, color: AppColors.primary),
                // Sekme etiketi
                label: 'Ana Sayfa',
              // NavigationDestination kapanışı
              ),
              // 2. Hedef: Favoriler
              NavigationDestination(
                // Seçili değilkenki boş kalp ikonu
                icon: Icon(Icons.favorite_outline_rounded),
                // Seçiliykenki dolu yeşil kalp ikonu
                selectedIcon:
                    Icon(Icons.favorite_rounded, color: AppColors.primary),
                // Sekme etiketi
                label: 'Favoriler',
              // NavigationDestination kapanışı
              ),
              // 3. Hedef: Malzemeler / Buzdolabı
              NavigationDestination(
                // Seçili değilkenki buzdolabı ikonu
                icon: Icon(Icons.kitchen_outlined),
                // Seçiliykenki dolu yeşil buzdolabı ikonu
                selectedIcon:
                    Icon(Icons.kitchen_rounded, color: AppColors.primary),
                // Sekme etiketi
                label: 'Malzemeler',
              // NavigationDestination kapanışı
              ),
              // 4. Hedef: Şef Menüsü
              NavigationDestination(
                // Seçili değilkenki sihirli yıldız ikonu
                icon: Icon(Icons.auto_awesome_outlined),
                // Seçiliykenki dolu yeşil sihirli yıldız ikonu
                selectedIcon:
                    Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
                // Sekme etiketi
                label: 'Şef Menüsü',
              // NavigationDestination kapanışı
              ),
              // 5. Hedef: Profil
              NavigationDestination(
                // Seçili değilkenki boş kişi ikonu
                icon: Icon(Icons.person_outline_rounded),
                // Seçiliykenki dolu yeşil kişi ikonu
                selectedIcon:
                    Icon(Icons.person_rounded, color: AppColors.primary),
                // Sekme etiketi
                label: 'Profil',
              // NavigationDestination kapanışı
              ),
            // destinations listesi kapanışı
            ],
          // NavigationBar kapanışı
          ),
        // NavigationBarTheme kapanışı
        ),
      // Container kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _MainScaffoldScreenState sınıfının kapanış parantezi
}
