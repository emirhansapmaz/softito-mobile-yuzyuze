// Flutter materyal arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Tarih ve saat formatlama işlemleri için intl kütüphanesini içe aktarıyoruz.
import 'package:intl/intl.dart';
// Durum yönetimi için Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Uygulama tema renklerini içe aktarıyoruz.
import '../../core/theme/app_colors.dart';
// Araç veri modelini içe aktarıyoruz.
import '../../models/car.dart';
// Rezervasyon veri modelini içe aktarıyoruz.
import '../../models/reservation.dart';
// Kullanıcı oturum bilgilerine erişmek için AuthProvider'ı içe aktarıyoruz.
import '../../providers/auth_provider.dart';
// Özel buton bileşenini içe aktarıyoruz.
import '../../widgets/custom_button.dart';
// Güncel yakıt fiyatları açılır penceresini içe aktarıyoruz.
import '../../widgets/fuel_dialog.dart';
// Ödeme ve rezervasyon tamamlama ekranını içe aktarıyoruz.
import 'checkout_screen.dart';

/// Aracın tüm teknik ayrıntılarını, yakıt seviyesini, kiralama tarih aralığını ve 250 km kuralını gösteren detay ekranı.
class VehicleDetailScreen extends StatefulWidget {
  /// İncelenen araç nesnesi
  final Car car;

  /// VehicleDetailScreen kurucu metodu (Constructor)
  const VehicleDetailScreen({super.key, required this.car});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  /// Kullanıcının seçtiği kiralama başlangıç ve bitiş tarih aralığı
  DateTimeRange? _selectedDateRange;

  @override
  void initState() {
    super.initState();
    // Ekran ilk açıldığında varsayılan olarak bugünden itibaren 2 günlük bir aralık seçiyoruz.
    final now = DateTime.now();
    _selectedDateRange = DateTimeRange(
      start: now,
      end: now.add(const Duration(days: 2)),
    );
  }

  /// Seçili tarih aralığından toplam kiralanan gün sayısını hesaplayan getter
  int get _rentalDays {
    if (_selectedDateRange == null) return 1;
    final diff = _selectedDateRange!.end.difference(_selectedDateRange!.start).inDays;
    // Eğer aynı gün seçildiyse en az 1 gün kabul ediyoruz.
    return diff <= 0 ? 1 : diff;
  }

  /// Aracın günlük fiyatı ile gün sayısını çarparak taban toplam tutarı hesaplayan getter
  double get _baseTotalAmount {
    return widget.car.dailyPrice * _rentalDays;
  }

  // ==========================================
  // TARİH ARALIĞI SEÇİCİ (DateRangePicker)
  // ==========================================
  /// Kullanıcıya takvim üzerinden kiralama başlangıç ve bitiş tarihlerini seçtiren diyalog
  Future<void> _selectDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 180)), // 6 aya kadar ileri rezervasyon
      initialDateRange: _selectedDateRange,
      helpText: 'KİRALAMA TARİH ARALIĞINI SEÇİN',
      cancelText: 'İPTAL',
      confirmText: 'UYGULA',
      builder: (context, child) {
        // Takvim temasını uygulama rengine uyarlıyoruz.
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

    // Yeni bir tarih seçildiyse durumu güncelliyoruz.
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  // ==========================================
  // ŞEHİR DIŞI VE ROTA HESAPLAMA MODALI
  // ==========================================
  /// 250 KM kuralını ve şehir dışı seyahat mesafesini hesaplatan alttan açılır pencereyi başlatır.
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
    // Koyu tema modunda mıyız sorguluyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final car = widget.car;

    // Tarihleri gün.ay.yıl biçiminde göstermek için formatlayıcı
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ==========================================
          // ESNEK ÜST ÇUBUK VE BÜYÜK ARAÇ GÖRSELİ
          // ==========================================
          SliverAppBar(
            expandedHeight: 280, // Üst görselin açılmış yüksekliği
            pinned: true, // Kaydırılsa bile AppBar tepede sabit kalır
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
                  // Araç fotoğrafı
                  Image.network(
                    car.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: Colors.grey.shade400,
                      child: const Center(child: Icon(Icons.directions_car, size: 80)),
                    ),
                  ),
                  // Üst ve alt gölgeli karartma gradyanı (metinlerin okunması için)
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
                  // Plaka ve Müsaitlik rozeti
                  Positioned(
                    bottom: 16,
                    left: 20,
                    right: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Resmi Plaka Numarası
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: Text(
                            car.plateNumber,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        // Müsait / Kirada Durumu
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: car.isAvailable ? AppColors.success : AppColors.error,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            car.isAvailable ? 'Müsait' : 'Kirada',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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

          // ==========================================
          // DETAY BİLGİLERİ VE FORMLAR LİSTESİ
          // ==========================================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Araç Adı ve Günlük Fiyat
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${car.dailyPrice.toStringAsFixed(0)} ₺',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                          Text(
                            '/ gün',
                            style: TextStyle(
                              fontSize: 13,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ==========================================
                  // TEKNİK ÖZELLİKLER ŞERİDİ
                  // ==========================================
                  Row(
                    children: [
                      _buildSpecItem(Icons.settings_suggest_rounded, 'Vites', car.transmission, isDark),
                      _buildSpecItem(Icons.local_gas_station_rounded, 'Yakıt', car.fuelType, isDark),
                      _buildSpecItem(Icons.event_seat_rounded, 'Kapasite', '${car.seatCount} Kişi', isDark),
                      _buildSpecItem(Icons.speed_rounded, 'Kilometre', '${car.kilometer} km', isDark),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ==========================================
                  // YAKIT SEVİYESİ VE TAHMİNİ MENZİL KARTI
                  // Tıklandığında güncel akaryakıt pompa fiyatlarını açar!
                  // ==========================================
                  InkWell(
                    onTap: () => FuelPriceDialog.show(context),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.battery_charging_full_rounded, color: AppColors.primaryBlue),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Yakıt Durumu (%${(car.fuelLevelPercentage * 100).toInt()})',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: isDark ? AppColors.textLight : AppColors.textDark,
                                    ),
                                  ),
                                ],
                              ),
                              // Pompa Fiyatlarını Gör bağlantısı
                              const Row(
                                children: [
                                  Text(
                                    'Pompa Fiyatları',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                  Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primaryBlue),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Yakıt Doluluk İlerleme Çubuğu (LinearProgressIndicator)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: car.fuelLevelPercentage,
                              minHeight: 8,
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
                              // Kalan yakıtla gidilebilecek tahmini menzil
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

                  // ==========================================
                  // MÜSAİTLİK TAKVİMİ / TARİH SEÇİCİ KARTI
                  // ==========================================
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

                  // ==========================================
                  // 250 KM KURALI BİLGİLENDİRME KUTUSU
                  // ==========================================
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
                  const SizedBox(height: 100), // Alt çubuğun içeriği örtmemesi için boşluk payı
                ],
              ),
            ),
          ),
        ],
      ),

      // ==========================================
      // ALT SABİT REZERVASYON ÇUBUĞU (BottomSheet)
      // ==========================================
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
              // Toplam Gün ve Tutar Özeti
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
              // Rezervasyon Yap Aksiyon Butonu
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

  /// Teknik özellik simge ve metnini oluşturan yardımcı kutu widget'ı
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

// ==========================================
// ŞEHİR DIŞI MESAFE VE KİLOMETRE HESAPLAMA MODALI
// ==========================================
/// Şehirlerarası seyahat durumunda mesafe seçimi ve 250 km limitine göre ek ücret hesaplayan modal sınıfı.
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
  /// Şehirlerarası seyahat yapılacak mı bayrağı
  bool _isIntercity = false;
  
  /// Seçilen rota şehri
  String _selectedCity = 'Bursa (150 km)';
  
  /// Gidilecek mesafe (km)
  int _distanceKm = 150;

  /// Şehirler ve İstanbul çıkışlı gidiş-dönüş / tek yön rota mesafeleri haritası
  final Map<String, int> _cityDistances = {
    'Bursa (150 km)': 150,
    'Kocaeli / Yalova (110 km)': 110,
    'Ankara (450 km)': 450,
    'İzmir (480 km)': 480,
    'Antalya (720 km)': 720,
    'Trabzon (1.050 km)': 1050,
  };

  // ==========================================
  // 250 KM KURALINA GÖRE EK GÜN HESABI
  // ==========================================
  /// Toplam tanınan kilometre = Gün Sayısı * 250 km.
  /// Eğer seyahat mesafesi bu hakkı aşıyorsa, aşan her 250 km için 1 ek gün ücreti yansıtılır.
  int get _extraDaysCharged {
    if (!_isIntercity) return 0;
    final allowedKm = widget.rentalDays * 250;
    if (_distanceKm <= allowedKm) {
      return 0; // Sınır dahilinde, ek ücret yok
    } else {
      final excessKm = _distanceKm - allowedKm;
      // Yukarı yuvarlayarak aşılan her 250 km dilimine 1 tam gün hesaplıyoruz.
      return (excessKm / 250).ceil();
    }
  }

  /// Ekstra mesafe için yansıtılan toplam ek bedel
  double get _extraAmount {
    return _extraDaysCharged * widget.car.dailyPrice;
  }

  /// Taban kiralama bedeli ile ekstra mesafe bedelinin toplamı
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
            // Modal tutamağı
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

            // ==========================================
            // ŞEHİR DIŞI SEYAHAT SEÇİM ANAHTARI (Switch)
            // ==========================================
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

            // ==========================================
            // ŞEHİR SEÇİMİ AÇILIR MENÜSÜ (Dropdown)
            // ==========================================
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

              // ==========================================
              // KİLOMETRE VE EK ÜCRET BİLGİLENDİRME KUTUSU
              // ==========================================
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

            // Toplam Tutar Özeti
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

            // ==========================================
            // ÖDEMEYE İLERLE BUTONU
            // ==========================================
            CustomElevatedButton(
              text: 'Ödemeye İlerle',
              icon: Icons.payment_rounded,
              onPressed: () {
                Navigator.of(context).pop(); // Rota modalını kapatıyoruz.

                // Girilen rota, gün ve ücret bilgilerine göre rezervasyon nesnesi oluşturuyoruz.
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

                // Kullanıcıyı güvenli ödeme (kart bilgisi girme) ekranına yönlendiriyoruz.
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
