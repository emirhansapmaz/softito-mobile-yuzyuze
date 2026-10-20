/// Farklı akaryakıt dağıtım şirketlerinin güncel yakıt fiyatlarını temsil eden model.
class FuelPrice {
  /// Akaryakıt firmasının adı (örn: Opet, Shell, BP, Petrol Ofisi)
  final String companyName;
  
  /// Benzin litre satış fiyatı (TL)
  final double gasolinePrice;
  
  /// Motorin / Dizel litre satış fiyatı (TL)
  final double dieselPrice;
  
  /// Otogaz / LPG litre satış fiyatı (TL)
  final double lpgPrice;
  
  /// Firmanın marka kimliğini temsil eden Hex renk kodu (örn: '#0066FF')
  final String brandColorHex;
  
  /// Fiyatların son güncellenme tarihi ve saati
  final DateTime lastUpdated;

  /// FuelPrice kurucu metodu (Constructor)
  const FuelPrice({
    required this.companyName,
    required this.gasolinePrice,
    required this.dieselPrice,
    required this.lpgPrice,
    required this.brandColorHex,
    required this.lastUpdated,
  });

  /// JSON verisinden FuelPrice nesnesi oluşturan fabrika metot
  factory FuelPrice.fromJson(Map<String, dynamic> json) {
    return FuelPrice(
      // Firma adını JSON'dan alıyoruz.
      companyName: json['companyName'] as String,
      // Benzin fiyatını double olarak alıyoruz.
      gasolinePrice: (json['gasolinePrice'] as num).toDouble(),
      // Motorin fiyatını double olarak alıyoruz.
      dieselPrice: (json['dieselPrice'] as num).toDouble(),
      // LPG fiyatını double olarak alıyoruz.
      lpgPrice: (json['lpgPrice'] as num).toDouble(),
      // Renk kodunu alıyoruz.
      brandColorHex: json['brandColorHex'] as String,
      // Son güncelleme tarihini DateTime nesnesine çeviriyoruz.
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  /// FuelPrice nesnesini JSON formatına dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'gasolinePrice': gasolinePrice,
      'dieselPrice': dieselPrice,
      'lpgPrice': lpgPrice,
      'brandColorHex': brandColorHex,
      // Tarihi ISO8601 biçiminde metne çeviriyoruz.
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
