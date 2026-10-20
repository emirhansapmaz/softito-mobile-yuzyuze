// Asenkron gecikmeler ve zamanlayıcı (Timer) işlemleri için Dart asenkron kütüphanesini içe aktarıyoruz.
import 'dart:async';
// Flutter materyal arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Uygulama tema renklerini içe aktarıyoruz.
import '../../core/theme/app_colors.dart';
// Marka tipografik logosunu içe aktarıyoruz.
import '../../widgets/sem_logo.dart';
// Yönlendirilecek olan giriş ekranını içe aktarıyoruz.
import '../auth/login_screen.dart';

/// Uygulama ilk açıldığında gösterilen animasyonlu karşılama (Splash) ekranı.
class SplashScreen extends StatefulWidget {
  /// SplashScreen kurucu metodu (Constructor)
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// SplashScreen durum sınıfı: Animasyon kontrolcüsü için SingleTickerProviderStateMixin kullanır.
class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  /// Logo ve içerik animasyonunun süresini ve durumunu yöneten denetleyici
  late AnimationController _controller;
  
  /// Opaklık geçişi (Fade-in) animasyonu
  late Animation<double> _fadeAnimation;
  
  /// Boyut büyütme/esneme (Scale-in) animasyonu
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1.2 saniye sürecek animasyon denetleyicisini tanımlıyoruz.
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Opaklık animasyonu: 0'dan 1'e yumuşak geçiş (easeIn eğrisi)
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Boyut animasyonu: 0.85 ölçeğinden 1.0 tam boyutuna hafif yaylanma efektiyle (easeOutBack)
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Animasyonu ileri doğru başlatıyoruz.
    _controller.forward();
    
    // Belirlenen süre sonunda giriş ekranına yönlendirme fonksiyonunu çağırıyoruz.
    _navigateToNext();
  }

  /// 2.5 saniye sonra LoginScreen ekranına yumuşak geçiş (FadeTransition) ile geçiş yapan fonksiyon
  void _navigateToNext() {
    Timer(const Duration(milliseconds: 2500), () {
      // Widget ağaçtan çıkarılmışsa işlem yapmıyoruz (bellek sızıntısı önlemi).
      if (!mounted) return;
      // Geri dönüşü engelleyecek şekilde mevcut ekranı silip yerine LoginScreen'i koyuyoruz.
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Sayfalar arası geçişi saydamlık animasyonu ile yapıyoruz.
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    });
  }

  @override
  void dispose() {
    // Animasyon denetleyicisini bellekten temizliyoruz.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Koyu tema modunda mıyız sorguluyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // ==========================================
            // ARKA PLAN DEKORATİF GRADYAN DAİRELERİ
            // ==========================================
            // Sağ üst köşedeki hafif mavi ışıma efekti
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withValues(alpha: isDark ? 0.08 : 0.05),
                ),
              ),
            ),
            // Sol alt köşedeki hafif mavi ışıma efekti
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withValues(alpha: isDark ? 0.06 : 0.04),
                ),
              ),
            ),

            // ==========================================
            // MERKEZİ LOGO VE İKON ALANI (Animasyonlu)
            // ==========================================
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Araba simgesini içeren gölgeli dairesel kart
                      Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surfaceDarkElevated
                              : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryBlue.withValues(alpha: 0.18),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.directions_car_filled_rounded,
                          size: 54,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // SEM Auto Tipografik Logo ve alt slogan
                      const SemLogo(
                        fontSize: 40,
                        showSubtitle: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================
            // ALT YÜKLENME GÖSTERGESİ VE METİN
            // ==========================================
            Positioned(
              left: 0,
              right: 0,
              bottom: 48,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dönen mavi çember yükleniyor animasyonu
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.8,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Yükleniyor durum metni
                  Text(
                    'Araçlar hazırlanıyor...',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.textMutedDark
                          : AppColors.textMutedLight,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
