// Kimlik doğrulama işlemleri için kuralları belirlediğimiz soyut sözleşme sınıfı (Interface)
abstract class AuthRepository {
  // Giriş yapma fonksiyonu: E-posta ve şifre alıp geriye String token döndürür
  Future<String> login(String email, String password);
  // Çıkış yapma fonksiyonu: Asenkron çalışır ve geriye bir şey döndürmez
  Future<void> logout();
  // Kullanıcının şu an giriş yapmış olup olmadığını kontrol eden getter özelliği
  bool get isAuth;
// AuthRepository arayüzünün kapanış parantezi
}

// Gerçek Firebase veritabanı ile çalışacak somut kimlik doğrulama sınıfımız
class FirebaseAuthRepository implements AuthRepository {
  // Arayüzden gelen login metodunu somutlaştırıyoruz
  @override
  // Firebase üzerinden e-posta ve şifre ile giriş yapan asenkron metot
  Future<String> login(String email, String password) async {
    // Gerçek Firebase entegrasyonunda sunucudan dönen kimlik doğrulama token'ı
    return "firebase_token_xyz_123";
  // login metodunun kapanış parantezi
  }

  // Arayüzden gelen logout metodunu somutlaştırıyoruz
  @override
  // Kullanıcının Firebase oturumunu sonlandıran metot
  Future<void> logout() async {
    // Firebase oturumu burada güvenle kapatılır
  // logout metodunun kapanış parantezi
  }

  // Arayüzden gelen oturum kontrol getter'ını somutlaştırıyoruz
  @override
  // Kullanıcı başarıyla doğrulandığı için true dönüyoruz
  bool get isAuth => true;
// FirebaseAuthRepository sınıfının kapanış parantezi
}

// Test ve geliştirme aşamasında gerçek servise gitmeden sahte veri üreten sınıfımız
class MockAuthRepository implements AuthRepository {
  // Arayüzden gelen login metodunu sahte veriyle simüle ediyoruz
  @override
  // Test ortamı için 1 saniyelik ağ gecikmesi taklidi yapan metot
  Future<String> login(String email, String password) async {
    // Gerçekçi bir ağ gecikmesi hissettirmek için 1 saniye bekletiyoruz
    await Future.delayed(const Duration(seconds: 1));
    // Test için sahte bir token döndürüyoruz
    return "mock_token_abc_789";
  // login metodunun kapanış parantezi
  }

  // Arayüzden gelen logout metodunun test versiyonu
  @override
  // Sahte oturum sonlandırma işlemi
  Future<void> logout() async {
    // Test oturumu kapatıldı
  // logout metodunun kapanış parantezi
  }

  // Arayüzden gelen oturum kontrol getter'ı
  @override
  // Test başlangıcında kullanıcı henüz giriş yapmadı sayıyoruz
  bool get isAuth => false;
// MockAuthRepository sınıfının kapanış parantezi
}

// Loglama yeteneğini sınıflara kalıtım yapmadan eklememizi sağlayan Mixin yapısı
mixin Logger {
  // Konsola log formatında bilgi yazdıran yardımcı fonksiyon
  void log(String msg) => print("LOG: $msg");
// Logger mixin'inin kapanış parantezi
}

// Analitik ve istatistik takibi yapmamızı sağlayan ikinci Mixin yapımız
mixin Analytics {
  // Analitik verisini biçimlendirip konsola basan yardımcı fonksiyon
  void log(String msg) => print("ANALİZ: $msg");
// Analytics mixin'inin kapanış parantezi
}

// Birden fazla mixin'i (Logger ve Analytics) bünyesine katan ödeme servisi sınıfımız
class PaymentService with Logger, Analytics {
  // Ödeme işlemini başlatan ana fonksiyonumuz
  void pay() {
    // Logger ve Analytics mixin'lerinden gelen log fonksiyonunu çağırıyoruz
    log("Ödeme Yapıldı");
  // pay metodunun kapanış parantezi
  }
// PaymentService sınıfının kapanış parantezi
}

// Ekrandaki görsel widget'ların temelini oluşturan soyut sınıf
abstract class BaseWidget {
  // Temel widget özellikleri burada tanımlanır
// BaseWidget sınıfının kapanış parantezi
}

// 'on BaseWidget' kısıtlaması ile bu mixin sadece BaseWidget ve onun alt sınıflarında kullanılabilir
mixin LifeLogger on BaseWidget {
  // Widget ekrana çizilirken yaşam döngüsünü loglayan fonksiyon
  void logInit() => print("Widget Başlatıldı");
// LifeLogger mixin'inin kapanış parantezi
}

// String sınıfına sonradan eklediğimiz pratik doğrulama ve biçimlendirme yetenekleri (Extension)
extension StringValidator on String {
  // E-postanın geçerli bir e-posta formatında olup olmadığını kontrol eden getter
  bool get isValidEmail {
    // Standart e-posta formatı için RegExp (düzenli ifade) kuralı
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // Metin bu regex kuralına uyuyorsa true, uymuyorsa false döner
    return emailRegex.hasMatch(this);
  // isValidEmail getter kapanış parantezi
  }

  // Metnin ilk harfini büyük, geri kalanını olduğu gibi bırakan yardımcı fonksiyon
  String toCapitalize() {
    // Metin boşsa işlem yapmadan kendisini geri döndürüyoruz
    if (isEmpty) return this;
    // İlk harfi büyütüp 1. indeksten sonraki kısımla birleştiriyoruz
    return this[0].toUpperCase() + substring(1);
  // toCapitalize metodunun kapanış parantezi
  }
// StringValidator extension'ının kapanış parantezi
}

// Kodlarımızı test edip konsol çıktısını görebileceğimiz ana çalıştırma fonksiyonumuz
void main() {
  // Test etmek istediğimiz örnek e-posta adresini değişkene atıyoruz
  String email = "selahaddin@kodvance.com";

  // Yazdığımız extension getter'ı sayesinde e-postayı doğrudan kontrol ediyoruz
  if (email.isValidEmail) {
    // E-posta geçerliyse ekrana onay mesajı basıyoruz
    print("Geçerli Eposta");
  // E-posta formatı hatalıysa burası çalışır
  } else {
    // Format geçersizse uyarı mesajı basıyoruz
    print("geçersiz eposta");
  // if-else bloğunun kapanışı
  }
// main fonksiyonunun kapanış parantezi
}
