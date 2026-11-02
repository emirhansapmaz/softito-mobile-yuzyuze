// JSON çözme ve UTF-8 karakter desteği için gerekli kütüphane
import 'dart:convert';
// İnternet üzerinden HTTP istekleri göndermek için kullanılan resmi paket
import 'package:http/http.dart' as http;
// Çözümlenen verilerin aktarılacağı Urun modelini içe aktarıyoruz
import '../models/urun.dart';
// Kategori enum tanımını içe aktarıyoruz
import '../models/kategori.dart';
// Uygulanacak servis sözleşmesini (interface) içe aktarıyoruz
import 'i_urun_servisi.dart';

// FakeStore REST API ile gerçek internet iletişimi kuran servis sınıfımız
class ApiUrunServisi implements IUrunServisi {
  // FakeStore API temel uç nokta adresi
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  // Soyut arayüzden gelen tüm ürünleri getirme fonksiyonunu somutlaştırıyoruz
  @override
  // Sunucudan tüm ürünleri asenkron çeken fonksiyon
  Future<List<Urun>> tumUrunleriGetir() async {
    // String adresi Uri nesnesine dönüştürüyoruz
    final uri = Uri.parse(_baseUrl);
    // Ağ hatalarını yakalamak için try-catch bloğu açıyoruz
    try {
      // Sunucuya HTTP GET isteği gönderiyoruz ve 10 saniye zaman aşımı sınırı koyuyoruz
      final yanit = await http.get(uri).timeout(
        // En fazla 10 saniye yanıt bekliyoruz
        const Duration(seconds: 10),
        // Zaman aşımı meydana geldiğinde fırlatılacak istisna
        onTimeout: () => throw Exception("Ağ isteği zaman aşımına uğradı (Timeout)"),
      // http.get çağrısının kapanışı
      );

      // Sunucu HTTP 200 Başarılı durum kodu döndüyse
      if (yanit.statusCode == 200) {
        // Türkçe karakterlerin bozulmasını önlemek için bodyBytes'ı UTF-8 olarak çözüp JSON yapısına çeviriyoruz
        final List<dynamic> hamListe = jsonDecode(utf8.decode(yanit.bodyBytes));
        // Her bir JSON elemanını Urun.fromJson ile Urun nesnesine çevirip liste olarak dönüyoruz
        return hamListe
            // Listedeki her haritayı Map<String, dynamic> olarak okuyup modele dönüştürüyoruz
            .map((tekilJson) => Urun.fromJson(tekilJson as Map<String, dynamic>))
            // Standart Dart Listesine çeviriyoruz
            .toList();
      // Sunucu 200 haricinde bir hata kodu döndürdüyse
      } else {
        // Sunucu hata durumunu bildiren istisna fırlatıyoruz
        throw Exception('Sunucu hatası oluştu! Durum Kodu: ${yanit.statusCode}');
      // if-else kapanışı
      }
    // Bağlantı kopması veya ağ hatalarını yakalıyoruz
    } catch (hata) {
      // Kullanıcı arayüzüne hatayı bildirmek için yeniden fırlatıyoruz
      throw Exception('İnternet Bağlantısı Kurulamadı: $hata');
    // try-catch bloğu kapanışı
    }
  // tumUrunleriGetir metodunun kapanış parantezi
  }

  // Soyut arayüzden gelen kategoriye göre filtreleme metodunu somutlaştırıyoruz
  @override
  // Belirtilen kategoriye ait ürünleri getiren fonksiyon
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    // Eğer 'Hepsi' seçildiyse doğrudan tüm ürünleri çekip dönüyoruz
    if (kategori == Kategori.hepsi) {
      // Tüm ürünler listesini dönüyoruz
      return tumUrunleriGetir();
    // if kontrolü kapanışı
    }

    // Önce tüm ürünleri sunucudan çekiyoruz
    final tumUrunler = await tumUrunleriGetir();
    // Gelen ürünlerden sadece seçilen kategoriye ait olanları filtreleyip dönüyoruz
    return tumUrunler.where((urun) => urun.kategori == kategori).toList();
  // kategoriyeGoreGetir metodunun kapanış parantezi
  }

  // Soyut arayüzden gelen arama metnine göre arama metodunu somutlaştırıyoruz
  @override
  // Başlık veya açıklamada aranan metni içeren ürünleri döndüren fonksiyon
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    // Önce tüm ürünleri çekiyoruz
    final tumUrunler = await tumUrunleriGetir();
    // Arama kutusu boşsa veya sadece boşluktan ibaretse tüm listeyi dönüyoruz
    if (aramaMetni.trim().isEmpty) return tumUrunler;

    // Aranan kelimeyi küçük harfe çevirip boşluklarını buduyoruz
    final aranan = aramaMetni.trim().toLowerCase();
    // Ürünün başlığında veya açıklamasında aranan metin geçenleri filtreliyoruz
    return tumUrunler.where((urun) {
      // Başlık veya açıklamada aranan kelime var mı kontrolü
      return urun.baslik.toLowerCase().contains(aranan) ||
          urun.aciklama.toLowerCase().contains(aranan);
    // where filtresi ve toList dönüşümü
    }).toList();
  // adaGoreAra metodunun kapanış parantezi
  }
// ApiUrunServisi sınıfının kapanış parantezi
}
