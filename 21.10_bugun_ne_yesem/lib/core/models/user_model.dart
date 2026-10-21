class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? passwordHint; // Kolay giriş için ipucu metni veya görsel linki

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.phone = '',
    this.passwordHint,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'passwordHint': passwordHint,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return UserModel(
      uid: documentId ?? map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      passwordHint: map['passwordHint'] as String?,
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? passwordHint,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      passwordHint: passwordHint ?? this.passwordHint,
    );
  }
}
