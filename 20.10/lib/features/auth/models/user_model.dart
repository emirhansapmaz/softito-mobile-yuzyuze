// Değiştirilemezlik (immutable) kontrolü için temel flutter kütüphanesini içeri alıyoruz
import 'package:flutter/foundation.dart';
// Kullanıcı rolü numaralandırmasını içeri alıyoruz
import 'user_role.dart';

/// Yörünge Platformu - Kullanıcı Modeli
@immutable
class UserModel {
  // Kullanıcının benzersiz kimliği
  final String id;
  // Kullanıcının tam adı ve soyadı
  final String name;
  // Kullanıcının e-posta adresi
  final String email;
  // Kullanıcının sistemdeki rolü (Girişimci, Mentor, Yatırımcı)
  final UserRole role;
  // Profil fotoğrafı görsel bağlantı adresi
  final String avatarUrl;

  // UserModel kurucu metodu
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
  }); // Kurucu metod kapanışı

  // Belirli alanları güncelleyip yeni bir UserModel nesnesi üreten metot
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    UserRole? role,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    ); // UserModel dönüşü
  } // copyWith metodu kapanışı

  // JSON Map verisinden UserModel nesnesi oluşturan fabrika kurucu metot
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // ID alanını alıyoruz
      id: json['id'] as String? ?? '',
      // İsim alanını alıyoruz
      name: json['name'] as String? ?? '',
      // E-posta alanını alıyoruz
      email: json['email'] as String? ?? '',
      // Rol değerini enum ile eşleştiriyoruz
      role: UserRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => UserRole.entrepreneur,
      ), // firstWhere kapanışı
      // Profil fotoğrafını alıyoruz
      avatarUrl: json['avatarUrl'] as String? ?? '',
    ); // UserModel dönüşü
  } // fromJson fabrika metodu kapanışı

  // UserModel nesnesini JSON formatına dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'avatarUrl': avatarUrl,
    }; // Map dönüşü
  } // toJson metodu kapanışı

  // İki nesnenin eşitliğini kontrol eden eşitlik operatörü
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          email == other.email &&
          role == other.role &&
          avatarUrl == other.avatarUrl;

  // Nesnenin özet kodunu üreten getter
  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      email.hashCode ^
      role.hashCode ^
      avatarUrl.hashCode;
} // UserModel sınıfı kapanışı
