// Flutter temel Material bileşenleri kütüphanesi
import 'package:flutter/material.dart';
// Model ve servis katmanını içeren dosyamızı içe aktarıyoruz
import '../services/urun_servisi.dart';

// Anasayfa: API'den gelen canlı ürün listesini ekranda gösteren ana ekranımız
class Anasayfa extends StatefulWidget {
  // Anasayfa sınıfının değişmez kurucu metodu
  const Anasayfa({
    // Widget ağacı için üst sınıfa key iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (state) yöneticisini bağlayan metot
  @override
  // _AnasayfaState durum nesnesini döndürüyoruz
  State<Anasayfa> createState() => _AnasayfaState();
// Anasayfa sınıfının kapanış parantezi
}

// Anasayfa ekranının durum değişkenlerini ve API mantığını tutan State sınıfımız
class _AnasayfaState extends State<Anasayfa> {
  // IUrunServisi tipinde referans alıyoruz (Polimorfizm prensibi):
  // Yarın CanliApiUrunServisi yerine TestServisi gelse bile aşağıdaki kodları değiştirmemiz gerekmez
  final IUrunServisi _urunServisi = CanliApiUrunServisi();

  // Asenkron API isteğinin sonucunu (bekleme, veri veya hata) tutacak Future değişkenimiz
  late Future<List<UrunModel>> _urunlerFuture;

  // Widget belleğe ilk yüklendiğinde bir kereliğine çalışan yaşam döngüsü metodu
  @override
  // initState metodunun başlangıcı
  void initState() {
    // Üst sınıfın initState fonksiyonunu çağırıyoruz
    super.initState();
    // initState: Sayfa ilk açıldığında sadece 1 kez çalışır.
    // build() içinde çağırmıyoruz çünkü build her tetiklendiğinde tekrar tekrar API'ye istek atıp kotayı tüketmesin
    _urunlerFuture = _urunServisi.urunleriGetir();
  // initState kapanış parantezi
  }

  // Ekranın görsel ağacını inşa eden build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren fonksiyon
  Widget build(BuildContext context) {
    // FutureBuilder: Asenkron işlem bitene kadar bekleyen ve snapshot ile durumları otomatik yöneten widget
    return FutureBuilder<List<UrunModel>>(
      // Takip edilecek Future asenkron işlemimiz
      future: _urunlerFuture,
      // Asenkron duruma göre uygun widget'ı ekrana çizen builder fonksiyonu
      builder: (context, snapshot) {
        // 1. Durum: Veriler sunucudan henüz gelmedi, yükleniyor durumu
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Ekranın tam ortasında dönen yükleme göstergesi
          return const Center(
            // Yeşil renkli dönen yükleme animasyonu
            child: CircularProgressIndicator(color: Colors.green),
          // Center kapanışı
          );
        // 2. Durum: Ağ kopması veya sunucu hatası oluştuysa
        } else if (snapshot.hasError) {
          // Hata mesajını ortalayarak gösteriyoruz
          return Center(
            // Kenarlardan 16 piksel boşluk bırakıyoruz
            child: Padding(
              // Her yönden 16 piksel padding
              padding: const EdgeInsets.all(16.0),
              // Hatanın ne olduğunu belirten metin
              child: Text(
                // Gelen hata mesajı içeriği
                'Hata Oluştu: ${snapshot.error}',
                // Metni ortalıyoruz
                textAlign: TextAlign.center,
                // Kırmızı ve kalın yazı stili
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              // Text kapanışı
              ),
            // Padding kapanışı
            ),
          // Center kapanışı
          );
        // 3. Durum: Veriler başarıyla geldiyse ve liste boş değilse
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Gelen ürün listesini yerel bir değişkene alıyoruz
          final urunler = snapshot.data!;

          // Gelen ürünleri dikeyde performanslı bir liste halinde diziyoruz
          return ListView.builder(
            // Listenin dış kenar boşlukları
            padding: const EdgeInsets.all(12),
            // Listedeki toplam ürün sayısı
            itemCount: urunler.length,
            // Her bir satır için çalışacak eleman yapıcı fonksiyon
            itemBuilder: (context, index) {
              // Sıradaki ürün nesnesini alıyoruz
              final urun = urunler[index];

              // Her bir ürünü temsil eden modern kart bileşeni
              return Card(
                // Kartlar arasına dikeyde 8 piksel boşluk
                margin: const EdgeInsets.symmetric(vertical: 8),
                // Karta hafif gölge derinliği veriyoruz
                elevation: 2,
                // Kartın köşelerini 12 piksel yuvarlatıyoruz
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                // Kart içeriğinin kenar boşlukları
                child: Padding(
                  // İçerik için her yönden 12 piksel boşluk
                  padding: const EdgeInsets.all(12.0),
                  // Görsel ve metinleri yan yana dizen Row
                  child: Row(
                    // Row çocukları listesi
                    children: [
                      // Ürün görselinin köşelerini yuvarlatan ClipRRect
                      ClipRRect(
                        // Köşeleri 8 piksel yuvarlatıyoruz
                        borderRadius: BorderRadius.circular(8),
                        // İnternetten resmi çeken Image.network
                        child: Image.network(
                          // Ürünün resim URL adresi
                          urun.resimUrl,
                          // Görsel genişliği
                          width: 80,
                          // Görsel yüksekliği
                          height: 80,
                          // Görselin kutuyu tam kaplamasını sağlıyoruz
                          fit: BoxFit.cover,
                          // Resim yüklenemezse veya link kırıksa gösterilecek yedek ikon
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80),
                        // Image.network kapanışı
                        ),
                      // ClipRRect kapanışı
                      ),
                      // Görsel ile metinler arasına 16 piksel yatay boşluk
                      const SizedBox(width: 16),

                      // Ürün Bilgileri Bölümü (Taşmayı önleyen Expanded mimarisi!)
                      Expanded(
                        // Metinleri alt alta dizen Column
                        child: Column(
                          // Metinleri sola hizalıyoruz
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // Sütun elemanları listesi
                          children: [
                            // Ürünün başlık metni
                            Text(
                              // Başlık içeriği
                              urun.baslik,
                              // En fazla 2 satır görünmesini sağlıyoruz
                              maxLines: 2,
                              // 2 satırı aşarsa sonuna üç nokta (...) koyuyoruz
                              overflow: TextOverflow.ellipsis,
                              // Kalın ve 16 punto yazı stili
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            // Text kapanışı
                            ),
                            // 4 piksel dikey boşluk
                            const SizedBox(height: 4),
                            // Kategori adı metni
                            Text(
                              // Kategori adını büyük harflerle yazdırıyoruz
                              urun.kategori.toUpperCase(),
                              // Gri renkli ve harf aralıklı stil
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12, letterSpacing: 1),
                            // Text kapanışı
                            ),
                            // 8 piksel dikey boşluk
                            const SizedBox(height: 8),
                            // Fiyat bilgisi metni
                            Text(
                              // Fiyatı dolar işareti ve 2 ondalık basamakla yazdırıyoruz
                              '\$${urun.fiyat.toStringAsFixed(2)}',
                              // Yeşil ve kalın fiyat stili
                              style: const TextStyle(
                                // Yeşil metin rengi
                                color: Colors.green,
                                // Kalın font
                                fontWeight: FontWeight.bold,
                                // 16 punto boyut
                                fontSize: 16,
                              // TextStyle kapanışı
                              ),
                            // Text kapanışı
                            ),
                          // Column çocukları kapanışı
                          ],
                        // Column kapanışı
                        ),
                      // Expanded kapanışı
                      ),
                    // Row çocukları kapanışı
                    ],
                  // Row kapanışı
                  ),
                // Padding kapanışı
                ),
              // Card kapanışı
              );
            // itemBuilder kapanışı
            },
          // ListView.builder kapanışı
          );
        // 3. Durum kapanışı
        }

        // 4. Durum: Sunucudan veri geldi ama liste tamamen boşsa
        return const Center(
          // Boş liste bilgilendirme metni
          child: Text('Gösterilecek ürün bulunamadı.'),
        // Center kapanışı
        );
      // FutureBuilder builder kapanışı
      },
    // FutureBuilder kapanışı
    );
  // build metodu kapanış parantezi
  }
// _AnasayfaState sınıfının kapanış parantezi
}

// Ürün listesine özel genişletme (extension) tanımı
extension on List<UrunModel> {
  // Liste eleman sayısını nullable dönen getter
  int? get count => null;
// extension kapanışı
}
