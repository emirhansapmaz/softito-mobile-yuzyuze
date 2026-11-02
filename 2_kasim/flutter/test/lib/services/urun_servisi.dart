// JSON verilerini çözmek ve haritalara dönüştürmek için gerekli kütüphane
import 'dart:convert';
// İnternet üzerinden HTTP istekleri göndermek için kullanılan paket
import 'package:http/http.dart' as http;

// 1. MODEL SINIFI:
// REST API'den dönecek ürün verilerini temsil eden tip güvenli model sınıfımız.
class UrunModel {
  // Ürünün benzersiz ID numarası
  final int id;
  // Ürünün başlığı / adı
  final String baslik;
  // Ürünün satış fiyatı
  final double fiyat;
  // Ürünün görsel linki
  final String resimUrl;
  // Ürünün kategorisi
  final String kategori;

  // UrunModel sınıfının değişmez kurucu metodu
  const UrunModel({
    // ID alanının zorunlu olduğunu belirtiyoruz
    required this.id,
    // Başlık alanının zorunlu olduğunu belirtiyoruz
    required this.baslik,
    // Fiyat alanının zorunlu olduğunu belirtiyoruz
    required this.fiyat,
    // Resim linkinin zorunlu olduğunu belirtiyoruz
    required this.resimUrl,
    // Kategori alanının zorunlu olduğunu belirtiyoruz
    required this.kategori,
  // Kurucu metodun kapanış parantezi
  });

  // fromJson fabrika kurucusu:
  // Sunucudan gelen Map<String, dynamic> formatındaki JSON verisini güvenle UrunModel nesnesine dönüştürür
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    // Yeni UrunModel nesnesi oluşturup geriye döndürüyoruz
    return UrunModel(
      // ID null gelirse 0 atıyoruz
      id: json['id'] as int? ?? 0,
      // Başlık null gelirse varsayılan isim atıyoruz
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      // API'den fiyat tam sayı da gelse ondalıklı da gelse toDouble() ile güvenle double yapıyoruz
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      // Resim linki null gelirse geçici yer tutucu görsel atıyoruz
      resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150',
      // category veya kategori anahtarından hangisi doluysa onu okuyoruz
      kategori: (json['category'] ?? json['kategori']) as String? ?? 'Genel',
    // UrunModel nesne çağrısının kapanışı
    );
  // fromJson metodunun kapanış parantezi
  }
// UrunModel sınıfının kapanış parantezi
}

// 2. SERVİS SÖZLEŞMESİ (Interface):
// Katmanlı mimaride arayüz (UI) doğrudan API koduna değil, bu soyut sınıfa güvenir.
// Böylece servis değişse bile arayüz kodunu bozmadan kolayca geçiş yapabiliriz.
abstract class IUrunServisi {
  // Ürün listesini asenkron olarak getirmeyi taahhüt eden soyut fonksiyon
  Future<List<UrunModel>> urunleriGetir();
// IUrunServisi arayüzünün kapanış parantezi
}

// 3. CANLI API SERVİSİ:
// Gerçek internet bağlantısı kurup FakeStoreAPI'den ürünleri çeken somut servis sınıfımız.
class CanliApiUrunServisi implements IUrunServisi {
  // FakeStore API ürünler uç noktası adresi
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  // Soyut arayüzden gelen urunleriGetir fonksiyonunu somutlaştırıyoruz
  @override
  // Sunucudan ürünleri asenkron olarak çeken fonksiyon
  Future<List<UrunModel>> urunleriGetir() async {
    // Ağ ve dönüşüm hatalarını yakalamak için try-catch bloğu açıyoruz
    try {
      // http.get ile isteği atıyoruz, 10 saniye içinde yanıt gelmezse timeout fırlatıyoruz
      final yanit = await http.get(Uri.parse(_baseUrl)).timeout(
        // En fazla 10 saniye bekliyoruz
        const Duration(seconds: 10),
        // Zaman aşımı olduğunda çalışacak fonksiyon
        onTimeout: () {
          // Zaman aşımı hatası fırlatıyoruz
          throw Exception('Ağ zaman aşımına uğradı.');
        // onTimeout kapanışı
        },
      // http.get çağrısının kapanışı
      );

      // 200 HTTP OK: İstek başarılı, veriler elimizde
      if (yanit.statusCode == 200) {
        // Gelen String metin cevabı JSON listesine ayrıştırıyoruz
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        // Her elemanı UrunModel'e çevirip List<UrunModel> olarak döndürüyoruz
        return hamListe
            // Her JSON haritasını UrunModel.fromJson ile nesneye dönüştürüyoruz
            .map((json) => UrunModel.fromJson(json as Map<String, dynamic>))
            // Standart Dart Listesine çeviriyoruz
            .toList();
      // 200 haricinde sunucu hatası döndüğünde
      } else {
        // Sunucu hata durumunu açıklayan istisna fırlatıyoruz
        throw Exception('Sunucu hatası: ${yanit.statusCode}');
      // if-else kapanışı
      }
    // Herhangi bir ağ veya format hatasını yakalıyoruz
    } catch (e) {
      // Hatayı UI katmanı yakalayabilsin diye fırlatıyoruz
      throw Exception('Ağ hatası: $e');
    // try-catch bloğu kapanışı
    }
  // urunleriGetir metodunun kapanış parantezi
  }
// CanliApiUrunServisi sınıfının kapanış parantezi
}
