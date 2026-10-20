/// Araç kiralama sistemindeki araç nesnesini temsil eden veri modeli.
/// Aracın tüm teknik, durum ve fiyatlandırma bilgilerini saklar.
class Car {
  /// Aracın benzersiz kimliği (ID)
  final String id;
  
  /// Aracın markası (örn: BMW, Mercedes, Renault)
  final String brand;
  
  /// Aracın model adı (örn: 320i, Clio, Megane)
  final String model;
  
  /// Aracın üretim yılı (örn: 2023)
  final int year;
  
  /// Aracın ait olduğu kategorinin kimliği (örn: sedan, suv, ekonomi)
  final String categoryId;
  
  /// Aracın resmi plaka numarası (örn: 34 ABC 123)
  final String plateNumber;
  
  /// Aracın 1 günlük kiralama bedeli (TL cinsinden)
  final double dailyPrice;
  
  /// Aracın güncel kilometre bilgisi
  final int kilometer;
  
  /// Yakıt türü ('Benzin', 'Dizel', 'LPG', 'Elektrik')
  final String fuelType;
  
  /// Mevcut yakıt/şarj doluluk oranı (0.0 ile 1.0 arasında, örn: 0.75 = %75)
  final double fuelLevelPercentage;
  
  /// Kalan yakıtla gidilebilecek tahmini menzil (km cinsinden, örn: 520 km)
  final int estimatedRangeKm;
  
  /// Vites türü ('Otomatik', 'Manuel')
  final String transmission;
  
  /// Araçtaki koltuk/yolcu kapasitesi (varsayılan: 5)
  final int seatCount;
  
  /// Aracın görselinin internet bağlantı adresi (URL)
  final String imageUrl;
  
  /// Aracın kiralanmaya uygun (müsait) olup olmadığını belirten bayrak
  final bool isAvailable;
  
  /// Aracın en son periyodik bakıma girdiği tarih
  final DateTime lastMaintenanceDate;
  
  /// Aracın bir sonraki resmi muayene tarihi
  final DateTime nextInspectionDate;

  /// Car sınıfının kurucu metodu (Constructor)
  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.categoryId,
    required this.plateNumber,
    required this.dailyPrice,
    required this.kilometer,
    required this.fuelType,
    required this.fuelLevelPercentage,
    required this.estimatedRangeKm,
    required this.transmission,
    this.seatCount = 5,
    required this.imageUrl,
    this.isAvailable = true,
    required this.lastMaintenanceDate,
    required this.nextInspectionDate,
  });

  /// Marka ve modeli birleştirerek tam araç adını döndüren yardımcı getter (örn: "BMW 320i")
  String get fullName => '$brand $model';

  /// Mevcut nesnenin belirli alanlarını güncelleyerek yeni bir Car nesnesi oluşturan metot (Immutability desteği)
  Car copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    String? categoryId,
    String? plateNumber,
    double? dailyPrice,
    int? kilometer,
    String? fuelType,
    double? fuelLevelPercentage,
    int? estimatedRangeKm,
    String? transmission,
    int? seatCount,
    String? imageUrl,
    bool? isAvailable,
    DateTime? lastMaintenanceDate,
    DateTime? nextInspectionDate,
  }) {
    return Car(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      categoryId: categoryId ?? this.categoryId,
      plateNumber: plateNumber ?? this.plateNumber,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      kilometer: kilometer ?? this.kilometer,
      fuelType: fuelType ?? this.fuelType,
      fuelLevelPercentage: fuelLevelPercentage ?? this.fuelLevelPercentage,
      estimatedRangeKm: estimatedRangeKm ?? this.estimatedRangeKm,
      transmission: transmission ?? this.transmission,
      seatCount: seatCount ?? this.seatCount,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      lastMaintenanceDate: lastMaintenanceDate ?? this.lastMaintenanceDate,
      nextInspectionDate: nextInspectionDate ?? this.nextInspectionDate,
    );
  }

  /// JSON formatındaki Map verisini Car model nesnesine dönüştüren fabrika kurucu metot
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      // JSON'dan String türünde 'id' değerini alıyoruz.
      id: json['id'] as String,
      // JSON'dan 'brand' (marka) değerini alıyoruz.
      brand: json['brand'] as String,
      // JSON'dan 'model' değerini alıyoruz.
      model: json['model'] as String,
      // JSON'dan üretim yılını tamsayı olarak alıyoruz.
      year: json['year'] as int,
      // Kategori kimliğini alıyoruz.
      categoryId: json['categoryId'] as String,
      // Plaka numarasını alıyoruz.
      plateNumber: json['plateNumber'] as String,
      // Günlük ücreti sayıdan ondalıklı sayıya (double) çevirerek alıyoruz.
      dailyPrice: (json['dailyPrice'] as num).toDouble(),
      // Kilometre bilgisini tamsayı olarak alıyoruz.
      kilometer: json['kilometer'] as int,
      // Yakıt türünü alıyoruz.
      fuelType: json['fuelType'] as String,
      // Yakıt yüzdesini ondalıklı sayı olarak alıyoruz.
      fuelLevelPercentage: (json['fuelLevelPercentage'] as num).toDouble(),
      // Kalan tahmini menzili km cinsinden alıyoruz.
      estimatedRangeKm: json['estimatedRangeKm'] as int,
      // Vites türünü alıyoruz.
      transmission: json['transmission'] as String,
      // Koltuk sayısı belirtilmemişse varsayılan 5 atıyoruz.
      seatCount: json['seatCount'] as int? ?? 5,
      // Araç görsel URL adresini alıyoruz.
      imageUrl: json['imageUrl'] as String,
      // Müsaitlik durumunu alıyoruz (belirtilmemişse true).
      isAvailable: json['isAvailable'] as bool? ?? true,
      // Tarih metnini (ISO8601 string) DateTime nesnesine ayrıştırıyoruz.
      lastMaintenanceDate: DateTime.parse(json['lastMaintenanceDate'] as String),
      // Muayene tarihini DateTime nesnesine ayrıştırıyoruz.
      nextInspectionDate: DateTime.parse(json['nextInspectionDate'] as String),
    );
  }

  /// Car model nesnesini API veya yerel depolama için JSON Map formatına dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'categoryId': categoryId,
      'plateNumber': plateNumber,
      'dailyPrice': dailyPrice,
      'kilometer': kilometer,
      'fuelType': fuelType,
      'fuelLevelPercentage': fuelLevelPercentage,
      'estimatedRangeKm': estimatedRangeKm,
      'transmission': transmission,
      'seatCount': seatCount,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
      // Tarihleri standart ISO8601 string formatına çeviriyoruz.
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
      'nextInspectionDate': nextInspectionDate.toIso8601String(),
    };
  }
}
