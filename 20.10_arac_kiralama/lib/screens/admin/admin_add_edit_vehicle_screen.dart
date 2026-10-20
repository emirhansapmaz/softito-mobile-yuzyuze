// Flutter materyal arayüz kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Durum yönetimi için Provider paketini içe aktarıyoruz.
import 'package:provider/provider.dart';
// Tema renk paletini içe aktarıyoruz.
import '../../core/theme/app_colors.dart';
// Araç modelini içe aktarıyoruz.
import '../../models/car.dart';
// Araç ekleme ve güncelleme işlemlerini yapacak VehicleProvider'ı içe aktarıyoruz.
import '../../providers/vehicle_provider.dart';
// Özel buton bileşenini içe aktarıyoruz.
import '../../widgets/custom_button.dart';
// Özel metin kutusu bileşenini içe aktarıyoruz.
import '../../widgets/custom_text_field.dart';

/// Yöneticinin sisteme yeni bir araç eklemesini veya mevcut bir aracın özelliklerini güncellemesini sağlayan form ekranı.
class AdminAddEditVehicleScreen extends StatefulWidget {
  /// Düzenlenecek araç nesnesi (Yeni araç ekleniyorsa null'dur)
  final Car? carToEdit;

  /// AdminAddEditVehicleScreen kurucu metodu (Constructor)
  const AdminAddEditVehicleScreen({super.key, this.carToEdit});

  @override
  State<AdminAddEditVehicleScreen> createState() => _AdminAddEditVehicleScreenState();
}

class _AdminAddEditVehicleScreenState extends State<AdminAddEditVehicleScreen> {
  /// Form geçerlilik kontrolü anahtarı
  final _formKey = GlobalKey<FormState>();

  /// Form alanları için metin kontrolcüleri
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _plateController;
  late TextEditingController _dailyPriceController;
  late TextEditingController _kmController;
  late TextEditingController _rangeController;
  late TextEditingController _imageUrlController;

  /// Seçili kategori kimliği (Varsayılan: 'basic')
  String _selectedCategoryId = 'basic';
  
  /// Seçili vites türü (Varsayılan: 'Otomatik')
  String _selectedTransmission = 'Otomatik';
  
  /// Seçili yakıt türü (Varsayılan: 'Benzin')
  String _selectedFuelType = 'Benzin';
  
  /// Yakıt doluluk oranı kaydırıcı değeri (0.10 ile 1.0 arası)
  double _fuelLevel = 0.80;

  /// Ekranın düzenleme mi yoksa yeni ekleme modunda mı olduğunu belirten getter
  bool get isEditing => widget.carToEdit != null;

  @override
  void initState() {
    super.initState();
    final car = widget.carToEdit;

    // Eğer düzenleme modundaysak mevcut araç verileriyle, değilse varsayılan değerlerle başlatıyoruz.
    _brandController = TextEditingController(text: car?.brand ?? '');
    _modelController = TextEditingController(text: car?.model ?? '');
    _yearController = TextEditingController(text: car != null ? '${car.year}' : '2024');
    _plateController = TextEditingController(text: car?.plateNumber ?? '34 SEM ');
    _dailyPriceController = TextEditingController(text: car != null ? '${car.dailyPrice.toInt()}' : '2000');
    _kmController = TextEditingController(text: car != null ? '${car.kilometer}' : '15000');
    _rangeController = TextEditingController(text: car != null ? '${car.estimatedRangeKm}' : '650');
    _imageUrlController = TextEditingController(
      text: car?.imageUrl ??
          'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
    );

    if (car != null) {
      _selectedCategoryId = car.categoryId;
      _selectedTransmission = car.transmission;
      _selectedFuelType = car.fuelType;
      _fuelLevel = car.fuelLevelPercentage;
    }
  }

  @override
  void dispose() {
    // Form denetleyicilerini bellekten siliyoruz.
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _plateController.dispose();
    _dailyPriceController.dispose();
    _kmController.dispose();
    _rangeController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // ==========================================
  // ARACI KAYDETME / GÜNCELLEME İŞLEMİ
  // ==========================================
  /// Formu denetler, yeni veya güncellenmiş Car nesnesini oluşturup Provider'a iletir.
  void _saveVehicle() {
    if (!_formKey.currentState!.validate()) return;

    final vp = Provider.of<VehicleProvider>(context, listen: false);

    // Form alanlarından Car nesnesini inşa ediyoruz.
    final car = Car(
      id: widget.carToEdit?.id ?? 'c_${DateTime.now().millisecondsSinceEpoch}',
      brand: _brandController.text.trim(),
      model: _modelController.text.trim(),
      year: int.tryParse(_yearController.text.trim()) ?? 2024,
      categoryId: _selectedCategoryId,
      plateNumber: _plateController.text.trim(),
      dailyPrice: double.tryParse(_dailyPriceController.text.trim()) ?? 2000,
      kilometer: int.tryParse(_kmController.text.trim()) ?? 15000,
      fuelType: _selectedFuelType,
      fuelLevelPercentage: _fuelLevel,
      estimatedRangeKm: int.tryParse(_rangeController.text.trim()) ?? 600,
      transmission: _selectedTransmission,
      imageUrl: _imageUrlController.text.trim(),
      isAvailable: widget.carToEdit?.isAvailable ?? true,
      lastMaintenanceDate: widget.carToEdit?.lastMaintenanceDate ?? DateTime.now(),
      nextInspectionDate: widget.carToEdit?.nextInspectionDate ?? DateTime.now().add(const Duration(days: 365)),
    );

    if (isEditing) {
      // Düzenleme modundaysak mevcut aracı güncelliyoruz.
      vp.updateCar(car);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Araç başarıyla güncellendi!'), backgroundColor: AppColors.success),
      );
    } else {
      // Yeni araç modundaysak filoya ekliyoruz.
      vp.addCar(car);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yeni araç başarıyla filoya eklendi!'), backgroundColor: AppColors.success),
      );
    }

    // Form ekranını kapatıp önceki sayfaya dönüyoruz.
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = Provider.of<VehicleProvider>(context).categories;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Aracı Düzenle' : 'Yeni Araç Ekle'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==========================================
                // MARKA VE MODEL GİRİŞ ALANLARI
                // ==========================================
                Row(
                  children: [
                    // Marka Kutusu
                    Expanded(
                      child: CustomTextField(
                        controller: _brandController,
                        labelText: 'Marka',
                        hintText: 'Örn: Mercedes',
                        textInputAction: TextInputAction.next,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Gerekli' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Model Kutusu
                    Expanded(
                      child: CustomTextField(
                        controller: _modelController,
                        labelText: 'Model',
                        hintText: 'Örn: C200',
                        textInputAction: TextInputAction.next,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Gerekli' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ==========================================
                // ARAÇ KATEGORİSİ SEÇİMİ (Dropdown)
                // ==========================================
                DropdownButtonFormField<String>(
                  initialValue: _selectedCategoryId,
                  decoration: InputDecoration(
                    labelText: 'Araç Kategorisi',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  items: categories.map((cat) {
                    return DropdownMenuItem(
                      value: cat.id,
                      child: Text('${cat.name} (${cat.description})'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCategoryId = val);
                  },
                ),
                const SizedBox(height: 16),

                // ==========================================
                // MODEL YILI VE PLAKA
                // ==========================================
                Row(
                  children: [
                    // Model Yılı
                    Expanded(
                      child: CustomTextField(
                        controller: _yearController,
                        labelText: 'Model Yılı',
                        hintText: '2024',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Gerekli' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Plaka Numarası
                    Expanded(
                      child: CustomTextField(
                        controller: _plateController,
                        labelText: 'Plaka',
                        hintText: '34 SEM 777',
                        textInputAction: TextInputAction.next,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Gerekli' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ==========================================
                // GÜNLÜK KİRA BEDELİ VE MEVCUT KİLOMETRE
                // ==========================================
                Row(
                  children: [
                    // Günlük Fiyat (TL)
                    Expanded(
                      child: CustomTextField(
                        controller: _dailyPriceController,
                        labelText: 'Günlük Fiyat (TL)',
                        hintText: '2500',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Gerekli' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Kilometre
                    Expanded(
                      child: CustomTextField(
                        controller: _kmController,
                        labelText: 'Mevcut KM',
                        hintText: '25000',
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (v) => v == null || v.trim().isEmpty ? 'Gerekli' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ==========================================
                // ŞANZIMAN VE YAKIT TİPİ SEÇİMLERİ (Dropdown)
                // ==========================================
                Row(
                  children: [
                    // Vites (Otomatik / Manuel)
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedTransmission,
                        decoration: InputDecoration(
                          labelText: 'Şanzıman',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        items: ['Otomatik', 'Manuel'].map((t) {
                          return DropdownMenuItem(value: t, child: Text(t));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedTransmission = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Yakıt Türü (Benzin / Dizel / LPG / Elektrik)
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedFuelType,
                        decoration: InputDecoration(
                          labelText: 'Yakıt',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        items: ['Benzin', 'Dizel', 'LPG', 'Elektrik'].map((f) {
                          return DropdownMenuItem(value: f, child: Text(f));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _selectedFuelType = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // ==========================================
                // TAHMİNİ MENZİL ALANI (KM)
                // ==========================================
                CustomTextField(
                  controller: _rangeController,
                  labelText: 'Tahmini Menzil (KM)',
                  hintText: 'Örn: 700',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Gerekli' : null,
                ),
                const SizedBox(height: 16),

                // ==========================================
                // ARAÇ GÖRSEL BAĞLANTI ADRESİ (URL)
                // ==========================================
                CustomTextField(
                  controller: _imageUrlController,
                  labelText: 'Araç Görsel URL',
                  hintText: 'https://...',
                  textInputAction: TextInputAction.done,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Görsel linki zorunludur' : null,
                ),
                const SizedBox(height: 20),

                // ==========================================
                // YAKIT SEVİYESİ KAYDIRICI (Slider)
                // ==========================================
                Text(
                  'Mevcut Yakıt Doluluk Oranı (%${(_fuelLevel * 100).toInt()})',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                Slider(
                  value: _fuelLevel,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  activeColor: AppColors.primaryBlue,
                  label: '%${(_fuelLevel * 100).toInt()}',
                  onChanged: (val) => setState(() => _fuelLevel = val),
                ),
                const SizedBox(height: 24),

                // ==========================================
                // KAYDET / GÜNCELLE BUTONU
                // ==========================================
                CustomElevatedButton(
                  text: isEditing ? 'Değişiklikleri Kaydet' : 'Filoya Ekle',
                  icon: isEditing ? Icons.save_rounded : Icons.add_circle_outline_rounded,
                  onPressed: _saveVehicle,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
