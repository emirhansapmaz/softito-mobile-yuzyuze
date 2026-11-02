// Ürün servisi soyut sözleşmesini (interface) içe aktarıyoruz
import 'i_urun_servisi.dart';
// Kategori enum tanımını içe aktarıyoruz
import '../models/kategori.dart';
// Ürün veri modelini içe aktarıyoruz
import '../models/urun.dart';
// Ürün değerlendirme (puan ve oy) modelini içe aktarıyoruz
import '../models/degerlendirme.dart';

// Gerçek internet bağlantısı olmadan sahte (mock) veri sağlayan test servisi sınıfımız
class MockUrunServisi implements IUrunServisi {
  // Test aşamasında kullanılacak sabit ürün listesi depomuz
  final List<Urun> _urunDeposu = const [
    // 1. Ürün: Macbook M5 Pro Laptop
    Urun(
      // Benzersiz ürün kimliği
      id: 1,
      // Ürün başlığı
      baslik: "Macbook M5 Pro Laptop",
      // Ürün detay açıklaması
      aciklama: "Apple'ın en güçlü işlemcisine sahip yeni nesil Macbook Pro",
      // Ürün satış fiyatı
      fiyat: 179999.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/200/200",
      // Ürün kategorisi (elektronik)
      kategori: Kategori.elektronik,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 5,
    // 1. Urun kapanışı
    ),
    // 2. Ürün: Apple iPhone 18 Pro Max
    Urun(
      // Benzersiz ürün kimliği
      id: 2,
      // Ürün başlığı
      baslik: "Apple İphone 18 Pro Max",
      // Ürün detay açıklaması
      aciklama: "Apple'ın en gelişmiş kamera sistemine sahip yeni nesil İphone",
      // Ürün satış fiyatı
      fiyat: 149999.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/400/400",
      // Ürün kategorisi (elektronik)
      kategori: Kategori.elektronik,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 14,
    // 2. Urun kapanışı
    ),
    // 3. Ürün: Erkek Giyim Gömlek
    Urun(
      // Benzersiz ürün kimliği
      id: 3,
      // Ürün başlığı
      baslik: "Erkek Giyim Gömlek",
      // Ürün detay açıklaması
      aciklama: "Erkek Giyim Gömlek",
      // Ürün satış fiyatı
      fiyat: 499.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/400/400",
      // Ürün kategorisi (giyim)
      kategori: Kategori.giyim,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 15,
    // 3. Urun kapanışı
    ),
    // 4. Ürün: Lenovo Thinkpad X1
    Urun(
      // Benzersiz ürün kimliği
      id: 4,
      // Ürün başlığı
      baslik: "Lenovo Thinkpad X1",
      // Ürün detay açıklaması
      aciklama: "İş Dünyasının Vazgeçilmezi İşlemciye sahip yeni nesil laptop",
      // Ürün satış fiyatı
      fiyat: 17999.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/400/400",
      // Ürün kategorisi (elektronik)
      kategori: Kategori.elektronik,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 5,
    // 4. Urun kapanışı
    ),
    // 5. Ürün: Adidas Sneakers
    Urun(
      // Benzersiz ürün kimliği
      id: 5,
      // Ürün başlığı
      baslik: "Adidas Sneackers",
      // Ürün detay açıklaması
      aciklama: "Adidas Sneackers",
      // Ürün satış fiyatı
      fiyat: 1799.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/400/400",
      // Ürün kategorisi (ayakkabı)
      kategori: Kategori.ayakkabi,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 132,
    // 5. Urun kapanışı
    ),
    // 6. Ürün: Nike Air Jordan
    Urun(
      // Benzersiz ürün kimliği
      id: 6,
      // Ürün başlığı
      baslik: "Nike Air Jordan",
      // Ürün detay açıklaması
      aciklama: "Nike Air Jordan",
      // Ürün satış fiyatı
      fiyat: 2999.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/400/400",
      // Ürün kategorisi (ayakkabı)
      kategori: Kategori.ayakkabi,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 132,
    // 6. Urun kapanışı
    ),
    // 7. Ürün: İnci Kolye
    Urun(
      // Benzersiz ürün kimliği
      id: 7,
      // Ürün başlığı
      baslik: "İnci Kolye",
      // Ürün detay açıklaması
      aciklama: "Zarif ve Şık İnci Kolye",
      // Ürün satış fiyatı
      fiyat: 4999.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/400/400",
      // Ürün kategorisi (aksesuar)
      kategori: Kategori.aksesuar,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 25,
    // 7. Urun kapanışı
    ),
    // 8. Ürün: Apple Watch Series 10
    Urun(
      // Benzersiz ürün kimliği
      id: 8,
      // Ürün başlığı
      baslik: "Apple Watch Series 10",
      // Ürün detay açıklaması
      aciklama: "Apple Watch Series 10",
      // Ürün satış fiyatı
      fiyat: 25999.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/400/400",
      // Ürün kategorisi (elektronik)
      kategori: Kategori.elektronik,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 5,
    // 8. Urun kapanışı
    ),
    // 9. Ürün: Erkek Deri Ceket
    Urun(
      // Benzersiz ürün kimliği
      id: 9,
      // Ürün başlığı
      baslik: "Erkek Deri Ceket",
      // Ürün detay açıklaması
      aciklama: "Erkek Deri Ceket",
      // Ürün satış fiyatı
      fiyat: 1999.99,
      // Ürün görsel adresi
      resimUrl: "https://picsum.photos/400/400",
      // Ürün kategorisi (giyim)
      kategori: Kategori.giyim,
      // Değerlendirme puan ve oy sayısı
      degerlendirme: Degerlendirme(
        // Ortalama puanı
        puan: 4.5,
        // Toplam oy sayısı
        oySayisi: 120,
      // Degerlendirme kapanışı
      ),
      // Depodaki stok miktarı
      stokAdedi: 34,
    // 9. Urun kapanışı
    ),
  // _urunDeposu listesi kapanışı
  ];

  // MockUrunServisi sınıfının kurucu metodu
  MockUrunServisi();

  // Arayüzden gelen tüm ürünleri getirme metodunu somutlaştırıyoruz
  @override
  // Sahte depodaki tüm ürünleri asenkron olarak döndüren fonksiyon
  Future<List<Urun>> tumUrunleriGetir() async {
    // Gerçekçi ağ gecikmesi hissettirmek için 3 saniye bekletiyoruz
    await Future.delayed(const Duration(milliseconds: 3000));
    // Ürün listesinin kopyasını yeni bir liste olarak dönüyoruz
    return List.from(_urunDeposu);
  // tumUrunleriGetir metodunun kapanış parantezi
  }

  // Arayüzden gelen isme göre arama metodunu somutlaştırıyoruz
  @override
  // Arama metnine uyan ürünleri filtreleyen fonksiyon
  Future<List<Urun>> adaGoreAra(String aramaMetni) async {
    // 300 milisaniye arama gecikmesi simüle ediyoruz
    await Future.delayed(const Duration(milliseconds: 300));
    // Arama kutusu boşsa tüm listeyi dönüyoruz
    if (aramaMetni.trim().isEmpty) {
      // Tüm ürün listesini geri dönüyoruz
      return List.from(_urunDeposu);
    // if kontrolü kapanışı
    }

    // Başlığında aranan metin geçen ürünleri filtreliyoruz
    return _urunDeposu.where((urun) {
      // Ürün başlığını küçük harfe çeviriyoruz
      final baslikKucuk = urun.baslik.toLowerCase();
      // Aranan kelimeyi küçük harfe çeviriyoruz
      final arananKucuk = aramaMetni.toLowerCase();
      // Başlık içinde geçip geçmediğini kontrol ediyoruz
      return baslikKucuk.contains(arananKucuk);
    // where filtresi ve toList dönüşümü
    }).toList();
  // adaGoreAra metodunun kapanış parantezi
  }

  // Arayüzden gelen kategoriye göre filtreleme metodunu somutlaştırıyoruz
  @override
  // Seçilen kategoriye ait ürünleri getiren fonksiyon
  Future<List<Urun>> kategoriyeGoreGetir(Kategori kategori) async {
    // 400 milisaniye gecikme simüle ediyoruz
    await Future.delayed(const Duration(milliseconds: 400));
    // 'Hepsi' seçildiyse tüm ürünleri dönüyoruz
    if (kategori == Kategori.hepsi) {
      // Listenin tamamını dönüyoruz
      return List.from(_urunDeposu);
    // if kontrolü kapanışı
    }
    // Seçilen kategoriye eşit olan ürünleri filtreleyip dönüyoruz
    return _urunDeposu.where((urun) => urun.kategori == kategori).toList();
  // kategoriyeGoreGetir metodunun kapanış parantezi
  }
// MockUrunServisi sınıfının kapanış parantezi
}
