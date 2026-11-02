// Firestore veritabanı kütüphanesini içe aktarıyoruz
import 'package:cloud_firestore/cloud_firestore.dart';
// Firebase Authentication (Kimlik Doğrulama) kütüphanesini içe aktarıyoruz
import 'package:firebase_auth/firebase_auth.dart';
// Uygulama genelindeki sabitleri içe aktarıyoruz
import '../constants/app_constants.dart';
// Kullanıcı profil modelini içe aktarıyoruz
import '../models/user_model.dart';
// Firebase başlatma kontrol sınıfımızı içe aktarıyoruz
import 'firebase_initializer.dart';

// Firebase Auth ve Firestore ile kullanıcı giriş, kayıt ve profil yönetimini sağlayan servis sınıfımız
class AuthService {
  // Firebase Auth örneği (Firebase kapalıysa null olabilir)
  final FirebaseAuth? _auth;
  // Firebase Firestore örneği (Firebase kapalıysa null olabilir)
  final FirebaseFirestore? _firestore;

  // Demo / offline ortamda bellekte tuttuğumuz sahte aktif kullanıcı nesnesi
  UserModel? _mockCurrentUser;

  // AuthService sınıfının kurucu metodu
  AuthService({
    // İsteğe bağlı dışarıdan verilebilecek FirebaseAuth nesnesi
    FirebaseAuth? auth,
    // İsteğe bağlı dışarıdan verilebilecek FirebaseFirestore nesnesi
    FirebaseFirestore? firestore,
  // Yapıcı gövdesi başlangıcı
  })  : _auth = FirebaseInitializer.isInitialized
            // Firebase hazırsa instance'ı alıyoruz
            ? (auth ?? FirebaseAuth.instance)
            // Hazır değilse null atıyoruz
            : null,
        _firestore = FirebaseInitializer.isInitialized
            // Firebase hazırsa Firestore instance'ını alıyoruz
            ? (firestore ?? FirebaseFirestore.instance)
            // Değilse null atıyoruz
            : null;

  // Şu an Firebase oturumu açık olan User nesnesini döndüren getter
  User? get currentUser => _auth?.currentUser;

  // Kullanıcının oturum açma/kapatma durumunu canlı dinleyen Stream
  Stream<User?> get authStateChanges =>
      // Firebase varsa canlı stream'i, yoksa tek seferlik null yayını döndürüyoruz
      _auth?.authStateChanges() ?? Stream.value(null);

  // Firestore'daki 'users' koleksiyon referansına erişen yardımcı getter
  CollectionReference<Map<String, dynamic>>? get _usersRef =>
      // Firestore nesnesi varsa users koleksiyonunu alıyoruz
      _firestore?.collection(AppConstants.usersCollection);

  // E-posta ve şifre ile yeni kullanıcı kaydı oluşturan fonksiyon
  Future<UserModel> registerWithEmailAndPassword({
    // Kullanıcının adı
    required String name,
    // Kullanıcının e-posta adresi
    required String email,
    // Kullanıcının şifresi
    required String password,
    // Kullanıcının telefon numarası (varsayılan boş)
    String phone = '',
    // Kullanıcının şifre ipucu metni
    String? passwordHint,
  // Metot gövdesi başlangıcı
  }) async {
    // İlk olarak temel kullanıcı modelini oluşturuyoruz
    final userModel = UserModel(
      // Geçici bir UID üretiyoruz
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      // İsimdeki boşlukları temizliyoruz
      name: name.trim(),
      // E-postadaki boşlukları temizliyoruz
      email: email.trim(),
      // Telefonu temizliyoruz
      phone: phone.trim(),
      // Şifre ipucunu temizliyoruz
      passwordHint: passwordHint?.trim(),
    // UserModel kapanışı
    );

    // Eğer Firebase Auth servisi aktifse gerçek Firebase kaydı yapıyoruz
    if (_auth != null) {
      // Hata yakalama try bloğu
      try {
        // Firebase üzerinde e-posta ve şifre ile kullanıcı oluşturuyoruz
        final credential = await _auth.createUserWithEmailAndPassword(
          // E-posta adresi
          email: email.trim(),
          // Şifre
          password: password,
        // createUserWithEmailAndPassword kapanışı
        );
        // Gerçek Firebase UID'sini modele aktarıyoruz
        final realModel = userModel.copyWith(uid: credential.user!.uid);
        // Kullanıcı verilerini Firestore'daki dokümanına kaydediyoruz
        await _usersRef?.doc(credential.user!.uid).set(realModel.toMap());
        // Firebase Auth profilindeki görünen adı (displayName) güncelliyoruz
        await credential.user!.updateDisplayName(name.trim());
        // Gerçek modeli döndürüyoruz
        return realModel;
      // Firebase hatası olursa demo akışına devam ediyoruz
      } catch (_) {}
    // if _auth kapanışı
    }

    // Firebase kapalıysa sahte kullanıcıyı kaydedip dönüyoruz
    _mockCurrentUser = userModel;
    // Modeli geriye dönüyoruz
    return userModel;
  // registerWithEmailAndPassword metodunun kapanış parantezi
  }

  // E-posta ve şifre ile mevcut kullanıcı oturumu açan fonksiyon
  Future<UserModel?> signInWithEmailAndPassword({
    // E-posta adresi
    required String email,
    // Şifre
    required String password,
  // Metot gövdesi başlangıcı
  }) async {
    // Firebase Auth aktifse gerçek oturum açma deniyoruz
    if (_auth != null) {
      // Hata yakalama try bloğu
      try {
        // Firebase Auth ile giriş yapıyoruz
        final credential = await _auth.signInWithEmailAndPassword(
          // E-posta
          email: email.trim(),
          // Şifre
          password: password,
        // signInWithEmailAndPassword kapanışı
        );
        // Kullanıcının Firestore'daki tam profil bilgilerini çekip dönüyoruz
        return await getUserData(credential.user!.uid);
      // Hata durumunda demo kullanıcısına düşüyoruz
      } catch (_) {}
    // if _auth kapanışı
    }

    // Firebase yoksa veya test modundaysak demo kullanıcı oluşturuyoruz
    _mockCurrentUser = UserModel(
      // Sabit demo ID
      uid: 'demo_user_1',
      // Misafir kullanıcı adı
      name: 'Misafir Kullanıcı',
      // Girilen e-posta
      email: email.trim(),
      // Örnek şifre ipucu
      passwordHint: 'pamuk',
    // UserModel kapanışı
    );
    // Demo kullanıcıyı döndürüyoruz
    return _mockCurrentUser;
  // signInWithEmailAndPassword metodunun kapanış parantezi
  }

  // Verilen UID'ye göre Firestore'dan kullanıcı profil verilerini çeken fonksiyon
  Future<UserModel?> getUserData(String uid) async {
    // Firestore referansı varsa sorgu atıyoruz
    if (_usersRef != null) {
      // Hata yakalama try bloğu
      try {
        // UID'ye ait dokümanı çekiyoruz
        final doc = await _usersRef!.doc(uid).get();
        // Doküman varsa ve verisi boş değilse modele çevirip dönüyoruz
        if (doc.exists && doc.data() != null) {
          // Map'ten UserModel nesnesi üretiyoruz
          return UserModel.fromMap(doc.data()!, documentId: doc.id);
        // if doc.exists kapanışı
        }
      // Hata olursa yakalıyoruz
      } catch (_) {}
    // if _usersRef kapanışı
    }
    // Veritabanı yoksa hafızadaki mock kullanıcıyı dönüyoruz
    return _mockCurrentUser;
  // getUserData metodunun kapanış parantezi
  }

  // Kullanıcının profil bilgilerini Firestore'da güncelleyen fonksiyon
  Future<void> updateUserProfile(UserModel user) async {
    // Bellekteki kullanıcıyı güncelliyoruz
    _mockCurrentUser = user;
    // Firestore bağlantısı varsa buluta kaydediyoruz
    if (_usersRef != null) {
      // Hata yakalama try bloğu
      try {
        // Dokümanı güncelliyoruz (merge: true ile sadece değişen alanlar ezilir)
        await _usersRef!.doc(user.uid).set(user.toMap(), SetOptions(merge: true));
        // Auth profilindeki isim boş değilse displayName'i de güncelliyoruz
        if (_auth?.currentUser != null && user.name.isNotEmpty) {
          // Firebase Auth görünen adını güncelliyoruz
          await _auth!.currentUser!.updateDisplayName(user.name);
        // if kontrolü kapanışı
        }
      // Hata durumunu yutuyoruz
      } catch (_) {}
    // if _usersRef kapanışı
    }
  // updateUserProfile metodunun kapanış parantezi
  }

  // Şifresini unutan kullanıcıya sıfırlama linki e-postası gönderen fonksiyon
  Future<void> sendPasswordResetEmail(String email) async {
    // Firebase Auth aktifse e-posta atıyoruz
    if (_auth != null) {
      // Hata yakalama try bloğu
      try {
        // Firebase sıfırlama e-postası tetikliyoruz
        await _auth.sendPasswordResetEmail(email: email.trim());
      // Hata olursa yakalıyoruz
      } catch (_) {}
    // if _auth kapanışı
    }
  // sendPasswordResetEmail metodunun kapanış parantezi
  }

  // Kullanıcının şifresini doğrudan güncelleyen fonksiyon
  Future<void> updatePassword(String newPassword) async {
    // Aktif oturum açmış kullanıcıyı alıyoruz
    final current = _auth?.currentUser;
    // Kullanıcı varsa şifresini güncelliyoruz
    if (current != null) {
      // Yeni şifreyi Firebase Auth'a yazıyoruz
      await current.updatePassword(newPassword);
    // if current kapanışı
    }
  // updatePassword metodunun kapanış parantezi
  }

  // Kolay Giriş İçin e-posta adresine bağlı şifre ipucunu sorgulayan fonksiyon
  Future<String?> getPasswordHintByEmail(String email) async {
    // Firestore referansını yerel değişkene alıyoruz
    final usersRef = _usersRef;
    // Veritabanı bağlantısı varsa e-postaya göre sorguluyoruz
    if (usersRef != null) {
      // Hata yakalama try bloğu
      try {
        // E-postası eşleşen ilk kullanıcıyı arıyoruz
        final query = await usersRef
            // E-posta eşitlik filtresi
            .where('email', isEqualTo: email.trim())
            // En fazla 1 kayıt alıyoruz
            .limit(1)
            // Sorguyu çalıştırıyoruz
            .get();
        // Eğer eşleşen doküman bulunduysa ipucu alanını dönüyoruz
        if (query.docs.isNotEmpty) {
          // passwordHint alanını String olarak okuyoruz
          return query.docs.first.data()['passwordHint'] as String?;
        // if query.docs kapanışı
        }
      // Hata durumunu yakalıyoruz
      } catch (_) {}
    // if usersRef kapanışı
    }
    // Bulunamazsa veya test modundaysak örnek bir ipucu dönüyoruz
    return 'İlk evcil hayvanınızın adı (Örn: pamuk)';
  // getPasswordHintByEmail metodunun kapanış parantezi
  }

  // Kullanıcının oturumunu güvenle kapatan fonksiyon
  Future<void> signOut() async {
    // Bellekteki mock kullanıcıyı sıfırlıyoruz
    _mockCurrentUser = null;
    // Firebase Auth aktifse çıkış yapıyoruz
    if (_auth != null) {
      // Firebase oturumunu kapatıyoruz
      await _auth.signOut();
    // if _auth kapanışı
    }
  // signOut metodunun kapanış parantezi
  }
// AuthService sınıfının kapanış parantezi
}
