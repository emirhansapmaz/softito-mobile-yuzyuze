import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../models/habit_model.dart';
import '../../models/habit_log_model.dart';
import '../../services/firebase/habit_service.dart';
import '../../widgets/dialogs/streak_celebration_dialog.dart';
import '../../widgets/habit_card.dart';
import '../habits/add_habit_bottom_sheet.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _habitService = HabitService();
  final String _currentUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> _handleToggleHabit(HabitModel habit, bool isCompleted, List<HabitLogModel> todayLogs) async {
    if (isCompleted) {
      // Tamamlanmayı geri al
      final log = todayLogs.firstWhere((l) => l.habitId == habit.habitId);
      await _habitService.uncompleteHabit(habit, log.logId);
    } else {
      // Görevi tamamla ve streak'i artır
      final newStreak = await _habitService.completeHabit(habit);
      if (!mounted) return;

      // Soft Renkli Motivasyon Pop-up'ını Göster
      StreakCelebrationDialog.show(
        context,
        habitTitle: habit.baslik,
        streakCount: newStreak,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final todayFormatted = DateFormat('d MMMM EEEE', 'tr_TR').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Günün Görevleri'),
            Text(
              todayFormatted,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded),
            tooltip: 'Yeni Alışkanlık',
            onPressed: () {
              if (_currentUid.isNotEmpty) {
                AddHabitBottomSheet.show(context, uid: _currentUid);
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<HabitModel>>(
        stream: _habitService.getHabitsStream(_currentUid),
        builder: (context, habitsSnapshot) {
          if (habitsSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final habits = habitsSnapshot.data ?? [];

          if (habits.isEmpty) {
            return _buildEmptyState(context, isDark);
          }

          return StreamBuilder<List<HabitLogModel>>(
            stream: _habitService.getTodayLogsStream(),
            builder: (context, logsSnapshot) {
              final todayLogs = logsSnapshot.data ?? [];
              final completedHabitIds = todayLogs
                  .where((log) => log.tamamlandiMi)
                  .map((log) => log.habitId)
                  .toSet();

              final pendingHabits = habits
                  .where((h) => !completedHabitIds.contains(h.habitId))
                  .toList();

              final completedHabits = habits
                  .where((h) => completedHabitIds.contains(h.habitId))
                  .toList();

              final int totalCount = habits.length;
              final int completedCount = completedHabits.length;
              final double progress = totalCount > 0 ? (completedCount / totalCount) : 0.0;

              return ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  // İlerleme Özeti Kartı
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Bugünkü İlerlemen',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '$completedCount / $totalCount Tamamlandı',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark ? AppColors.sageGreen : AppColors.deepSage,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: isDark
                                ? AppColors.surfaceVariantDark
                                : AppColors.surfaceVariantLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress == 1.0
                                  ? AppColors.success
                                  : (isDark ? AppColors.sageGreen : AppColors.deepSage),
                            ),
                          ),
                        ),
                        if (progress == 1.0) ...[
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
                              const SizedBox(width: 6),
                              Text(
                                'Harika! Bugünün tüm hedeflerini tamamladın 🎉',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bekleyen Görevler Başlığı
                  if (pendingHabits.isNotEmpty) ...[
                    Text(
                      'Yapılacaklar (${pendingHabits.length})',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...pendingHabits.map((habit) {
                      return HabitCard(
                        habit: habit,
                        isCompleted: false,
                        onToggle: () => _handleToggleHabit(habit, false, todayLogs),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],

                  // Bugün Bitenler Başlığı (Grileşerek alta düşenler)
                  if (completedHabits.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(
                          Icons.done_all_rounded,
                          size: 18,
                          color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Bugün Bitenler (${completedHabits.length})',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...completedHabits.map((habit) {
                      return HabitCard(
                        habit: habit,
                        isCompleted: true,
                        onToggle: () => _handleToggleHabit(habit, true, todayLogs),
                      );
                    }),
                  ],
                ],
              );
            },
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
        label: const Text('Yeni Alışkanlık', style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceVariantDark
                    : AppColors.sageGreen.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.nature_people_rounded,
                size: 46,
                color: isDark ? AppColors.sageGreen : AppColors.deepSage,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Henüz Bir Alışkanlık Eklenmedi',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Günün görevlerini oluşturmak için hemen bir sağlıklı alışkanlık veya bırakmak istediğin bir hedef belirle.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                if (_currentUid.isNotEmpty) {
                  AddHabitBottomSheet.show(context, uid: _currentUid);
                }
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('İlk Alışkanlığını Ekle'),
            ),
          ],
        ),
      ),
    );
  }
}
