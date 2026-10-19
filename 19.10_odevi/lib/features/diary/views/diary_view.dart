import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../controllers/diary_controller.dart';
import '../models/diary_model.dart';
import '../widgets/add_diary_sheet.dart';
import '../widgets/diary_calendar_bar.dart';
import '../widgets/diary_card.dart';
import '../widgets/diary_empty_state.dart';
import '../widgets/diary_logo.dart';

/// monolog Ana Ekranı (DiaryView).
/// Instagram tarzı ortalanmış tipografik logoya ve modern akıcı arayüze sahiptir.
class DiaryView extends StatelessWidget {
  final DiaryController _controller;

  DiaryView({
    super.key,
    DiaryController? controller,
  }) : _controller = controller ?? DiaryController();

  void _openAddDiarySheet(BuildContext context) {
    AddDiarySheet.show(
      context: context,
      targetDate: _controller.selectedDate.value,
      onSave: (newEntry) {
        _controller.addEntry(newEntry);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Memonoloğun başarıyla kaydedildi.'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  void _openEditDiarySheet(BuildContext context, DiaryEntry entry) {
    AddDiarySheet.show(
      context: context,
      targetDate: _controller.selectedDate.value,
      initialEntry: entry,
      onSave: (updatedEntry) {
        _controller.updateEntry(updatedEntry);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Memonoloğun başarıyla güncellendi.'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        // Sol Kısım: Seri (Streak) Rozeti
        leadingWidth: 70,
        leading: Center(
          child: Container(
            margin: const EdgeInsets.only(left: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🔥', style: TextStyle(fontSize: 13)),
                SizedBox(width: 3),
                Text(
                  '3',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Instagram Gibi En Üstte Ortalanmış Tipografik Logo (memory + monolog)
        centerTitle: true,
        title: const MemonologLogo(fontSize: 27),

        // Sağ Kısım: Tema Değiştirme Butonu
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.instance.themeModeNotifier,
            builder: (context, themeMode, _) {
              final isDarkModeActive = themeMode == ThemeMode.dark;
              return Container(
                margin: const EdgeInsets.only(right: 16),
                child: InkWell(
                  onTap: () => ThemeController.instance.toggleTheme(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.06)
                          : Colors.black.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isDarkModeActive
                          ? Icons.light_mode_rounded
                          : Icons.dark_mode_rounded,
                      size: 19,
                      color: isDark
                          ? AppColors.darkPrimary
                          : AppColors.lightPrimary,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Üst Kısım: Ultra Modern Haftalık Takvim Şeridi
            ValueListenableBuilder<List<DiaryEntry>>(
              valueListenable: _controller.allEntries,
              builder: (context, allEntries, _) {
                return ValueListenableBuilder<DateTime>(
                  valueListenable: _controller.selectedDate,
                  builder: (context, selectedDate, _) {
                    return DiaryCalendarBar(
                      selectedDate: selectedDate,
                      onDateSelected: _controller.changeDate,
                      hasEntriesOn: _controller.hasEntriesOn,
                    );
                  },
                );
              },
            ),

            // 2. Alt Kısım: Filtrelenmiş Günlük Akışı
            Expanded(
              child: ValueListenableBuilder<List<DiaryEntry>>(
                valueListenable: _controller.filteredEntries,
                builder: (context, entries, _) {
                  if (entries.isEmpty) {
                    return DiaryEmptyState(
                      onAddPressed: () => _openAddDiarySheet(context),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 90),
                    physics: const BouncingScrollPhysics(),
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return DiaryCard(
                        entry: entry,
                        onEdit: () => _openEditDiarySheet(context, entry),
                        onDelete: () {
                          _controller.deleteEntry(entry.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Günlük silindi.'),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // 3. Sağ Alt Köşe: Modern Degrade Dolgulu FAB
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isDark
              ? AppColors.darkPrimaryGradient
              : AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                  .withValues(alpha: 0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _openAddDiarySheet(context),
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Yeni Memonolog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
