import 'package:flutter/material.dart';
import '../data/urunler.dart';

class UrunKarti extends StatelessWidget {
  final Urun urun;

  const UrunKarti({
    super.key,
    required this.urun,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              urun.ad,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('${urun.fiyat} TL'),
          ],
        ),
      ),
    );
  }
}