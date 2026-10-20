import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/car.dart';
import '../../models/reservation.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/fuel_dialog.dart';
import 'checkout_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  final Car car;

  const VehicleDetailScreen({super.key, required this.car});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    // Varsayılan olarak bugünden başlayarak 2 günlük aralık
    final now = DateTime.now();
    _selectedDateRange = DateTimeRange(
      start: now,
      end: now.add(const Duration(days: 2)),
    );
  }

  int get _rentalDays {
    if (_selectedDateRange == null) return 1;
    final diff = _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays;
    return diff <= 0 ? 1 : diff;
  }

  double get _baseTotalAmount {
    return widget.car.dailyPrice * _rentalDays;
  }

  // Tarih Aralığı Seçici (Takvim)
  Future<void> _selectDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 180)),
      initialDateRange: _selectedDateRange,
      helpText: 'KİRALAMA TARİH ARALIĞINI SEÇİN',
      cancelText: 'İPTAL',
      confirmText: 'UYGULA',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primaryBlue,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  // Rezervasyon ve Şehir Dışı Kilometre Hesaplama Diyaloğu
  void _openReservationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _IntercityCalculationModal(
        car: widget.car,
        rentalDays: _rentalDays,
        baseTotal: _baseTotalAmount,
        dateRange: _selectedDateRange!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final car = widget.car;

    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // AppBar & Büyük Araç Görseli
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                  color: isDark ? Colors.white : Colors.black,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    car.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey.shade400,
                      child: const Center(child: Icon(Icons.directions_car, size: 80)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${car.dailyPrice.toStringAsFixed(0)} ₺ / gün',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            shadows: [Shadow(blurRadius: 10, color: Colors.black54)],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: car.isAvailable ? AppColors.success : AppColors.error,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            car.isAvailable ? 'MÜSAİT' : 'KİRADA',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // İçerik Listesi
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Marka Model & Plaka
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          car.fullName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textLight : AppColors.textDark,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.surfaceDarkElevated : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Text(
                          car.plateNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Temel Özellikler Izgarası (Yıl, KM, Şanzıman, Koltuk)
                  Row(
                    children: [
                      _buildSpecItem(Icons.calendar_today_rounded, 'Model Yılı', '${car.year}', isDark),
                      _buildSpecItem(Icons.speed_rounded, 'Kilometre', '${car.kilometer} km', isDark),
                      _buildSpecItem(Icons.settings_suggest_rounded, 'Vites', car.transmission, isDark),
                      _buildSpecItem(Icons.airline_seat_recline_normal_rounded, 'Kapasite', '${car.seatCount} Kişi', isDark),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // KRİTİK ÖDEV KRİTERİ: Yakıt Göstergesi & Pop-up Tıklaması
                  Text(
                    'Yakıt Durumu ve Tahmini Menzil',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => FuelPriceDialog.show(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDarkElevated : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.primaryBlue.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_gas_station_rounded, color: AppColors.primaryBlue),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${car.fuelType} (Depo %${(car.fuelLevelPercentage * 100).toInt()})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark ? AppColors.textLight : AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Fiyatları Gör',
                                    style: TextStyle(
                                      color: AppColors.primaryBlue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.primaryBlue),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Görsel Yakıt İlerleme Çubuğu (Gauge / Progress Bar)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: car.fuelLevelPercentage,
                              minHeight: 12,
                              backgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                car.fuelLevelPercentage > 0.5
                                    ? AppColors.success
                                    : (car.fuelLevelPercentage > 0.25 ? AppColors.warning : AppColors.error),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tahmini Menzil: ~${car.estimatedRangeKm} km',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: AppColors.primaryBlue,
                                ),
                              ),
                              Text(
                                'Detay için dokunun 👆',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Müsaitlik Takvimi (DateRangePicker)
                  Text(
                    'Kiralama Tarihleri',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textLight : AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _selectDateRange,
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDarkElevated : AppColors.backgroundLight,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.date_range_rounded, color: AppColors.primaryBlue),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedDateRange != null
                                      ? '${dateFormat.format(_selectedDateRange!.start)} - ${dateFormat.format(_selectedDateRange!.end)}'
                                      : 'Tarih Seçiniz',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? AppColors.textLight : AppColors.textDark,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Toplam: $_rentalDays Gün',
                                  style: const TextStyle(
                                    color: AppColors.primaryBlue,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit_calendar_rounded, color: AppColors.primaryBlue, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 250 KM Kuralı Bilgilendirme Kutusu
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.warning.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_rounded, color: AppColors.warning, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '250 KM Günlük Kullanım Kuralı',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: AppColors.warning,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Günlük sürüş hakkınız 250 km ile sınırlıdır. Şehir dışı çıkışlarda aşılan her 250 km için ekstra bir gün kira bedeli eklenir.',
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: isDark ? AppColors.textLight : AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100), // Alt çubuk payı
                ],
              ),
            ),
          ),
        ],
      ),

      // Alt Sabit Rezervasyon Çubuğu
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Toplam ($_rentalDays Gün)',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                    Text(
                      '${_baseTotalAmount.toStringAsFixed(0)} ₺',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: CustomElevatedButton(
                  text: 'Rezervasyon Yap',
                  onPressed: car.isAvailable ? _openReservationDialog : null,
                  icon: Icons.calendar_month_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String title, String value, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDarkElevated : AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: AppColors.primaryBlue),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Şehir Dışı Mesafe & Kilometre Hesaplama Modalı
class _IntercityCalculationModal extends StatefulWidget {
  final Car car;
  final int rentalDays;
  final double baseTotal;
  final DateTimeRange dateRange;

  const _IntercityCalculationModal({
    required this.car,
    required this.rentalDays,
    required this.baseTotal,
    required this.dateRange,
  });

  @override
  State<_IntercityCalculationModal> createState() => _IntercityCalculationModalState();
}

class _IntercityCalculationModalState extends State<_IntercityCalculationModal> {
  bool _isIntercity = false;
  String _selectedCity = 'Bursa (150 km)';
  int _distanceKm = 150;

  final Map<String, int> _cityDistances = {
    'Bursa (150 km)': 150,
    'Kocaeli / Yalova (110 km)': 110,
    'Ankara (450 km)': 450,
    'İzmir (480 km)': 480,
    'Antalya (720 km)': 720,
    'Trabzon (1.050 km)': 1050,
  };

  // 250 KM Kuralına Göre Ekstra Ücret Hesabı
  int get _extraDaysCharged {
    if (!_isIntercity) return 0;
    // Toplam tanınan km hakkı = Kiralama günü * 250 km
    final allowedKm = widget.rentalDays * 250;
    if (_distanceKm <= allowedKm) {
      return 0; // Mesafe sınır dahilinde, ek ücret yok!
    } else {
      final excessKm = _distanceKm - allowedKm;
      // Aşılan her 250 km için 1 gün ekstra ücret
      return (excessKm / 250).ceil();
    }
  }

  double get _extraAmount {
    return _extraDaysCharged * widget.car.dailyPrice;
  }

  double get _finalTotalAmount {
    return widget.baseTotal + _extraAmount;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Rezervasyon ve Rota Detayları',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Şehir dışı seyahat durumunuzu belirleyin.',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 20),

            // Şehir Dışına Çıkış Switch'i
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDarkElevated : AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.alt_route_rounded, color: AppColors.primaryBlue),
                      SizedBox(width: 12),
                      Text(
                        'Şehir dışına çıkacak mısınız?',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isIntercity,
                    activeThumbColor: AppColors.primaryBlue,
                    onChanged: (val) {
                      setState(() {
                        _isIntercity = val;
                      });
                    },
                  ),
                ],
              ),
            ),

            // Şehir Seçimi Dropdown (Eğer Şehir Dışı Seçilmişse)
            if (_isIntercity) ...[
              const SizedBox(height: 16),
              Text(
                'Hedef Şehir ve Mesafe',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textLight : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _selectedCity,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: _cityDistances.keys.map((city) {
                  return DropdownMenuItem(value: city, child: Text(city));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCity = val;
                      _distanceKm = _cityDistances[val]!;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),

              // Mesafe Hesaplama Uyarı Kutusu
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _extraDaysCharged > 0
                      ? AppColors.warning.withValues(alpha: 0.15)
                      : AppColors.success.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _extraDaysCharged > 0 ? Icons.warning_amber_rounded : Icons.check_circle_outline,
                      color: _extraDaysCharged > 0 ? AppColors.warning : AppColors.success,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _extraDaysCharged > 0
                            ? 'Mesafe ($_distanceKm km), tanınan sınırı (${widget.rentalDays * 250} km) aşıyor! +$_extraDaysCharged gün bedeli (+${_extraAmount.toStringAsFixed(0)} ₺) eklendi.'
                            : 'Mesafe ($_distanceKm km), toplam km hakkınız (${widget.rentalDays * 250} km) dahilinde. Ekstra ücret yok!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _extraDaysCharged > 0 ? AppColors.warning : AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Divider(),

            // Tutar Özeti
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Toplam Tutar:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  '${_finalTotalAmount.toStringAsFixed(0)} ₺',
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Ödeme Ekranına Geç Butonu
            CustomElevatedButton(
              text: 'Ödemeye İlerle',
              icon: Icons.payment_rounded,
              onPressed: () {
                Navigator.of(context).pop(); // Modalı kapat

                final reservation = Reservation(
                  id: 'res_${DateTime.now().millisecondsSinceEpoch}',
                  carId: widget.car.id,
                  carName: widget.car.fullName,
                  carImageUrl: widget.car.imageUrl,
                  userId: auth.currentUser?.id ?? 'guest',
                  userName: auth.currentUser?.fullName ?? 'Müşteri',
                  startDate: widget.dateRange.start,
                  endDate: widget.dateRange.end,
                  totalDays: widget.rentalDays,
                  isIntercity: _isIntercity,
                  destinationCity: _isIntercity ? _selectedCity : 'Şehir İçi',
                  estimatedDistanceKm: _isIntercity ? _distanceKm : 100,
                  dailyPrice: widget.car.dailyPrice,
                  extraDistanceCharge: _extraAmount,
                  totalAmount: _finalTotalAmount,
                  createdAt: DateTime.now(),
                );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CheckoutScreen(reservation: reservation),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
