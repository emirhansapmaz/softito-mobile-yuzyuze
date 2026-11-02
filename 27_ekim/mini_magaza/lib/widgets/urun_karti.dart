// Flutter Material tasarım bileşenlerini içe aktarıyoruz
import 'package:flutter/material.dart';
// Ürün veri modelini içe aktarıyoruz
import '../models/urun.dart';
// Stok durumunu gösteren rozet bileşenini içe aktarıyoruz
import 'stok_rozeti.dart';

// Liste ekranında her bir ürünü kart şeklinde gösteren tekrar kullanılabilir bileşenimiz
class UrunKarti extends StatelessWidget {
  // Kart üzerinde bilgileri gösterilecek ürün nesnesi
  final Urun urun;

  // Kalp ikonuna tıklandığında üst sınıftaki fonksiyonu tetikleyecek Callback
  final VoidCallback onFavoriTiklandi;
  // Kartın kendisine tıklandığında detay sayfasına yönlendirecek Callback
  final VoidCallback onDetayTiklandi;

  // UrunKarti sınıfının değişmez kurucu metodu
  const UrunKarti({
    // Widget ağacı için anahtar parametresi
    super.key,
    // Ürün nesnesinin zorunlu olduğunu belirtiyoruz
    required this.urun,
    // Favori tıklama olayının zorunlu olduğunu belirtiyoruz
    required this.onFavoriTiklandi,
    // Detay tıklama olayının zorunlu olduğunu belirtiyoruz
    required this.onDetayTiklandi,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext parametresini alan ve Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Hafif gölgeli ve yuvarlatılmış köşeli Card bileşeni
    return Card(
      // Kartlar arasına yatayda 16, dikeyde 8 piksel dış boşluk (margin)
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      // Kart gölgesinin derinlik derecesi (2 piksel)
      elevation: 2,
      // Kartın köşelerini 12 piksel yuvarlatıyoruz
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // Tıklandığında su dalgası (ripple) efekti veren InkWell bileşeni
      child: InkWell(
        // Dalgalanma efektinin kartın yuvarlatılmış köşelerinden taşmasını önlüyoruz
        borderRadius: BorderRadius.circular(12),
        // Karta tıklandığında dışarıdan iletilen onDetayTiklandi fonksiyonunu çalıştırıyoruz
        onTap: onDetayTiklandi,
        // Kart içeriği için iç boşluk (padding)
        child: Padding(
          // İçerik için her yönden 12 piksel boşluk
          padding: const EdgeInsets.all(12.0),
          // Resim, metinler ve kalp ikonunu yatayda dizen Row
          child: Row(
            // Elemanları yukarıdan aynı hizaya başlatıyoruz
            crossAxisAlignment: CrossAxisAlignment.start,
            // Row elemanları listesi
            children: [
              // Ürün görselinin köşelerini yuvarlatan ClipRRect
              ClipRRect(
                // Görselin köşelerini 10 piksel yuvarlatıyoruz
                borderRadius: BorderRadius.circular(10),
                // İnternet adresinden resmi indiren Image.network
                child: Image.network(
                  // Ürün resim URL adresi
                  urun.resimUrl,
                  // Görsel genişliği (90 piksel)
                  width: 90,
                  // Görsel yüksekliği (90 piksel)
                  height: 90,
                  // Görselin kutuyu orantılı şekilde kırparak doldurmasını sağlıyoruz
                  fit: BoxFit.cover,
                  // Resim internetten inerken dönen yükleme göstergesi
                  loadingBuilder: (context, child, progress) {
                    // Resim indirme bittiyse orijinal görseli gösteriyoruz
                    if (progress == null) return child;
                    // Henüz iniyorsa gri bir kutu içinde dönen yükleme ikonu gösteriyoruz
                    return Container(
                      // Kutu genişliği (90 piksel)
                      width: 90,
                      // Kutu yüksekliği (90 piksel)
                      height: 90,
                      // Açık gri arka plan
                      color: Colors.grey.shade100,
                      // Yükleme ikonunu ortalayan Center
                      child: const Center(
                        // İnce çizgili dönen yükleme animasyonu
                        child: CircularProgressIndicator(strokeWidth: 2),
                      // Center kapanışı
                      ),
                    // Container kapanışı
                    );
                  // loadingBuilder kapanışı
                  },
                // Image.network kapanışı
                ),
              // ClipRRect kapanışı
              ),
              // Görsel ile metinler arasına 14 piksel yatay boşluk
              const SizedBox(width: 14),

              // Kalan tüm yatay alanı dolduran ve metinlerin taşmasını önleyen Expanded
              Expanded(
                // Metinleri alt alta dizen Column
                child: Column(
                  // Metinleri sola hizalıyoruz
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Sütun elemanları listesi
                  children: [
                    // Kategori adı ve stok rozetini yan yana dizen satır
                    Row(
                      // Kategori ile stok rozeti arasını maksimum açıyoruz
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // Satır elemanları listesi
                      children: [
                        // Kategori ikon ve adını gösteren metin
                        Text(
                          // Kategorinin simgesi ve Türkçe adı
                          '${urun.kategori.ikon} ${urun.kategori.baslik}',
                          // Kategori metin stili
                          style: TextStyle(
                            // Gri metin rengi
                            color: Colors.grey.shade600,
                            // 12 punto boyut
                            fontSize: 12,
                            // Yarı kalın font
                            fontWeight: FontWeight.w600,
                          // TextStyle kapanışı
                          ),
                        // Text kapanışı
                        ),
                        // Stok durumunu gösteren özel rozet bileşeni
                        StokRozeti(stok: urun.stokAdedi),
                      // Row çocukları kapanışı
                      ],
                    // Row kapanışı
                    ),
                    // 6 piksel dikey boşluk
                    const SizedBox(height: 6),

                    // Ürün başlığı metni (tek satırla sınırlı)
                    Text(
                      // Ürünün adı
                      urun.baslik,
                      // En fazla 1 satır görünmesini sağlıyoruz
                      maxLines: 1,
                      // Metin uzarsa sonuna '...' ekliyoruz
                      overflow: TextOverflow.ellipsis,
                      // Başlık stili
                      style: const TextStyle(
                        // 15 punto boyut
                        fontSize: 15,
                        // Kalın font
                        fontWeight: FontWeight.bold,
                      // TextStyle kapanışı
                      ),
                    // Text kapanışı
                    ),
                    // 4 piksel dikey boşluk
                    const SizedBox(height: 4),

                    // Ürün açıklaması metni (2 satırla sınırlı)
                    Text(
                      // Açıklama metni
                      urun.aciklama,
                      // En fazla 2 satır gösteriyoruz
                      maxLines: 2,
                      // 2 satırı aşarsa üç nokta koyuyoruz
                      overflow: TextOverflow.ellipsis,
                      // Açıklama stili
                      style: TextStyle(
                        // 12 punto boyut
                        fontSize: 12,
                        // Koyu gri yazı rengi
                        color: Colors.grey.shade700,
                        // Satır aralığı yüksekliği
                        height: 1.2,
                      // TextStyle kapanışı
                      ),
                    // Text kapanışı
                    ),
                    // 8 piksel dikey boşluk
                    const SizedBox(height: 8),

                    // Fiyat metni
                    Text(
                      // Fiyatı 2 ondalık basamak ve TL simgesi ile formatlıyoruz
                      '${urun.fiyat.toStringAsFixed(2)} ₺',
                      // Fiyat stili
                      style: TextStyle(
                        // Temanın ana rengini kullanıyoruz
                        color: Theme.of(context).colorScheme.primary,
                        // 16 punto büyük boyut
                        fontSize: 16,
                        // Çok kalın font
                        fontWeight: FontWeight.w900,
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

              // Favorilere ekleme/çıkarma kalp butonu
              IconButton(
                // Ürünün favori olma durumuna göre dolu veya boş kalp ikonu
                icon: Icon(
                  // Favoriyse dolu kalp, değilse boş kalp
                  urun.favoriMi ? Icons.favorite : Icons.favorite_border,
                  // Favoriyse kırmızı, değilse gri renk
                  color: urun.favoriMi ? Colors.red : Colors.grey,
                // Icon kapanışı
                ),
                // Butona basıldığında üst sınıftan iletilen favori fonksiyonunu tetikliyoruz
                onPressed: onFavoriTiklandi,
              // IconButton kapanışı
              ),
            // Row çocukları kapanışı
            ],
          // Row kapanışı
          ),
        // Padding kapanışı
        ),
      // InkWell kapanışı
      ),
    // Card kapanışı
    );
  // build metodu kapanış parantezi
  }
// UrunKarti sınıfının kapanış parantezi
}
