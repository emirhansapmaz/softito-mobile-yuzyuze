import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/recipe_card.dart';
import '../../recipe_detail/presentation/recipe_detail_screen.dart';
import 'app_settings_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _clocheController;
  late Animation<double> _shakeAnimation;
  late Animation<double> _liftAnimation;

  bool _isChoosing = false;
  RecipeModel? _revealedRecipe;
  String _selectedCategory = 'Tümü';

  @override
  void initState() {
    super.initState();
    _clocheController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // Titreme (Shake / Wobble) Animasyonu: 0% -> 60%
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.15), weight: 15),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.15), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: -0.12), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.10), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.10, end: 0.0), weight: 25),
    ]).animate(
      CurvedAnimation(
        parent: _clocheController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    // Kubbenin Yukarı Kalkması (Lift / Open): 60% -> 100%
    _liftAnimation = Tween<double>(begin: 0.0, end: -70.0).animate(
      CurvedAnimation(
        parent: _clocheController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
      ),
    );

    _clocheController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_revealedRecipe != null) {
          _showRevealedRecipeDialog(_revealedRecipe!);
        }
      }
    });
  }

  @override
  void dispose() {
    _clocheController.dispose();
    super.dispose();
  }

  /// 04.1. Gümüş Kubbe ve Rastgele Yemek Seçimi Algoritması
  Future<void> _handleLuckySelection() async {
    if (_isChoosing) return;

    setState(() {
      _isChoosing = true;
      _revealedRecipe = null;
    });

    _clocheController.reset();
    _clocheController.forward();

    try {
      final db = ref.read(databaseServiceProvider);
      // Firestore veya seed listesinden rastgele yemek çekilir
      final randomRecipe = await db.getRandomRecipe();
      if (!mounted) return;

      setState(() {
        _revealedRecipe = randomRecipe;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isChoosing = false);
    }
  }

  void _showRevealedRecipeDialog(RecipeModel recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Şanslı Menünüz Belli Oldu!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              RecipeCard(
                recipe: recipe,
                isFavorite: false,
                onTap: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: 'Tarifi Hemen İncele',
                icon: Icons.restaurant_menu_rounded,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(recipe: recipe),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    ).whenComplete(() {
      if (mounted) {
        setState(() {
          _isChoosing = false;
        });
        _clocheController.reset();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recipesAsync = ref.watch(recipesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.soup_kitchen_rounded,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 10),
            const Text(
              AppConstants.appName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          // 1. Hızlı Tema Değiştirme Butonu (Çalışan Dinamik Toggle)
          IconButton(
            tooltip: isDark ? 'Açık Temaya Geç' : 'Koyu Temaya Geç',
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              color: isDark ? Colors.amber : AppColors.primary,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
          ),
          // 2. Uygulama Ayarları Ekranı Butonu
          IconButton(
            tooltip: 'Uygulama Ayarları',
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AppSettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GÜMÜŞ SERVİS KUBBESİ (SILVER CLOCHE) ALANI
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1E2822), const Color(0xFF2E3D33)]
                      : [const Color(0xFFE8F0EA), const Color(0xFFF3F7F4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // LOTTIE & ANIMATED CLOCHE INTERACTION
                  SizedBox(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Tabak / Alt Sunum Tepsisi
                        Positioned(
                          bottom: 12,
                          child: Container(
                            width: 190,
                            height: 14,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFCFD8DC), Color(0xFFECEFF1), Color(0xFF90A4AE)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Altında beliren Sürpriz Yemek İkonu & Parıltısı
                        if (_isChoosing)
                          Positioned(
                            bottom: 24,
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _clocheController.value > 0.5 ? 1.0 : 0.0,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.restaurant_menu_rounded,
                                    size: 42,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _revealedRecipe?.name ?? 'Lezzet Hazırlanıyor...',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColors.primaryDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Gümüş Kubbe: Titreme & Açılma (Lift) Efekti
                        AnimatedBuilder(
                          animation: _clocheController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _liftAnimation.value),
                              child: Transform.rotate(
                                angle: _shakeAnimation.value,
                                child: Container(
                                  width: 150,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    gradient: const RadialGradient(
                                      colors: [
                                        Color(0xFFFFFFFF), // Parlama
                                        Color(0xFFCFD8DC), // Gümüş gövde
                                        Color(0xFF78909C), // Metalik derinlik
                                      ],
                                      center: Alignment(-0.2, -0.3),
                                      radius: 0.85,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.25),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // Tutacak
                                      Positioned(
                                        top: 10,
                                        child: Container(
                                          width: 26,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFECEFF1),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.blueGrey.shade300),
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.dinner_dining_rounded,
                                        size: 52,
                                        color: Color(0xFF37474F),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Text(
                    'Bugün Ne Yiyeceğine Karar Veremedin mi?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isChoosing
                        ? 'Gümüş kubbe açılıyor, günün lezzeti seçiliyor...'
                        : 'Gümüş servis kubbesini kaldır, günün leziz sürprizini hemen keşfet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: _isChoosing ? 'Kubbe Açılıyor...' : 'Kendimi Şanslı Hissediyorum',
                    icon: Icons.casino_rounded,
                    isLoading: _isChoosing,
                    backgroundColor: AppColors.primary,
                    onPressed: _handleLuckySelection,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Popüler & Öne Çıkan Lezzetler Listesi & Filtreler
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Öne Çıkan Tarifler',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '15 Tarif',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Kategori Filtre Butonları (Düşük Kalorili, Bütçe Dostu, Pratik)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  'Tümü',
                  'Masterchef',
                  'Düşük Kalorili',
                  'Bütçe Dostu',
                  'Pratik',
                  'Geleneksel',
                ].map((category) {
                  final isSelected = _selectedCategory == category;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? Colors.white70 : Colors.black87),
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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
                          _selectedCategory = category;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            recipesAsync.when(
              data: (recipes) {
                final displayRecipes = recipes.where((r) {
                  if (_selectedCategory == 'Tümü') return true;
                  return r.category.toLowerCase() ==
                      _selectedCategory.toLowerCase();
                }).toList();

                if (displayRecipes.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Bu kategoride henüz tarif bulunmuyor.',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  children: displayRecipes.map((recipe) {
                    return RecipeCard(
                      recipe: recipe,
                      isFavorite: false,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                      onFavoriteTap: () async {
                        final db = ref.read(databaseServiceProvider);
                        final isNowFav =
                            await db.toggleFavorite('default_user', recipe.id);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isNowFav
                                  ? '${recipe.name} favorilere eklendi!'
                                  : '${recipe.name} favorilerden çıkarıldı.',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (err, stack) => Center(
                child: Text('Tarifler yüklenirken hata: $err'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
