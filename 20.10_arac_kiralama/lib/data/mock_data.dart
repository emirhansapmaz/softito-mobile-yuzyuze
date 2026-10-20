// Araç veri modelini içe aktarıyoruz.
import '../models/car.dart';
// Kategori veri modelini içe aktarıyoruz.
import '../models/category.dart';
// Akaryakıt fiyat veri modelini içe aktarıyoruz.
import '../models/fuel_price.dart';
// Kullanıcı veri modelini içe aktarıyoruz.
import '../models/user.dart';

/// Uygulama için statik ve sahte (mock) verileri sağlayan yardımcı veri sınıfı.
/// API veya veritabanı bağlanana kadar arayüzün dinamik çalışması için kullanılır.
class MockData {
  // ==========================================
  // ARAÇ KATEGORİLERİ (Categories)
  // ==========================================
  /// Sistemde sunulan araç segmentleri ve açıklamaları
  static final List<Category> categories = [
    // 1. Temel ekonomik sınıf (Şehir içi günlük pratik kullanım)
    const Category(
      id: 'basic',
      name: 'Basic',
      description: 'Ekonomik ve pratik şehir içi sürüşü',
      iconName: 'directions_car',
    ),
    // 2. Geniş bagajlı ve konforlu aile seçenekleri
    const Category(
      id: 'basic_plus',
      name: 'Basic+',
      description: 'Geniş bagajlı konforlu aile seçenekleri',
      iconName: 'commute',
    ),
    // 3. Dinamik Crossover ve SUV sınıfı
    const Category(
      id: 'flex',
      name: 'flex',
      description: 'Esnek, dinamik ve maceracı Crossover/SUV',
      iconName: 'electric_car',
    ),
    // 4. Gelişmiş donanımlı üst segment araçlar
    const Category(
      id: 'flex_plus',
      name: 'flex+',
      description: 'Gelişmiş donanımlı üst segment araçlar',
      iconName: 'airport_shuttle',
    ),
    // 5. Prestij ve üst düzey konfor deneyimi sunan lüks sınıf
    const Category(
      id: 'lux',
      name: 'Lux',
      description: 'Prestij ve üst düzey konfor deneyimi',
      iconName: 'stars',
    ),
    // 6. Ayrıcalıklı ve yüksek performanslı süper lüks sınıf
    const Category(
      id: 'ultra_lux',
      name: 'Ultra Lux',
      description: 'Ayrıcalıklı ve yüksek performanslı süper lüks',
      iconName: 'workspace_premium',
    ),
  ];

  // ==========================================
  // SAHTE ARAÇ LİSTESİ (Cars)
  // ==========================================
  /// Sistemde kiralanabilir ve yönetilebilir sahte araç filosu
  static final List<Car> cars = [
    // Araç 1: Renault Clio (Basic kategorisi)
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
    // Araç 2: Fiat Egea (Basic kategorisi, muayenesi yaklaşan araç örneği)
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
      nextInspectionDate: DateTime.now().add(const Duration(days: 15)), // Yaklaşan muayene uyarısı için
    ),
    // Araç 3: Toyota Corolla Hibrit (Basic+ kategorisi)
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
    // Araç 4: Ford Focus Dizel (Basic+ kategorisi)
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
    // Araç 5: Peugeot 3008 SUV (Flex kategorisi)
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
    // Araç 6: Hyundai Tucson (Flex kategorisi)
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
    // Araç 7: Volkswagen Passat (Flex+ kategorisi, muayene uyarısı)
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
    // Araç 8: Audi A4 Sedan (Flex+ kategorisi)
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
    // Araç 9: BMW 520i (Lux kategorisi)
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
    // Araç 10: Mercedes-Benz E 200 (Lux kategorisi)
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
    // Araç 11: Porsche Panamera (Ultra Lux kategorisi)
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
    // Araç 12: Range Rover Autobiography (Ultra Lux kategorisi)
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

  // ==========================================
  // AKARYAKIT FİYATLARI (Fuel Prices)
  // ==========================================
  /// 3 Farklı Petrol Şirketinin Güncel Mock Yakıt Fiyatları
  static final List<FuelPrice> fuelPrices = [
    // 1. Opet Fiyatları
    FuelPrice(
      companyName: 'Opet',
      gasolinePrice: 44.82,
      dieselPrice: 43.88,
      lpgPrice: 22.45,
      brandColorHex: '#0047BA',
      lastUpdated: DateTime.now(),
    ),
    // 2. Petrol Ofisi Fiyatları
    FuelPrice(
      companyName: 'Petrol Ofisi',
      gasolinePrice: 44.78,
      dieselPrice: 43.82,
      lpgPrice: 22.39,
      brandColorHex: '#E30613',
      lastUpdated: DateTime.now(),
    ),
    // 3. Shell Fiyatları
    FuelPrice(
      companyName: 'Shell',
      gasolinePrice: 44.95,
      dieselPrice: 43.99,
      lpgPrice: 22.52,
      brandColorHex: '#FBCE07',
      lastUpdated: DateTime.now(),
    ),
  ];

  // ==========================================
  // KULLANICILAR (Users)
  // ==========================================
  /// Sistemde tanımlı varsayılan yönetici ve müşteri profilleri
  static final List<User> users = [
    // Yönetici Hesabı: 'admin@semauto.com' ile giriş yapılabilir.
    const User(
      id: 'u_admin',
      fullName: 'SEM Auto Yönetici',
      email: 'admin@semauto.com',
      tcNo: '11111111110',
      drivingLicenseNo: 'TR-ADM-9988',
      role: UserRole.admin,
      isNfcVerified: true,
    ),
    // Normal Müşteri Hesabı: 'ahmet@gmail.com' ile giriş yapılabilir.
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

  // ==========================================
  // KULLANICI SÖZLEŞMESİ METNİ (User Agreement)
  // ==========================================
  /// Müşterinin rezervasyon onayı sırasında okuyup kabul ettiği yasal şartlar
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
