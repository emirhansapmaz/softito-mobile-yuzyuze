enum ReservationStatus {
  pending,
  confirmed,
  rejected,
  completed,
}

class Reservation {
  final String id;
  final String carId;
  final String carName;
  final String carImageUrl;
  final String userId;
  final String userName;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final bool isIntercity;
  final String? destinationCity;
  final int estimatedDistanceKm;
  final double dailyPrice;
  final double extraDistanceCharge;
  final double totalAmount;
  final ReservationStatus status;
  final DateTime createdAt;

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
      status: ReservationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReservationStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

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
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
