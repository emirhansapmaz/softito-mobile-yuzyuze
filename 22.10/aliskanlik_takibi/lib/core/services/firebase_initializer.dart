import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import '../../firebase_options.dart';

class FirebaseInitializer {
  static bool _isInitialized = false;
  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
      developer.log('Firebase başarıyla başlatıldı.', name: 'FirebaseInitializer');
    } catch (e) {
      try {
        await Firebase.initializeApp();
        _isInitialized = true;
        developer.log('Firebase varsayılan ile başlatıldı.', name: 'FirebaseInitializer');
      } catch (innerError) {
        developer.log(
          'Firebase başlatma uyarısı: $innerError',
          name: 'FirebaseInitializer',
        );
        _isInitialized = false;
      }
    }
  }
}
