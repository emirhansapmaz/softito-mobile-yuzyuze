enum UserRole {
  customer,
  admin,
}

class User {
  final String id;
  final String fullName;
  final String email;
  final String tcNo;
  final String drivingLicenseNo;
  final UserRole role;
  final bool isNfcVerified;

  const User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.tcNo,
    required this.drivingLicenseNo,
    this.role = UserRole.customer,
    this.isNfcVerified = false,
  });

  bool get isAdmin => role == UserRole.admin;

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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      tcNo: json['tcNo'] as String,
      drivingLicenseNo: json['drivingLicenseNo'] as String,
      role: json['role'] == 'admin' ? UserRole.admin : UserRole.customer,
      isNfcVerified: json['isNfcVerified'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'tcNo': tcNo,
      'drivingLicenseNo': drivingLicenseNo,
      'role': role == UserRole.admin ? 'admin' : 'customer',
      'isNfcVerified': isNfcVerified,
    };
  }
}
