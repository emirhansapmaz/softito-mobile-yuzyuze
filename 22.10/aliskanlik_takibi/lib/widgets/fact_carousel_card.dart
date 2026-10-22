import 'dart:async';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/tip_model.dart';
import '../services/firebase/habit_service.dart';

class FactCarouselCard extends StatefulWidget {
  const FactCarouselCard({super.key});

  @override
  State<FactCarouselCard> createState() => _FactCarouselCardState();
}

class _FactCarouselCardState extends State<FactCarouselCard> {
  final _habitService = HabitService();
  int _currentIndex = 0;
  Timer? _timer;
  List<TipModel> _tips = TipModel.defaultTips;

  @override
  void initState() {
    super.initState();
    // 8 saniyede bir otomatik geçiş
    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (_tips.isNotEmpty && mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % _tips.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _nextFact() {
    if (_tips.isEmpty) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % _tips.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return StreamBuilder<List<TipModel>>(
      stream: _habitService.getTipsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _tips = snapshot.data!;
        }
        if (_currentIndex >= _tips.length) _currentIndex = 0;
        final currentTip = _tips[_currentIndex];

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceVariantDark
                : AppColors.sereneBlue.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark
                  : AppColors.sereneBlue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Kısım: İkon, Başlık ve Değiştir Butonu
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.surfaceDark
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lightbulb_outline_rounded,
                      size: 18,
                      color: isDark ? AppColors.sereneBlue : AppColors.deepSage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Biliyor Muydunuz?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.deepSage,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.refresh_rounded,
                      size: 18,
                      color: isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight,
                    ),
                    onPressed: _nextFact,
                    tooltip: 'Başka Bilgi Göster',
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Bilimsel Gerçek Metni
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  currentTip.icerik,
                  key: ValueKey<String>(currentTip.id),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.45,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    fontSize: 13.5,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Gösterge Çizgileri
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_tips.length, (index) {
                  final isActive = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: isActive ? 16 : 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: isActive
                          ? (isDark ? AppColors.sageGreen : AppColors.deepSage)
                          : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}
