import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/firebase_initializer.dart';
import '../../models/user_model.dart';

class AuthService {
  FirebaseAuth? get _auth => FirebaseInitializer.isInitialized ? FirebaseAuth.instance : null;
  FirebaseFirestore? get _firestore => FirebaseInitializer.isInitialized ? FirebaseFirestore.instance : null;

  // Aktif kullanıcı akışı
  Stream<User?> get authStateChanges {
    final auth = _auth;
    if (auth == null) {
      return Stream.value(null);
    }
    return auth.authStateChanges();
  }

  User? get currentUser => _auth?.currentUser;

  /// Kullanıcı adının benzersiz (unique) olup olmadığını kontrol eder
  Future<bool> isUsernameAvailable(String username) async {
    final firestore = _firestore;
    if (firestore == null) return true; // Offline / demo modunda izin ver

    final cleanUsername = username.trim().toLowerCase();
    if (cleanUsername.isEmpty) return false;

    final querySnapshot = await firestore
        .collection(AppConstants.usersCollection)
        .where('kullanici_adi', isEqualTo: cleanUsername)
        .limit(1)
        .get();

    return querySnapshot.docs.isEmpty;
  }

  /// Giriş Yap (Login)
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final auth = _auth;
    if (auth == null) {
      // Firebase aktif değilse demo girişi sağla
      return null;
    }

    try {
      return await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Giriş yapılırken beklenmeyen bir hata oluştu: $e';
    }
  }

  /// Yeni Kayıt Ol (Sign Up)
  Future<UserCredential?> registerWithEmail({
    required String adSoyad,
    required String kullaniciAdi,
    required String email,
    required String password,
    String telefon = '',
  }) async {
    final normalizedUsername = kullaniciAdi.trim().toLowerCase();

    final isAvailable = await isUsernameAvailable(normalizedUsername);
    if (!isAvailable) {
      throw 'Bu kullanıcı adı zaten alınmış. Lütfen başka bir kullanıcı adı seçin.';
    }

    final auth = _auth;
    final firestore = _firestore;

    if (auth == null || firestore == null) {
      return null;
    }

    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) {
        throw 'Kullanıcı kimliği oluşturulamadı.';
      }

      await userCredential.user?.updateDisplayName(adSoyad.trim());

      final userModel = UserModel(
        uid: uid,
        adSoyad: adSoyad.trim(),
        kullaniciAdi: normalizedUsername,
        email: email.trim(),
        telefon: telefon.trim(),
        kayitTarihi: DateTime.now(),
        toplamPuan: 0,
      );

      await firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .set(userModel.toMap());

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Kayıt işlemi sırasında bir hata oluştu: $e';
    }
  }

  /// Şifremi Unuttum (Reset Password)
  Future<void> sendPasswordResetEmail(String email) async {
    final auth = _auth;
    if (auth == null) return;

    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Şifre sıfırlama bağlantısı gönderilirken bir hata oluştu: $e';
    }
  }

  /// Çıkış Yap
  Future<void> signOut() async {
    await _auth?.signOut();
  }

  /// Aktif Kullanıcının Firestore Profilini Getir
  Future<UserModel?> getCurrentUserProfile() async {
    final uid = currentUser?.uid;
    final firestore = _firestore;
    if (uid == null || firestore == null) return null;

    final doc = await firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();

    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Bu e-posta adresine ait bir hesap bulunamadı.';
      case 'wrong-password':
        return 'Hatalı şifre girdiniz.';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda.';
      case 'invalid-email':
        return 'Geçersiz bir e-posta adresi girdiniz.';
      case 'weak-password':
        return 'Şifre çok zayıf. Lütfen en az 6 karakterli daha güçlü bir şifre seçin.';
      case 'user-disabled':
        return 'Bu kullanıcı hesabı devre dışı bırakılmıştır.';
      case 'too-many-requests':
        return 'Çok fazla başarısız deneme yapıldı. Lütfen biraz sonra tekrar deneyin.';
      case 'invalid-credential':
        return 'E-posta veya şifre hatalı.';
      default:
        return e.message ?? 'Bir kimlik doğrulama hatası oluştu (${e.code}).';
    }
  }
}
