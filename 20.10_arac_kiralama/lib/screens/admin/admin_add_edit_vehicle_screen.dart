import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/car.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class AdminAddEditVehicleScreen extends StatefulWidget {
  final Car? carToEdit;

  const AdminAddEditVehicleScreen({super.key, this.carToEdit});

  @override
  State<AdminAddEditVehicleScreen> createState() => _AdminAddEditVehicleScreenState();
}

class _AdminAddEditVehicleScreenState extends State<AdminAddEditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _plateController;
  late TextEditingController _dailyPriceController;
  late TextEditingController _kmController;
  late TextEditingController _rangeController;
  late TextEditingController _imageUrlController;

  String _selectedCategoryId = 'basic';
  String _selectedTransmission = 'Otomatik';
  String _selectedFuelType = 'Benzin';
  double _fuelLevel = 0.80;

  bool get isEditing => widget.carToEdit != null;

  @override
  void initState() {
    super.initState();
    final car = widget.carToEdit;
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

  void _saveVehicle() {
    if (!_formKey.currentState!.validate()) return;

    final vp = Provider.of<VehicleProvider>(context, listen: false);

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
      vp.updateCar(car);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Araç başarıyla güncellendi!'), backgroundColor: AppColors.success),
      );
    } else {
      vp.addCar(car);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Yeni araç başarıyla filoya eklendi!'), backgroundColor: AppColors.success),
      );
    }

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
                // Marka & Model
                Row(
                  children: [
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

                // Kategori Seçimi
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

                // Yıl ve Plaka
                Row(
                  children: [
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

                // Günlük Fiyat & Kilometre
                Row(
                  children: [
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

                // Şanzıman ve Yakıt Tipi
                Row(
                  children: [
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

                // Tahmini Menzil
                CustomTextField(
                  controller: _rangeController,
                  labelText: 'Tahmini Menzil (KM)',
                  hintText: 'Örn: 700',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Gerekli' : null,
                ),
                const SizedBox(height: 16),

                // Görsel URL
                CustomTextField(
                  controller: _imageUrlController,
                  labelText: 'Araç Görsel URL',
                  hintText: 'https://...',
                  textInputAction: TextInputAction.done,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Görsel linki zorunludur' : null,
                ),
                const SizedBox(height: 20),

                // Yakıt Doluluk Sliderı
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

                // Kaydet Butonu
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
