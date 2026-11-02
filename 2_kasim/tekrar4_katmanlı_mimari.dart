// JSON verilerini çözmek ve Dart haritalarına dönüştürmek için temel kütüphane
import 'dart:convert';
// İnternet üzerinden HTTP GET ve POST istekleri yapmamızı sağlayan paket
import 'package:http/http.dart' as http;

// 1. MODEL KATMANI:
// FakeStore API'den gelen karmaşık JSON verisini tip güvenli bir Dart nesnesine dönüştürmek için yazdığımız model sınıfı.
class UrunModel {
  // Ürünün benzersiz kimlik numarası
  final int id;
  // Ürünün adı / başlığı
  final String baslik;
  // Ürünün satış fiyatı
  final double fiyat;
  // Ürün görselinin internetteki linki
  final String resimUrl;
  // Ürünün ait olduğu kategori adı
  final String kategori;

  // UrunModel sınıfının değişmez (const) kurucu metodu
  const UrunModel({
    // ID alanının zorunlu olduğunu belirten parametre
    required this.id,
    // Başlık alanının zorunlu olduğunu belirten parametre
    required this.baslik,
    // Fiyat alanının zorunlu olduğunu belirten parametre
    required this.fiyat,
    // Resim URL alanının zorunlu olduğunu belirten parametre
    required this.resimUrl,
    // Kategori alanının zorunlu olduğunu belirten parametre
    required this.kategori,
  // Kurucu metodun kapanış parantezi
  });

  // fromJson fabrika kurucusu:
  // Sunucudan gelen Map<String, dynamic> verisini okuyup güvenli bir UrunModel nesnesi üretir.
  factory UrunModel.fromJson(Map<String, dynamic> json) {
    // Yeni UrunModel nesnesi oluşturup geriye döndürüyoruz
    return UrunModel(
      // null gelme ihtimaline karşı varsayılan olarak 0 atıyoruz
      id: json['id'] as int? ?? 0,
      // Başlık null gelirse varsayılan isim veriyoruz
      baslik: json['title'] as String? ?? 'İsimsiz Ürün',
      // Fiyat API'den int (109) veya double (109.95) gelebilir; tip çökmesini önlemek için num? -> toDouble() yapıyoruz
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      // Resim linki boşsa geçici bir yer tutucu görsel veriyoruz
      resimUrl: json['image'] as String? ?? 'https://via.placeholder.com/150',
      // Kategori bilgisi null ise 'Genel' olarak belirliyoruz
      kategori: json['category'] as String? ?? 'Genel',
    // UrunModel oluşturma çağrısının kapanışı
    );
  // fromJson fabrika metodunun kapanış parantezi
  }
// UrunModel sınıfının kapanış parantezi
}

// 2. SERVİS ARAYÜZÜ (Interface):
// Katmanlı mimarinin temeli. Ekran doğrudan somut sınıfa değil, bu soyut arayüze bağımlı olur.
// Böylece yarın bir gün test için sahte (mock) veri veya başka bir API'ye geçmek çocuk oyuncağı olur.
abstract class IUrunServisi {
  // Ürün listesini asenkron getirmeyi taahhüt eden soyut fonksiyon
  Future<List<UrunModel>> urunleriGetir();
// IUrunServisi arayüzünün kapanış parantezi
}

// 3. SOMUT SERVİS KATMANI:
// IUrunServisi sözleşmesini uygulayarak internet üzerinden gerçek API isteği yapan servis sınıfı.
class CanliApiUrunServisi implements IUrunServisi {
  // Veriyi çekeceğimiz FakeStore temel API adresi
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  // Soyut arayüzden gelen urunleriGetir metodunu somutlaştırıyoruz
  @override
  // Sunucudan ürün listesini çeken asenkron fonksiyon
  Future<List<UrunModel>> urunleriGetir() async {
    // Ağ ve dönüşüm hatalarını yakalamak için try-catch bloğu açıyoruz
    try {
      // http.get ile sunucuya istek gönderiyoruz.
      // timeout: İnternet yavaşsa veya kesilirse sonsuza kadar beklemesin, 10 saniye sonra zaman aşımı versin diye ekledik.
      final yanit = await http.get(Uri.parse(_baseUrl)).timeout(
        // En fazla 10 saniye bekleme süresi
        const Duration(seconds: 10),
        // Zaman aşımı olduğunda çalışacak fonksiyon
        onTimeout: () {
          // Özel zaman aşımı istisnası fırlatıyoruz
          throw Exception('Ağ zaman aşımına uğradı.');
        // onTimeout kapanışı
        },
      // http.get çağrısının kapanışı
      );

      // 200 OK: İstek başarılı, veriler sunucudan eksiksiz döndü
      if (yanit.statusCode == 200) {
        // jsonDecode: Gelen String metin halindeki JSON verisini Dart List yapısına çevirir
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        // Listedeki her JSON haritasını UrunModel.fromJson ile model nesnesine çevirip liste olarak dönüyoruz
        return hamListe
            // Listedeki her elemanı Map<String, dynamic> olarak okuyup modele dönüştürüyoruz
            .map((json) => UrunModel.fromJson(json as Map<String, dynamic>))
            // Iterable koleksiyonunu standart Dart Listesine çeviriyoruz
            .toList();
      // 200 dışında bir durum kodu döndüğünde (404, 500 vb.)
      } else {
        // Sunucu hata kodunu belirten istisna fırlatıyoruz
        throw Exception('Sunucu hatası: HTTP ${yanit.statusCode}');
      // if-else kapanışı
      }
    // Beklenmedik bağlantı veya çözümleme hatalarını yakalıyoruz
    } catch (e) {
      // Hatayı kullanıcı arayüzü katmanı görsün diye yukarı fırlatıyoruz
      throw Exception('Ağ hatası: $e');
    // try-catch bloğu kapanışı
    }
  // urunleriGetir metodunun kapanış parantezi
  }
// CanliApiUrunServisi sınıfının kapanış parantezi
}
