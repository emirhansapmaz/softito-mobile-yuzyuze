// Flutter materyal arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Tarih formatlama işlemleri için intl kütüphanesini içe aktarıyoruz.
import 'package:intl/intl.dart';
// Durum yönetimi için Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Uygulama tema renklerini içe aktarıyoruz.
import '../../core/theme/app_colors.dart';
// Araç veri modelini içe aktarıyoruz.
import '../../models/car.dart';
// Rezervasyon veri modelini ve durum enum'ını içe aktarıyoruz.
import '../../models/reservation.dart';
// Oturum yönetimi Provider'ını içe aktarıyoruz.
import '../../providers/auth_provider.dart';
// Tema tercihi Provider'ını içe aktarıyoruz.
import '../../providers/theme_provider.dart';
// Araç ve rezervasyon yönetim Provider'ını içe aktarıyoruz.
import '../../providers/vehicle_provider.dart';
// Logo bileşenini içe aktarıyoruz.
import '../../widgets/sem_logo.dart';
// Çıkış yapıldığında dönülecek giriş ekranını içe aktarıyoruz.
import '../auth/login_screen.dart';
// Araç ekleme ve düzenleme ekranını içe aktarıyoruz.
import 'admin_add_edit_vehicle_screen.dart';

/// Sistem yöneticisinin (Admin) filoyu yönettiği, rezervasyonları onaylayıp reddettiği ve muayene/bakımları takip ettiği yönetim paneli ekranı.
class AdminDashboardScreen extends StatefulWidget {
  /// AdminDashboardScreen kurucu metodu (Constructor)
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  /// 3 sekme (Araçlar, Talepler, Muayene & Bakım) arasındaki geçişi kontrol eden TabController
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    // 3 adet sekme tanımlıyoruz.
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    // Controller nesnesini bellekten siliyoruz.
    _tabController.dispose();
    super.dispose();
  }

  // ==========================================
  // ARAÇ SİLME ONAY DİYALOĞU (AlertDialog)
  // ==========================================
  /// Bir aracı silmeden önce yöneticiden onay isteyen AlertDialog bileşeni
  void _confirmDeleteCar(BuildContext context, Car car) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_forever_rounded, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Text('Aracı Sil', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: Text(
          '${car.fullName} (${car.plateNumber}) plakalı aracı filodan tamamen silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.textLight : AppColors.textDark,
          ),
        ),
        actions: [
          // İptal Butonu
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('İptal'),
          ),
          // Evet, Sil Onay Butonu
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              // Provider üzerinden aracı siliyoruz.
              Provider.of<VehicleProvider>(context, listen: false).deleteCar(car.id);
              Navigator.of(dialogContext).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${car.fullName} filodan silindi.'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: const Text('Evet, Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final vp = Provider.of<VehicleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // Başlık: Logo ve kırmızı ADMIN rozeti
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SemLogo(fontSize: 20),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'ADMIN',
                style: TextStyle(
                  color: AppColors.error,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Tema değiştirme butonu
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
            ),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Temayı Değiştir',
          ),
          // Çıkış yap butonu
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              auth.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            tooltip: 'Çıkış Yap',
          ),
        ],
        // 3 Ana Yönetim Sekmesi (TabBar)
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryBlue,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
          tabs: [
            // 1. Sekme: Araçlar Listesi
            Tab(
              icon: const Icon(Icons.directions_car_rounded, size: 20),
              text: 'Araçlar (${vp.cars.length})',
            ),
            // 2. Sekme: Müşteri Rezervasyon Talepleri
            Tab(
              icon: const Icon(Icons.book_online_rounded, size: 20),
              text: 'Talepler (${vp.reservations.length})',
            ),
            // 3. Sekme: Muayene ve Bakım Takvimi
            Tab(
              icon: const Icon(Icons.build_circle_rounded, size: 20),
              text: 'Muayene & Bakım',
            ),
          ],
        ),
      ),
      // Sekmelerin içeriği
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCarsTab(context, isDark, vp),
          _buildReservationsTab(context, isDark, vp),
          _buildMaintenanceTab(context, isDark, vp),
        ],
      ),
      // İlk sekmede iken (Araçlar) sağ altta "Yeni Araç Ekle" butonu gösteriyoruz.
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminAddEditVehicleScreen()),
                );
              },
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Yeni Araç Ekle'),
            )
          : null,
    );
  }

  // ==========================================
  // 1. SEKME: ARAÇ LİSTESİ VE YÖNETİMİ
  // ==========================================
  /// Filodaki araçları kartlar halinde listeler; düzenleme ve silme aksiyonları sunar.
  Widget _buildCarsTab(BuildContext context, bool isDark, VehicleProvider vp) {
    final cars = vp.cars;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Küçük Araç Görseli
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    car.imageUrl,
                    width: 90,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 90,
                      height: 70,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.directions_car),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Araç Temel Bilgileri
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        car.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${car.plateNumber} • ${car.year} • ${car.transmission}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${car.dailyPrice.toStringAsFixed(0)} ₺/gün',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlue,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Müsait / Kirada Rozeti
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: car.isAvailable
                                  ? AppColors.success.withValues(alpha: 0.15)
                                  : AppColors.error.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              car.isAvailable ? 'Müsait' : 'Kirada',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: car.isAvailable ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Düzenle & Sil Aksiyon Butonları
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Düzenle Butonu
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.primaryBlue, size: 20),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => AdminAddEditVehicleScreen(carToEdit: car),
                          ),
                        );
                      },
                      tooltip: 'Düzenle',
                    ),
                    // Sil Butonu (Onay dialogu açar)
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                      onPressed: () => _confirmDeleteCar(context, car),
                      tooltip: 'Sil',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // 2. SEKME: REZERVASYON İSTEKLERİ VE YÖNETİMİ
  // ==========================================
  /// Müşterilerin gönderdiği rezervasyon taleplerini listeler, onaylama veya reddetme imkanı sağlar.
  Widget _buildReservationsTab(BuildContext context, bool isDark, VehicleProvider vp) {
    final reservations = vp.reservations;
    final dateFormat = DateFormat('dd.MM.yyyy');

    // Henüz talep yoksa boş kutu mesajı gösteriyoruz.
    if (reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 64, color: isDark ? Colors.grey.shade700 : Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Henüz yeni rezervasyon talebi yok',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Müşteriler kiralama yaptığında talepler burada listelenecektir.',
              style: TextStyle(
                fontSize: 12.5,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
          ],
        ),
      );
    }

    // Rezervasyonları listeliyoruz.
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reservations.length,
      itemBuilder: (context, index) {
        final res = reservations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      res.carName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    _buildReservationStatusBadge(res.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Müşteri: ${res.userName}',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Tarihler: ${dateFormat.format(res.startDate)} - ${dateFormat.format(res.endDate)} (${res.totalDays} Gün)',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                // Şehirlerarası seyahat varsa rota ve ek bedel bilgisi
                if (res.isIntercity)
                  Text(
                    'Şehir Dışı: ${res.destinationCity} (+${res.extraDistanceCharge.toStringAsFixed(0)} ₺)',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tutar: ${res.totalAmount.toStringAsFixed(0)} ₺',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    // Eğer talep beklemedeyse Onayla ve Reddet butonlarını gösteriyoruz
                    if (res.status == ReservationStatus.pending)
                      Row(
                        children: [
                          // Reddet Butonu
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.error,
                              side: const BorderSide(color: AppColors.error),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                            ),
                            onPressed: () {
                              vp.updateReservationStatus(res.id, ReservationStatus.rejected);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Rezervasyon reddedildi.')),
                              );
                            },
                            child: const Text('Reddet', style: TextStyle(fontSize: 12)),
                          ),
                          const SizedBox(width: 8),
                          // Onayla Butonu
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                            ),
                            onPressed: () {
                              vp.updateReservationStatus(res.id, ReservationStatus.confirmed);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Rezervasyon onaylandı!'), backgroundColor: AppColors.success),
                              );
                            },
                            child: const Text('Onayla', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================
  // REZERVASYON DURUMU ROZETİ ÜRETİCİSİ
  // ==========================================
  /// Rezervasyon durumuna göre (Bekliyor, Onaylandı, Reddedildi, Tamamlandı) renkli rozet çizer.
  Widget _buildReservationStatusBadge(ReservationStatus status) {
    Color color;
    String label;

    switch (status) {
      case ReservationStatus.pending:
        color = AppColors.warning;
        label = 'Bekliyor';
        break;
      case ReservationStatus.confirmed:
        color = AppColors.success;
        label = 'Onaylandı';
        break;
      case ReservationStatus.rejected:
        color = AppColors.error;
        label = 'Reddedildi';
        break;
      case ReservationStatus.completed:
        color = AppColors.primaryBlue;
        label = 'Tamamlandı';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ==========================================
  // 3. SEKME: MUAYENE VE BAKIM TAKİP ÇİZELGESİ
  // ==========================================
  /// Araçların gelecek muayene ve son bakım tarihlerini gün farkına göre (Acil, Yaklaşan, İyi) analiz edip listeler.
  Widget _buildMaintenanceTab(BuildContext context, bool isDark, VehicleProvider vp) {
    final cars = vp.cars;
    final now = DateTime.now();
    final dateFormat = DateFormat('dd.MM.yyyy');

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        // Muayeneye kalan gün sayısını hesaplıyoruz.
        final daysToInspection = car.nextInspectionDate.difference(now).inDays;
        // 15 günden az kaldıysa Acil Muayene (Kırmızı)
        final isUrgent = daysToInspection <= 15;
        // 15 ile 60 gün arası Yaklaşan Muayene (Turuncu)
        final isWarning = daysToInspection > 15 && daysToInspection <= 60;

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isUrgent
                  ? AppColors.error
                  : (isWarning ? AppColors.warning : (isDark ? AppColors.borderDark : AppColors.borderLight)),
              width: (isUrgent || isWarning) ? 1.5 : 1.0,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        car.fullName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Acil / Yaklaşan / Durum İyi rozeti
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isUrgent
                            ? AppColors.error.withValues(alpha: 0.15)
                            : (isWarning
                                ? AppColors.warning.withValues(alpha: 0.15)
                                : AppColors.success.withValues(alpha: 0.15)),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isUrgent
                            ? 'ACİL MUAYENE ($daysToInspection gün)'
                            : (isWarning ? 'Yaklaşan Muayene ($daysToInspection gün)' : 'Durum İyi ($daysToInspection gün)'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isUrgent ? AppColors.error : (isWarning ? AppColors.warning : AppColors.success),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Plaka: ${car.plateNumber} • Mevcut KM: ${car.kilometer} km',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 4),
                // Gelecek muayene tarihi
                Row(
                  children: [
                    Icon(
                      Icons.event_available_rounded,
                      size: 15,
                      color: isUrgent ? AppColors.error : AppColors.primaryBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Gelecek Muayene Tarihi: ${dateFormat.format(car.nextInspectionDate)}',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isUrgent ? AppColors.error : (isDark ? AppColors.textLight : AppColors.textDark),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Son periyodik bakım tarihi
                Row(
                  children: [
                    const Icon(Icons.history_rounded, size: 15, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      'Son Periyodik Bakım: ${dateFormat.format(car.lastMaintenanceDate)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Muayene Yenile (+1 Yıl) Butonu
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                      ),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('Muayene Yenile (+1 Yıl)', style: TextStyle(fontSize: 11.5)),
                      onPressed: () {
                        // Muayene tarihine 365 gün ekleyip aracı güncelliyoruz.
                        final updated = car.copyWith(
                          nextInspectionDate: car.nextInspectionDate.add(const Duration(days: 365)),
                        );
                        vp.updateCar(updated);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${car.fullName} muayene tarihi 1 yıl uzatıldı.'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
