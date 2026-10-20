/// Kullanıcının sistemdeki rolünü/yetkisini temsil eden numaralandırma.
enum UserRole {
  /// Standart müşteri hesabı (araç kiralayabilir, rezervasyonları görebilir)
  customer,
  /// Yönetici hesabı (araç ekleyip düzenleyebilir, onay/ret işlemleri yapabilir)
  admin,
}

/// Sistemdeki kullanıcı (müşteri veya yönetici) profilini temsil eden veri modeli.
class User {
  /// Kullanıcının benzersiz kimliği (ID)
  final String id;
  
  /// Kullanıcının tam adı ve soyadı
  final String fullName;
  
  /// Giriş için kullanılan e-posta adresi
  final String email;
  
  /// Türkiye Cumhuriyeti Kimlik Numarası (11 haneli)
  final String tcNo;
  
  /// Sürücü belgesi / Ehliyet seri veya belge numarası
  final String drivingLicenseNo;
  
  /// Kullanıcının rolü (müşteri veya admin)
  final UserRole role;
  
  /// Yeni kimlik kartının NFC ile taranıp doğrulanıp doğrulanmadığını belirten bayrak
  final bool isNfcVerified;

  /// User kurucu metodu (Constructor)
  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.tcNo,
    required this.drivingLicenseNo,
    this.role = UserRole.customer,
    this.isNfcVerified = false,
  });

  /// Kullanıcının yönetici yetkisine sahip olup olmadığını kontrol eden pratik getter
  bool get isAdmin => role == UserRole.admin;

  /// Kullanıcı bilgilerinin kopyasını oluşturup istenilen alanları güncellemeye yarayan metot
  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? tcNo,
    String? drivingLicenseNo,
    UserRole? role,
    bool? isNfcVerified,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      tcNo: tcNo ?? this.tcNo,
      drivingLicenseNo: drivingLicenseNo ?? this.drivingLicenseNo,
      role: role ?? this.role,
      isNfcVerified: isNfcVerified ?? this.isNfcVerified,
    );
  }

  /// JSON verisini User nesnesine dönüştüren fabrika kurucu metot
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      tcNo: json['tcNo'] as String,
      drivingLicenseNo: json['drivingLicenseNo'] as String,
      // Rol metni 'admin' ise UserRole.admin, değilse UserRole.customer atıyoruz.
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.customer,
      // NFC doğrulama durumu belirtilmemişse varsayılan false kabul ediyoruz.
      isNfcVerified: json['isNfcVerified'] as bool? ?? false,
    );
  }

  /// User nesnesini JSON formatına dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'tcNo': tcNo,
      'drivingLicenseNo': drivingLicenseNo,
      // Rol değerini JSON için 'admin' veya 'customer' string değerine dönüştürüyoruz.
      'role': role == UserRole.admin ? 'admin' : 'customer',
      'isNfcVerified': isNfcVerified,
    };
  }
}
