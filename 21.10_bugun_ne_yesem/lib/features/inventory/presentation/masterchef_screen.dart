// Flutter'ın temel materyal tasarım kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Riverpod durum yönetimi için gerekli kütüphane
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Benzersiz kimlik (UUID) üretmek için kullandığımız paket
import 'package:uuid/uuid.dart';
// Şef tarifi veri modelimiz
import '../../../core/models/chef_recipe_model.dart';
// Veritabanı servis provider'larımız
import '../../../core/providers/database_provider.dart';
// Uygulama renk paleti
import '../../../core/theme/app_colors.dart';
// Özel tasarım buton bileşenimiz
import '../../../shared/widgets/custom_button.dart';
// Özel tasarım metin giriş kutusu bileşenimiz
import '../../../shared/widgets/custom_text_field.dart';

// Riverpod ile durum dinleyebilen Masterchef ekranımız (Stateful)
class MasterchefScreen extends ConsumerStatefulWidget {
  // Kullanıcının sepetinden ya da dolabından gelen malzemeler listesi
  final List<String> availableIngredients;

  // Kurucu metodumuz, varsayılan popüler malzemeler listesi atanmış durumda
  const MasterchefScreen({
    // Widget ağacı için anahtar
    super.key,
    // Eğer dışarıdan malzeme listesi gelmezse varsayılan olarak bu liste kullanılır
    this.availableIngredients = const [
      'Yumurta',
      'Peynir',
      'Domates',
      'Biber',
      'Zeytinyağı',
      'Makarna',
      'Tavuk Göğsü',
      'Soğan',
      'Sarımsak',
      'Mantar',
    ],
  }); // Kurucu metod kapanışı

  // Riverpod State nesnesini oluşturan override metodumuz
  @override
  ConsumerState<MasterchefScreen> createState() => _MasterchefScreenState();
} // MasterchefScreen sınıfı kapanışı

// Masterchef ekranının durum yönetimi sınıfı
class _MasterchefScreenState extends ConsumerState<MasterchefScreen> {
  // Tarif adı için yazı denetleyicisi
  final _nameController = TextEditingController();
  // Kalori miktarı için yazı denetleyicisi
  final _caloriesController = TextEditingController();
  // Hazırlanış adımları için yazı denetleyicisi
  final _stepsController = TextEditingController();
  // Seçilen malzemeleri benzersiz tutmak için Set kümesi
  final Set<String> _selectedIngredients = {};
  // Kaydediliyor durumunu tutan bayrak (yükleniyor animasyonu için)
  bool _isSaving = false;

  // Ekran ilk açıldığında çalışan başlangıç metodu
  @override
  void initState() {
    // Üst sınıfın initState metodunu çağırıyoruz
    super.initState();
    // Gelen malzeme listesi boş değilse
    if (widget.availableIngredients.isNotEmpty) {
      // İlk 3 malzemeyi otomatik seçili olarak kümeye ekliyoruz
      _selectedIngredients.addAll(widget.availableIngredients.take(3));
      // Akıllı şef taslağını otomatik üretiyoruz
      _generateSmartChefDraft();
    } // if sonu
  } // initState metodu kapanışı

  // Ekrandan çıkıldığında bellek sızıntısını önlemek için controller'ları temizliyoruz
  @override
  void dispose() {
    // İsim controller'ını bellekten atıyoruz
    _nameController.dispose();
    // Kalori controller'ını bellekten atıyoruz
    _caloriesController.dispose();
    // Adımlar controller'ını bellekten atıyoruz
    _stepsController.dispose();
    // Üst sınıfın dispose metodunu çağırıyoruz
    super.dispose();
  } // dispose metodu kapanışı

  /// Seçilen malzemelere göre otomatik akıllı şef taslağı oluşturur
  void _generateSmartChefDraft() {
    // Eğer hiçbir malzeme seçilmemişse fonksiyondan çık
    if (_selectedIngredients.isEmpty) return;

    // Kümeyi listeye çeviriyoruz
    final items = _selectedIngredients.toList();
    // Yumurta ve domates varsa menemen öner
    if (items.contains('Yumurta') && items.contains('Domates')) {
      // Yemek adını ayarla
      _nameController.text = 'Özel Köy Usulü Çakallı Menemeni';
      // Kalorisini ayarla
      _caloriesController.text = '290';
      // Hazırlanış adımlarını yazdır
      _stepsController.text =
          '1. Tavada tereyağını eritin ve biberleri soteleyin.\n2. İnce doğranmış domatesleri ekleyin, ezerek suyunu çektirin.\n3. Yumurtaları ve peyniri ekleyip kısık ateşte 3 dakika karıştırın.';
    } else if (items.contains('Tavuk Göğsü') && items.contains('Makarna')) {
      // Tavuk ve makarna varsa tavuklu makarna öner
      _nameController.text = 'Şefin Kremalı Tavuklu Makarnası';
      // Kalori değeri
      _caloriesController.text = '540';
      // Adımları doldur
      _stepsController.text =
          '1. Makarnayı bol tuzlu kaynar suda 9 dakika haşlayın.\n2. Tavuk parçalarını sarımsak ve baharatlarla yüksek ateşte soteleyin.\n3. Sosla makarnayı harmanlayıp sıcak servis edin.';
    } else {
      // Başka kombinasyonlar için jenerik şef tabağı oluştur
      _nameController.text = 'Şefin Özel ${items.first} Tabağı';
      // Ortalama kalori
      _caloriesController.text = '380';
      // Genel yemek hazırlama adımları
      _stepsController.text =
          '1. ${items.join(', ')} malzemelerini özenle yıkayıp doğrayın.\n2. Tavada zeytinyağı eşliğinde sırayla soteleyin.\n3. Baharatlarını ekleyip 10 dakika dinlendirerek servis yapın.';
    } // if-else sonu
    // Arayüzü güncelle
    setState(() {});
  } // _generateSmartChefDraft kapanışı

  /// 04.2. Masterchef Üretim Algoritması & Firestore Kaydı
  Future<void> _onCreateRecipe() async {
    // Tarif adını boşluklardan arındırıp alıyoruz
    final name = _nameController.text.trim();
    // Girilen kaloriyi sayıya çeviriyoruz, hata varsa 350 yapıyoruz
    final calories = int.tryParse(_caloriesController.text.trim()) ?? 350;
    // Hazırlanış adımlarını alıyoruz
    final steps = _stepsController.text.trim();

    // Yemek adı boş mu kontrolü
    if (name.isEmpty) {
      // Kullanıcıya uyarı mesajı göster
      ScaffoldMessenger.of(context).showSnackBar(
        // Bildirim çubuğu
        const SnackBar(content: Text('Lütfen yemeğinize bir isim verin.')),
      );
      // İşlemi durdur
      return;
    } // if sonu

    // Malzeme seçilmiş mi kontrolü
    if (_selectedIngredients.isEmpty) {
      // Uyarı mesajı
      ScaffoldMessenger.of(context).showSnackBar(
        // Bildirim çubuğu
        const SnackBar(content: Text('Lütfen en az bir malzeme seçin.')),
      );
      // İşlemi durdur
      return;
    } // if sonu

    // Kayıt başladı durumuna alıp arayüzü yeniliyoruz
    setState(() => _isSaving = true);

    // Yeni şef tarifi modelimizi oluşturuyoruz
    final newChefRecipe = ChefRecipeModel(
      // Benzersiz rastgele kimlik
      id: const Uuid().v4(),
      // Varsayılan kullanıcı kimliği
      userId: 'default_user',
      // Yemek adı
      name: name,
      // Seçilen malzemelerin listesi
      ingredients: _selectedIngredients.toList(),
      // Kalori değeri
      calories: calories,
      // Eğer adımlar boşsa varsayılan metin veriyoruz
      steps: steps.isNotEmpty
          ? steps
          : '1. Tüm malzemeleri özenle hazırlayın.\n2. Tavada pişirip sıcak servis edin.',
      // Oluşturulma tarihi şu an
      createdAt: DateTime.now(),
    ); // Model nesnesi sonu

    // Riverpod üzerinden veritabanı servisini okuyoruz
    final db = ref.read(databaseServiceProvider);
    // Veritabanına yeni şef tarifini kaydediyoruz
    await db.addChefRecipe(newChefRecipe);

    // Riverpod Stream Provider'larını yeniden tetikleyerek listeleri tazeliyoruz
    ref.invalidate(chefRecipesStreamProvider('default_user'));
    // Genel tarif listesini de güncelliyoruz
    ref.invalidate(recipesStreamProvider);

    // Widget ekrandan kaldırıldıysa devam etme kontrolü
    if (!mounted) return;
    // Kayıt işlemini tamamlandı durumuna alıyoruz
    setState(() => _isSaving = false);

    // Kullanıcıya başarı mesajı gösteriyoruz
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // Başarı metni
        content: Text('Tebrikler! "$name" Masterchef Menüsü\'ne eklendi.'),
        // Yeşil başarı rengi
        backgroundColor: AppColors.success,
        // Ekranda 4 saniye kalsın
        duration: const Duration(seconds: 4),
        // Havada asılı duran modern stil
        behavior: SnackBarBehavior.floating,
        // Köşeleri yuvarlatıyoruz
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ), // SnackBar kapanışı
    ); // showSnackBar kapanışı
    // Sayfadan önceki ekrana geri dönüyoruz
    Navigator.of(context).pop();
  } // _onCreateRecipe metodu kapanışı

  // Arayüzü inşa eden temel yapı
  @override
  Widget build(BuildContext context) {
    // Mevcut temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // İskelet widget'ı döndürüyoruz
    return Scaffold(
      // Üst uygulama çubuğu
      appBar: AppBar(
        // Başlık kısmı
        title: const Row(
          // İçeriği kadar yer kaplasın
          mainAxisSize: MainAxisSize.min,
          // Çubuk içeriği
          children: [
            // Restoran ikonu
            Icon(Icons.restaurant_rounded, color: AppColors.primary, size: 22),
            // İkon ile yazı arası boşluk
            SizedBox(width: 8),
            // Başlık yazısı
            Text('Masterchef Atölyesi'),
          ], // Başlık çocukları kapanışı
        ), // Row kapanışı
      ), // AppBar kapanışı
      // Güvenli alan widget'ı
      body: SafeArea(
        // Taşmaları önlemek için kaydırılabilir gövde
        child: SingleChildScrollView(
          // Kenar boşlukları
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          // Dikey sıralama kolonu
          child: Column(
            // Sola hizalama
            crossAxisAlignment: CrossAxisAlignment.start,
            // Kolon çocukları
            children: [
              // Üst Karşılama Kartı
              Container(
                // Genişliği tam ekran yayıyoruz
                width: double.infinity,
                // İç kenar boşluğu
                padding: const EdgeInsets.all(18),
                // Dekorasyon özellikleri
                decoration: BoxDecoration(
                  // Gradyan renk geçişi
                  gradient: const LinearGradient(
                    // Renkler
                    colors: [AppColors.primary, AppColors.primaryDark],
                    // Başlangıç noktası sol üst
                    begin: Alignment.topLeft,
                    // Bitiş noktası sağ alt
                    end: Alignment.bottomRight,
                  ), // Gradyan kapanışı
                  // Yuvarlak köşeler
                  borderRadius: BorderRadius.circular(20),
                ), // BoxDecoration kapanışı
                // Kart içeriği kolonu
                child: const Column(
                  // Sola hizala
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Çocuklar
                  children: [
                    // Kart başlığı
                    Text(
                      'Kendi Tarifini Yarat!',
                      // Stil özellikleri
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ), // TextStyle kapanışı
                    ), // Text kapanışı
                    // Yazılar arası boşluk
                    SizedBox(height: 6),
                    // Açıklama yazısı
                    Text(
                      'Dolabındaki malzemeleri seç, adımları yaz ve kendi özel şef menünü oluştur.',
                      // Stil özellikleri
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ), // Text kapanışı
                  ], // Kolon çocukları kapanışı
                ), // Column kapanışı
              ), // Container kapanışı
              // Araya dikey boşluk
              const SizedBox(height: 24),

              // 1. Adım: Malzeme Seçimi Başlığı
              Row(
                // İki uca yaslama
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Satır çocukları
                children: [
                  // Bölüm başlığı
                  Text(
                    '1. Malzemelerini Seç (${_selectedIngredients.length})',
                    // Stil özellikleri
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ), // TextStyle kapanışı
                  ), // Text kapanışı
                  // Akıllı taslak butonu
                  TextButton.icon(
                    // Sihirli değnek ikonu
                    icon: const Icon(Icons.auto_fix_high, size: 16),
                    // Buton etiketi
                    label: const Text('Akıllı Taslak', style: TextStyle(fontSize: 12)),
                    // Tıklanınca taslak oluştur
                    onPressed: _generateSmartChefDraft,
                  ), // TextButton kapanışı
                ], // Row çocukları kapanışı
              ), // Row kapanışı
              // Dikey boşluk
              const SizedBox(height: 8),
              // Malzeme etiketlerini saran esnek sarıcı widget
              Wrap(
                // Yatay boşluk
                spacing: 8,
                // Satırlar arası dikey boşluk
                runSpacing: 8,
                // Malzemeleri butonlara dönüştürüyoruz
                children: widget.availableIngredients.map((item) {
                  // Seçili mi kontrolü
                  final isSelected = _selectedIngredients.contains(item);
                  // Filtre çipi widget'ı
                  return FilterChip(
                    // Malzeme adı
                    label: Text(item),
                    // Seçili olma durumu
                    selected: isSelected,
                    // Seçilince arka plan rengi
                    selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
                    // Onay işareti rengi
                    checkmarkColor: AppColors.primary,
                    // Etiket yazı stili
                    labelStyle: TextStyle(
                      // Seçiliyse renk ana renk, değilse tema rengi
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? Colors.white70 : Colors.black87),
                      // Seçiliyse kalın yazı
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ), // TextStyle kapanışı
                    // Çip kenar çizgisi ve köşe şekli
                    shape: RoundedRectangleBorder(
                      // Yuvarlak kenarlar
                      borderRadius: BorderRadius.circular(12),
                      // Kenarlık çizgisi
                      side: BorderSide(
                        // Seçiliyse turuncu çizgi
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                      ), // BorderSide kapanışı
                    ), // RoundedRectangleBorder kapanışı
                    // Çipe tıklandığında çalışacak fonksiyon
                    onSelected: (selected) {
                      // Arayüzü yenile
                      setState(() {
                        // Eğer seçildiyse kümeye ekle
                        if (selected) {
                          _selectedIngredients.add(item);
                        } else {
                          // Seçim kaldırıldıysa kümeden sil
                          _selectedIngredients.remove(item);
                        } // if-else sonu
                      }); // setState sonu
                      // Taslağı anında güncelle
                      _generateSmartChefDraft();
                    }, // onSelected kapanışı
                  ); // FilterChip kapanışı
                }).toList(), // map ve toList kapanışı
              ), // Wrap kapanışı
              // Dikey boşluk
              const SizedBox(height: 24),

              // 2. Adım: Tarif Bilgileri Başlığı
              const Text(
                '2. Tarif Bilgileri',
                // Stil
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ), // TextStyle kapanışı
              ), // Text kapanışı
              // Dikey boşluk
              const SizedBox(height: 12),
              // Tarif Adı Giriş Kutusu
              CustomTextField(
                // Denetleyici
                controller: _nameController,
                // Alan etiketi
                label: 'Tarifinizin Adı',
                // İpucu metni
                hint: 'Örn: Şef Usulü Tavuklu Penne',
                // Sol ikon
                prefixIcon: Icons.menu_book_rounded,
              ), // CustomTextField kapanışı
              // Dikey boşluk
              const SizedBox(height: 16),
              // Kalori Miktarı Giriş Kutusu
              CustomTextField(
                // Denetleyici
                controller: _caloriesController,
                // Alan etiketi
                label: 'Tahmini Kalori (kcal)',
                // İpucu metni
                hint: 'Örn: 420',
                // Ateş ikonu
                prefixIcon: Icons.local_fire_department_rounded,
                // Sayısal klavye açsın
                keyboardType: TextInputType.number,
              ), // CustomTextField kapanışı
              // Dikey boşluk
              const SizedBox(height: 20),

              // 3. Adım: Pişirme Adımları Başlığı
              const Text(
                '3. Hazırlanış ve Pişirme Adımları',
                // Yazı stili
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ), // TextStyle kapanışı
              ), // Text kapanışı
              // Dikey boşluk
              const SizedBox(height: 12),
              // Adım Adım Tarif Giriş Alanı
              CustomTextField(
                // Denetleyici
                controller: _stepsController,
                // Alan etiketi
                label: 'Adım Adım Tarif',
                // İpucu metni
                hint: '1. Tavayı ısıtıp zeytinyağını ekleyin...\n2. Malzemeleri soteleyin...\n3. 15 dakika kısık ateşte pişirin.',
                // Çok satırlı giriş için satır sayısı
                maxLines: 5,
                // Liste numarası ikonu
                prefixIcon: Icons.format_list_numbered_rounded,
              ), // CustomTextField kapanışı
              // Dikey boşluk
              const SizedBox(height: 32),

              // Kaydet ve Üret Butonu
              CustomButton(
                // Yükleniyorsa başka yazı göster
                text: _isSaving ? 'Menüye Ekleniyor...' : 'Yemeği Üret & Şef Menüme Kaydet',
                // Sihirli parlama ikonu
                icon: Icons.auto_awesome,
                // Yüklenme durumu
                isLoading: _isSaving,
                // Buton rengi ana turuncu renk
                backgroundColor: AppColors.primary,
                // Tıklanınca tarifi kaydet
                onPressed: _onCreateRecipe,
              ), // CustomButton kapanışı
              // Alt kenar boşluğu
              const SizedBox(height: 20),
            ], // Kolon çocukları kapanışı
          ), // Column kapanışı
        ), // SingleChildScrollView kapanışı
      ), // SafeArea kapanışı
    ); // Scaffold kapanışı
  } // build metodu kapanışı
} // _MasterchefScreenState sınıfı kapanışı
