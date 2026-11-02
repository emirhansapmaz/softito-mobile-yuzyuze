// Flutter Material tasarım bileşenlerini içe aktarıyoruz
import 'package:flutter/material.dart';

// Ürünün stok durumunu (Tükendi veya Kalan Stok adedi) kutucuk içinde gösteren rozet bileşeni
class StokRozeti extends StatelessWidget {
  // Ürünün depodaki kalan stok adedini tutan tam sayı değişkeni
  final int stok;

  // StokRozeti sınıfının değişmez (const) kurucu metodu
  const StokRozeti({
    // Widget ağacı için üst sınıfa anahtar iletiyoruz
    super.key,
    // Stok miktarının zorunlu parametre olduğunu belirtiyoruz
    required this.stok,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext parametresini alan ve Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Stok 0 ise ürün tükenmiştir, mantıksal kontrolü değişkene alıyoruz (sınavda sorulabilir)
    final tukendiMi = stok == 0;

    // Rozetin dış kutu çerçevesini ve renklerini ayarladığımız Container
    return Container(
      // Kutu içi yatayda 8, dikeyde 4 piksel iç boşluk (padding)
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      // Kutunun arka plan rengi, kenarlık ve köşe yuvarlatma özellikleri
      decoration: BoxDecoration(
        // Ürün tükendiyse açık kırmızı, stokta varsa açık yeşil arka plan
        color: tukendiMi ? Colors.red.shade100 : Colors.green.shade100,
        // Köşeleri 6 piksel yuvarlatıyoruz
        borderRadius: BorderRadius.circular(6),
        // Kutunun dışına ince çerçeve çizgisi çiziyoruz
        border: Border.all(
          // Çerçeve rengini duruma göre kırmızı veya yeşil yapıyoruz
          color: tukendiMi ? Colors.red.shade400 : Colors.green.shade400,
          // Çerçeve kalınlığı (0.8 piksel)
          width: 0.8,
        // Border.all kapanışı
        ),
      // BoxDecoration kapanışı
      ),
      // Rozet içindeki bilgilendirme metni
      child: Text(
        // Tükendiyse 'Tükendi', stok varsa kalan adedi yazdırıyoruz
        tukendiMi ? "Tükendi" : "Stok:$stok",
        // Metin stil özellikleri
        style: TextStyle(
          // Yazı rengini duruma göre koyu kırmızı veya koyu yeşil yapıyoruz
          color: tukendiMi ? Colors.red.shade900 : Colors.green.shade900,
          // Yazı tipi boyutu 11 punto
          fontSize: 11,
          // Kalın yazı tipi
          fontWeight: FontWeight.bold,
        // TextStyle kapanışı
        ),
      // Text kapanışı
      ),
    // Container kapanışı
    );
  // build metodu kapanış parantezi
  }
// StokRozeti sınıfının kapanış parantezi
}
