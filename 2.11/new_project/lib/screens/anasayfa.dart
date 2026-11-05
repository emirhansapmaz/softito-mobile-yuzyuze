import 'package:flutter/material.dart';
import '../models/model.dart';
import '../services/i_urun_servisi.dart';

// 1. ANA SAYFA: ÜRÜN LİSTESİ
class UrunListesiEkrani extends StatelessWidget {
  const UrunListesiEkrani({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ürünler')),
      body: FutureBuilder<List<UrunModel>>(
        future: CanliApiUrunServisi().urunleriGetir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Ürün bulunamadı.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final urun = snapshot.data![index];
              return ListTile(
                leading: Image.network(urun.resimUrl, width: 50, errorBuilder: (_, _, _) => const Icon(Icons.image)),
                title: Text(urun.baslik, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('\$${urun.fiyat}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UrunDetailEkrani(urun: urun))),
              );
            },
          );
        },
      ),
    );
  }
}

// 2. DETAY EKRANI
class UrunDetailEkrani extends StatelessWidget {
  final UrunModel urun;
  const UrunDetailEkrani({super.key, required this.urun});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(urun.kategori)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: Image.network(urun.resimUrl)),
            const SizedBox(height: 16),
            Text(urun.baslik, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('\$${urun.fiyat}', style: const TextStyle(fontSize: 18, color: Colors.green, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sepete Eklendi!'))),
              child: const Text('Sepete Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
