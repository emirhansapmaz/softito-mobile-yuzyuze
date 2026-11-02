// Mülakat İçin önemli: 
// Sealed sınıf demek: Sadece bu dosya içinde alt sınıfları türetilebilir, dışarıdan extend edilemez.
// Amacı: Switch yapısında tüm alt sınıfları tek tek kontrol etmeyi (exhaustiveness) zorunlu kılar.
// Böylece yeni bir durum eklendiğinde switch'te unutma şansımız kalmaz, default/else yazmaya da gerek kalmaz.
sealed class OdemeDurumu {
// OdemeDurumu sealed sınıfının kapanış parantezi
}

// Ödeme işlemi başarıyla tamamlandığında geriye döneceğimiz durum sınıfı
class OdemeBasarili extends OdemeDurumu {
  // Record kullanımı: Ayrı bir model/class yazmadan birden fazla veriyi (referansKodu ve tutar)
  // tek seferde taşımak için Dart 3'ün bu özelliğini kullandık.
  final ({String referansKodu, double tutar}) veri;

  // OdemeBasarili sınıfının kurucu metodu
  OdemeBasarili(
    // Başarılı ödeme verisini alan parametre
    this.veri,
  // Kurucu metodun kapanış parantezi
  );
// OdemeBasarili sınıfının kapanış parantezi
}

// Ödeme başarısız olduğunda veya reddedildiğinde çalışacak durum sınıfı
class OdemeBasarisiz extends OdemeDurumu {
  // Ödemenin neden reddedildiğini tutan hata mesajı
  final String hataNedeni;

  // OdemeBasarisiz sınıfının kurucu metodu
  OdemeBasarisiz(
    // Hata nedenini alan parametre
    this.hataNedeni,
  // Kurucu metodun kapanış parantezi
  );
// OdemeBasarisiz sınıfının kapanış parantezi
}

// abstract class (Soyut Arayüz / Interface):
// Buradaki amaç bir standart ve sözleşme belirlemek. Yarın Garanti yerine Akbank gelse de
// odemeYap metodunu aynı parametrelerle ezmek (override etmek) zorunda kalacak.
abstract class IBankaServisi {
  // Verilen miktar kadar ödeme çekip sonucu asenkron olarak OdemeDurumu tipinde döndüren soyut fonksiyon
  Future<OdemeDurumu> odemeYap({
    // Çekilecek para tutarı
    required double miktar,
  // odemeYap metodunun kapanış parantezi
  });
// IBankaServisi arayüzünün kapanış parantezi
}

// mixin: Dart'ta çoklu kalıtım (multiple inheritance) olmadığı için kullanılır.
// Tek bir sınıfa birden fazla yetenek eklemek amacıyla yazdık; 'with' anahtar kelimesiyle sınıfa dahil edilir.
mixin GuvenlikDenetimiMixin {
  // Token kontrolü: Boş mu ve en az 32 karakter mi diye kontrol eden fonksiyon
  bool tokenGecerliMi(String token) {
    // Hem boş olmamalı hem de 32 karakter veya daha uzun olmalı kuralı
    return token.isNotEmpty && token.length >= 32;
  // tokenGecerliMi metodunun kapanış parantezi
  }
// GuvenlikDenetimiMixin mixin'inin kapanış parantezi
}

// Yapılan bankacılık işlemlerini zaman damgasıyla konsola basan denetim (audit) loglama mixin'i
mixin AuditLogMixin {
  // İşlem detayını ekrana basan loglama metodu
  void islemKaydet(String mesaj) {
    // Şu anki anlık tarih ve saat bilgisini ISO formatında alıyoruz
    final zaman = DateTime.now().toIso8601String();
    // Zaman damgası ve log mesajını formatlayarak konsola yazdırıyoruz
    print('Log - $zaman: $mesaj');
  // islemKaydet metodunun kapanış parantezi
  }
// AuditLogMixin mixin'inin kapanış parantezi
}

// Somut servis sınıfımız:
// with -> Mixin'leri ekleyip güvenlik kontrolü ve loglama yeteneklerini aldık.
// implements -> IBankaServisi sözleşmesine uyacağımızı taahhüt ettik.
class GarantiBankasiServisi with GuvenlikDenetimiMixin, AuditLogMixin implements IBankaServisi {
  // Banka API'sine erişim sağlayacak gizli anahtar
  final String apiAnahtari;

  // GarantiBankasiServisi sınıfının kurucu metodu
  GarantiBankasiServisi({
    // API anahtarının zorunlu olduğunu belirten parametre
    required this.apiAnahtari,
  // Kurucu metodun kapanış parantezi
  });

  // IBankaServisi arayüzündeki odemeYap fonksiyonunu somutlaştırıyoruz
  @override
  // Asenkron olarak ödeme talebini işleyen fonksiyon
  Future<OdemeDurumu> odemeYap({
    // Ödenecek tutar
    required double miktar,
  // Metot gövdesi başlangıcı
  }) async {
    // 1. Adım: Mixin'den gelen güvenlik metodunu çalıştır, token geçersizse işlemi anında kes
    if (!tokenGecerliMi(apiAnahtari)) {
      // Hatalı denemeyi log dosyasına yazdırıyoruz
      islemKaydet('Ödeme Reddedildi. Geçersiz Api Anahtarı.');
      // Kullanıcıya başarısızlık durumunu ve sebebini döndürüyoruz
      return OdemeBasarisiz('Yetkilendirme hatası: Geçersiz token.');
    // if kontrolü kapanışı
    }

    // 2. Adım: Gerçek banka sunucusu yanıt veriyormuş gibi 1 saniye bekletiyoruz (Simülasyon)
    await Future.delayed(const Duration(milliseconds: 1000));
    // Başarılı işlem bilgisini logluyoruz
    islemKaydet('$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI.');

    // Başarılı sonucu Record yapısı içinde referans kodu ve tutarla oluşturup dönüyoruz
    return OdemeBasarili((
      // Benzersiz referans numarası üretimi
      referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}',
      // Çekilen tutar
      tutar: miktar,
    // Record kapanışı
    ));
  // odemeYap metodunun kapanış parantezi
  }
// GarantiBankasiServisi sınıfının kapanış parantezi
}

// Ödeme sonucunu kullanıcı dostu bir dille konsola yazdıran fonksiyon
void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  // Sealed class kullandığımız için switch expression burada tip kontrolü yapar.
  // OdemeBasarili ve OdemeBasarisiz durumlarının ikisini de yazdığımız için compiler default sormaz.
  final mesaj = switch (durum) {
    // Başarılı durumdaysa referans kodu ve tutarı ekrana basacak metin
    OdemeBasarili b => 'Ödeme Başarılı! Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar}₺',
    // Başarısız durumdaysa ret gerekçesini bildiren metin
    OdemeBasarisiz h => 'Ödeme Başarısız! Gerekçe: ${h.hataNedeni}',
  // switch ifadesi kapanışı
  };
  // Elde edilen mesajı konsola yazdırıyoruz
  print(mesaj);
// odemeSonucunuEkranaBas fonksiyonunun kapanış parantezi
}

// Uygulamayı ve banka servislerini test ettiğimiz ana fonksiyon
void main() async {
  // 1. senaryo test başlığı
  print('--- 1. Senaryo: Geçersiz API Anahtarı (Hatalı Durum) ---');
  // Kısa ve geçersiz bir token vererek hatalı senaryoyu test ediyoruz
  final hataliServis = GarantiBankasiServisi(apiAnahtari: 'kisa-token');
  // 150 TL'lik ödeme denemesi yapıyoruz
  final sonuc1 = await hataliServis.odemeYap(miktar: 150.0);
  // Dönen sonucu ekrana yazdırıyoruz
  odemeSonucunuEkranaBas(sonuc1);

  // 2. senaryo test başlığı
  print('\n--- 2. Senaryo: Başarılı Ödeme Durumu ---');
  // 32 karakterlik geçerli bir token vererek başarılı durumu test ediyoruz
  final basariliServis = GarantiBankasiServisi(apiAnahtari: 'abcdefghij1234567890abcdefghij12');
  // 2450.50 TL'lik geçerli bir ödeme işlemi başlatıyoruz
  final sonuc2 = await basariliServis.odemeYap(miktar: 2450.50);
  // Başarılı sonucu konsola yazdırıyoruz
  odemeSonucunuEkranaBas(sonuc2);
// main fonksiyonunun kapanış parantezi
}
