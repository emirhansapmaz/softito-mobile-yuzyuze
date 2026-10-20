// Flutter durum yönetimi ve temel arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Sahte başlangıç verilerini sağlayan MockData sınıfını içe aktarıyoruz.
import '../data/mock_data.dart';
// Araç veri modelini içe aktarıyoruz.
import '../models/car.dart';
// Kategori veri modelini içe aktarıyoruz.
import '../models/category.dart';
// Akaryakıt fiyat modelini içe aktarıyoruz.
import '../models/fuel_price.dart';
// Rezervasyon veri modelini içe aktarıyoruz.
import '../models/reservation.dart';

/// Araçların listelenmesinde kullanılan sıralama seçenekleri numaralandırması.
enum SortOption {
  /// Fiyata göre artan (En düşük fiyattan en yükseğe)
  priceAsc,
  /// Fiyata göre azalan (En yüksek fiyattan en düşüğe)
  priceDesc,
  /// Yıla göre azalan (En yeni modelden en eskiye)
  yearDesc,
  /// Yıla göre artan (En eski modelden en yeniye)
  yearAsc,
  /// Kilometreye göre artan (En düşük km'den yükseğe)
  kmAsc,
  /// Kilometreye göre azalan (En yüksek km'den düşüğe)
  kmDesc,
}

/// Araç yönetimi, filtreleme, sıralama, rezervasyon oluşturma ve yönetici işlemlerini yöneten ana Provider sınıfı.
class VehicleProvider extends ChangeNotifier {
  /// Sistemdeki araçların listesi (Başlangıçta MockData'dan kopyalanır)
  final List<Car> _cars = List.from(MockData.cars);
  
  /// Sistemdeki kategorilerin listesi
  final List<Category> _categories = List.from(MockData.categories);
  
  /// Güncel akaryakıt fiyatları listesi
  final List<FuelPrice> _fuelPrices = List.from(MockData.fuelPrices);
  
  /// Kullanıcılar tarafından oluşturulan rezervasyonların listesi
  final List<Reservation> _reservations = [];

  /// Seçili sıralama tercihi (Varsayılan: En düşük fiyat önce)
  SortOption _selectedSortOption = SortOption.priceAsc;
  
  /// Seçili vites türü filtresi ('Tümü', 'Otomatik', 'Manuel')
  String _selectedTransmission = 'Tümü';
  
  /// Seçili yakıt türü filtresi ('Tümü', 'Benzin', 'Dizel', 'LPG', 'Elektrik')
  String _selectedFuelType = 'Tümü';
  
  /// Kullanıcının arama çubuğuna yazdığı arama metni
  String _searchQuery = '';

  // ==========================================
  // GETTER'LAR (Okuma Özellikleri)
  // ==========================================
  
  /// Tüm araçlar listesini döndürür.
  List<Car> get cars => _cars;
  
  /// Tüm kategorileri döndürür.
  List<Category> get categories => _categories;
  
  /// Akaryakıt fiyatlarını döndürür.
  List<FuelPrice> get fuelPrices => _fuelPrices;
  
  /// Tüm rezervasyonları döndürür.
  List<Reservation> get reservations => _reservations;

  /// Aktif sıralama seçeneğini döndürür.
  SortOption get selectedSortOption => _selectedSortOption;
  
  /// Aktif vites filtresini döndürür.
  String get selectedTransmission => _selectedTransmission;
  
  /// Aktif yakıt filtresini döndürür.
  String get selectedFuelType => _selectedFuelType;
  
  /// Aktif arama kelimesini döndürür.
  String get searchQuery => _searchQuery;

  // ==========================================
  // FİLTRE VE ARAMA GÜNCELLEME METOTLARI
  // ==========================================

  /// Arama metnini günceller ve listeyi yeniler.
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Sıralama tercihini günceller ve listeyi yeniler.
  void setSortOption(SortOption option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  /// Vites tipi filtresini günceller ve listeyi yeniler.
  void setFilterTransmission(String transmission) {
    _selectedTransmission = transmission;
    notifyListeners();
  }

  /// Yakıt tipi filtresini günceller ve listeyi yeniler.
  void setFilterFuelType(String fuelType) {
    _selectedFuelType = fuelType;
    notifyListeners();
  }

  /// Tüm filtreleri, arama metnini ve sıralamayı varsayılan değerlerine sıfırlar.
  void resetFilters() {
    _selectedSortOption = SortOption.priceAsc;
    _selectedTransmission = 'Tümü';
    _selectedFuelType = 'Tümü';
    _searchQuery = '';
    notifyListeners();
  }

  // ==========================================
  // ARAÇ LİSTELEME VE FİLTRELEME MANTIĞI
  // ==========================================

  /// Belirli bir kategoriye ait araçları filtreler, arama kelimesiyle süzer ve sıralar.
  List<Car> getFilteredCars(String categoryId) {
    // 1. İlgili kategoriye ait araçları ayıklıyoruz.
    var list = _cars.where((car) => car.categoryId == categoryId).toList();

    // 2. Arama filtresi: Marka, model veya tam araç adı içinde arama yapılır.
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((car) {
        return car.fullName.toLowerCase().contains(q) ||
            car.brand.toLowerCase().contains(q) ||
            car.model.toLowerCase().contains(q);
      }).toList();
    }

    // 3. Vites türü filtresi ('Tümü' değilse seçilen türe göre eşleştir)
    if (_selectedTransmission != 'Tümü') {
      list = list.where((car) => car.transmission == _selectedTransmission).toList();
    }

    // 4. Yakıt türü filtresi ('Tümü' değilse seçilen türe göre eşleştir)
    if (_selectedFuelType != 'Tümü') {
      list = list.where((car) => car.fuelType == _selectedFuelType).toList();
    }

    // 5. Seçili sıralama kriterine göre listeyi sıralama
    switch (_selectedSortOption) {
      case SortOption.priceAsc:
        list.sort((a, b) => a.dailyPrice.compareTo(b.dailyPrice));
        break;
      case SortOption.priceDesc:
        list.sort((a, b) => b.dailyPrice.compareTo(a.dailyPrice));
        break;
      case SortOption.yearDesc:
        list.sort((a, b) => b.year.compareTo(a.year));
        break;
      case SortOption.yearAsc:
        list.sort((a, b) => a.year.compareTo(b.year));
        break;
      case SortOption.kmAsc:
        list.sort((a, b) => a.kilometer.compareTo(b.kilometer));
        break;
      case SortOption.kmDesc:
        list.sort((a, b) => b.kilometer.compareTo(a.kilometer));
        break;
    }

    return list;
  }

  /// Bir kategoride toplam kaç araç bulunduğunu döndürür.
  int getCarCountForCategory(String categoryId) {
    return _cars.where((car) => car.categoryId == categoryId).length;
  }

  /// ID'si verilen aracı listeden bulup döndürür (Bulunamazsa null).
  Car? getCarById(String id) {
    try {
      return _cars.firstWhere((car) => car.id == id);
    } catch (_) {
      return null;
    }
  }

  // ==========================================
  // REZERVASYON İŞLEMLERİ
  // ==========================================

  /// Yeni rezervasyon ekler ve aracı kiralanmış (müsait değil) durumuna getirir.
  Future<void> addReservation(Reservation reservation) async {
    // 1.2 saniyelik işlem gecikmesi simülasyonu
    await Future.delayed(const Duration(milliseconds: 1200));
    // Yeni rezervasyonu listenin en başına ekliyoruz.
    _reservations.insert(0, reservation);

    // Kiralanan aracın müsaitlik bayrağını false (dolu) yapıyoruz.
    final carIndex = _cars.indexWhere((c) => c.id == reservation.carId);
    if (carIndex != -1) {
      _cars[carIndex] = _cars[carIndex].copyWith(isAvailable: false);
    }

    // Arayüzü güncelliyoruz.
    notifyListeners();
  }

  // ==========================================
  // YÖNETİCİ (ADMIN) İŞLEMLERİ
  // ==========================================

  /// Yönetici tarafından sisteme yeni araç ekleme metodu
  void addCar(Car car) {
    _cars.insert(0, car);
    notifyListeners();
  }

  /// Yönetici tarafından mevcut araç bilgilerini güncelleme metodu
  void updateCar(Car updatedCar) {
    final index = _cars.indexWhere((c) => c.id == updatedCar.id);
    if (index != -1) {
      _cars[index] = updatedCar;
      notifyListeners();
    }
  }

  /// Yönetici tarafından bir aracı sistemden silme metodu
  void deleteCar(String carId) {
    _cars.removeWhere((c) => c.id == carId);
    notifyListeners();
  }

  /// Yönetici tarafından rezervasyon durumunu (onaylandı, reddedildi vb.) güncelleme metodu
  void updateReservationStatus(String reservationId, ReservationStatus newStatus) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(status: newStatus);

      // Rezervasyon reddedilirse veya kiralama süresi tamamlanırsa aracı tekrar müsait yapıyoruz.
      if (newStatus == ReservationStatus.rejected || newStatus == ReservationStatus.completed) {
        final carIndex = _cars.indexWhere((c) => c.id == _reservations[index].carId);
        if (carIndex != -1) {
          _cars[carIndex] = _cars[carIndex].copyWith(isAvailable: true);
        }
      }

      // Değişikliği dinleyen ekranlara bildiriyoruz.
      notifyListeners();
    }
  }
}
