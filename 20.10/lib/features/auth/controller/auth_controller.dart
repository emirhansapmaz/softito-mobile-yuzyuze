// JSON kodlama ve çözme işlemleri için dart:convert kütüphanesini içeri alıyoruz
import 'dart:convert';
// Temel bildirimciler ve ValueNotifier için foundation kütüphanesini içeri alıyoruz
import 'package:flutter/foundation.dart';
// Yerel cihaz hafızasında oturum saklamak için SharedPreferences paketini içeri alıyoruz
import 'package:shared_preferences/shared_preferences.dart';
// Sahte mock kullanıcı verilerini içeri alıyoruz
import '../data/mock_auth_data.dart';
// Kullanıcı model sınıfını içeri alıyoruz
import '../models/user_model.dart';
// Kullanıcı rolleri numaralandırmasını içeri alıyoruz
import '../models/user_role.dart';

/// Yörünge Platformu - Kimlik Doğrulama ve Rol Seçimi Denetleyicisi.
/// 1. Kural: Sadece foundation.dart ve shared_preferences import edilir.
class AuthController {
  // Cihaz hafızasındaki oturum anahtar kelimesi
  static const String _userStorageKey = 'yorunge_current_user_v1';
  // Singleton tekil nesne referansı
  static AuthController? _instance;

  /// Paylaşılan tekil örnek (Singleton getter)
  static AuthController get instance => _instance ??= AuthController();

  /// Ekranda seçilen rolü tutan reaktif bildirimci (Varsayılan: Girişimci)
  final ValueNotifier<UserRole?> selectedRoleNotifier =
      ValueNotifier<UserRole?>(UserRole.entrepreneur);

  /// Başarılı giriş yapmış aktif kullanıcıyı tutan bildirimci
  final ValueNotifier<UserModel?> currentUserNotifier =
      ValueNotifier<UserModel?>(null);

  /// Giriş işlemi sırasında yükleniyor (spinner) durumunu tutan bildirimci
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

  // Kurucu metodumuz, çalışır çalışmaz kayıtlı kullanıcıyı kontrol eder
  AuthController() {
    // Kayıtlı oturum var mı tara
    checkSavedUser();
  } // Kurucu metod kapanışı

  /// Aktif seçili rolü okuyan getter
  UserRole? get selectedRole => selectedRoleNotifier.value;

  /// Aktif giriş yapmış kullanıcı nesnesini okuyan getter
  UserModel? get currentUser => currentUserNotifier.value;

  /// Kullanıcının oturum açıp açmadığını bildiren mantıksal getter
  bool get isAuthenticated => currentUserNotifier.value != null;

  /// Kullanıcı rolü seçimi yapma fonksiyonu
  void selectRole(UserRole role) {
    // Seçilen rolü bildirimciye ata
    selectedRoleNotifier.value = role;
  } // selectRole metodu kapanışı

  /// Giriş yapma simülasyonu fonksiyonu
  Future<bool> login(String email, String password) async {
    // Yüklenme durumunu true yap
    isLoadingNotifier.value = true;

    // 1 saniyelik ağ gecikmesi simülasyonu yapıyoruz
    await Future.delayed(const Duration(milliseconds: 1000));

    // Hedef rolü al
    final targetRole = selectedRoleNotifier.value ?? UserRole.entrepreneur;

    // E-posta veya seçili role göre uygun mock kullanıcıyı bul
    final user = kMockUsers.firstWhere(
      (u) =>
          u.email.toLowerCase() == email.trim().toLowerCase() ||
          u.role == targetRole,
      orElse: () => kMockUsers.first,
    ); // firstWhere kapanışı

    // Kullanıcıyı aktif kullanıcı olarak ata
    currentUserNotifier.value = user;
    // Yüklenme durumunu kapat
    isLoadingNotifier.value = false;

    // Kullanıcıyı yerel belleğe kaydet
    await _saveUserToPrefs(user);
    // Başarılı döndür
    return true;
  } // login metodu kapanışı

  /// Çıkış yapma ve oturum temizleme fonksiyonu
  Future<void> logout() async {
    // Aktif kullanıcıyı sıfırla
    currentUserNotifier.value = null;
    try {
      // SharedPreferences örneğini al
      final prefs = await SharedPreferences.getInstance();
      // Kayıtlı kullanıcı bilgisini sil
      await prefs.remove(_userStorageKey);
    } catch (e) {
      // Hata oluşursa konsola yaz
      debugPrint('Kullanıcı çıkışı sırasında hata: $e');
    } // catch sonu
  } // logout metodu kapanışı

  /// Başlangıçta kayıtlı oturumu kontrol etme fonksiyonu
  Future<void> checkSavedUser() async {
    try {
      // Cihaz hafızasını aç
      final prefs = await SharedPreferences.getInstance();
      // Saklanan kullanıcı JSON metnini oku
      final userJson = prefs.getString(_userStorageKey);
      // Eğer veri varsa
      if (userJson != null && userJson.isNotEmpty) {
        // JSON'ı Map'e dönüştür
        final Map<String, dynamic> decoded =
            jsonDecode(userJson) as Map<String, dynamic>;
        // Modeli ayağa kaldırıp bildirimciye ver
        currentUserNotifier.value = UserModel.fromJson(decoded);
      } // if sonu
    } catch (e) {
      // Hata durumunda konsola yazdır
      debugPrint('Kayıtlı kullanıcı kontrolünde hata: $e');
    } // catch sonu
  } // checkSavedUser metodu kapanışı

  // Kullanıcı modelini JSON olarak hafızaya yazan yardımcı metot
  Future<void> _saveUserToPrefs(UserModel user) async {
    try {
      // Hafıza nesnesini al
      final prefs = await SharedPreferences.getInstance();
      // JSON olarak kaydet
      await prefs.setString(_userStorageKey, jsonEncode(user.toJson()));
    } catch (e) {
      // Hata konsola bas
      debugPrint('Kullanıcı kaydedilirken hata: $e');
    } // catch sonu
  } // _saveUserToPrefs metodu kapanışı

  /// Bildirimcileri bellekten temizleme metodu
  void dispose() {
    // Rol bildirimcisini kapat
    selectedRoleNotifier.dispose();
    // Kullanıcı bildirimcisini kapat
    currentUserNotifier.dispose();
    // Yükleniyor bildirimcisini kapat
    isLoadingNotifier.dispose();
  } // dispose metodu kapanışı
} // AuthController sınıfı kapanışı
