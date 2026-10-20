import '../models/car.dart';
import '../models/category.dart';
import '../models/fuel_price.dart';
import '../models/user.dart';

class MockData {
  // Kategoriler
  static final List<Category> categories = [
    const Category(
      id: 'basic',
      name: 'Basic',
      description: 'Ekonomik ve pratik şehir içi sürüşü',
      iconName: 'directions_car',
    ),
    const Category(
      id: 'basic_plus',
      name: 'Basic+',
      description: 'Geniş bagajlı konforlu aile seçenekleri',
      iconName: 'commute',
    ),
    const Category(
      id: 'flex',
      name: 'flex',
      description: 'Esnek, dinamik ve maceracı Crossover/SUV',
      iconName: 'electric_car',
    ),
    const Category(
      id: 'flex_plus',
      name: 'flex+',
      description: 'Gelişmiş donanımlı üst segment araçlar',
      iconName: 'airport_shuttle',
    ),
    const Category(
      id: 'lux',
      name: 'Lux',
      description: 'Prestij ve üst düzey konfor deneyimi',
      iconName: 'stars',
    ),
    const Category(
      id: 'ultra_lux',
      name: 'Ultra Lux',
      description: 'Ayrıcalıklı ve yüksek performanslı süper lüks',
      iconName: 'workspace_premium',
    ),
  ];

  // Araçlar
  static final List<Car> cars = [
    Car(
      id: 'c1',
      brand: 'Renault',
      model: 'Clio 1.0 TCe',
      year: 2023,
      categoryId: 'basic',
      plateNumber: '34 SEM 101',
      dailyPrice: 1250,
      kilometer: 38400,
      fuelType: 'Benzin',
      fuelLevelPercentage: 0.85,
      estimatedRangeKm: 640,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1619767886558-efdc259cde1a?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 45)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 280)),
    ),
    Car(
      id: 'c2',
      brand: 'Fiat',
      model: 'Egea 1.3 MultiJet',
      year: 2022,
      categoryId: 'basic',
      plateNumber: '34 SEM 102',
      dailyPrice: 1350,
      kilometer: 52100,
      fuelType: 'Dizel',
      fuelLevelPercentage: 0.60,
      estimatedRangeKm: 710,
      transmission: 'Manuel',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 80)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 15)), // Yaklaşan muayene!
    ),
    Car(
      id: 'c3',
      brand: 'Toyota',
      model: 'Corolla 1.8 Hybrid',
      year: 2023,
      categoryId: 'basic_plus',
      plateNumber: '34 SEM 201',
      dailyPrice: 1850,
      kilometer: 26500,
      fuelType: 'Benzin',
      fuelLevelPercentage: 0.90,
      estimatedRangeKm: 850,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 20)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 320)),
    ),
    Car(
      id: 'c4',
      brand: 'Ford',
      model: 'Focus 1.5 EcoBlue',
      year: 2022,
      categoryId: 'basic_plus',
      plateNumber: '34 SEM 202',
      dailyPrice: 1750,
      kilometer: 41200,
      fuelType: 'Dizel',
      fuelLevelPercentage: 0.70,
      estimatedRangeKm: 760,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1551830820-330a71b99659?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 110)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 90)),
    ),
    Car(
      id: 'c5',
      brand: 'Peugeot',
      model: '3008 GT 1.5 BlueHDi',
      year: 2023,
      categoryId: 'flex',
      plateNumber: '34 SEM 301',
      dailyPrice: 2450,
      kilometer: 21000,
      fuelType: 'Dizel',
      fuelLevelPercentage: 0.80,
      estimatedRangeKm: 810,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 30)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 240)),
    ),
    Car(
      id: 'c6',
      brand: 'Hyundai',
      model: 'Tucson 1.6 T-GDI Elite',
      year: 2024,
      categoryId: 'flex',
      plateNumber: '34 SEM 302',
      dailyPrice: 2600,
      kilometer: 14500,
      fuelType: 'Benzin',
      fuelLevelPercentage: 0.65,
      estimatedRangeKm: 620,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1541899481282-d53bffe3c35d?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 15)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 410)),
    ),
    Car(
      id: 'c7',
      brand: 'Volkswagen',
      model: 'Passat 2.0 TDI Elegance',
      year: 2023,
      categoryId: 'flex_plus',
      plateNumber: '34 SEM 401',
      dailyPrice: 3200,
      kilometer: 31800,
      fuelType: 'Dizel',
      fuelLevelPercentage: 0.75,
      estimatedRangeKm: 920,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1542282088-72c9c27ed0cd?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 90)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 8)), // Çok acil muayene!
    ),
    Car(
      id: 'c8',
      brand: 'Audi',
      model: 'A4 Sedan 40 TDI quattro',
      year: 2023,
      categoryId: 'flex_plus',
      plateNumber: '34 SEM 402',
      dailyPrice: 3800,
      kilometer: 19500,
      fuelType: 'Dizel',
      fuelLevelPercentage: 0.85,
      estimatedRangeKm: 840,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 60)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 180)),
    ),
    Car(
      id: 'c9',
      brand: 'BMW',
      model: '520i M Sport',
      year: 2024,
      categoryId: 'lux',
      plateNumber: '34 SEM 501',
      dailyPrice: 5200,
      kilometer: 11200,
      fuelType: 'Benzin',
      fuelLevelPercentage: 0.90,
      estimatedRangeKm: 740,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1555215695-3004980ad54e?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 25)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 350)),
    ),
    Car(
      id: 'c10',
      brand: 'Mercedes-Benz',
      model: 'E 200 AMG Edition',
      year: 2024,
      categoryId: 'lux',
      plateNumber: '34 SEM 502',
      dailyPrice: 5600,
      kilometer: 8400,
      fuelType: 'Benzin',
      fuelLevelPercentage: 0.95,
      estimatedRangeKm: 780,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 10)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 390)),
    ),
    Car(
      id: 'c11',
      brand: 'Porsche',
      model: 'Panamera 4S Executive',
      year: 2024,
      categoryId: 'ultra_lux',
      plateNumber: '34 SEM 601',
      dailyPrice: 11500,
      kilometer: 5600,
      fuelType: 'Benzin',
      fuelLevelPercentage: 0.70,
      estimatedRangeKm: 610,
      transmission: 'Otomatik',
      seatCount: 4,
      imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 40)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 300)),
    ),
    Car(
      id: 'c12',
      brand: 'Range Rover',
      model: 'Autobiography V8 LWB',
      year: 2024,
      categoryId: 'ultra_lux',
      plateNumber: '34 SEM 602',
      dailyPrice: 14000,
      kilometer: 7200,
      fuelType: 'Dizel',
      fuelLevelPercentage: 0.85,
      estimatedRangeKm: 890,
      transmission: 'Otomatik',
      seatCount: 5,
      imageUrl: 'https://images.unsplash.com/photo-1606016159991-dfe4f2746ad5?auto=format&fit=crop&w=800&q=80',
      isAvailable: true,
      lastMaintenanceDate: DateTime.now().subtract(const Duration(days: 12)),
      nextInspectionDate: DateTime.now().add(const Duration(days: 340)),
    ),
  ];

  // 3 Farklı Petrol Şirketinin Güncel Mock Yakıt Fiyatları
  static final List<FuelPrice> fuelPrices = [
    FuelPrice(
      companyName: 'Opet',
      gasolinePrice: 44.82,
      dieselPrice: 43.88,
      lpgPrice: 22.45,
      brandColorHex: '#0047BA',
      lastUpdated: DateTime.now(),
    ),
    FuelPrice(
      companyName: 'Petrol Ofisi',
      gasolinePrice: 44.78,
      dieselPrice: 43.82,
      lpgPrice: 22.39,
      brandColorHex: '#E30613',
      lastUpdated: DateTime.now(),
    ),
    FuelPrice(
      companyName: 'Shell',
      gasolinePrice: 44.95,
      dieselPrice: 43.99,
      lpgPrice: 22.52,
      brandColorHex: '#FBCE07',
      lastUpdated: DateTime.now(),
    ),
  ];

  // Kullanıcılar (Müşteri & Admin)
  static final List<User> users = [
    const User(
      id: 'u_admin',
      fullName: 'SEM Auto Yönetici',
      email: 'admin@semauto.com',
      tcNo: '11111111110',
      drivingLicenseNo: 'TR-ADM-9988',
      role: UserRole.admin,
      isNfcVerified: true,
    ),
    const User(
      id: 'u_customer',
      fullName: 'Ahmet Yılmaz',
      email: 'ahmet@gmail.com',
      tcNo: '12345678901',
      drivingLicenseNo: 'TR-DRV-4567',
      role: UserRole.customer,
      isNfcVerified: true,
    ),
  ];

  // Kullanıcı Sözleşmesi Metni
  static const String userAgreementText = '''
SEM AUTO ARAÇ KİRALAMA VE KULLANICI SÖZLEŞMESİ

1. TARAFLAR VE AMAÇ
İşbu sözleşme, SEM Auto ile aracı kiralayan gerçek kişi (Kullanıcı) arasında, mobil uygulama üzerinden gerçekleştirilecek araç kiralama işlemlerinin koşullarını belirler.

2. KİLOMETRE VE KULLANIM SINIRI
Günlük kullanım sınırı azami 250 (iki yüz elli) kilometredir. Şehir dışı seyahatlerde rota ve mesafe hesaplaması esas alınır. Aşılan her 250 km için bir günlük kiralama bedeli otomatik olarak toplam tutara yansıtılır.

3. YAKIT VE TESLİMAT POLİTİKASI
Araçlar, teslim alındığı andaki yakıt seviyesi ile iade edilmelidir. Eksik yakıt ile iade durumunda, güncel akaryakıt pompa fiyatı ve hizmet bedeli tahsil edilir.

4. EHLİYET VE KİMLİK DOĞRULAMA
Kullanıcı, T.C. Kimlik Numarası ve en az 2 yıllık geçerli sürücü belgesi ibraz etmekle yükümlüdür. NFC ile okutulan veya manuel girilen ehliyet bilgileri resmi veritabanları ile teyit edilir.

5. SİGORTA VE HASAR SORUMLULUĞU
Tüm araçlarımız Rent A Car Kaskolu olup, alkol/uyuşturucu etkisi altında kullanım veya üçüncü şahıslara devir durumunda kasko teminatı geçersiz sayılır ve doğacak tüm zarardan kullanıcı sorumludur.

6. İPTAL VE İADE KOŞULLARI
Rezervasyon başlangıç saatinden 24 saat öncesine kadar yapılan iptallerde kesintisiz tam iade yapılır.

SEM Auto © 2026 - Tüm Hakları Saklıdır.
''';
}
