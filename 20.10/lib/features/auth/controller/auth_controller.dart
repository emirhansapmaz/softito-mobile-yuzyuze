import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/mock_auth_data.dart';
import '../models/user_model.dart';
import '../models/user_role.dart';

/// Yörünge Platformu - Kimlik Doğrulama ve Rol Seçimi Denetleyicisi.
/// 1. Kural: Sadece foundation.dart ve shared_preferences import edilir.
class AuthController {
  static const String _userStorageKey = 'yorunge_current_user_v1';
  static AuthController? _instance;

  /// Paylaşılan tekil örnek
  static AuthController get instance => _instance ??= AuthController();

  /// Ekranda seçilen rolü tutan reaktif bildirimci (Varsayılan: Girişimci)
  final ValueNotifier<UserRole?> selectedRoleNotifier =
      ValueNotifier<UserRole?>(UserRole.entrepreneur);

  /// Başarılı giriş yapmış aktif kullanıcıyı tutan bildirimci
  final ValueNotifier<UserModel?> currentUserNotifier =
      ValueNotifier<UserModel?>(null);

  /// Giriş işlemi sırasında yükleniyor (spinner) durumunu tutan bildirimci
  final ValueNotifier<bool> isLoadingNotifier = ValueNotifier<bool>(false);

  AuthController() {
    checkSavedUser();
  }

  /// Aktif seçili rol
  UserRole? get selectedRole => selectedRoleNotifier.value;

  /// Aktif giriş yapmış kullanıcı
  UserModel? get currentUser => currentUserNotifier.value;

  /// Kullanıcı oturum açmış mı?
  bool get isAuthenticated => currentUserNotifier.value != null;

  /// Rol seçimi yapma
  void selectRole(UserRole role) {
    selectedRoleNotifier.value = role;
  }

  /// Giriş yapma simülasyonu
  Future<bool> login(String email, String password) async {
    isLoadingNotifier.value = true;

    // 1 saniyelik ağ gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 1000));

    final targetRole = selectedRoleNotifier.value ?? UserRole.entrepreneur;

    // Email veya seçili role göre uygun mock kullanıcıyı bul
    final user = kMockUsers.firstWhere(
      (u) =>
          u.email.toLowerCase() == email.trim().toLowerCase() ||
          u.role == targetRole,
      orElse: () => kMockUsers.first,
    );

    currentUserNotifier.value = user;
    isLoadingNotifier.value = false;

    // Kullanıcıyı yerel belleğe kaydet
    await _saveUserToPrefs(user);
    return true;
  }

  /// Çıkış yapma ve oturum temizleme
  Future<void> logout() async {
    currentUserNotifier.value = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userStorageKey);
    } catch (e) {
      debugPrint('Kullanıcı çıkışı sırasında hata: $e');
    }
  }

  /// Başlangıçta kayıtlı oturumu kontrol etme
  Future<void> checkSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userStorageKey);
      if (userJson != null && userJson.isNotEmpty) {
        final Map<String, dynamic> decoded =
            jsonDecode(userJson) as Map<String, dynamic>;
        currentUserNotifier.value = UserModel.fromJson(decoded);
      }
    } catch (e) {
      debugPrint('Kayıtlı kullanıcı kontrolünde hata: $e');
    }
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userStorageKey, jsonEncode(user.toJson()));
    } catch (e) {
      debugPrint('Kullanıcı kaydedilirken hata: $e');
    }
  }

  /// Bildirimcileri bellekten temizler
  void dispose() {
    selectedRoleNotifier.dispose();
    currentUserNotifier.dispose();
    isLoadingNotifier.dispose();
  }
}
