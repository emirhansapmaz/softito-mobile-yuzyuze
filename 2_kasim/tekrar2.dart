// Flutter'ın temel Material bileşenlerini içeren kütüphaneyi içe aktarıyoruz
import 'package:flutter/material.dart';

// Bu widget'ta Flutter'da sıkça karşılaşılan "Row içinde metin taşması (overflow)"
// hatasını ve Expanded ile çözümünü satır satır inceliyoruz.
class HataliveDogruRow extends StatelessWidget {
  // HataliveDogruRow sınıfının değişmez (const) kurucu metodu
  const HataliveDogruRow({
    // Widget ağacı için üst sınıfa key parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext alıp geriye Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Sayfanın temel iskeletini sağlayan Scaffold bileşeni
    return Scaffold(
      // Sayfanın üst bilgi çubuğu (AppBar)
      appBar: AppBar(
        // Başlık metni
        title: const Text("Row ve Layout"),
      // AppBar kapanışı
      ),
      // Sayfanın gövde alanı ve tüm kenarlardan 16 piksel boşluk
      body: Padding(
        // Her yönden 16 piksel boşluk veriyoruz
        padding: const EdgeInsets.all(16.0),
        // Elemanları yukarıdan aşağıya alt alta dizen Column
        child: Column(
          // Çocukları sola hizalıyoruz
          crossAxisAlignment: CrossAxisAlignment.start,
          // Column içindeki dikey bileşenler listesi
          children: [
            // 1. Kısım: Hatalı yapı uyarısı
            // Row yatayda sınırsız genişlik verir. Eğer Row içine uzun bir Text koyarsak
            // ekran sınırını aşar ve meşhur sarı-siyah şeritli "RenderFlex overflowed" hatası çıkar.
            const Text(
              // Uyarı metni
              'Hatalı Yapı: A overflowed by *** pixels (sarı siyah şerit)',
              // Metin stil özellikleri
              style: TextStyle(
                // Kalın yazı tipi
                fontWeight: FontWeight.bold,
                // Kırmızı renk ile dikkat çekiyoruz
                color: Colors.red,
              // TextStyle kapanışı
              ),
            // Text kapanışı
            ),
            // 8 piksellik dikey boşluk
            const SizedBox(height: 8),

            // Hatalı örneği gösterdiğimiz sarı arka planlı kutu
            Container(
              // Arka plan rengini açık amber yapıyoruz
              color: Colors.amber.shade100,
              // Elemanları yatayda yan yana dizen Row
              child: Row(
                // Row içindeki yatay bileşenler
                children: const [
                  // Uyarı ikonu
                  Icon(Icons.warning, color: Colors.red),
                  // Bu metin kısa kaldığı sürece patlamaz ama uzarsa veya ekran daralırsa sınır olmadığı için taşar
                  Text('Kısa Metin (hata vermez ama uzarsa Render Patlar)'),
                // Row çocukları kapanışı
                ],
              // Row kapanışı
              ),
            // Container kapanışı
            ),
            // Bölümler arasına 32 piksellik dikey boşluk bırakıyoruz
            const SizedBox(height: 32),

            // 2. Kısım: Doğru yapı açıklaması
            // Expanded kullanmak demek: "Row içindeki kalan tüm boşluğu sen kapla ve
            // çocuğunun bu sınırı aşmasına izin verme" demektir. Böylece metin alt satıra geçer.
            const Text(
              // Bilgi metni
              'Doğru Yapı: Flexible ve Expanded ile sınırlandırılmıştır.',
              // Metin stil özellikleri
              style: TextStyle(
                // Kalın yazı tipi
                fontWeight: FontWeight.bold,
                // Yeşil renk ile doğru olduğunu belirtiyoruz
                color: Colors.green,
              // TextStyle kapanışı
              ),
            // Text kapanışı
            ),
            // 8 piksellik dikey boşluk
            const SizedBox(height: 8),

            // Doğru örneği gösterdiğimiz yeşil arka planlı ve çerçeveli kutu
            Container(
              // İçerik için her yönden 12 piksel iç boşluk (padding)
              padding: const EdgeInsets.all(12),
              // Kutunun görsel dekorasyonu
              decoration: BoxDecoration(
                // Açık yeşil arka plan rengi
                color: Colors.green.shade50,
                // Köşeleri 8 piksel yuvarlatıyoruz
                borderRadius: BorderRadius.circular(8),
                // Yeşil renkli dış çerçeve çizgisi
                border: Border.all(color: Colors.green),
              // BoxDecoration kapanışı
              ),
              // Elemanları yatayda hizalayan Row
              child: Row(
                // Row içindeki elemanlar listesi
                children: const [
                  // Yeşil daire içinde onay işareti
                  CircleAvatar(
                    // Daire arka plan rengi
                    backgroundColor: Colors.green,
                    // Beyaz renkli onay ikonu
                    child: Icon(Icons.check, color: Colors.white),
                  // CircleAvatar kapanışı
                  ),
                  // İkon ile metin arasına 12 piksel yatay boşluk
                  SizedBox(width: 12),

                  // Expanded widget'ı: Row içindeki boş alanı hesaplar ve Column/Text'i bu alanla sınırlar
                  Expanded(
                    // Taşmayı önlemek için sınırlandırılan dikey Column
                    child: Column(
                      // Metinleri sola hizalıyoruz
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Sütun elemanları listesi
                      children: [
                        // Başlık metni
                        Text(
                          // Metin içeriği
                          'Softito 4.Dönem Mobil Standartı',
                          // Kalın yazı stili
                          style: TextStyle(fontWeight: FontWeight.bold),
                        // Text kapanışı
                        ),
                        // Başlık ile açıklama arasına 4 piksel boşluk
                        SizedBox(height: 4),
                        // Metin artık ekran genişliğini bildiği için otomatik olarak alt satıra kayar
                        Text(
                          // Uzun açıklama metni
                          'Bu metin ne kadar uzun olursa olsun, telefonun ekranının genişliğinde alt satıra geçer ve asla sarı siyah taşma hatası üretmez.',
                          // Koyu gri yazı rengi
                          style: TextStyle(color: Colors.black87),
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
            // Container kapanışı
            ),
          // Column çocukları kapanışı
          ],
        // Column kapanışı
        ),
      // Padding kapanışı
      ),
    // Scaffold kapanışı
    );
  // build metodu kapanış parantezi
  }
// HataliveDogruRow sınıfının kapanış parantezi
}
