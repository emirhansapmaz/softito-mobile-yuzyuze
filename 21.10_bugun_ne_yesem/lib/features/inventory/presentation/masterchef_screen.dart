import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/models/chef_recipe_model.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';

class MasterchefScreen extends ConsumerStatefulWidget {
  final List<String> availableIngredients;

  const MasterchefScreen({
    super.key,
    this.availableIngredients = const [
      'Yumurta',
      'Peynir',
      'Domates',
      'Biber',
      'Zeytinyağı',
      'Makarna',
      'Tavuk Göğsü',
      'Soğan',
      'Sarımsak',
      'Mantar',
    ],
  });

  @override
  ConsumerState<MasterchefScreen> createState() => _MasterchefScreenState();
}

class _MasterchefScreenState extends ConsumerState<MasterchefScreen> {
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _stepsController = TextEditingController();
  final Set<String> _selectedIngredients = {};
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.availableIngredients.isNotEmpty) {
      _selectedIngredients.addAll(widget.availableIngredients.take(3));
      _generateSmartChefDraft();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  /// Seçilen malzemelere göre otomatik akıllı şef taslağı oluşturur
  void _generateSmartChefDraft() {
    if (_selectedIngredients.isEmpty) return;

    final items = _selectedIngredients.toList();
    if (items.contains('Yumurta') && items.contains('Domates')) {
      _nameController.text = 'Özel Köy Usulü Çakallı Menemeni';
      _caloriesController.text = '290';
      _stepsController.text =
          '1. Tavada tereyağını eritin ve biberleri soteleyin.\n2. İnce doğranmış domatesleri ekleyin, ezerek suyunu çektirin.\n3. Yumurtaları ve peyniri ekleyip kısık ateşte 3 dakika karıştırın.';
    } else if (items.contains('Tavuk Göğsü') && items.contains('Makarna')) {
      _nameController.text = 'Şefin Kremalı Tavuklu Makarnası';
      _caloriesController.text = '540';
      _stepsController.text =
          '1. Makarnayı bol tuzlu kaynar suda 9 dakika haşlayın.\n2. Tavuk parçalarını sarımsak ve baharatlarla yüksek ateşte soteleyin.\n3. Sosla makarnayı harmanlayıp sıcak servis edin.';
    } else {
      _nameController.text = 'Şefin Özel ${items.first} Tabağı';
      _caloriesController.text = '380';
      _stepsController.text =
          '1. ${items.join(', ')} malzemelerini özenle yıkayıp doğrayın.\n2. Tavada zeytinyağı eşliğinde sırayla soteleyin.\n3. Baharatlarını ekleyip 10 dakika dinlendirerek servis yapın.';
    }
    setState(() {});
  }

  /// 04.2. Masterchef Üretim Algoritması & Firestore Kaydı
  Future<void> _onCreateRecipe() async {
    final name = _nameController.text.trim();
    final calories = int.tryParse(_caloriesController.text.trim()) ?? 350;
    final steps = _stepsController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen yemeğinize bir isim verin.')),
      );
      return;
    }

    if (_selectedIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen en az bir malzeme seçin.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final newChefRecipe = ChefRecipeModel(
      id: const Uuid().v4(),
      userId: 'default_user',
      name: name,
      ingredients: _selectedIngredients.toList(),
      calories: calories,
      steps: steps.isNotEmpty
          ? steps
          : '1. Tüm malzemeleri özenle hazırlayın.\n2. Tavada pişirip sıcak servis edin.',
      createdAt: DateTime.now(),
    );

    final db = ref.read(databaseServiceProvider);
    await db.addChefRecipe(newChefRecipe);

    // Riverpod Stream Provider'larını yeniden tetikle
    ref.invalidate(chefRecipesStreamProvider('default_user'));
    ref.invalidate(recipesStreamProvider);

    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tebrikler! "$name" Masterchef Menüsü\'ne eklendi.'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.restaurant_rounded, color: AppColors.primary, size: 22),
            SizedBox(width: 8),
            Text('Masterchef Atölyesi'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kendi Tarifini Yarat!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Dolabındaki malzemeleri seç, adımları yaz ve kendi özel şef menünü oluştur.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Step 1: Ingredient Selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1. Malzemelerini Seç (${_selectedIngredients.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.auto_fix_high, size: 16),
                    label: const Text('Akıllı Taslak', style: TextStyle(fontSize: 12)),
                    onPressed: _generateSmartChefDraft,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.availableIngredients.map((item) {
                  final isSelected = _selectedIngredients.contains(item);
                  return FilterChip(
                    label: Text(item),
                    selected: isSelected,
                    selectedColor: AppColors.primaryLight.withValues(alpha: 0.3),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                      ),
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedIngredients.add(item);
                        } else {
                          _selectedIngredients.remove(item);
                        }
                      });
                      _generateSmartChefDraft();
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Step 2: Recipe Name & Calories
              const Text(
                '2. Tarif Bilgileri',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _nameController,
                label: 'Tarifinizin Adı',
                hint: 'Örn: Şef Usulü Tavuklu Penne',
                prefixIcon: Icons.menu_book_rounded,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _caloriesController,
                label: 'Tahmini Kalori (kcal)',
                hint: 'Örn: 420',
                prefixIcon: Icons.local_fire_department_rounded,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Step 3: Preparation Steps
              const Text(
                '3. Hazırlanış ve Pişirme Adımları',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _stepsController,
                label: 'Adım Adım Tarif',
                hint: '1. Tavayı ısıtıp zeytinyağını ekleyin...\n2. Malzemeleri soteleyin...\n3. 15 dakika kısık ateşte pişirin.',
                maxLines: 5,
                prefixIcon: Icons.format_list_numbered_rounded,
              ),
              const SizedBox(height: 32),

              // Submit Button
              CustomButton(
                text: _isSaving ? 'Menüye Ekleniyor...' : 'Yemeği Üret & Şef Menüme Kaydet',
                icon: Icons.auto_awesome,
                isLoading: _isSaving,
                backgroundColor: AppColors.primary,
                onPressed: _onCreateRecipe,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
