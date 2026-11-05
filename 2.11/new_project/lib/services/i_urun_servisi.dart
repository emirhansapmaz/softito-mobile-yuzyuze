import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/model.dart';

abstract class IUrunServisi {
  Future<List<UrunModel>> urunleriGetir();
}

class CanliApiUrunServisi implements IUrunServisi {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  @override
  Future<List<UrunModel>> urunleriGetir() async {
    try {
      final yanit = await http.get(Uri.parse(_baseUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Ağ zaman aşımına uğradı.');
        },
      );

      if (yanit.statusCode == 200) {
        final List<dynamic> hamListe = jsonDecode(yanit.body) as List<dynamic>;
        return hamListe
            .map((eleman) => UrunModel.fromJson(eleman as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Sunucu hatası: ${yanit.statusCode}');
      }
    } catch (e) {
      throw Exception('API hatası: $e');
    }
  }
}

