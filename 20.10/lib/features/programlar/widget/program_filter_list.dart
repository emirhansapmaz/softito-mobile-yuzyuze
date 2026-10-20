import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Destek programları kategorilerini yatayda listeleyen filtre çubuğu.
/// 2. Kural: Renk ve stil context uzantılarından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ProgramFilterList extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelectCategory;

  const ProgramFilterList({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.paddingHorizontalMd,
        itemCount: categories.length,
        separatorBuilder: (context, index) => AppSpacing.gapW8,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return _CategoryChip(
            category: category,
            isSelected: isSelected,
            onTap: () => onSelectCategory(category),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return ActionChip(
      onPressed: onTap,
      label: Text(
        category,
        style: isSelected
            ? texts.bodyMedium?.copyWith(color: Colors.black)
            : texts.bodyMedium,
      ),
      backgroundColor: isSelected ? colors.primary : colors.cardBackground,
      side: BorderSide(
        color: isSelected ? colors.primary : colors.border,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
    );
  }
}
