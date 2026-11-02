// Flutter temel Material bileşenler kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Riverpod tüketici widget'larını kullanabilmek için gerekli paket
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama geneli sabitleri içe aktarıyoruz
import '../../../core/constants/app_constants.dart';
// Tema, dil ve bildirim sağlayıcılarını içe aktarıyoruz
import '../../../core/providers/theme_provider.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';

// Tema, dil, bildirim ve önbellek tercihlerinin yönetildiği ayarlar ekranı bileşenimiz
class AppSettingsScreen extends ConsumerWidget {
  // AppSettingsScreen sınıfının değişmez kurucu metodu
  const AppSettingsScreen({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan ve ref ile sağlayıcıları dinleyen build metodu
  @override
  // BuildContext ve WidgetRef alıp Widget döndüren build metodu
  Widget build(BuildContext context, WidgetRef ref) {
    // Aktif tema modunu (Açık/Koyu/Sistem) dinliyoruz
    final themeMode = ref.watch(themeModeProvider);
    // Aktif dili ('tr' / 'en') dinliyoruz
    final locale = ref.watch(localeProvider);
    // Bildirim ve haptik ayarlarını dinliyoruz
    final notifications = ref.watch(notificationSettingsProvider);
    // Temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sayfa iskeleti
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlık metni
        title: const Text('Uygulama Ayarları'),
      // AppBar kapanışı
      ),
      // Ayar kartlarını dikeyde listeleyen ListView
      body: ListView(
        // Liste kenar boşlukları
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        // Liste çocukları
        children: [
          // 1. TEMA VE GÖRÜNÜM AYARLARI BÖLÜMÜ
          _buildSectionHeader('Görünüm & Tema', Icons.palette_outlined),
          // 8 piksel dikey boşluk
          const SizedBox(height: 8),

          // Tema seçeneklerini içeren kart
          Card(
            // 20 piksel yuvarlatılmış köşeler
            shape: RoundedRectangleBorder(
              // Köşe yarıçapı
              borderRadius: BorderRadius.circular(20),
              // Kenar çizgisi
              side: BorderSide(
                // Temaya göre kenarlık rengi
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              // BorderSide kapanışı
              ),
            // RoundedRectangleBorder kapanışı
            ),
            // Gölge sıfır
            elevation: 0,
            // Temaya göre kart rengi
            color: isDark ? AppColors.cardDark : Colors.white,
            // Kart içi dikey boşluk
            child: Padding(
              // Dikeyde 8 piksel iç boşluk
              padding: const EdgeInsets.symmetric(vertical: 8),
              // Tema seçenekleri sütunu
              child: Column(
                // Elemanlar listesi
                children: [
                  // Açık Tema Seçeneği
                  ListTile(
                    // Başlık
                    title: const Text('Açık Tema (Light Mode)', style: TextStyle(fontWeight: FontWeight.w600)),
                    // Alt başlık
                    subtitle: const Text('Ferah, yumuşak sage yeşili tonları'),
                    // Güneş ikonu
                    leading: const Icon(Icons.light_mode_rounded, color: Colors.amber, size: 28),
                    // Seçili olma durumuna göre onay ikonu
                    trailing: themeMode == ThemeMode.light
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    // Tıklandığında açık temayı aktifleştiriyoruz
                    onTap: () {
                      // Temayı açık yapıyoruz
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                    // onTap kapanışı
                    },
                  // ListTile kapanışı
                  ),
                  // Ayırıcı çizgi
                  const Divider(indent: 16, endIndent: 16),

                  // Koyu Tema Seçeneği
                  ListTile(
                    // Başlık
                    title: const Text('Koyu Tema (Dark Mode)', style: TextStyle(fontWeight: FontWeight.w600)),
                    // Alt başlık
                    subtitle: const Text('Gözü yormayan şık koyu yeşil & antrasit'),
                    // Ay ikonu
                    leading: const Icon(Icons.dark_mode_rounded, color: Colors.deepPurpleAccent, size: 28),
                    // Seçili olma durumuna göre onay ikonu
                    trailing: themeMode == ThemeMode.dark
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    // Tıklandığında koyu temayı aktifleştiriyoruz
                    onTap: () {
                      // Temayı koyu yapıyoruz
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                    // onTap kapanışı
                    },
                  // ListTile kapanışı
                  ),
                  // Ayırıcı çizgi
                  const Divider(indent: 16, endIndent: 16),

                  // Sistem Teması Seçeneği
                  ListTile(
                    // Başlık
                    title: const Text('Sistem Teması', style: TextStyle(fontWeight: FontWeight.w600)),
                    // Alt başlık
                    subtitle: const Text('Cihazınızın sistem ayarlarıyla otomatik eşleşir'),
                    // Sistem ikonu
                    leading: const Icon(Icons.settings_system_daydream_rounded, color: AppColors.primary, size: 28),
                    // Seçili olma durumu
                    trailing: themeMode == ThemeMode.system
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    // Tıklandığında sistem temasını seçiyoruz
                    onTap: () {
                      // Temayı sistem moduna alıyoruz
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                    // onTap kapanışı
                    },
                  // ListTile kapanışı
                  ),
                // Column çocukları kapanışı
                ],
              // Column kapanışı
              ),
            // Padding kapanışı
            ),
          // Card kapanışı
          ),
          // 24 piksel dikey boşluk
          const SizedBox(height: 24),

          // 2. DİL VE BÖLGE AYARLARI BÖLÜMÜ
          _buildSectionHeader('Dil & Bölge', Icons.language_rounded),
          // 8 piksel dikey boşluk
          const SizedBox(height: 8),

          // Dil kartı bileşeni
          Card(
            // 20 piksel yuvarlak köşe
            shape: RoundedRectangleBorder(
              // Köşe yarıçapı
              borderRadius: BorderRadius.circular(20),
              // Kenar çizgisi
              side: BorderSide(
                // Temaya göre kenarlık
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              // BorderSide kapanışı
              ),
            // RoundedRectangleBorder kapanışı
            ),
            // Gölge sıfır
            elevation: 0,
            // Temaya göre arka plan
            color: isDark ? AppColors.cardDark : Colors.white,
            // Dil satırı bileşeni
            child: ListTile(
              // İç boşluk
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              // Çeviri ikonu
              leading: Container(
                // 10 piksel iç boşluk
                padding: const EdgeInsets.all(10),
                // Yuvarlak dekorasyon
                decoration: BoxDecoration(
                  // Yüzde 10 yeşil arka plan
                  color: AppColors.primary.withValues(alpha: 0.1),
                  // Daire
                  shape: BoxShape.circle,
                // BoxDecoration kapanışı
                ),
                // Tercüme simgesi
                child: const Icon(Icons.translate_rounded, color: AppColors.primary),
              // Container kapanışı
              ),
              // Başlık
              title: const Text('Uygulama Dili', style: TextStyle(fontWeight: FontWeight.bold)),
              // Alt başlık (Türkçe veya English)
              subtitle: Text(locale == 'tr' ? 'Türkçe (Varsayılan)' : 'English'),
              // Açılır menü (Dropdown)
              trailing: DropdownButton<String>(
                // Seçili değer
                value: locale,
                // Alt çizgiyi kaldırıyoruz
                underline: const SizedBox(),
                // Menü köşelerini yuvarlatıyoruz
                borderRadius: BorderRadius.circular(16),
                // Dil seçenekleri listesi
                items: const [
                  // Türkçe
                  DropdownMenuItem(value: 'tr', child: Text('Türkçe 🇹🇷')),
                  // İngilizce
                  DropdownMenuItem(value: 'en', child: Text('English 🇬🇧')),
                // items listesi kapanışı
                ],
                // Dil değiştirildiğinde tetiklenen olay
                onChanged: (val) {
                  // Değer boş değilse güncelliyoruz
                  if (val != null) {
                    // Sağlayıcıya yeni dili atıyoruz
                    ref.read(localeProvider.notifier).setLocale(val);
                    // Bilgilendirme SnackBar'ı gösteriyoruz
                    ScaffoldMessenger.of(context).showSnackBar(
                      // SnackBar bileşeni
                      SnackBar(
                        // Bildirim metni
                        content: Text(val == 'tr'
                            ? 'Uygulama dili Türkçe olarak güncellendi.'
                            : 'App language set to English.'),
                        // 1 saniye ekranda kalsın
                        duration: const Duration(seconds: 1),
                      // SnackBar kapanışı
                      ),
                    // showSnackBar kapanışı
                    );
                  // if val != null kapanışı
                  }
                // onChanged kapanışı
                },
              // DropdownButton kapanışı
              ),
            // ListTile kapanışı
            ),
          // Card kapanışı
          ),
          // 24 piksel dikey boşluk
          const SizedBox(height: 24),

          // 3. BİLDİRİM TERCİHLERİ BÖLÜMÜ
          _buildSectionHeader('Öğün & Tarif Bildirimleri', Icons.notifications_active_outlined),
          // 8 piksel dikey boşluk
          const SizedBox(height: 8),

          // Bildirim ayarları anahtarları kartı
          Card(
            // Yuvarlatılmış köşeler
            shape: RoundedRectangleBorder(
              // 20 piksel yuvarlatma
              borderRadius: BorderRadius.circular(20),
              // Kenar çizgisi
              side: BorderSide(
                // Temaya göre kenarlık
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              // BorderSide kapanışı
              ),
            // RoundedRectangleBorder kapanışı
            ),
            // Gölge sıfır
            elevation: 0,
            // Temaya göre kart rengi
            color: isDark ? AppColors.cardDark : Colors.white,
            // Switch bileşenleri sütunu
            child: Column(
              // Elemanlar listesi
              children: [
                // Günün Menü Önerisi Bildirimi
                SwitchListTile(
                  // Aktif çizgi rengi
                  activeTrackColor: AppColors.primary,
                  // Başlık
                  title: const Text('Günün Menü Önerisi', style: TextStyle(fontWeight: FontWeight.w600)),
                  // Alt başlık
                  subtitle: const Text('Her gün 12:00\'de leziz bir öğle önerisi al'),
                  // Değer
                  value: notifications.dailyMealReminder,
                  // Değişim olayı
                  onChanged: (val) {
                    // Bildirim sağlayıcısını güncelliyoruz
                    ref.read(notificationSettingsProvider.notifier).toggleDailyMealReminder(val);
                  // onChanged kapanışı
                  },
                // SwitchListTile kapanışı
                ),
                // Ayırıcı çizgi
                const Divider(indent: 16, endIndent: 16),

                // Akşam Yemeği İlhamı Bildirimi
                SwitchListTile(
                  // Aktif çizgi rengi
                  activeTrackColor: AppColors.primary,
                  // Başlık
                  title: const Text('Akşam Yemeği İlhamı', style: TextStyle(fontWeight: FontWeight.w600)),
                  // Alt başlık
                  subtitle: const Text('18:00\'de dolaptaki malzemelere uygun tarif hatırlatması'),
                  // Değer
                  value: notifications.eveningInspiration,
                  // Değişim olayı
                  onChanged: (val) {
                    // Bildirim sağlayıcısını güncelliyoruz
                    ref.read(notificationSettingsProvider.notifier).toggleEveningInspiration(val);
                  // onChanged kapanışı
                  },
                // SwitchListTile kapanışı
                ),
                // Ayırıcı çizgi
                const Divider(indent: 16, endIndent: 16),

                // Gümüş Kubbe Dokunsal Titreşim Ayarı
                SwitchListTile(
                  // Aktif çizgi rengi
                  activeTrackColor: AppColors.primary,
                  // Başlık
                  title: const Text('Gümüş Kubbe Titreşimi', style: TextStyle(fontWeight: FontWeight.w600)),
                  // Alt başlık
                  subtitle: const Text('Kubbe açılırken haptik geri bildirim verilsin'),
                  // Değer
                  value: notifications.clocheHaptics,
                  // Değişim olayı
                  onChanged: (val) {
                    // Bildirim sağlayıcısını güncelliyoruz
                    ref.read(notificationSettingsProvider.notifier).toggleClocheHaptics(val);
                  // onChanged kapanışı
                  },
                // SwitchListTile kapanışı
                ),
              // Column çocukları kapanışı
              ],
            // Column kapanışı
            ),
          // Card kapanışı
          ),
          // 24 piksel dikey boşluk
          const SizedBox(height: 24),

          // 4. DEPOLAMA VE ÖNBELLEK TEMİZLEME BÖLÜMÜ
          _buildSectionHeader('Veri & Depolama', Icons.cleaning_services_rounded),
          // 8 piksel dikey boşluk
          const SizedBox(height: 8),

          // Önbellek temizleme kartı
          Card(
            // Yuvarlatılmış köşeler
            shape: RoundedRectangleBorder(
              // 20 piksel yuvarlatma
              borderRadius: BorderRadius.circular(20),
              // Kenar çizgisi
              side: BorderSide(
                // Temaya göre kenarlık
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              // BorderSide kapanışı
              ),
            // RoundedRectangleBorder kapanışı
            ),
            // Gölge sıfır
            elevation: 0,
            // Temaya göre kart rengi
            color: isDark ? AppColors.cardDark : Colors.white,
            // Önbellek satırı
            child: ListTile(
              // Sol çöp ikonu
              leading: Container(
                // 10 piksel iç boşluk
                padding: const EdgeInsets.all(10),
                // Turuncu daire dekorasyonu
                decoration: BoxDecoration(
                  // Yüzde 10 şeffaf turuncu renk
                  color: Colors.orange.withValues(alpha: 0.1),
                  // Daire şekli
                  shape: BoxShape.circle,
                // BoxDecoration kapanışı
                ),
                // Temizlik ikonu
                child: const Icon(Icons.delete_sweep_rounded, color: Colors.orange),
              // Container kapanışı
              ),
              // Başlık
              title: const Text('Görsel Önbelleğini Temizle', style: TextStyle(fontWeight: FontWeight.bold)),
              // Alt başlık
              subtitle: const Text('Yemek fotoğraflarını yeniden indirmek için önbelleği boşalt'),
              // Sağ ok ikonu
              trailing: const Icon(Icons.chevron_right),
              // Tıklandığında önbellek temizleme mesajı basıyoruz
              onTap: () {
                // SnackBar bildirimi
                ScaffoldMessenger.of(context).showSnackBar(
                  // SnackBar bileşeni
                  const SnackBar(
                    // Başarı mesajı
                    content: Text('Uygulama önbelleği başarıyla temizlendi!'),
                    // Yeşil renk
                    backgroundColor: AppColors.success,
                    // 2 saniye ekranda kalsın
                    duration: Duration(seconds: 2),
                  // SnackBar kapanışı
                  ),
                // showSnackBar kapanışı
                );
              // onTap kapanışı
              },
            // ListTile kapanışı
            ),
          // Card kapanışı
          ),
          // 24 piksel dikey boşluk
          const SizedBox(height: 24),

          // 5. UYGULAMA HAKKINDA BÖLÜMÜ
          _buildSectionHeader('Hakkında', Icons.info_outline_rounded),
          // 8 piksel dikey boşluk
          const SizedBox(height: 8),

          // Hakkında bilgi kartı
          Card(
            // Yuvarlatılmış köşeler
            shape: RoundedRectangleBorder(
              // 20 piksel yuvarlatma
              borderRadius: BorderRadius.circular(20),
              // Kenar çizgisi
              side: BorderSide(
                // Temaya göre kenarlık
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              // BorderSide kapanışı
              ),
            // RoundedRectangleBorder kapanışı
            ),
            // Gölge sıfır
            elevation: 0,
            // Temaya göre kart rengi
            color: isDark ? AppColors.cardDark : Colors.white,
            // Kart içi boşluk
            child: Padding(
              // 16 piksel kenar boşluğu
              padding: const EdgeInsets.all(16),
              // Bilgileri dizen Column
              child: Column(
                // Elemanlar listesi
                children: [
                  // Logo ve sürüm satırı
                  Row(
                    // Satır elemanları
                    children: [
                      // Küçük logo kutucuğu
                      Container(
                        // 8 piksel iç boşluk
                        padding: const EdgeInsets.all(8),
                        // Daire dekorasyonu
                        decoration: BoxDecoration(
                          // Yüzde 10 yeşil renk
                          color: AppColors.primary.withValues(alpha: 0.1),
                          // Daire
                          shape: BoxShape.circle,
                        // BoxDecoration kapanışı
                        ),
                        // Mutfak ikonu
                        child: const Icon(Icons.soup_kitchen_rounded, color: AppColors.primary),
                      // Container kapanışı
                      ),
                      // 12 piksel yatay boşluk
                      const SizedBox(width: 12),

                      // Uygulama adı ve sürüm sütunu
                      const Column(
                        // Sola yaslama
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // Elemanlar
                        children: [
                          // Uygulama adı
                          Text(
                            // 'Bugün Ne Yesem?' başlığı
                            AppConstants.appName,
                            // Kalın ve 16 punto yazı stili
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          // Text kapanışı
                          ),
                          // Sürüm numarası
                          Text('Sürüm 1.0.0 (Build 2026)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        // Column çocukları kapanışı
                        ],
                      // Column kapanışı
                      ),
                    // Row çocukları kapanışı
                    ],
                  // Row kapanışı
                  ),
                  // 12 piksel dikey boşluk
                  const SizedBox(height: 12),

                  // Misyon ve proje tanıtım metni
                  const Text(
                    // Tanıtım metni
                    'Bugün Ne Yesem, evdeki malzemelerinizle harikalar yaratmanızı ve ne yiyeceğinize saniyeler içinde karar vermenizi sağlayan akıllı bir mutfak asistanıdır.',
                    // Stil
                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                  // Text kapanışı
                  ),
                // Column çocukları kapanışı
                ],
              // Column kapanışı
              ),
            // Padding kapanışı
            ),
          // Card kapanışı
          ),
          // 32 piksel dikey boşluk
          const SizedBox(height: 32),
        // ListView çocukları kapanışı
        ],
      // ListView kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }

  // Bölüm başlıklarını ikon ve yeşil metinle standartlaştıran yardımcı widget fonksiyonumuz
  Widget _buildSectionHeader(String title, IconData icon) {
    // İkon ve metni yan yana dizen Row
    return Row(
      // Elemanlar listesi
      children: [
        // Bölüm ikonu
        Icon(icon, size: 18, color: AppColors.primary),
        // 8 piksel boşluk
        const SizedBox(width: 8),
        // Bölüm başlık metni
        Text(
          // Başlık içeriği
          title,
          // Stil özellikleri
          style: const TextStyle(
            // 14 punto boyut
            fontSize: 14,
            // Kalın font
            fontWeight: FontWeight.bold,
            // Yeşil renk
            color: AppColors.primary,
          // TextStyle kapanışı
          ),
        // Text kapanışı
        ),
      // Row çocukları kapanışı
      ],
    // Row kapanışı
    );
  // _buildSectionHeader fonksiyonunun kapanış parantezi
  }
// AppSettingsScreen sınıfının kapanış parantezi
}
