// Flutter durum yönetimi ve arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Sahte kullanıcı verilerini içeren MockData sınıfını içe aktarıyoruz.
import '../data/mock_data.dart';
// Kullanıcı veri modelini içe aktarıyoruz.
import '../models/user.dart';

/// Kullanıcı kimlik doğrulama, oturum açma, kayıt olma ve rol yönetimini sağlayan Provider sınıfı.
class AuthProvider extends ChangeNotifier {
  /// Şu anda oturum açmış olan kullanıcı (Giriş yapılmamışsa null)
  User? _currentUser;
  
  /// Giriş veya kayıt işlemi sırasında yükleniyor göstergesi için bayrak
  bool _isLoading = false;
  
  /// Hata durumunda gösterilecek hata mesajı metni
  String? _errorMessage;

  // ==========================================
  // GETTER'LAR (Dışa Açık Okuma Özellikleri)
  // ==========================================
  
  /// Aktif kullanıcı nesnesini döndürür.
  User? get currentUser => _currentUser;
  
  /// İşlem devam ediyor mu bilgisini döndürür.
  bool get isLoading => _isLoading;
  
  /// Varsa hata mesajını döndürür.
  String? get errorMessage => _errorMessage;
  
  /// Kullanıcının oturum açıp açmadığını kontrol eder.
  bool get isAuthenticated => _currentUser != null;
  
  /// Oturum açmış kullanıcının yönetici (admin) olup olmadığını döndürür.
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // ==========================================
  // GİRİŞ İŞLEMİ (Login)
  // ==========================================
  /// Kullanıcı e-posta ve şifresi ile oturum açma metodu (1.5 sn simüle gecikmeli)
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    // Yüklenme durumunu başlatıyoruz ve önceki hataları temizliyoruz.
    _isLoading = true;
    _errorMessage = null;
    // Dinleyicilere durum değişikliğini bildiriyoruz.
    notifyListeners();

    // Gerçekçi bir ağ isteği simülasyonu için 1.5 saniye bekletiyoruz.
    await Future.delayed(const Duration(milliseconds: 1500));

    // E-posta adresini boşluklardan arındırıp küçük harfe dönüştürüyoruz.
    final normalizedEmail = email.trim().toLowerCase();

    // Eğer girilen e-posta yönetici e-postası ise admin profilini atıyoruz.
    if (normalizedEmail == 'admin@semauto.com') {
      _currentUser = MockData.users.firstWhere((u) => u.role == UserRole.admin);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      // Normal müşteri girişi kontrolü: Mock listede eşleşen e-posta var mı?
      final existingUser = MockData.users.cast<User?>().firstWhere(
            (u) => u?.email.toLowerCase() == normalizedEmail,
            orElse: () => null,
          );

      if (existingUser != null) {
        // Sistemde kayıtlı kullanıcı bulunduysa oturumu açıyoruz.
        _currentUser = existingUser;
      } else {
        // Eşleşen kullanıcı yoksa yeni bir müşteri oturumu oluşturuyoruz.
        _currentUser = User(
          id: 'u_${DateTime.now().millisecondsSinceEpoch}',
          fullName: 'Değerli Müşteri',
          email: normalizedEmail,
          tcNo: '12345678901',
          drivingLicenseNo: 'TR-DRV-7788',
          role: UserRole.customer,
          isNfcVerified: true,
        );
      }
      // Yüklenme durumunu sonlandırıp arayüzü güncelliyoruz.
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  // ==========================================
  // KAYIT İŞLEMİ (Register)
  // ==========================================
  /// Yeni bir müşteri hesabı oluşturma ve oturum açma metodu
  Future<bool> register({
    required String fullName,
    required String email,
    required String tcNo,
    required String drivingLicenseNo,
    required String password,
    bool isNfcVerified = false,
  }) async {
    // Yükleniyor durumunu açıyoruz.
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 1.5 saniyelik sunucu kayıt işlemi simülasyonu
    await Future.delayed(const Duration(milliseconds: 1500));

    // Yeni kullanıcı nesnesi oluşturuyoruz.
    final newUser = User(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      tcNo: tcNo.trim(),
      drivingLicenseNo: drivingLicenseNo.trim(),
      role: UserRole.customer,
      isNfcVerified: isNfcVerified,
    );

    // Yeni kullanıcıyı sahte kullanıcı listesine ekliyoruz.
    MockData.users.add(newUser);
    // Aktif oturum olarak yeni kullanıcıyı ayarlıyoruz.
    _currentUser = newUser;
    // Yüklenme durumunu kapatıyoruz.
    _isLoading = false;
    // Değişikliği tüm dinleyen widget'lara haber veriyoruz.
    notifyListeners();
    return true;
  }

  // ==========================================
  // ÇIKIŞ İŞLEMİ (Logout)
  // ==========================================
  /// Mevcut kullanıcının oturumunu sonlandıran metot
  void logout() {
    // Aktif kullanıcıyı sıfırlıyoruz.
    _currentUser = null;
    // Değişikliği arayüze bildirerek oturum açma ekranına dönüş sağlıyoruz.
    notifyListeners();
  }
}
