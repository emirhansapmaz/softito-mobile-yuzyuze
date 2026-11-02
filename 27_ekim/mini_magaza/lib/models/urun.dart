// Kategori enum yapısını içe aktarıyoruz
import 'kategori.dart';
// Ürün değerlendirme (puan ve oy sayısı) modelini içe aktarıyoruz
import 'degerlendirme.dart';

// Mağazadaki bir ürüne ait tüm alanları ve iş kurallarını barındıran temel model sınıfımız
class Urun {
  // Ürünün benzersiz ID numarası
  final int id;
  // Ürünün başlığı / adı
  final String baslik;
  // Ürünün detaylı açıklaması
  final String aciklama;
  // Ürünün satış fiyatı (TL cinsinden)
  final double fiyat;
  // Ürünün görsel linki (URL)
  final String resimUrl;
  // Ürünün bağlı olduğu kategori enum değeri
  final Kategori kategori;
  // Ürünün depodaki güncel stok adedi
  final int stokAdedi;
  // Kullanıcının bu ürünü favoriye ekleyip eklemediğini tutan bayrak
  final bool favoriMi;
  // Ürünün kullanıcı değerlendirme nesnesi
  final Degerlendirme degerlendirme;

  // Urun sınıfının değişmez (const) kurucu metodu
  const Urun({
    // ID alanının zorunlu olduğunu belirtiyoruz
    required this.id,
    // Başlık alanının zorunlu olduğunu belirtiyoruz
    required this.baslik,
    // Açıklama alanının zorunlu olduğunu belirtiyoruz
    required this.aciklama,
    // Fiyat alanının zorunlu olduğunu belirtiyoruz
    required this.fiyat,
    // Resim linkinin zorunlu olduğunu belirtiyoruz
    required this.resimUrl,
    // Kategori alanının zorunlu olduğunu belirtiyoruz
    required this.kategori,
    // Stok adedinin zorunlu olduğunu belirtiyoruz
    required this.stokAdedi,
    // Varsayılan olarak ürün favorilere ekli değildir (false), copyWith ile değiştirilir
    this.favoriMi = false,
    // Değerlendirme nesnesinin zorunlu olduğunu belirtiyoruz
    required this.degerlendirme,
  // Kurucu metodun kapanış parantezi
  });

  // API'den gelen İngilizce veya farklı formatlardaki kategori metnini kendi Kategori enum'ımıza eşleyen yardımcı metot
  static Kategori _kategoriCozumle(dynamic kategoriJson) {
    // Kategori alanı null gelirse varsayılan olarak 'hepsi' dönüyoruz
    if (kategoriJson == null) return Kategori.hepsi;
    // Metni küçük harfe çevirip başındaki ve sonundaki boşlukları temizliyoruz
    final katStr = kategoriJson.toString().toLowerCase().trim();
    // 'electr' içeriyorsa elektronik kategorisine bağlıyoruz
    if (katStr.contains('electr')) {
      // Elektronik kategorisini dönüyoruz
      return Kategori.elektronik;
    // 'cloth' veya 'giyim' içeriyorsa giyim kategorisine bağlıyoruz
    } else if (katStr.contains('cloth') || katStr.contains('giyim')) {
      // Giyim kategorisini dönüyoruz
      return Kategori.giyim;
    // 'jewel' veya 'aksesuar' içeriyorsa aksesuar kategorisine bağlıyoruz
    } else if (katStr.contains('jewel') || katStr.contains('aksesuar')) {
      // Aksesuar kategorisini dönüyoruz
      return Kategori.aksesuar;
    // 'shoe' veya 'ayak' içeriyorsa ayakkabı kategorisine bağlıyoruz
    } else if (katStr.contains('shoe') || katStr.contains('ayak')) {
      // Ayakkabı kategorisini dönüyoruz
      return Kategori.ayakkabi;
    // if-else bloğu kapanışı
    }
    // Eşleşmeyen durumlarda 'hepsi' dönüyoruz
    return Kategori.hepsi;
  // _kategoriCozumle metodunun kapanış parantezi
  }

  // REST API'den gelen JSON haritasını Urun nesnesine dönüştüren fabrika kurucu metodumuz
  factory Urun.fromJson(Map<String, dynamic> json) {
    // Yeni Urun nesnesi üretiyoruz
    return Urun(
      // ID değerini tam sayı olarak güvenle okuyoruz, yoksa 0 atıyoruz
      id: (json['id'] as num?)?.toInt() ?? 0,
      // Başlık alanını okuyoruz, yoksa boş metin atıyoruz
      baslik: json['title'] as String? ?? '',
      // Fiyat alanını double olarak güvenle alıyoruz, yoksa 0.0 atıyoruz
      fiyat: (json['price'] as num?)?.toDouble() ?? 0.0,
      // Açıklama alanını okuyoruz, yoksa boş metin atıyoruz
      aciklama: json['description'] as String? ?? '',
      // Kategori metnini yardımcı metodumuzla Kategori enum'ına çeviriyoruz
      kategori: _kategoriCozumle(json['category']),
      // Stok adedi varsa doğrudan alıyoruz, yoksa rating count'u stok gibi simüle ediyoruz
      stokAdedi: (json['stokAdedi'] as num?)?.toInt() ??
          ((json['rating'] is Map && json['rating']['count'] != null)
              // API'deki oy sayısını stok gibi alıyoruz
              ? (json['rating']['count'] as num).toInt()
              // O da yoksa varsayılan 10 adet veriyoruz
              : 10),
      // Resim linkini okuyoruz
      resimUrl: json['image'] as String? ?? '',
      // rating haritasını Degerlendirme.fromJson ile çözümlüyoruz
      degerlendirme: Degerlendirme.fromJson(
        // rating alanı bir Map ise Map olarak geçiriyoruz, değilse null veriyoruz
        json['rating'] is Map<String, dynamic> ? json['rating'] as Map<String, dynamic> : null,
      // Degerlendirme.fromJson çağrısının kapanışı
      ),
      // İlk oluşturulduğunda ürün favori değildir
      favoriMi: false,
    // Urun nesne çağrısının kapanışı
    );
  // fromJson metodunun kapanış parantezi
  }

  // Değişmez (immutable) sınıflarda sadece belirli alanları (örn: favoriMi) güncelleyip yeni kopya üreten metot
  Urun copyWith({
    // İsteğe bağlı yeni ID
    int? id,
    // İsteğe bağlı yeni başlık
    String? baslik,
    // İsteğe bağlı yeni açıklama
    String? aciklama,
    // İsteğe bağlı yeni fiyat
    double? fiyat,
    // İsteğe bağlı yeni resim linki
    String? resimUrl,
    // İsteğe bağlı yeni kategori
    Kategori? kategori,
    // İsteğe bağlı yeni stok adedi
    int? stokAdedi,
    // İsteğe bağlı yeni favori durumu
    bool? favoriMi,
    // İsteğe bağlı yeni değerlendirme nesnesi
    Degerlendirme? degerlendirme,
  // Metot parametreleri kapanışı
  }) {
    // Yeni değer verildiyse onu, verilmediyse mevcut değeri koruyarak yeni Urun nesnesi döndürüyoruz
    return Urun(
      // Verildiyse yeni id, yoksa eski id
      id: id ?? this.id,
      // Verildiyse yeni baslik, yoksa eski baslik
      baslik: baslik ?? this.baslik,
      // Verildiyse yeni aciklama, yoksa eski aciklama
      aciklama: aciklama ?? this.aciklama,
      // Verildiyse yeni fiyat, yoksa eski fiyat
      fiyat: fiyat ?? this.fiyat,
      // Verildiyse yeni resimUrl, yoksa eski resimUrl
      resimUrl: resimUrl ?? this.resimUrl,
      // Verildiyse yeni kategori, yoksa eski kategori
      kategori: kategori ?? this.kategori,
      // Verildiyse yeni stokAdedi, yoksa eski stokAdedi
      stokAdedi: stokAdedi ?? this.stokAdedi,
      // Verildiyse yeni favoriMi, yoksa eski favoriMi
      favoriMi: favoriMi ?? this.favoriMi,
      // Verildiyse yeni degerlendirme, yoksa eski degerlendirme
      degerlendirme: degerlendirme ?? this.degerlendirme,
    // Urun nesne çağrısı kapanışı
    );
  // copyWith metodunun kapanış parantezi
  }

  // Sınıfın ekranda veya konsolda okunabilir metin temsilini veren toString metodu
  @override
  // toString metodunun gövdesi
  String toString() {
    // Ürünün özelliklerini formatlayarak döndürüyoruz
    return "Urun(id: $id, baslik: $baslik, fiyat: $fiyat ₺, favoriMi: $favoriMi)";
  // toString kapanış parantezi
  }
// Urun sınıfının kapanış parantezi
}
