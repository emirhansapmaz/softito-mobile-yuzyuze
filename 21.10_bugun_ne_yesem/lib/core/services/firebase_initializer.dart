import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();
      _isInitialized = true;
      developer.log('Firebase başarıyla başlatıldı.', name: 'FirebaseInitializer');
    } catch (e) {
      developer.log(
        'Firebase başlatılırken bir uyarı oluştu (Örn: firebase_options.dart henüz yapılandırılmamış olabilir): $e',
        name: 'FirebaseInitializer',
        error: e,
      );
      // Demo ve geliştirme ortamı için uygulamanın çökmesi engellenir
      _isInitialized = false;
    }
  }
}
