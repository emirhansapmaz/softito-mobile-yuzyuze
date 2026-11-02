// Flutter temel Material bileşenlerini içeren kütüphane
import 'package:flutter/material.dart';

// Ayarlar Ekranı: go_router içerisindeki 3. sekmeyi (StatefulShellBranch) temsil eder.
// Alt bardaki 'Ayarlar' sekmesine tıklandığında ekrana basılır.
class Ayarlar extends StatelessWidget {
  // Ayarlar sınıfının değişmez (const) kurucu metodu
  const Ayarlar({
    // Üst sınıfa anahtar parametresini iletiyoruz
    super.key,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel ağacını oluşturan build fonksiyonu
  @override
  // BuildContext alıp Widget döndüren build metodu
  Widget build(BuildContext context) {
    // İçeriği ekranın tam ortasına hizalayan Center widget'ı
    return const Center(
      // Ekranın ortasında yer alan metin bileşeni
      child: Text(
        // Başlık metni
        'Ayarlar İçeriği',
        // Yazı tipi boyutu 24 punto
        style: TextStyle(fontSize: 24),
      // Text kapanışı
      ),
    // Center kapanışı
    );
  // build metodu kapanış parantezi
  }
// Ayarlar sınıfının kapanış parantezi
}
