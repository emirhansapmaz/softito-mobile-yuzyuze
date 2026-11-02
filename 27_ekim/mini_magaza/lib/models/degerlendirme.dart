// Bir ürünün kullanıcı puanını ve toplam oy sayısını tutan model sınıfımız
class Degerlendirme {
  // Ürünün ortalama puanı (Örnek: 4.5, 3.9)
  final double puan;
  // Ürüne oy veren toplam kullanıcı sayısı (Örnek: 120)
  final int oySayisi;

  // Degerlendirme sınıfının değişmez (const) kurucu metodu
  const Degerlendirme({
    // Puan alanının zorunlu olduğunu belirten parametre
    required this.puan,
    // Oy sayısı alanının zorunlu olduğunu belirten parametre
    required this.oySayisi,
  // Kurucu metodun kapanış parantezi
  });

  // REST API'den gelen Map verisini okuyup güvenli Degerlendirme nesnesine çeviren fabrika kurucusu
  factory Degerlendirme.fromJson(Map<String, dynamic>? json) {
    // Eğer sunucudan gelen JSON haritası tamamen boş (null) ise varsayılan sıfır değerleri dönüyoruz
    if (json == null) {
      // Puanı 0.0, oy sayısını 0 olan varsayılan nesne
      return const Degerlendirme(puan: 0.0, oySayisi: 0);
    // if kontrolü kapanışı
    }
    // Gelen JSON alanlarını güvenli biçimde modele aktarıyoruz
    return Degerlendirme(
      // int veya double gelebilecek puan değerini güvenle double'a çeviriyoruz
      puan: (json['rate'] as num?)?.toDouble() ?? 0.0,
      // Tam sayı oy adedini güvenle okuyoruz, boşsa 0 atıyoruz
      oySayisi: (json['count'] as num?)?.toInt() ?? 0,
    // Degerlendirme çağrısının kapanışı
    );
  // fromJson metodunun kapanış parantezi
  }
// Degerlendirme sınıfının kapanış parantezi
}
