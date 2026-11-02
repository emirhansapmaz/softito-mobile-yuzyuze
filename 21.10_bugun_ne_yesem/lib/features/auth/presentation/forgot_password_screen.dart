// Flutter Material arayüz bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Riverpod tüketici widget'larını kullanabilmek için gerekli paket
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../../core/theme/app_colors.dart';
// Ortak buton bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/custom_button.dart';
// Ortak metin giriş kutusu bileşenimizi içe aktarıyoruz
import '../../../shared/widgets/custom_text_field.dart';

// Şifre sıfırlama ve kolay giriş ipucunu sorgulama ekranı bileşeni
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  // ForgotPasswordScreen sınıfının değişmez kurucu metodu
  const ForgotPasswordScreen({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (State) yöneticisini bağlayan metot
  @override
  // ConsumerState nesnesi döndürüyoruz
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
// ForgotPasswordScreen sınıfının kapanış parantezi
}

// Şifre sıfırlama mantığını ve ipucu getirme sürecini yöneten State sınıfımız
class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  // E-posta metin giriş kutusu kontrolcüsü
  final _emailController = TextEditingController();
  // Yeni şifre metin giriş kutusu kontrolcüsü
  final _newPasswordController = TextEditingController();
  // Yeni şifre onay kutusu kontrolcüsü
  final _confirmPasswordController = TextEditingController();
  // Sunucudan veya hafızadan çekilen şifre ipucu metni
  String? _retrievedHint;
  // İpucu sorgulanırken yükleme animasyonunu takip eden bayrak
  bool _isLoadingHint = false;

  // Bellek sızıntısını önlemek için kontrolcüleri temizleyen dispose metodu
  @override
  // dispose gövdesi
  void dispose() {
    // E-posta kontrolcüsünü temizliyoruz
    _emailController.dispose();
    // Yeni şifre kontrolcüsünü temizliyoruz
    _newPasswordController.dispose();
    // Şifre tekrar kontrolcüsünü temizliyoruz
    _confirmPasswordController.dispose();
    // Üst sınıfın dispose metodunu çağırıyoruz
    super.dispose();
  // dispose metodunun kapanış parantezi
  }

  // Girilen e-posta adresine kayıtlı kolay giriş ipucunu getiren fonksiyon
  void _lookupHint() {
    // E-posta metnini okuyup boşluklarını temizliyoruz
    final email = _emailController.text.trim();
    // E-posta alanı boşsa kullanıcıyı uyarıyoruz
    if (email.isEmpty) {
      // Ekrana SnackBar uyarı mesajı basıyoruz
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar bileşeni
        const SnackBar(content: Text('Lütfen önce e-posta adresinizi giriniz.')),
      // showSnackBar kapanışı
      );
      // Fonksiyondan çıkıyoruz
      return;
    // if kontrolü kapanışı
    }

    // Yükleme durumunu başlatıyoruz
    setState(() => _isLoadingHint = true);
    // 600 milisaniye ağ gecikmesi taklidi yapıyoruz
    Future.delayed(const Duration(milliseconds: 600), () {
      // Widget ekrandan çıktıysa işlem yapmıyoruz
      if (!mounted) return;
      // İpucunu ekrana yansıtmak için durumu güncelliyoruz
      setState(() {
        // Yüklemeyi kapatıyoruz
        _isLoadingHint = false;
        // Örnek ipucunu değişkene atıyoruz
        _retrievedHint = 'İpucu: İlk evcil hayvanınızın adı (Örn: pamuk)';
      // setState kapanışı
      });
    // Future.delayed kapanışı
    });
  // _lookupHint metodunun kapanış parantezi
  }

  // Şifre sıfırlama butonuna basıldığında çalışan fonksiyon
  void _onResetPassword() {
    // Kullanıcıya başarılı bildirim SnackBar'ı gösteriyoruz
    ScaffoldMessenger.of(context).showSnackBar(
      // SnackBar bileşeni
      const SnackBar(
        // Başarı metni
        content: Text('Şifre sıfırlama bağlantısı e-posta adresinize gönderildi!'),
        // Yeşil başarı arka plan rengi
        backgroundColor: AppColors.success,
      // SnackBar kapanışı
      ),
    // showSnackBar kapanışı
    );
    // Bir önceki ekrana geri dönüyoruz
    Navigator.of(context).pop();
  // _onResetPassword metodunun kapanış parantezi
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
        title: const Text('Şifremi Unuttum'),
      // AppBar kapanışı
      ),
      // Çentiğin altına taşmayı önleyen SafeArea
      body: SafeArea(
        // Kaydırılabilir içerik gövdesi
        child: SingleChildScrollView(
          // Kenar boşlukları
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          // Form elemanlarını alt alta dizen Column
          child: Column(
            // Elemanları sola hizalıyoruz
            crossAxisAlignment: CrossAxisAlignment.start,
            // Sütun elemanları listesi
            children: [
              // Başlık metni
              const Text(
                // Başlık içeriği
                'Şifre Yenileme & Kolay Giriş',
                // Başlık stili
                style: TextStyle(
                  // 22 punto boyut
                  fontSize: 22,
                  // Kalın font
                  fontWeight: FontWeight.bold,
                // TextStyle kapanışı
                ),
              // Text kapanışı
              ),
              // 8 piksel dikey boşluk
              const SizedBox(height: 8),

              // Bilgilendirici açıklama metni
              Text(
                // Açıklama içeriği
                'Hesabına ait e-posta adresini girerek şifreni sıfırlayabilir veya önceden belirlediğin kolay giriş ipucunu görüntüleyebilirsin.',
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
              // 28 piksel dikey boşluk
              const SizedBox(height: 28),

              // Kayıtlı E-posta Metin Giriş Kutusu
              CustomTextField(
                // Kontrolcü
                controller: _emailController,
                // Etiket
                label: 'Kayıtlı E-posta Adresi',
                // İpucu
                hint: 'ornek@email.com',
                // E-posta ikonu
                prefixIcon: Icons.email_outlined,
                // E-posta klavye türü
                keyboardType: TextInputType.emailAddress,
              // CustomTextField kapanışı
              ),
              // 12 piksel dikey boşluk
              const SizedBox(height: 12),

              // Kolay Giriş İpucu Kartı Kutusu
              Container(
                // Genişliği tam yayıyoruz
                width: double.infinity,
                // 16 piksel iç boşluk
                padding: const EdgeInsets.all(16),
                // Yeşil çerçeveli kutu dekorasyonu
                decoration: BoxDecoration(
                  // Yüzde 8 şeffaf yeşil arka plan
                  color: AppColors.primary.withValues(alpha: 0.08),
                  // 16 piksel yuvarlatma
                  borderRadius: BorderRadius.circular(16),
                  // Çerçeve çizgisi
                  border: Border.all(
                    // Yüzde 25 şeffaf yeşil kenarlık
                    color: AppColors.primary.withValues(alpha: 0.25),
                  // Border.all kapanışı
                  ),
                // BoxDecoration kapanışı
                ),
                // İçerikleri alt alta dizen Column
                child: Column(
                  // Sola yaslama
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Elemanlar listesi
                  children: [
                    // İpucu başlığı ve buton satırı
                    Row(
                      // İki uca yaslama
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // Satır elemanları listesi
                      children: [
                        // Ampul ikonu ve başlık
                        const Row(
                          // Elemanlar
                          children: [
                            // Ampul simgesi
                            Icon(
                              // Ampul ikonu
                              Icons.lightbulb_rounded,
                              // Yeşil renk
                              color: AppColors.primary,
                              // 20 piksel boyut
                              size: 20,
                            // Icon kapanışı
                            ),
                            // 8 piksel boşluk
                            SizedBox(width: 8),
                            // Başlık metni
                            Text(
                              // Metin içeriği
                              'Kolay Giriş İpucu',
                              // Stil
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
                        // İpucunu Getir Butonu
                        TextButton(
                          // Yükleniyorsa pasif, değilse sorgu fonksiyonunu tetikliyoruz
                          onPressed: _isLoadingHint ? null : _lookupHint,
                          // Yükleniyorsa dönen animasyon, değilse metin
                          child: _isLoadingHint
                              // Yükleme kutucuğu
                              ? const SizedBox(
                                  // Genişlik 14 piksel
                                  width: 14,
                                  // Yükseklik 14 piksel
                                  height: 14,
                                  // 2 piksel çizgi kalınlığı
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                // SizedBox kapanışı
                                )
                              // Normal buton metni
                              : const Text('İpucumu Getir'),
                        // TextButton kapanışı
                        ),
                      // Row çocukları kapanışı
                      ],
                    // Row kapanışı
                    ),
                    // Eğer ipucu geldiyse ekranda gösteriyoruz
                    if (_retrievedHint != null) ...[
                      // 20 piksel yükseklikte ayırıcı çizgi
                      const Divider(height: 20),
                      // İpucu metni
                      Text(
                        // İpucu içeriği
                        _retrievedHint!,
                        // Stil özellikleri
                        style: const TextStyle(
                          // 13 punto boyut
                          fontSize: 13,
                          // Yarı kalın font
                          fontWeight: FontWeight.w600,
                          // Koyu yeşil renk
                          color: AppColors.primaryDark,
                        // TextStyle kapanışı
                        ),
                      // Text kapanışı
                      ),
                    ],
                  // Column çocukları kapanışı
                  ],
                // Column kapanışı
                ),
              // Container kapanışı
              ),
              // 24 piksel dikey boşluk
              const SizedBox(height: 24),

              // Yeni Şifre Metin Giriş Kutusu
              CustomTextField(
                // Kontrolcü
                controller: _newPasswordController,
                // Etiket
                label: 'Yeni Şifre',
                // İpucu
                hint: '••••••••',
                // Şifre yenileme ikonu
                prefixIcon: Icons.lock_reset_rounded,
                // Şifreyi gizliyoruz
                obscureText: true,
              // CustomTextField kapanışı
              ),
              // 16 piksel dikey boşluk
              const SizedBox(height: 16),

              // Yeni Şifre Tekrar Metin Giriş Kutusu
              CustomTextField(
                // Kontrolcü
                controller: _confirmPasswordController,
                // Etiket
                label: 'Yeni Şifre (Tekrar)',
                // İpucu
                hint: '••••••••',
                // Kilit ikonu
                prefixIcon: Icons.lock_reset_rounded,
                // Şifreyi gizliyoruz
                obscureText: true,
              // CustomTextField kapanışı
              ),
              // 28 piksel dikey boşluk
              const SizedBox(height: 28),

              // Şifreyi Güncelle ve Sıfırla Butonu
              CustomButton(
                // Buton metni
                text: 'Şifreyi Güncelle & Sıfırla',
                // Gönder uçak ikonu
                icon: Icons.send_rounded,
                // Tıklama olayını bağlıyoruz
                onPressed: _onResetPassword,
              // CustomButton kapanışı
              ),
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
// _ForgotPasswordScreenState sınıfının kapanış parantezi
}
