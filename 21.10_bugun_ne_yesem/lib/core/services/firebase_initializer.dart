// Dart geliştirici araçları loglama kütüphanesi
import 'dart:developer' as developer;
// Firebase temel çekirdek kütüphanesi
import 'package:firebase_core/firebase_core.dart';

// Firebase servislerini güvenli bir şekilde başlatan ve hata olursa uygulamanın çökmesini önleyen başlatıcı sınıfımız
class FirebaseInitializer {
  // Firebase'in başarıyla başlatılıp başlatılmadığını tutan dahili statik bayrak
  static bool _isInitialized = false;

  // Firebase başlatma durumunu dışarıya sadece okunabilir olarak sunan getter
  static bool get isInitialized => _isInitialized;

  // Firebase'i asenkron olarak ayağa kaldıran statik metot
  static Future<void> initialize() async {
    // Başlatma sırasında oluşabilecek hataları yakalamak için try bloğu
    try {
      // Firebase çekirdek servislerini başlatıyoruz
      await Firebase.initializeApp();
      // Başlatma başarılı olduğu için bayrağı true yapıyoruz
      _isInitialized = true;
      // Geliştirici konsoluna başarı logu yazdırıyoruz
      developer.log('Firebase başarıyla başlatıldı.', name: 'FirebaseInitializer');
    // Eğer yapılandırma eksikse veya platform desteklenmiyorsa hatayı yakalıyoruz
    } catch (e) {
      // Hata detayını konsola açıklayıcı bir log olarak basıyoruz
      developer.log(
        // Açıklayıcı hata mesajı metni
        'Firebase başlatılırken bir uyarı oluştu (Örn: firebase_options.dart henüz yapılandırılmamış olabilir): $e',
        // Log başlığı / etiketi
        name: 'FirebaseInitializer',
        // Yakalanan hata nesnesi
        error: e,
      // developer.log kapanışı
      );
      // Demo ve geliştirme ortamında uygulamanın çökmesini önleyip bayrağı false yapıyoruz
      _isInitialized = false;
    // try-catch bloğu kapanışı
    }
  // initialize metodunun kapanış parantezi
  }
// FirebaseInitializer sınıfının kapanış parantezi
}
