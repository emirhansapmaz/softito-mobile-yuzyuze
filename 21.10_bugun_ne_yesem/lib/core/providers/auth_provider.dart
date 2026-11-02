// Firebase Kimlik Doğrulama User tipini içe aktarıyoruz
import 'package:firebase_auth/firebase_auth.dart';
// Riverpod reaktif durum yönetimi paketini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Kullanıcı profil modelini içe aktarıyoruz
import '../models/user_model.dart';
// Kimlik doğrulama servisimizi içe aktarıyoruz
import '../services/auth_service.dart';

// AuthService örneğini tek bir yerden oluşturan Riverpod Provider sağlayıcımız
final authServiceProvider = Provider<AuthService>((ref) {
  // AuthService nesnesi üretip döndürüyoruz
  return AuthService();
// authServiceProvider kapanışı
});

// Kullanıcının oturum açma veya çıkış yapma durumunu anlık dinleyen StreamProvider sağlayıcımız
final authStateProvider = StreamProvider<User?>((ref) {
  // authServiceProvider nesnesini okuyoruz
  final authService = ref.watch(authServiceProvider);
  // Canlı authStateChanges akışını dinlemeye veriyoruz
  return authService.authStateChanges;
// authStateProvider kapanışı
});

// Giriş yapmış kullanıcının Firestore'daki detaylı profil bilgilerini getiren FutureProvider
final currentUserDataProvider = FutureProvider<UserModel?>((ref) async {
  // Canlı oturum durumundaki kullanıcı nesnesini alıyoruz
  final authState = ref.watch(authStateProvider).value;
  // Oturum açık değilse geriye null dönüyoruz
  if (authState == null) return null;
  // authService referansını alıyoruz
  final authService = ref.watch(authServiceProvider);
  // Kullanıcının UID'sine göre detaylı profil verilerini çekip dönüyoruz
  return await authService.getUserData(authState.uid);
// currentUserDataProvider kapanışı
});
