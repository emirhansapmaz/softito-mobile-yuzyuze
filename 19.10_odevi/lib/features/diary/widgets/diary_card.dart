import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../models/diary_model.dart';

/// monolog uygulaması için lüks, derinlikli ve modern günlük kartı.
class DiaryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const DiaryCard({
    super.key,
    required this.entry,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final moodColor = _getMoodColor(entry.mood);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : const Color(0xFF4A3B32).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sol Taraftaki Ruh Hali Vurgu Çizgisi (Vibrant Accent Strip)
              Container(
                width: 5.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      moodColor,
                      moodColor.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),

              // Kart Ana İçeriği
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Üst Bilgi Satırı: Saat, Okuma Süresi ve Ruh Hali Rozeti
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.05)
                                      : Colors.black.withValues(alpha: 0.03),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_filled_rounded,
                                      size: 13,
                                      color: isDark
                                          ? AppColors.darkPrimary
                                          : AppColors.lightPrimary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      entry.timeString,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: isDark
                                            ? AppColors.darkTextPrimary
                                            : AppColors.lightTextPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•  ${_calculateReadingTime(entry.content)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),

                          // Ruh Hali (Mood) Rozeti
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4.5),
                            decoration: BoxDecoration(
                              color: moodColor.withValues(alpha: isDark ? 0.18 : 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: moodColor.withValues(alpha: isDark ? 0.4 : 0.25),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  entry.moodEmoji,
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  entry.moodLabel,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : moodColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Başlık (varsa)
                      if (entry.title.isNotEmpty) ...[
                        Text(
                          entry.title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                      ],

                      // İçerik Özeti (2-3 satır)
                      Text(
                        entry.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5,
                          height: 1.55,
                          fontWeight: FontWeight.w400,
                          color: isDark
                              ? AppColors.darkTextPrimary.withValues(alpha: 0.88)
                              : AppColors.lightTextPrimary.withValues(alpha: 0.88),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Alt Aksiyon Çubuğu
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            entry.dateString,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextSecondary.withValues(alpha: 0.7)
                                  : AppColors.lightTextSecondary.withValues(alpha: 0.8),
                            ),
                          ),
                        Row(
                          children: [
                            if (onEdit != null)
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: onEdit,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 15,
                                        color: isDark
                                            ? AppColors.darkPrimary
                                            : AppColors.lightPrimary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Düzenle',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? AppColors.darkPrimary
                                              : AppColors.lightPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (onEdit != null && onDelete != null)
                              const SizedBox(width: 6),
                            if (onDelete != null)
                              InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: onDelete,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 3),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline_rounded,
                                        size: 15,
                                        color: isDark
                                            ? AppColors.darkTextSecondary
                                            : AppColors.lightTextSecondary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Sil',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: isDark
                                              ? AppColors.darkTextSecondary
                                              : AppColors.lightTextSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'happy':
        return AppColors.moodHappy;
      case 'peaceful':
        return AppColors.moodPeaceful;
      case 'calm':
        return AppColors.moodCalm;
      case 'inspired':
        return AppColors.moodInspired;
      case 'melancholic':
        return AppColors.moodMelancholic;
      case 'energetic':
        return AppColors.moodEnergetic;
      default:
        return AppColors.lightPrimary;
    }
  }

  String _calculateReadingTime(String text) {
    final words = text.trim().split(RegExp(r'\s+')).length;
    if (words <= 30) return '1 dk okuma';
    final minutes = (words / 130).ceil();
    return '$minutes dk okuma';
  }
}
