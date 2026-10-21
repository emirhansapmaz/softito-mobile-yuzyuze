import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/recipe_model.dart';
import '../../../core/providers/database_provider.dart';
import '../../../core/theme/app_colors.dart';

class RecipeDetailScreen extends ConsumerStatefulWidget {
  final RecipeModel recipe;

  const RecipeDetailScreen({
    super.key,
    required this.recipe,
  });

  @override
  ConsumerState<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends ConsumerState<RecipeDetailScreen> {
  bool _isFavorite = false;
  bool _isLoadingFav = true;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final db = ref.read(databaseServiceProvider);
    final fav = await db.isFavorite('default_user', widget.recipe.id);
    if (!mounted) return;
    setState(() {
      _isFavorite = fav;
      _isLoadingFav = false;
    });
  }

  Future<void> _toggleFavorite() async {
    final db = ref.read(databaseServiceProvider);
    final isNowFav = await db.toggleFavorite('default_user', widget.recipe.id);
    if (!mounted) return;
    setState(() {
      _isFavorite = isNowFav;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isNowFav
              ? '${widget.recipe.name} favorilerinize eklendi!'
              : '${widget.recipe.name} favorilerden çıkarıldı.',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  /// 'Yanında iyi gider' eşleştirme algoritması
  List<Map<String, dynamic>> _getPairingRecommendations(RecipeModel recipe) {
    final name = recipe.name.toLowerCase();
    if (name.contains('çorba') || name.contains('mercimek')) {
      return [
        {'name': 'Kıtır Ekmek / Kruton', 'icon': Icons.bakery_dining_rounded, 'desc': 'Fırınlanmış baharatlı küp ekmekler'},
        {'name': 'Taze Sıkılmış Limon', 'icon': Icons.eco_rounded, 'desc': 'Asiditesiyle çorbanın lezzetini katlar'},
        {'name': 'Közlenmiş Acı Biber', 'icon': Icons.local_fire_department, 'desc': 'Hafif acı dokunuşuyla mükemmel uyum'},
      ];
    } else if (name.contains('mantı') || name.contains('makarna')) {
      return [
        {'name': 'Naneli Yayık Ayranı', 'icon': Icons.local_drink_rounded, 'desc': 'Buz gibi ferahlatıcı geleneksel tat'},
        {'name': 'Mevsim Çoban Salatası', 'icon': Icons.dinner_dining_rounded, 'desc': 'Taze domates ve salatalık ferahlığı'},
        {'name': 'Kızgın Tereyağı & Sumak', 'icon': Icons.flare_rounded, 'desc': 'Karakteristik ekstra sos dokunuşu'},
      ];
    } else if (name.contains('somon') || name.contains('balık')) {
      return [
        {'name': 'Roka & Kırmızı Soğan Salatası', 'icon': Icons.spa_rounded, 'desc': 'Somonun yağ dengesini mükemmel ayarlar'},
        {'name': 'Buharda Sebze Tabağı', 'icon': Icons.grass_rounded, 'desc': 'Havuç, brokoli ve taze limon dilimleri'},
        {'name': 'Fırında Elma Dilim Patates', 'icon': Icons.lunch_dining_rounded, 'desc': 'Kekikli çıtır lezzet'},
      ];
    } else {
      return [
        {'name': 'Naneli Ev Cacığı', 'icon': Icons.local_cafe_rounded, 'desc': 'Süzme yoğurt ve kıtır salatalık ferahlığı'},
        {'name': 'Tane Tane Tereyağlı Pilav', 'icon': Icons.rice_bowl_rounded, 'desc': 'Yemeğin doyurucu ve klasik tamamlayıcısı'},
        {'name': 'Mevsim Yeşillikleri', 'icon': Icons.eco_rounded, 'desc': 'Zeytinyağı ve limon soslu taze yeşillikler'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pairings = _getPairingRecommendations(recipe);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Large Image & Real Database Favorite Action
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    shape: BoxShape.circle,
                  ),
                  child: _isLoadingFav
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          _isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorite ? Colors.redAccent : Colors.white,
                          size: 20,
                        ),
                ),
                onPressed: _toggleFavorite,
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'recipe_image_${recipe.id}',
                    child: CachedNetworkImage(
                      imageUrl: recipe.imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[700],
                        child: const Icon(Icons.restaurant,
                            size: 60, color: Colors.white),
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.5),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.local_fire_department,
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                '${recipe.calories} Kalori',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Details Body
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    'Tarif Açıklaması',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Ingredients Section
                  Text(
                    'Malzemeler (${recipe.ingredients.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: recipe.ingredients.map((item) {
                      return Chip(
                        avatar: const CircleAvatar(
                          backgroundColor: AppColors.primaryLight,
                          radius: 10,
                          child: Icon(Icons.check, size: 12, color: Colors.white),
                        ),
                        label: Text(
                          item,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 13),
                        ),
                        backgroundColor: isDark
                            ? AppColors.cardDark
                            : AppColors.backgroundLight,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // Servis Önerisi Kartı
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.room_service_rounded,
                                color: AppColors.primary, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Servis Önerisi',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.servingSuggestion.isNotEmpty
                              ? recipe.servingSuggestion
                              : 'Taze ve sıcak servis edilmesi önerilir.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 'YANINDA İYİ GİDER' EŞLEŞTİRME VE TAVSİYELERİ
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: AppColors.accent.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.wine_bar_rounded,
                                color: AppColors.accent, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Yanında İyi Gider Eşleştirmesi',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          recipe.pairsWellWith.isNotEmpty
                              ? recipe.pairsWellWith
                              : 'Yanında taze sıkılmış mevsim içecekleri önerilir.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Divider(height: 24),
                        const Text(
                          'Tamamlayıcı Şef Önerileri:',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Tamamlayıcı mini kartlar
                        ...pairings.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(item['icon'] as IconData,
                                      size: 16, color: AppColors.accent),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] as String,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                      Text(
                                        item['desc'] as String,
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: isDark
                                              ? AppColors.textSecondaryDark
                                              : AppColors.textSecondaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
