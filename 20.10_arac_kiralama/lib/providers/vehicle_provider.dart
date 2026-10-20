import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/car.dart';
import '../models/category.dart';
import '../models/fuel_price.dart';
import '../models/reservation.dart';

enum SortOption {
  priceAsc,
  priceDesc,
  yearDesc,
  yearAsc,
  kmAsc,
  kmDesc,
}

class VehicleProvider extends ChangeNotifier {
  final List<Car> _cars = List.from(MockData.cars);
  final List<Category> _categories = List.from(MockData.categories);
  final List<FuelPrice> _fuelPrices = List.from(MockData.fuelPrices);
  final List<Reservation> _reservations = [];

  SortOption _selectedSortOption = SortOption.priceAsc;
  String _selectedTransmission = 'Tümü';
  String _selectedFuelType = 'Tümü';
  String _searchQuery = '';

  List<Car> get cars => _cars;
  List<Category> get categories => _categories;
  List<FuelPrice> get fuelPrices => _fuelPrices;
  List<Reservation> get reservations => _reservations;

  SortOption get selectedSortOption => _selectedSortOption;
  String get selectedTransmission => _selectedTransmission;
  String get selectedFuelType => _selectedFuelType;
  String get searchQuery => _searchQuery;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(SortOption option) {
    _selectedSortOption = option;
    notifyListeners();
  }

  void setFilterTransmission(String transmission) {
    _selectedTransmission = transmission;
    notifyListeners();
  }

  void setFilterFuelType(String fuelType) {
    _selectedFuelType = fuelType;
    notifyListeners();
  }

  void resetFilters() {
    _selectedSortOption = SortOption.priceAsc;
    _selectedTransmission = 'Tümü';
    _selectedFuelType = 'Tümü';
    _searchQuery = '';
    notifyListeners();
  }

  // Kategoriye ve filtrelere göre araçları getir
  List<Car> getFilteredCars(String categoryId) {
    var list = _cars.where((car) => car.categoryId == categoryId).toList();

    // Arama filtresi
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list.where((car) {
        return car.fullName.toLowerCase().contains(q) ||
            car.brand.toLowerCase().contains(q) ||
            car.model.toLowerCase().contains(q);
      }).toList();
    }

    // Şanzıman filtresi
    if (_selectedTransmission != 'Tümü') {
      list = list.where((car) => car.transmission == _selectedTransmission).toList();
    }

    // Yakıt filtresi
    if (_selectedFuelType != 'Tümü') {
      list = list.where((car) => car.fuelType == _selectedFuelType).toList();
    }

    // Sıralama
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

  int getCarCountForCategory(String categoryId) {
    return _cars.where((car) => car.categoryId == categoryId).length;
  }

  Car? getCarById(String id) {
    try {
      return _cars.firstWhere((car) => car.id == id);
    } catch (_) {
      return null;
    }
  }

  // Rezervasyon Ekle
  Future<void> addReservation(Reservation reservation) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    _reservations.insert(0, reservation);

    // İlgili aracı müsait değil yap
    final carIndex = _cars.indexWhere((c) => c.id == reservation.carId);
    if (carIndex != -1) {
      _cars[carIndex] = _cars[carIndex].copyWith(isAvailable: false);
    }

    notifyListeners();
  }

  // Admin: Araç Ekle
  void addCar(Car car) {
    _cars.insert(0, car);
    notifyListeners();
  }

  // Admin: Araç Güncelle
  void updateCar(Car updatedCar) {
    final index = _cars.indexWhere((c) => c.id == updatedCar.id);
    if (index != -1) {
      _cars[index] = updatedCar;
      notifyListeners();
    }
  }

  // Admin: Araç Sil
  void deleteCar(String carId) {
    _cars.removeWhere((c) => c.id == carId);
    notifyListeners();
  }

  // Admin: Rezervasyon Durumu Güncelle
  void updateReservationStatus(String reservationId, ReservationStatus newStatus) {
    final index = _reservations.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      _reservations[index] = _reservations[index].copyWith(status: newStatus);

      // Reddedilirse veya tamamlanırsa aracı tekrar müsait yap
      if (newStatus == ReservationStatus.rejected || newStatus == ReservationStatus.completed) {
        final carIndex = _cars.indexWhere((c) => c.id == _reservations[index].carId);
        if (carIndex != -1) {
          _cars[carIndex] = _cars[carIndex].copyWith(isAvailable: true);
        }
      }

      notifyListeners();
    }
  }
}
