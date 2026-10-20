class FuelPrice {
  final String companyName;
  final double gasolinePrice; // Benzin
  final double dieselPrice;   // Motorin / Dizel
  final double lpgPrice;      // Otogaz / LPG
  final String brandColorHex;
  final DateTime lastUpdated;

  const FuelPrice({
    required this.companyName,
    required this.gasolinePrice,
    required this.dieselPrice,
    required this.lpgPrice,
    required this.brandColorHex,
    required this.lastUpdated,
  });

  factory FuelPrice.fromJson(Map<String, dynamic> json) {
    return FuelPrice(
      companyName: json['companyName'] as String,
      gasolinePrice: (json['gasolinePrice'] as num).toDouble(),
      dieselPrice: (json['dieselPrice'] as num).toDouble(),
      lpgPrice: (json['lpgPrice'] as num).toDouble(),
      brandColorHex: json['brandColorHex'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'gasolinePrice': gasolinePrice,
      'dieselPrice': dieselPrice,
      'lpgPrice': lpgPrice,
      'brandColorHex': brandColorHex,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
