import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../controllers/diary_controller.dart';
import '../models/diary_model.dart';

/// monolog uygulaması için hem yeni ekleme hem de düzenleme destekli şık Bottom Sheet.
class AddDiarySheet extends StatefulWidget {
  final DateTime targetDate;
  final DiaryEntry? initialEntry;
  final ValueChanged<DiaryEntry> onSave;

  const AddDiarySheet({
    super.key,
    required this.targetDate,
    this.initialEntry,
    required this.onSave,
  });

  static Future<void> show({
    required BuildContext context,
    required DateTime targetDate,
    DiaryEntry? initialEntry,
    required ValueChanged<DiaryEntry> onSave,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AddDiarySheet(
        targetDate: targetDate,
        initialEntry: initialEntry,
        onSave: onSave,
      ),
    );
  }

  @override
  State<AddDiarySheet> createState() => _AddDiarySheetState();
}

class _AddDiarySheetState extends State<AddDiarySheet> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  String _selectedMood = 'peaceful';
  String? _errorMessage;

  bool get _isEditing => widget.initialEntry != null;

  final List<Map<String, dynamic>> _moodOptions = const [
    {'mood': 'happy', 'emoji': '😊', 'label': 'Mutlu', 'color': AppColors.moodHappy},
    {'mood': 'peaceful', 'emoji': '🌿', 'label': 'Huzurlu', 'color': AppColors.moodPeaceful},
    {'mood': 'calm', 'emoji': '☕', 'label': 'Sakin', 'color': AppColors.moodCalm},
    {'mood': 'inspired', 'emoji': '✨', 'label': 'İlham', 'color': AppColors.moodInspired},
    {'mood': 'melancholic', 'emoji': '🌧️', 'label': 'Dalgın', 'color': AppColors.moodMelancholic},
    {'mood': 'energetic', 'emoji': '⚡', 'label': 'Enerjik', 'color': AppColors.moodEnergetic},
  ];

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialEntry?.title ?? '');
    _contentController =
        TextEditingController(text: widget.initialEntry?.content ?? '');
    _selectedMood = widget.initialEntry?.mood ?? 'peaceful';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submit() {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      setState(() {
        _errorMessage = 'Lütfen günlüğün için birkaç satır bir şey yaz.';
      });
      return;
    }

    final now = DateTime.now();
    final timeString =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    final entry = _isEditing
        ? widget.initialEntry!.copyWith(
            title: _titleController.text.trim(),
            content: content,
            mood: _selectedMood,
          )
        : DiaryEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            content: content,
            dateString: DiaryController.formatDateKey(widget.targetDate),
            timeString: timeString,
            mood: _selectedMood,
          );

    widget.onSave(entry);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final keyboardPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + keyboardPadding),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sürükleme Tutamacı
            Center(
              child: Container(
                width: 44,
                height: 4.5,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            // Başlık & Tarih Etiketi
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEditing ? 'Memonoloğu Düzenle' : 'Günün Memonoloğu',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Icon(
                            Icons.edit_calendar_rounded,
                            size: 13,
                            color: isDark
                                ? AppColors.darkPrimary
                                : AppColors.lightPrimary,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '${widget.targetDate.day}.${widget.targetDate.month}.${widget.targetDate.year} tarihli kayıt',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Ruh Hali Seçici (Mood Selector)
            Text(
              'Ruh Halini Seç',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _moodOptions.map((opt) {
                  final isSelected = _selectedMood == opt['mood'];
                  final Color moodColor = opt['color'] as Color;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedMood = opt['mood'] as String;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? moodColor.withValues(alpha: isDark ? 0.25 : 0.15)
                              : (isDark
                                  ? AppColors.darkCardBackground
                                  : AppColors.lightBackground),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? moodColor
                                : (isDark
                                    ? AppColors.darkBorder
                                    : AppColors.lightBorder),
                            width: isSelected ? 1.5 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: moodColor.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(opt['emoji'] as String,
                                style: const TextStyle(fontSize: 15)),
                            const SizedBox(width: 6),
                            Text(
                              opt['label'] as String,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isSelected
                                    ? (isDark ? Colors.white : moodColor)
                                    : (isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 18),

            // Başlık Alanı
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Başlık (İsteğe bağlı)...',
                prefixIcon: Icon(Icons.title_rounded, size: 20),
              ),
            ),

            const SizedBox(height: 14),

            // İçerik Alanı
            TextField(
              controller: _contentController,
              maxLines: 6,
              minLines: 3,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) {
                if (_errorMessage != null) {
                  setState(() {
                    _errorMessage = null;
                  });
                }
              },
              decoration: InputDecoration(
                hintText: 'Zihnindeki düşünceleri, hislerini buraya dök...',
                errorText: _errorMessage,
              ),
            ),

            const SizedBox(height: 22),

            // Kaydet / Güncelle Butonu (Modern Degrade)
            InkWell(
              onTap: _submit,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkPrimaryGradient
                      : AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark
                              ? AppColors.darkPrimary
                              : AppColors.lightPrimary)
                          .withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _isEditing ? 'Değişiklikleri Kaydet' : 'Memonoloğu Kaydet',
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
