class Car {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String categoryId;
  final String plateNumber;
  final double dailyPrice;
  final int kilometer;
  final String fuelType; // 'Benzin', 'Dizel', 'LPG', 'Elektrik'
  final double fuelLevelPercentage; // 0.0 to 1.0 (e.g. 0.75 = 75%)
  final int estimatedRangeKm; // e.g. 520 km
  final String transmission; // 'Otomatik', 'Manuel'
  final int seatCount;
  final String imageUrl;
  final bool isAvailable;
  final DateTime lastMaintenanceDate;
  final DateTime nextInspectionDate;

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

  String get fullName => '$brand $model';

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

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      categoryId: json['categoryId'] as String,
      plateNumber: json['plateNumber'] as String,
      dailyPrice: (json['dailyPrice'] as num).toDouble(),
      kilometer: json['kilometer'] as int,
      fuelType: json['fuelType'] as String,
      fuelLevelPercentage: (json['fuelLevelPercentage'] as num).toDouble(),
      estimatedRangeKm: json['estimatedRangeKm'] as int,
      transmission: json['transmission'] as String,
      seatCount: json['seatCount'] as int? ?? 5,
      imageUrl: json['imageUrl'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
      lastMaintenanceDate: DateTime.parse(json['lastMaintenanceDate'] as String),
      nextInspectionDate: DateTime.parse(json['nextInspectionDate'] as String),
    );
  }

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
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
      'nextInspectionDate': nextInspectionDate.toIso8601String(),
    };
  }
}
