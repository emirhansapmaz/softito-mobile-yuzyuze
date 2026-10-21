import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../constants/app_constants.dart';
import '../models/user_model.dart';
import 'firebase_initializer.dart';

class AuthService {
  final FirebaseAuth? _auth;
  final FirebaseFirestore? _firestore;

  UserModel? _mockCurrentUser;

  AuthService({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = FirebaseInitializer.isInitialized
            ? (auth ?? FirebaseAuth.instance)
            : null,
        _firestore = FirebaseInitializer.isInitialized
            ? (firestore ?? FirebaseFirestore.instance)
            : null;

  User? get currentUser => _auth?.currentUser;

  Stream<User?> get authStateChanges =>
      _auth?.authStateChanges() ?? Stream.value(null);

  CollectionReference<Map<String, dynamic>>? get _usersRef =>
      _firestore?.collection(AppConstants.usersCollection);

  /// E-posta & Şifre ile Kayıt Olma
  Future<UserModel> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String? passwordHint,
  }) async {
    final userModel = UserModel(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      phone: phone.trim(),
      passwordHint: passwordHint?.trim(),
    );

    if (_auth != null) {
      try {
        final credential = await _auth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        final realModel = userModel.copyWith(uid: credential.user!.uid);
        await _usersRef?.doc(credential.user!.uid).set(realModel.toMap());
        await credential.user!.updateDisplayName(name.trim());
        return realModel;
      } catch (_) {}
    }

    _mockCurrentUser = userModel;
    return userModel;
  }

  /// E-posta & Şifre ile Giriş Yapma
  Future<UserModel?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (_auth != null) {
      try {
        final credential = await _auth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
        return await getUserData(credential.user!.uid);
      } catch (_) {}
    }

    _mockCurrentUser = UserModel(
      uid: 'demo_user_1',
      name: 'Misafir Kullanıcı',
      email: email.trim(),
      passwordHint: 'pamuk',
    );
    return _mockCurrentUser;
  }

  /// Kullanıcı Bilgilerini Getirme
  Future<UserModel?> getUserData(String uid) async {
    if (_usersRef != null) {
      try {
        final doc = await _usersRef!.doc(uid).get();
        if (doc.exists && doc.data() != null) {
          return UserModel.fromMap(doc.data()!, documentId: doc.id);
        }
      } catch (_) {}
    }
    return _mockCurrentUser;
  }

  /// Kullanıcı Bilgilerini Güncelleme
  Future<void> updateUserProfile(UserModel user) async {
    _mockCurrentUser = user;
    if (_usersRef != null) {
      try {
        await _usersRef!.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
        if (_auth?.currentUser != null && user.name.isNotEmpty) {
          await _auth!.currentUser!.updateDisplayName(user.name);
        }
      } catch (_) {}
    }
  }

  /// Şifre Sıfırlama E-postası Gönderme
  Future<void> sendPasswordResetEmail(String email) async {
    if (_auth != null) {
      try {
        await _auth.sendPasswordResetEmail(email: email.trim());
      } catch (_) {}
    }
  }

  /// Şifre Değiştirme
  Future<void> updatePassword(String newPassword) async {
    final current = _auth?.currentUser;
    if (current != null) {
      await current.updatePassword(newPassword);
    }
  }

  /// Kolay Giriş İçin Şifre İpucu (Password Hint) Sorgulama
  Future<String?> getPasswordHintByEmail(String email) async {
    final usersRef = _usersRef;
    if (usersRef != null) {
      try {
        final query = await usersRef
            .where('email', isEqualTo: email.trim())
            .limit(1)
            .get();
        if (query.docs.isNotEmpty) {
          return query.docs.first.data()['passwordHint'] as String?;
        }
      } catch (_) {}
    }
    return 'İlk evcil hayvanınızın adı (Örn: pamuk)';
  }

  /// Çıkış Yapma
  Future<void> signOut() async {
    _mockCurrentUser = null;
    if (_auth != null) {
      await _auth.signOut();
    }
  }
}
