import 'package:flutter/material.dart';
import '../data/urunler.dart';
import '../widgets/urun_karti.dart';

class UrunEkrani extends StatelessWidget {
  const UrunEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Listesi'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          UrunKarti(urun: urunler[0]),
          const SizedBox(height: 16),
          
          UrunKarti(urun: urunler[1]),
        ],
      ),
    );
  }
}


  