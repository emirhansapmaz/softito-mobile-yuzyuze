// Flutter'ın temel materyal tasarım kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Riverpod durum yönetimi için gerekli kütüphane
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Tarih ve zamanı biçimlendirmek için kullandığımız intl kütüphanesi
import 'package:intl/intl.dart';
// Veritabanı işlemleri ve stream provider'larımız
import '../../../core/providers/database_provider.dart';
// Uygulama tema ve renk sabitleri
import '../../../core/theme/app_colors.dart';

// Şefin özel üretilen tariflerini listeleyen Riverpod Stateful ekranı
class ChefRecipesScreen extends ConsumerStatefulWidget {
  // Kurucu metodumuz
  const ChefRecipesScreen({super.key});

  // State nesnesini üreten override metodu
  @override
  ConsumerState<ChefRecipesScreen> createState() => _ChefRecipesScreenState();
} // ChefRecipesScreen sınıfı kapanışı

// Şef tarifleri ekranının durum sınıfı
class _ChefRecipesScreenState extends ConsumerState<ChefRecipesScreen> {
  // Arayüzü çizen build metodu
  @override
  Widget build(BuildContext context) {
    // Mevcut temanın koyu modda olup olmadığını yakalıyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Riverpod üzerinden kullanıcının ürettiği şef tariflerinin canlı akışını izliyoruz
    final chefRecipesAsync = ref.watch(chefRecipesStreamProvider('default_user'));

    // Sayfa iskeletini döndürüyoruz
    return Scaffold(
      // Üst uygulama başlığı
      appBar: AppBar(
        // Başlık satırı
        title: const Row(
          // İçeriği kadar yer kaplasın
          mainAxisSize: MainAxisSize.min,
          // Çocuk widget'lar
          children: [
            // Parlayan yıldız ikonu
            Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
            // İkon ile metin arası boşluk
            SizedBox(width: 8),
            // Başlık metni
            Text('Masterchef Menüsü'),
          ], // Row çocukları kapanışı
        ), // Row kapanışı
      ), // AppBar kapanışı
      // AsyncValue durumuna göre arayüzü çiziyoruz (veri, yükleniyor, hata)
      body: chefRecipesAsync.when(
        // Veri başarıyla geldiğinde
        data: (recipes) {
          // Eğer hiç şef tarifi üretilmemişse boş durum ekranı göster
          if (recipes.isEmpty) {
            // Ortalanmış içerik
            return Center(
              // Dikey hizalama kolonu
              child: Column(
                // Ortada topla
                mainAxisAlignment: MainAxisAlignment.center,
                // Kolon çocukları
                children: [
                  // Mutfak çorba kazanı ikonu
                  Icon(
                    Icons.soup_kitchen_outlined,
                    size: 64,
                    color: isDark ? Colors.white24 : Colors.black26,
                  ), // Icon kapanışı
                  // Araya boşluk
                  const SizedBox(height: 16),
                  // Bilgilendirme başlığı
                  const Text(
                    'Henüz Masterchef tarifi üretmediniz.',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ), // Text kapanışı
                  // Boşluk
                  const SizedBox(height: 6),
                  // Yönlendirme alt metni
                  Text(
                    'Malzemeler sekmesinden Masterchef modunu başlatın!',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ), // TextStyle kapanışı
                  ), // Text kapanışı
                ], // Kolon çocukları kapanışı
              ), // Column kapanışı
            ); // Center kapanışı
          } // if sonu

          // Eğer tarifler varsa ListView ile listeliyoruz
          return ListView.builder(
            // Kenar boşlukları
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            // Liste eleman sayısı
            itemCount: recipes.length,
            // Eleman oluşturucu fonksiyon
            itemBuilder: (context, index) {
              // Sıradaki şef tarifini alıyoruz
              final chefRecipe = recipes[index];
              // Tarihi okunabilir Türkçe biçime çeviriyoruz
              final dateString =
                  DateFormat('dd MMM yyyy, HH:mm').format(chefRecipe.createdAt);

              // Kart tasarımı
              return Card(
                // Alt kenar boşluğu
                margin: const EdgeInsets.only(bottom: 16),
                // Gölgesiz düz modern görünüm
                elevation: 0,
                // Arka plan rengi temaya göre
                color: isDark ? AppColors.cardDark : Colors.white,
                // Kart kenarlık şekli
                shape: RoundedRectangleBorder(
                  // Yuvarlak köşeler
                  borderRadius: BorderRadius.circular(20),
                  // Kenar çizgisi
                  side: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ), // BorderSide kapanışı
                ), // RoundedRectangleBorder kapanışı
                // İç kenar boşluğu
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  // Kart içi dikey kolon
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Başlık, kalori ve silme butonunun olduğu üst satır
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sol taraf: Yemek adı ve tarihi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Tarif adı
                                Text(
                                  chefRecipe.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ), // TextStyle kapanışı
                                ), // Text kapanışı
                                const SizedBox(height: 4),
                                // Oluşturulma tarihi
                                Text(
                                  dateString,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isDark
                                        ? AppColors.textSecondaryDark
                                        : AppColors.textSecondaryLight,
                                  ), // TextStyle kapanışı
                                ), // Text kapanışı
                              ], // Column çocukları kapanışı
                            ), // Column kapanışı
                          ), // Expanded kapanışı
                          // Kalori rozeti kutusu
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ), // BoxDecoration kapanışı
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Ateş simgesi
                                const Icon(
                                  Icons.local_fire_department,
                                  size: 14,
                                  color: AppColors.primary,
                                ), // Icon kapanışı
                                const SizedBox(width: 4),
                                // Kalori değeri metni
                                Text(
                                  '${chefRecipe.calories} kcal',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ), // TextStyle kapanışı
                                ), // Text kapanışı
                              ], // Row çocukları kapanışı
                            ), // Row kapanışı
                          ), // Container kapanışı
                          // Tarifi silme butonu
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 20,
                              color: Colors.redAccent,
                            ), // Icon kapanışı
                            // Silme butonuna basıldığında
                            onPressed: () async {
                              // Veritabanı servisini çağır
                              final db = ref.read(databaseServiceProvider);
                              // Tarifi veritabanından sil
                              await db.deleteChefRecipe(chefRecipe.id);
                              // Sayfa kapandıysa devam etme
                              if (!context.mounted) return;
                              // Kullanıcıya silindi bilgisini göster
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '"${chefRecipe.name}" menünüzden silindi.'),
                                  duration: const Duration(seconds: 1),
                                ), // SnackBar kapanışı
                              ); // showSnackBar kapanışı
                            }, // onPressed kapanışı
                          ), // IconButton kapanışı
                        ], // Row çocukları kapanışı
                      ), // Row kapanışı
                      // Dikey boşluk
                      const SizedBox(height: 12),

                      // Malzemeler Başlığı
                      const Text(
                        'Kullanılan Malzemeler:',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey,
                        ), // TextStyle kapanışı
                      ), // Text kapanışı
                      const SizedBox(height: 6),
                      // Malzemeleri saran esnek çip listesi
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: chefRecipe.ingredients.map((item) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ), // BoxDecoration kapanışı
                            child: Text(
                              item,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.primaryDark,
                              ), // TextStyle kapanışı
                            ), // Text kapanışı
                          ); // Container kapanışı
                        }).toList(), // map toList kapanışı
                      ), // Wrap kapanışı
                      const SizedBox(height: 14),

                      // Hazırlanış Adımları Bölümü
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.2)
                              : AppColors.backgroundLight,
                          borderRadius: BorderRadius.circular(14),
                        ), // BoxDecoration kapanışı
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Adımlar başlık satırı
                            const Row(
                              children: [
                                Icon(Icons.list_alt_rounded,
                                    size: 16, color: AppColors.primary),
                                SizedBox(width: 6),
                                Text(
                                  'Hazırlanış Adımları',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColors.primary,
                                  ), // TextStyle kapanışı
                                ), // Text kapanışı
                              ], // Row çocukları kapanışı
                            ), // Row kapanışı
                            const SizedBox(height: 6),
                            // Adım açıklamaları metni
                            Text(
                              chefRecipe.steps,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondaryLight,
                                height: 1.4,
                              ), // TextStyle kapanışı
                            ), // Text kapanışı
                          ], // Column çocukları kapanışı
                        ), // Column kapanışı
                      ), // Container kapanışı
                    ], // Column çocukları kapanışı
                  ), // Column kapanışı
                ), // Padding kapanışı
              ); // Card kapanışı
            }, // itemBuilder kapanışı
          ); // ListView.builder kapanışı
        }, // data callback kapanışı
        // Veri yüklenirken döner çark göster
        loading: () => const Center(child: CircularProgressIndicator()),
        // Hata durumunda hata mesajı göster
        error: (err, stack) => Center(child: Text('Hata oluştu: $err')),
      ), // when kapanışı
    ); // Scaffold kapanışı
  } // build metodu kapanışı
} // _ChefRecipesScreenState sınıfı kapanışı
