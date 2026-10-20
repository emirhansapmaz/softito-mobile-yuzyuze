/// Rezervasyonun işlem durumlarını belirten enum (numaralandırma).
enum ReservationStatus {
  /// Onay bekleyen rezervasyon
  pending,
  /// Yönetici tarafından onaylanmış rezervasyon
  confirmed,
  /// Reddedilmiş veya iptal edilmiş rezervasyon
  rejected,
  /// Tamamlanmış (teslim edilmiş) rezervasyon
  completed,
}

/// Müşterinin oluşturduğu araç kiralama rezervasyonunu temsil eden model sınıfı.
class Reservation {
  /// Rezervasyonun benzersiz kimliği (ID)
  final String id;
  
  /// Kiralanan aracın benzersiz kimliği
  final String carId;
  
  /// Kiralanan aracın marka ve model adı
  final String carName;
  
  /// Kiralanan aracın görsel adresi
  final String carImageUrl;
  
  /// Rezervasyonu yapan kullanıcının kimliği
  final String userId;
  
  /// Rezervasyonu yapan müşterinin adı soyadı
  final String userName;
  
  /// Kiralamanın başlangıç tarihi
  final DateTime startDate;
  
  /// Kiralamanın bitiş (teslim) tarihi
  final DateTime endDate;
  
  /// Toplam kiralanan gün sayısı
  final int totalDays;
  
  /// Şehirlerarası seyahat edilip edilmeyeceği bilgisi
  final bool isIntercity;
  
  /// Şehirlerarası seyahat edilecekse gidilecek hedef şehir
  final String? destinationCity;
  
  /// Yapılması planlanan tahmini mesafe (kilometre cinsinden)
  final int estimatedDistanceKm;
  
  /// Aracın günlük kiralama ücreti
  final double dailyPrice;
  
  /// Günlük limit aşıldığında veya şehirlerarası durumda yansıyan ek kilometre bedeli
  final double extraDistanceCharge;
  
  /// Tüm ek ücretler ve gün sayısı dahil toplam ödenecek tutar
  final double totalAmount;
  
  /// Rezervasyonun güncel durumu (onaylandı, bekliyor, reddedildi vb.)
  final ReservationStatus status;
  
  /// Rezervasyonun sistemde oluşturulduğu tarih ve saat
  final DateTime createdAt;

  /// Reservation kurucu metodu (Constructor)
  const Reservation({
    required this.id,
    required this.carId,
    required this.carName,
    required this.carImageUrl,
    required this.userId,
    required this.userName,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.isIntercity,
    this.destinationCity,
    required this.estimatedDistanceKm,
    required this.dailyPrice,
    required this.extraDistanceCharge,
    required this.totalAmount,
    this.status = ReservationStatus.pending,
    required this.createdAt,
  });

  /// Mevcut rezervasyonun seçilen alanlarını güncelleyip yeni bir kopya oluşturan metot
  Reservation copyWith({
    String? id,
    String? carId,
    String? carName,
    String? carImageUrl,
    String? userId,
    String? userName,
    DateTime? startDate,
    DateTime? endDate,
    int? totalDays,
    bool? isIntercity,
    String? destinationCity,
    int? estimatedDistanceKm,
    double? dailyPrice,
    double? extraDistanceCharge,
    double? totalAmount,
    ReservationStatus? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      carName: carName ?? this.carName,
      carImageUrl: carImageUrl ?? this.carImageUrl,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalDays: totalDays ?? this.totalDays,
      isIntercity: isIntercity ?? this.isIntercity,
      destinationCity: destinationCity ?? this.destinationCity,
      estimatedDistanceKm: estimatedDistanceKm ?? this.estimatedDistanceKm,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      extraDistanceCharge: extraDistanceCharge ?? this.extraDistanceCharge,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// JSON haritasından Reservation nesnesi oluşturan fabrika kurucu
  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      carId: json['carId'] as String,
      carName: json['carName'] as String,
      carImageUrl: json['carImageUrl'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      totalDays: json['totalDays'] as int,
      isIntercity: json['isIntercity'] as bool,
      destinationCity: json['destinationCity'] as String?,
      estimatedDistanceKm: json['estimatedDistanceKm'] as int,
      dailyPrice: (json['dailyPrice'] as num).toDouble(),
      extraDistanceCharge: (json['extraDistanceCharge'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      // Metin olarak gelen durum adını ReservationStatus enum sabitine eşleştiriyoruz.
      status: ReservationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReservationStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Reservation nesnesini JSON formatına dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'carName': carName,
      'carImageUrl': carImageUrl,
      'userId': userId,
      'userName': userName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'totalDays': totalDays,
      'isIntercity': isIntercity,
      'destinationCity': destinationCity,
      'estimatedDistanceKm': estimatedDistanceKm,
      'dailyPrice': dailyPrice,
      'extraDistanceCharge': extraDistanceCharge,
      'totalAmount': totalAmount,
      // Enum değerini metin adına çeviriyoruz (örn: 'pending')
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
