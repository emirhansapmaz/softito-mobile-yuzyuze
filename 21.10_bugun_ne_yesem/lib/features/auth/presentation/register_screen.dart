// Flutter Material temel bileşenler kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Riverpod tüketici widget'larını kullanabilmek için gerekli kütüphane
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';
// Ortak buton bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/custom_button.dart';
// Ortak metin giriş kutusu bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/custom_text_field.dart';
// Kayıt tamamlandığında yönlendirilecek ana iskelet ekranı
import '../../home/presentation/main_scaffold_screen.dart';

// Yeni kullanıcı hesabı oluşturma ekranı bileşeni
class RegisterScreen extends ConsumerStatefulWidget {
  // RegisterScreen sınıfının değişmez kurucu metodu
  const RegisterScreen({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (State) yöneticisini bağlayan metot
  @override
  // ConsumerState nesnesi döndürüyoruz
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
// RegisterScreen sınıfının kapanış parantezi
}

// Kayıt ekranındaki form alanlarını ve kayıt işlemini yöneten State sınıfımız
class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  // Ad Soyad metin giriş kutusu kontrolcüsü
  final _nameController = TextEditingController();
  // E-posta metin giriş kutusu kontrolcüsü
  final _emailController = TextEditingController();
  // Telefon numarası metin giriş kutusu kontrolcüsü
  final _phoneController = TextEditingController();
  // Şifre metin giriş kutusu kontrolcüsü
  final _passwordController = TextEditingController();
  // Kolay giriş şifre ipucu kutusu kontrolcüsü
  final _hintController = TextEditingController();
  // Şifreyi gizleme/gösterme bayrağı
  bool _obscurePassword = true;

  // Bellek sızıntısını önlemek için kontrolcüleri temizleyen yaşam döngüsü metodu
  @override
  // dispose gövdesi
  void dispose() {
    // Ad soyad kontrolcüsünü temizliyoruz
    _nameController.dispose();
    // E-posta kontrolcüsünü temizliyoruz
    _emailController.dispose();
    // Telefon kontrolcüsünü temizliyoruz
    _phoneController.dispose();
    // Şifre kontrolcüsünü temizliyoruz
    _passwordController.dispose();
    // İpucu kontrolcüsünü temizliyoruz
    _hintController.dispose();
    // Üst sınıfın dispose metodunu çağırıyoruz
    super.dispose();
  // dispose metodunun kapanış parantezi
  }

  // Kayıt ol butonuna tıklandığında çalışan yönlendirme fonksiyonumuz
  void _onRegister() {
    // Tüm geçmiş sayfaları temizleyerek doğrudan ana sayfaya yönlendiriyoruz
    Navigator.of(context).pushAndRemoveUntil(
      // Sayfa rotası
      MaterialPageRoute(
        // Ana iskelet ekranı
        builder: (_) => const MainScaffoldScreen(),
      // MaterialPageRoute kapanışı
      ),
      // Geriye dönülmesini engellemek için false dönüyoruz
      (route) => false,
    // pushAndRemoveUntil kapanışı
    );
  // _onRegister metodunun kapanış parantezi
  }

  // Ekranın görsel ağacını inşa eden build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Temanın koyu modda olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sayfanın temel iskeleti
    return Scaffold(
      // Üst başlık çubuğu
      appBar: AppBar(
        // Başlık metni
        title: const Text('Hesap Oluştur'),
      // AppBar kapanışı
      ),
      // Ekran çentiğinin altına taşmayı önleyen SafeArea
      body: SafeArea(
        // Klavye açılınca taşmayı önleyen kaydırılabilir liste
        child: SingleChildScrollView(
          // Yatayda 24, dikeyde 16 piksel kenar boşluğu
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          // Form elemanlarını alt alta dizen Column
          child: Column(
            // Elemanları sola yaslıyoruz
            crossAxisAlignment: CrossAxisAlignment.start,
            // Sütun elemanları listesi
            children: [
              // Karşılama başlık metni
              Text(
                // Metin içeriği
                'Aramıza Hoş Geldin!',
                // Başlık stili
                style: const TextStyle(
                  // 24 punto boyut
                  fontSize: 24,
                  // Kalın font
                  fontWeight: FontWeight.bold,
                // TextStyle kapanışı
                ),
              // Text kapanışı
              ),
              // 6 piksel dikey boşluk
              const SizedBox(height: 6),

              // Açıklama metni
              Text(
                // Açıklama içeriği
                'Kişisel mutfak asistanını oluşturmak için bilgilerini doldur.',
                // Açıklama stili
                style: TextStyle(
                  // 14 punto boyut
                  fontSize: 14,
                  // Temaya göre ikincil metin rengi
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                // TextStyle kapanışı
                ),
              // Text kapanışı
              ),
              // 24 piksel dikey boşluk
              const SizedBox(height: 24),

              // Ad Soyad Metin Giriş Kutusu
              CustomTextField(
                // Kontrolcü
                controller: _nameController,
                // Etiket
                label: 'Ad Soyad',
                // İpucu
                hint: 'Örn: Ahmet Yılmaz',
                // Kişi ikonu
                prefixIcon: Icons.person_outline_rounded,
              // CustomTextField kapanışı
              ),
              // 16 piksel dikey boşluk
              const SizedBox(height: 16),

              // E-posta Metin Giriş Kutusu
              CustomTextField(
                // Kontrolcü
                controller: _emailController,
                // Etiket
                label: 'E-posta Adresi',
                // İpucu
                hint: 'ahmet@email.com',
                // E-posta ikonu
                prefixIcon: Icons.email_outlined,
                // Klavye türü
                keyboardType: TextInputType.emailAddress,
              // CustomTextField kapanışı
              ),
              // 16 piksel dikey boşluk
              const SizedBox(height: 16),

              // Telefon Numarası Metin Giriş Kutusu
              CustomTextField(
                // Kontrolcü
                controller: _phoneController,
                // Etiket
                label: 'Telefon Numarası',
                // İpucu
                hint: '+90 5XX XXX XX XX',
                // Telefon ikonu
                prefixIcon: Icons.phone_outlined,
                // Sayısal klavye türü
                keyboardType: TextInputType.phone,
              // CustomTextField kapanışı
              ),
              // 16 piksel dikey boşluk
              const SizedBox(height: 16),

              // Şifre Metin Giriş Kutusu
              CustomTextField(
                // Kontrolcü
                controller: _passwordController,
                // Etiket
                label: 'Şifre',
                // İpucu
                hint: 'En az 6 karakter',
                // Kilit ikonu
                prefixIcon: Icons.lock_outline_rounded,
                // Şifre gizleme durumu
                obscureText: _obscurePassword,
                // Göz göster/gizle ikonu
                suffixIcon: IconButton(
                  // İkon tipi
                  icon: Icon(
                    // Duruma göre göz ikonu
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    // Gri renk
                    color: Colors.grey,
                  // Icon kapanışı
                  ),
                  // Tıklandığında şifre görünürlüğünü tersine çeviriyoruz
                  onPressed: () {
                    // Durumu yeniliyoruz
                    setState(() {
                      // Gizleme bayrağını tersine çeviriyoruz
                      _obscurePassword = !_obscurePassword;
                    // setState kapanışı
                    });
                  // onPressed kapanışı
                  },
                // IconButton kapanışı
                ),
              // CustomTextField kapanışı
              ),
              // 20 piksel dikey boşluk
              const SizedBox(height: 20),

              // Kolay Giriş / Şifre İpucu Bölüm Kutusu
              Container(
                // Her yönden 16 piksel iç boşluk
                padding: const EdgeInsets.all(16),
                // Kutunun yeşilimsi çerçeveli dekorasyonu
                decoration: BoxDecoration(
                  // Yüzde 8 şeffaf yeşil arka plan
                  color: AppColors.primary.withValues(alpha: 0.08),
                  // 16 piksel yuvarlatma
                  borderRadius: BorderRadius.circular(16),
                  // İnce yeşil çerçeve çizgisi
                  border: Border.all(
                    // Yüzde 20 şeffaf yeşil kenarlık
                    color: AppColors.primary.withValues(alpha: 0.2),
                  // Border.all kapanışı
                  ),
                // BoxDecoration kapanışı
                ),
                // İçerikleri alt alta dizen Column
                child: Column(
                  // Sola hizalama
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Elemanlar listesi
                  children: [
                    // Ampul ikonu ve başlık satırı
                    const Row(
                      // Satır elemanları listesi
                      children: [
                        // Ampul simgesi
                        Icon(
                          // Ampul ikonu
                          Icons.lightbulb_outline_rounded,
                          // Yeşil renk
                          color: AppColors.primary,
                          // 20 piksel boyut
                          size: 20,
                        // Icon kapanışı
                        ),
                        // 8 piksel yatay boşluk
                        SizedBox(width: 8),
                        // Bölüm başlığı
                        Text(
                          // Başlık metni
                          'Kolay Giriş & Şifre İpucu (Özel)',
                          // Başlık stili
                          style: TextStyle(
                            // Kalın font
                            fontWeight: FontWeight.bold,
                            // 14 punto boyut
                            fontSize: 14,
                            // Yeşil renk
                            color: AppColors.primary,
                          // TextStyle kapanışı
                          ),
                        // Text kapanışı
                        ),
                      // Row çocukları kapanışı
                      ],
                    // Row kapanışı
                    ),
                    // 8 piksel dikey boşluk
                    const SizedBox(height: 8),

                    // İpucu bilgilendirme metni
                    Text(
                      // Açıklama içeriği
                      'Şifreni unutursan sana hatırlatacak bir kelime veya ipucu belirleyebilirsin.',
                      // Stil
                      style: TextStyle(
                        // 12 punto boyut
                        fontSize: 12,
                        // Temaya göre ikincil metin rengi
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      // TextStyle kapanışı
                      ),
                    // Text kapanışı
                    ),
                    // 12 piksel dikey boşluk
                    const SizedBox(height: 12),

                    // İpucu Metin Kutusu
                    CustomTextField(
                      // Kontrolcü
                      controller: _hintController,
                      // Etiket
                      label: 'Şifre İpucun (Opsiyonel)',
                      // İpucu örneği
                      hint: 'Örn: İlk evcil hayvanımın adı, memleketim...',
                      // Yardım soru ikonu
                      prefixIcon: Icons.help_outline_rounded,
                    // CustomTextField kapanışı
                    ),
                  // Column çocukları kapanışı
                  ],
                // Column kapanışı
                ),
              // Container kapanışı
              ),
              // 28 piksel dikey boşluk
              const SizedBox(height: 28),

              // Kayıt Ol Ana Butonu
              CustomButton(
                // Buton metni
                text: 'Kayıt Ol',
                // Onay işareti ikonu
                icon: Icons.check_circle_outline_rounded,
                // Kayıt fonksiyonunu tetikliyoruz
                onPressed: _onRegister,
              // CustomButton kapanışı
              ),
              // 24 piksel dikey boşluk
              const SizedBox(height: 24),
            // Column çocukları kapanışı
            ],
          // Column kapanışı
          ),
        // SingleChildScrollView kapanışı
        ),
      // SafeArea kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _RegisterScreenState sınıfının kapanış parantezi
}
