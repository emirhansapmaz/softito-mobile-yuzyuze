// Kategori filtreleme seçeneklerini sağlayan enum'ı içe aktarıyoruz
import '../models/kategori.dart';
// Ürün veri modelini içe aktarıyoruz
import '../models/urun.dart';

// Ürün servislerinin uyması gereken sözleşmeyi (interface) belirleyen soyut sınıfımız
abstract class IUrunServisi {
  // Depodaki veya API'deki tüm ürünleri getirmeyi taahhüt eden fonksiyon
  Future<List<Urun>> tumUrunleriGetir();

  // Seçilen kategoriye göre filtrelenmiş ürün listesini getiren fonksiyon
  Future<List<Urun>> kategoriyeGoreGetir(
    // Filtrelenecek kategori parametresi
    Kategori kategori,
  // kategoriyeGoreGetir metodunun kapanış parantezi
  );

  // Arama çubuğuna yazılan metne göre ürünleri filtreleyen fonksiyon
  Future<List<Urun>> adaGoreAra(
    // Kullanıcının yazdığı arama kelimesi
    String aramaMetni,
  // adaGoreAra metodunun kapanış parantezi
  );
// IUrunServisi arayüzünün kapanış parantezi
}
