import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/diary_controller.dart';
import 'month_calendar_dialog.dart';

/// Ultra modern, cam efektli (frosted/elevated) haftalık takvim kapsülü.
class DiaryCalendarBar extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool Function(DateTime date) hasEntriesOn;

  const DiaryCalendarBar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.hasEntriesOn,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final weekStart = _findWeekStart(selectedDate);
    final weekDays = List.generate(7, (index) => weekStart.add(Duration(days: index)));

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF4A3B32).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ay, Yıl & Hızlı Navigasyon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tıklanabilir Ay/Yıl Başlığı (Aylık Takvim Penceresini Açar)
              InkWell(
                onTap: () {
                  MonthCalendarDialog.show(
                    context: context,
                    initialDate: selectedDate,
                    onDateSelected: onDateSelected,
                    hasEntriesOn: hasEntriesOn,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: (isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.calendar_month_rounded,
                          size: 16,
                          color: isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatMonthYear(selectedDate),
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  // Bugün Rozeti
                  if (!DiaryController.isSameDay(selectedDate, DateTime.now()))
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: InkWell(
                        onTap: () => onDateSelected(DateTime.now()),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 11, vertical: 4.5),
                          decoration: BoxDecoration(
                            gradient: isDark
                                ? AppColors.darkPrimaryGradient
                                : AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Bugün',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Önceki Hafta Butonu
                  _NavIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    tooltip: 'Önceki Hafta',
                    isDark: isDark,
                    onTap: () => onDateSelected(
                        selectedDate.subtract(const Duration(days: 7))),
                  ),
                  const SizedBox(width: 4),
                  // Sonraki Hafta Butonu
                  _NavIconButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    tooltip: 'Sonraki Hafta',
                    isDark: isDark,
                    onTap: () =>
                        onDateSelected(selectedDate.add(const Duration(days: 7))),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 7 Günlük Kapsül Dizilimi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: weekDays.map((day) {
              final isSelected = DiaryController.isSameDay(day, selectedDate);
              final isToday = DiaryController.isSameDay(day, DateTime.now());
              final hasEntries = hasEntriesOn(day);

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                  child: _ModernDayCapsule(
                    date: day,
                    isSelected: isSelected,
                    isToday: isToday,
                    hasEntries: hasEntries,
                    onTap: () => onDateSelected(day),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  DateTime _findWeekStart(DateTime date) {
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: date.weekday - 1));
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      '',
      'Ocak',
      'Şubat',
      'Mart',
      'Nisan',
      'Mayıs',
      'Haziran',
      'Temmuz',
      'Ağustos',
      'Eylül',
      'Ekim',
      'Kasım',
      'Aralık'
    ];
    return '${months[date.month]} ${date.year}';
  }
}

class _NavIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final bool isDark;
  final VoidCallback onTap;

  const _NavIconButton({
    required this.icon,
    required this.tooltip,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.black.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 13,
          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        ),
      ),
    );
  }
}

class _ModernDayCapsule extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final bool isToday;
  final bool hasEntries;
  final VoidCallback onTap;

  const _ModernDayCapsule({
    required this.date,
    required this.isSelected,
    required this.isToday,
    required this.hasEntries,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    const weekdays = ['', 'Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];
    final weekdayName = weekdays[date.weekday];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? (isDark
                  ? AppColors.darkPrimaryGradient
                  : AppColors.primaryGradient)
              : null,
          color: isSelected
              ? null
              : isToday
                  ? (isDark
                      ? AppColors.darkPrimary.withValues(alpha: 0.12)
                      : AppColors.lightPrimary.withValues(alpha: 0.08))
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : isToday
                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                        .withValues(alpha: 0.45)
                    : Colors.transparent,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (isDark
                            ? AppColors.darkPrimary
                            : AppColors.lightPrimary)
                        .withValues(alpha: 0.28),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weekdayName,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.9)
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${date.day}',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: isSelected || isToday
                    ? FontWeight.w800
                    : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary),
              ),
            ),
            const SizedBox(height: 4),
            // Parlayan indikatör noktası
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasEntries
                    ? (isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkAccent
                            : AppColors.lightPrimary))
                    : Colors.transparent,
                boxShadow: hasEntries && isSelected
                    ? [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.8),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
