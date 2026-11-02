// Flutter'ın temel Material bileşenlerini içeren kütüphaneyi içe aktarıyoruz
import 'package:flutter/material.dart';

// Kategori enum yapısını içe aktarıyoruz
import '../models/kategori.dart';
// Ürün veri modelini içe aktarıyoruz
import '../models/urun.dart';
// Ürün servisi soyut sözleşmesini (interface) içe aktarıyoruz
import '../services/i_urun_servisi.dart';
// FakeStore API ile haberleşen somut servis sınıfını içe aktarıyoruz
import '../services/api_urun_servisi.dart';
// Liste elemanları için hazırlanan ürün kartı bileşenini içe aktarıyoruz
import '../widgets/urun_karti.dart';

// Dinamik olarak durumu (filtre, arama, favori) değişeceği için StatefulWidget olarak oluşturuyoruz
class UrunListesiEkrani extends StatefulWidget {
  // Widget ağacı için kurucu metot
  const UrunListesiEkrani({
    // Üst sınıfa key iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın durum (State) yöneticisini bağlayan metot
  @override
  // _UrunListesiEkraniState durum nesnesini bağlıyoruz
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
// UrunListesiEkrani sınıfının kapanış parantezi
}

// Ekranın durum değişkenlerini, API isteklerini ve filtreleme mantığını barındıran State sınıfımız
class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  // Polimorfizm prensibi ile soyut servis arayüzüne bağlanan API servis referansımız
  final IUrunServisi _servis = ApiUrunServisi();
  // Verilerin sunucudan yüklenme durumunu takip eden bayrak
  bool _yukleniyorMu = true;

  // Arama metin kutusunu kontrol eden ve metin değişimini dinleyen kontrolcümüz
  final TextEditingController _aramaController = TextEditingController();

  // Kullanıcının o anda seçili tuttuğu kategori filtresi (varsayılan: hepsi)
  Kategori _seciliKategori = Kategori.hepsi;

  // Anlık yazılan arama kelimesi
  String _aramaKelimesi = "";

  // Filtrelenmiş ve ekranda o an gösterilecek ürünler listesi
  List<Urun> _filtrelenmisUrunler = [];
  // Sunucudan gelen tüm ham ürün havuzumuz
  List<Urun> _tumUrunler = [];

  // Sayfa ilk kez belleğe yüklendiğinde bir kereliğine çalışan yaşam döngüsü fonksiyonu
  @override
  // initState gövdesi
  void initState() {
    // Üst sınıfın initState metodunu çağırıyoruz
    super.initState();
    // Ekran açılır açılmaz ürünleri sunucudan çekmeye başlıyoruz
    _urunleriYukle();
  // initState metodunun kapanış parantezi
  }

  // Sayfa kapandığında bellek sızıntısını önlemek için kontrolcüyü serbest bırakıyoruz
  @override
  // dispose gövdesi
  void dispose() {
    // Arama kontrolcüsünü bellekten temizliyoruz
    _aramaController.dispose();
    // Üst sınıfın dispose fonksiyonunu çağırıyoruz
    super.dispose();
  // dispose metodunun kapanış parantezi
  }

  // Sunucudan ürünleri asenkron olarak çeken ana fonksiyonumuz
  Future<void> _urunleriYukle() async {
    // Yükleme animasyonunu başlatmak için durumu güncelliyoruz
    setState(() {
      // Yükleniyor bayrağını true yapıyoruz
      _yukleniyorMu = true;
    // setState kapanışı
    });

    // Ağ hatalarını yakalamak için try-catch bloğu açıyoruz
    try {
      // Servis üzerinden ürün listesini asenkron olarak çekiyoruz
      final urunler = await _servis.tumUrunleriGetir();

      // Widget hala ekranda çiziliyse (mounted ise) durumu güncelliyoruz
      if (mounted) {
        // Ekranı yeni verilerle yeniden çiziyoruz
        setState(() {
          // Ham ürün havuzuna atıyoruz
          _tumUrunler = urunler;
          // İlk açılışta filtrelenmiş listeye de tüm ürünleri veriyoruz
          _filtrelenmisUrunler = urunler;
          // Yükleme bayrağını kapatıyoruz
          _yukleniyorMu = false;
        // setState kapanışı
        });
      // if mounted kontrolü kapanışı
      }
    // Hata durumunu yakalıyoruz
    } catch (e) {
      // Widget hala ekrandaysa kullanıcıya hata mesajı basıyoruz
      if (mounted) {
        // Ekran durumunu güncelliyoruz
        setState(() {
          // Yükleme bayrağını kapatıyoruz
          _yukleniyorMu = false;
        // setState kapanışı
        });
        // Ekranın altında kırmızı bir SnackBar gösteriyoruz
        ScaffoldMessenger.of(context).showSnackBar(
          // SnackBar bileşeni
          SnackBar(
            // Hata metni
            content: Text('Ürünler yüklenirken hata oluştu: $e'),
            // Kırmızı hata arka plan rengi
            backgroundColor: Colors.red,
          // SnackBar kapanışı
          ),
        // showSnackBar kapanışı
        );
      // if mounted kapanışı
      }
    // try-catch kapanışı
    }
  // _urunleriYukle metodunun kapanış parantezi
  }

  // Hem kategori filtresini hem de metin aramasını birleştirerek uygulayan fonksiyonumuz
  void _filtreUygula() {
    // Arama metnini küçük harfe çevirip boşlukları temizliyoruz
    final aranan = _aramaController.text.trim().toLowerCase();

    // Filtrelenmiş listeyi güncelleyip ekranı yeniden çiziyoruz
    setState(() {
      // Tüm ürünler arasından koşulları sağlayanları seçiyoruz
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        // Kategori 'hepsi' mi yoksa ürünün kategorisiyle uyuşuyor mu kontrolü
        final kategoriUygunMu = (_seciliKategori == Kategori.hepsi) || (urun.kategori == _seciliKategori);
        // Arama kutusu boş mu veya ürün başlığında / açıklamasında geçiyor mu kontrolü
        final aramaUygunMu = aranan.isEmpty ||
            urun.baslik.toLowerCase().contains(aranan) ||
            urun.aciklama.toLowerCase().contains(aranan);
        // İki koşul da sağlanıyorsa ürünü listeye dahil ediyoruz
        return kategoriUygunMu && aramaUygunMu;
      // where filtresi kapanışı ve toList dönüşümü
      }).toList();
    // setState kapanışı
    });
  // _filtreUygula metodunun kapanış parantezi
  }

  // Bir ürünün favori durumunu tersine çeviren (aç/kapat) fonksiyonumuz
  void _favoriyiDegistir(Urun hedefUrun) {
    // Ekranı güncellemek için setState çağırıyoruz
    setState(() {
      // copyWith kullanarak sadece favoriMi alanını tersine çeviriyoruz
      final yeniUrun = hedefUrun.copyWith(favoriMi: !hedefUrun.favoriMi);
      // Güncellenen ürünün ana listedeki indeksini buluyoruz
      final index = _tumUrunler.indexWhere((u) => u.id == hedefUrun.id);
      // Ürün listede mevcutsa yeni kopya ile değiştiriyoruz
      if (index != -1) {
        // Yeni ürünü eski yerine yazıyoruz
        _tumUrunler[index] = yeniUrun;
      // if kontrolü kapanışı
      }
      // Filtrelenmiş listeye de yansıması için filtreyi tekrar uyguluyoruz
      _filtreUygula();
    // setState kapanışı
    });
  // _favoriyiDegistir metodunun kapanış parantezi
  }

  // Ekranın görsel ağacını inşa eden build fonksiyonu
  @override
  // BuildContext parametresini alan ve Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Sayfanın temel iskeleti olan Scaffold
    return Scaffold(
      // Sayfanın üst bilgi çubuğu (AppBar)
      appBar: AppBar(
        // Başlık metni
        title: const Text(
          // Uygulama başlığı
          "Mini Mağaza",
          // Kalın yazı stili
          style: TextStyle(
            // Kalın font
            fontWeight: FontWeight.bold,
          // TextStyle kapanışı
          ),
        // Text kapanışı
        ),
        // Başlığı ortalıyoruz
        centerTitle: true,
        // Sağ üst köşedeki buton ve sayaçlar listesi
        actions: [
          // Sağ kenardan 16 piksel boşluk bırakıyoruz
          Padding(
            // Sağ kenar boşluğu
            padding: const EdgeInsets.only(right: 16.0),
            // İçeriği dikeyde ortalayan Center
            child: Center(
              // Üzerine favori sayısını rozet olarak basan Badge bileşeni
              child: Badge(
                // Rozet üzerindeki sayı metni
                label: Text(
                  // Favori olan ürünlerin toplam adedini hesaplayıp yazdırıyoruz
                  '${_tumUrunler.where((u) => u.favoriMi).length}',
                  // Rozet yazı stili
                  style: const TextStyle(
                    // Kalın font
                    fontWeight: FontWeight.bold,
                  // TextStyle kapanışı
                  ),
                // Text kapanışı
                ),
                // Rozetin altındaki kırmızı kalp ikonu
                child: const Icon(Icons.favorite, color: Colors.red),
              // Badge kapanışı
              ),
            // Center kapanışı
            ),
          // Padding kapanışı
          ),
        // actions listesi kapanışı
        ],
      // AppBar kapanışı
      ),
      // Sayfanın dikey gövde sütunu
      body: Column(
        // Sütun elemanları listesi
        children: [
          // Arama çubuğunu saran kenar boşluğu
          Padding(
            // Soldan 16, üstten 8, sağdan 16, alttan 4 piksel boşluk
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            // Metin giriş kutusu TextField
            child: TextField(
              // Metin kontrolcümüzü bağlıyoruz
              controller: _aramaController,
              // Kullanıcı her harf yazdığında filtreyi otomatik tetikliyoruz
              onChanged: (_) => _filtreUygula(),
              // Arama kutusunun görsel süslemeleri
              decoration: InputDecoration(
                // Silik yer tutucu ipucu metni
                hintText: "Ürün veya marka ara...",
                // Sol taraftaki büyüteç arama ikonu
                prefixIcon: const Icon(Icons.search),
                // Arama kutusunda metin varsa temizleme (çarpı) butonu gösteriyoruz
                suffixIcon: _aramaController.text.isNotEmpty
                    ? IconButton(
                        // Temizleme ikonu
                        icon: const Icon(Icons.clear),
                        // Butona basıldığında kutuyu temizleyip filtreyi yeniliyoruz
                        onPressed: () {
                          // Metin kutusunu temizliyoruz
                          _aramaController.clear();
                          // Filtreyi sıfırlıyoruz
                          _filtreUygula();
                        // onPressed kapanışı
                        },
                      // IconButton kapanışı
                      )
                    : null,
                // Arka planın dolgulu olmasını sağlıyoruz
                filled: true,
                // Açık gri dolgu rengi
                fillColor: Colors.grey.shade100,
                // Çizgisiz yuvarlak kenarlık tasarımı
                border: OutlineInputBorder(
                  // 12 piksel köşe yuvarlatma
                  borderRadius: BorderRadius.circular(12),
                  // Kenar çizgisini kaldırıyoruz
                  borderSide: BorderSide.none,
                // OutlineInputBorder kapanışı
                ),
                // Dikey iç boşluğu sıfırlayarak kutuyu kompakt tutuyoruz
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              // InputDecoration kapanışı
              ),
            // TextField kapanışı
            ),
          // Padding kapanışı
          ),

          // Kategorileri yatayda kaydırılabilir yapan SingleChildScrollView
          SingleChildScrollView(
            // Yatay eksende kaydırma yönü
            scrollDirection: Axis.horizontal,
            // Yatayda 12, dikeyde 8 piksel kenar boşluğu
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            // Kategorileri yan yana dizen Row
            child: Row(
              // Kategori enum değerlerini gezerek ChoiceChip bileşenlerine dönüştürüyoruz
              children: Kategori.values.map((kategori) {
                // Bu kategorinin şu an seçili olup olmadığını kontrol ediyoruz
                final seciliMi = _seciliKategori == kategori;
                // Her chip arasına 4 piksel yatay boşluk
                return Padding(
                  // Yatay kenar boşluğu
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  // Seçilebilir modern hap (chip) butonu
                  child: ChoiceChip(
                    // Chip'in solundaki kategori ikonu
                    avatar: Text(kategori.ikon),
                    // Chip üzerindeki kategori başlığı
                    label: Text(kategori.baslik),
                    // Seçili olma durumu
                    selected: seciliMi,
                    // Kullanıcı chip'e tıkladığında çalışan olay
                    onSelected: (secildi) {
                      // Eğer tıklandıysa seçili kategoriyi güncelliyoruz
                      if (secildi) {
                        // Durumu yeniliyoruz
                        setState(() {
                          // Yeni seçilen kategoriyi atıyoruz
                          _seciliKategori = kategori;
                          // Filtreyi güncelliyoruz
                          _filtreUygula();
                        // setState kapanışı
                        });
                      // if secildi kapanışı
                      }
                    // onSelected kapanışı
                    },
                  // ChoiceChip kapanışı
                  ),
                // Padding kapanışı
                );
              // map dönüşümü ve toList kapanışı
              }).toList(),
            // Row çocukları kapanışı
            ),
          // SingleChildScrollView kapanışı
          ),

          // Kalan tüm dikey alanı kaplayan ürün listesi alanı
          Expanded(
            // 1. Durum: Veriler yükleniyorsa dönen yükleme göstergesi
            child: _yukleniyorMu
                ? const Center(child: CircularProgressIndicator())
                // 2. Durum: Arama sonucu eşleşen ürün bulunamadıysa uyarı ekranı
                : _filtrelenmisUrunler.isEmpty
                    ? Center(
                        // İkon ve metni ortalayan sütun
                        child: Column(
                          // Dikeyde ortalıyoruz
                          mainAxisAlignment: MainAxisAlignment.center,
                          // Elemanlar listesi
                          children: [
                            // Arama bulunamadı ikonu
                            Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                            // 12 piksel dikey boşluk
                            const SizedBox(height: 12),
                            // Bilgilendirme metni
                            Text(
                              // Uyarı mesajı
                              'Aradığınız kriterlere uygun ürün bulunamadı.',
                              // Stil özellikleri
                              style: TextStyle(
                                // Gri metin rengi
                                color: Colors.grey.shade600,
                                // 16 punto boyut
                                fontSize: 16,
                                // Yarı kalın font
                                fontWeight: FontWeight.w600,
                              // TextStyle kapanışı
                              ),
                            // Text kapanışı
                            ),
                          // Column çocukları kapanışı
                          ],
                        // Column kapanışı
                        ),
                      // Center kapanışı
                      )
                    // 3. Durum: Filtrelenmiş ürün listesini gösteriyoruz
                    : ListView.builder(
                        // Listedeki toplam ürün adedi
                        itemCount: _filtrelenmisUrunler.length,
                        // Her bir ürün satırı için çalışan yapıcı
                        itemBuilder: (context, index) {
                          // Sıradaki ürün nesnesi
                          final urun = _filtrelenmisUrunler[index];
                          // Ürün kartı bileşeni
                          return UrunKarti(
                            // Resim linki boşsa rastgele yer tutucu görsel veriyoruz
                            urun: urun.resimUrl.isNotEmpty
                                ? urun
                                : urun.copyWith(resimUrl: "https://picsum.photos/400/400/?random=${urun.id}"),
                            // Favori butonuna tıklandığında favoriyi değiştiren fonksiyonu tetikliyoruz
                            onFavoriTiklandi: () => _favoriyiDegistir(urun),
                            // Karta tıklandığında tıklandığını bildiren geçici SnackBar gösteriyoruz
                            onDetayTiklandi: () {
                              // SnackBar gösteriyoruz
                              ScaffoldMessenger.of(context).showSnackBar(
                                // SnackBar bileşeni
                                SnackBar(
                                  // Tıklanan ürün başlığı mesajı
                                  content: Text('${urun.baslik} tıklandı!'),
                                  // 600 milisaniye ekranda kalsın
                                  duration: const Duration(milliseconds: 600),
                                // SnackBar kapanışı
                                ),
                              // showSnackBar kapanışı
                              );
                            // onDetayTiklandi kapanışı
                            },
                          // UrunKarti kapanışı
                          );
                        // itemBuilder kapanışı
                        },
                      // ListView.builder kapanışı
                      ),
          // Expanded kapanışı
          ),
        // Column çocukları kapanışı
        ],
      // Column kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// _UrunListesiEkraniState sınıfının kapanış parantezi
}
