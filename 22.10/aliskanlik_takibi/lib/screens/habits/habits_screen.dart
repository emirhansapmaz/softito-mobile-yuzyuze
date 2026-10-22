import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../models/habit_model.dart';
import '../../services/firebase/habit_service.dart';
import '../../widgets/fact_carousel_card.dart';
import 'add_habit_bottom_sheet.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _habitService = HabitService();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete(HabitModel habit) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Alışkanlığı Sil'),
        content: Text('"${habit.baslik}" alışkanlığını silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Vazgeç'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
              minimumSize: const Size(90, 42),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sil'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _habitService.deleteHabit(habit.habitId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alışkanlık başarıyla silindi.'),
          backgroundColor: AppColors.textPrimaryLight,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alışkanlıklarım'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              labelColor: isDark ? AppColors.sageGreen : AppColors.deepSage,
              unselectedLabelColor: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13.5),
              tabs: const [
                Tab(text: 'Sağlıklı Alışkanlıklar'),
                Tab(text: 'Zararlı Bırakma'),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<HabitModel>>(
        stream: _habitService.getHabitsStream(_currentUid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allHabits = snapshot.data ?? [];
          final healthyHabits = allHabits.where((h) => h.tip == HabitType.saglikli).toList();
          final harmfulHabits = allHabits.where((h) => h.tip == HabitType.zararli).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildHealthyTab(context, healthyHabits, isDark),
              _buildHarmfulTab(context, harmfulHabits, isDark),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? AppColors.sageGreen : AppColors.deepSage,
        foregroundColor: isDark ? AppColors.backgroundDark : Colors.white,
        elevation: 2,
        onPressed: () {
          if (_currentUid.isNotEmpty) {
            AddHabitBottomSheet.show(context, uid: _currentUid);
          }
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni Ekle', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // SEKME 1: SAĞLIKLI ALIŞKANLIKLAR LİSTESİ
  // --------------------------------------------------------------------------
  Widget _buildHealthyTab(BuildContext context, List<HabitModel> habits, bool isDark) {
    if (habits.isEmpty) {
      return _buildEmptyTab(
        context: context,
        icon: Icons.spa_rounded,
        title: 'Sağlıklı Alışkanlık Yok',
        description: 'Kitap okuma, su içme veya spor gibi sağlıklı hedefler ekleyerek seriye başla.',
        isDark: isDark,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemCount: habits.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final habit = habits[index];
        return _buildHabitCard(
          context: context,
          habit: habit,
          isDark: isDark,
          isHarmful: false,
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // SEKME 2: ZARARLI ALIŞKANLIKLAR & TASARRUF MODÜLÜ
  // --------------------------------------------------------------------------
  Widget _buildHarmfulTab(BuildContext context, List<HabitModel> habits, bool isDark) {
    // Toplam Tasarruf = Her bir zararlı alışkanlığın toplamTasarruf toplamı
    final double grandTotalSavings = habits.fold(
      0.0,
      (sum, habit) => sum + habit.toplamTasarruf,
    );

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // 03_ana_ekranlar.md: "Tasarruf Gösterimi: (Geçen Gün) x (Günlük Harcama)"
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.surfaceVariantDark, AppColors.surfaceDark]
                  : [
                      AppColors.sageGreen.withValues(alpha: 0.22),
                      AppColors.terracottaSoft.withValues(alpha: 0.12),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark
                  : AppColors.sageGreen.withValues(alpha: 0.35),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.savings_rounded,
                      color: AppColors.deepSage,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Kazanılan Özgürlük ve Tasarruf',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepSage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Şu ana kadar cebinde kalan:',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 4),
              Text(
                '${grandTotalSavings.toStringAsFixed(0)} ₺',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: AppColors.deepSage,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Bıraktığın zararlı alışkanlıkların sayesinde hem sağlığın hem de birikimlerin güvende.',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Zararlı Alışkanlıklar Listesi
        if (habits.isEmpty) ...[
          _buildEmptyTab(
            context: context,
            icon: Icons.smoke_free_rounded,
            title: 'Zararlı Bırakma Hedefi Yok',
            description: 'Sigara, alkol veya fast-food gibi bırakmak istediğin bir hedef ekleyerek tasarrufunu izle.',
            isDark: isDark,
          ),
        ] else ...[
          Text(
            'Bırakma Hedeflerin (${habits.length})',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
          ),
          const SizedBox(height: 12),
          ...habits.map((habit) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildHabitCard(
                  context: context,
                  habit: habit,
                  isDark: isDark,
                  isHarmful: true,
                ),
              )),
        ],

        const SizedBox(height: 16),

        // 03_ana_ekranlar.md: "Rastgele Bilgi Kartı: Sigara/Alkolün Zararları bilimsel gerçekler kutusu"
        const FactCarouselCard(),
        const SizedBox(height: 80), // FAB için boşluk
      ],
    );
  }

  Widget _buildHabitCard({
    required BuildContext context,
    required HabitModel habit,
    required bool isDark,
    required bool isHarmful,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  habit.baslik,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline_rounded,
                  size: 20,
                  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                ),
                onPressed: () => _confirmDelete(habit),
                tooltip: 'Alışkanlığı Sil',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // İstatistik Satırı
          Row(
            children: [
              // Aktif Seri
              _buildStatChip(
                icon: Icons.local_fire_department_rounded,
                iconColor: AppColors.streakFlame,
                label: '${habit.aktifStreak} Gün Seri',
                isDark: isDark,
              ),
              const SizedBox(width: 8),

              // En Uzun Rekor
              _buildStatChip(
                icon: Icons.emoji_events_outlined,
                iconColor: AppColors.warning,
                label: 'Rekor: ${habit.enUzunStreak} Gün',
                isDark: isDark,
              ),

              if (isHarmful && habit.gunlukMaliyet > 0) ...[
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Tasarruf',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                      ),
                    ),
                    Text(
                      '${habit.toplamTasarruf.toStringAsFixed(0)} ₺',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.deepSage,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTab({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 38,
              color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
          ),
        ],
      ),
    );
  }
}
