import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  // Giriş Yap (Gecikme simülasyonu ile)
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 1.5 saniye gerçekçi ağ simülasyonu
    await Future.delayed(const Duration(milliseconds: 1500));

    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail == 'admin@semauto.com') {
      _currentUser = MockData.users.firstWhere((u) => u.role == UserRole.admin);
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      // Normal müşteri girişi
      final existingUser = MockData.users.cast<User?>().firstWhere(
            (u) => u?.email.toLowerCase() == normalizedEmail,
            orElse: () => null,
          );

      if (existingUser != null) {
        _currentUser = existingUser;
      } else {
        // Yeni bir müşteri oturumu oluştur
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
      _isLoading = false;
      notifyListeners();
      return true;
    }
  }

  // Kayıt Ol (Gecikme simülasyonu ile)
  Future<bool> register({
    required String fullName,
    required String email,
    required String tcNo,
    required String drivingLicenseNo,
    required String password,
    bool isNfcVerified = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // 1.5 saniye simülasyon
    await Future.delayed(const Duration(milliseconds: 1500));

    final newUser = User(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName.trim(),
      email: email.trim().toLowerCase(),
      tcNo: tcNo.trim(),
      drivingLicenseNo: drivingLicenseNo.trim(),
      role: UserRole.customer,
      isNfcVerified: isNfcVerified,
    );

    MockData.users.add(newUser);
    _currentUser = newUser;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
