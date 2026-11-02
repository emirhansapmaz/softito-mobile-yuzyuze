// Kullanıcı hesap bilgilerini ve profil detaylarını tuttuğumuz model sınıfımız
class UserModel {
  // Firebase Auth tarafından üretilen benzersiz kullanıcı kimliği (UID)
  final String uid;
  // Kullanıcının adı ve soyadı
  final String name;
  // Kullanıcının kayıtlı e-posta adresi
  final String email;
  // Kullanıcının telefon numarası
  final String phone;
  // Kolay giriş için kullanıcının belirlediği şifre ipucu metni (opsiyonel)
  final String? passwordHint;

  // UserModel sınıfının değişmez (const) kurucu metodu
  const UserModel({
    // UID alanının zorunlu olduğunu belirtiyoruz
    required this.uid,
    // Ad alanının zorunlu olduğunu belirtiyoruz
    required this.name,
    // E-posta alanının zorunlu olduğunu belirtiyoruz
    required this.email,
    // Telefon numarası girilmediyse varsayılan boş metin veriyoruz
    this.phone = '',
    // Şifre ipucu isteğe bağlı parametre
    this.passwordHint,
  // Kurucu metodun kapanış parantezi
  });

  // Modeli Firebase Firestore'a kaydederken JSON Haritasına (Map) dönüştüren metot
  Map<String, dynamic> toMap() {
    // Dart Map koleksiyonunu döndürüyoruz
    return {
      // Veritabanındaki 'uid' alanı
      'uid': uid,
      // Veritabanındaki 'name' alanı
      'name': name,
      // Veritabanındaki 'email' alanı
      'email': email,
      // Veritabanındaki 'phone' alanı
      'phone': phone,
      // Veritabanındaki 'passwordHint' alanı
      'passwordHint': passwordHint,
    // Map kapanışı
    };
  // toMap metodunun kapanış parantezi
  }

  // Firestore'dan gelen Map verisini okuyup tip güvenli UserModel nesnesi üreten fabrika kurucusu
  factory UserModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    // Yeni UserModel nesnesi oluşturup geriye döndürüyoruz
    return UserModel(
      // Firestore doküman ID'si varsa onu, yoksa haritadaki 'uid'yi alıyoruz
      uid: documentId ?? map['uid'] as String? ?? '',
      // 'name' alanını okuyoruz, yoksa boş metin atıyoruz
      name: map['name'] as String? ?? '',
      // 'email' alanını okuyoruz, yoksa boş metin atıyoruz
      email: map['email'] as String? ?? '',
      // 'phone' alanını okuyoruz, yoksa boş metin atıyoruz
      phone: map['phone'] as String? ?? '',
      // 'passwordHint' alanını nullable olarak okuyoruz
      passwordHint: map['passwordHint'] as String?,
    // UserModel oluşturma kapanışı
    );
  // fromMap fabrika metodunun kapanış parantezi
  }

  // Değişmez (immutable) nesnenin sadece istenen alanlarını güncelleyip yeni bir kopyasını üreten yardımcı metot
  UserModel copyWith({
    // Yeni UID (isteğe bağlı)
    String? uid,
    // Yeni isim (isteğe bağlı)
    String? name,
    // Yeni e-posta (isteğe bağlı)
    String? email,
    // Yeni telefon (isteğe bağlı)
    String? phone,
    // Yeni şifre ipucu (isteğe bağlı)
    String? passwordHint,
  // copyWith parametreleri kapanışı
  }) {
    // Verildiyse yeni değeri, verilmediyse eski değeri koruyarak yeni nesne oluşturuyoruz
    return UserModel(
      // Yeni UID varsa al, yoksa eskisi
      uid: uid ?? this.uid,
      // Yeni isim varsa al, yoksa eskisi
      name: name ?? this.name,
      // Yeni e-posta varsa al, yoksa eskisi
      email: email ?? this.email,
      // Yeni telefon varsa al, yoksa eskisi
      phone: phone ?? this.phone,
      // Yeni ipucu varsa al, yoksa eskisi
      passwordHint: passwordHint ?? this.passwordHint,
    // UserModel çağrısı kapanışı
    );
  // copyWith metodunun kapanış parantezi
  }
// UserModel sınıfının kapanış parantezi
}
