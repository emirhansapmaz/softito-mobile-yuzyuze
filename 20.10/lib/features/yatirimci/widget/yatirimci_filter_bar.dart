import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Yörünge Platformu - Yatırımcı Modülü Çift Filtre Çubuğu (Tür & Aşama).
/// 2. Kural: Renkler ve stiller context uzantılarından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class YatirimciFilterBar extends StatelessWidget {
  final List<String> types;
  final String selectedType;
  final ValueChanged<String> onSelectType;
  final List<String> stages;
  final String selectedStage;
  final ValueChanged<String> onSelectStage;

  const YatirimciFilterBar({
    super.key,
    required this.types,
    required this.selectedType,
    required this.onSelectType,
    required this.stages,
    required this.selectedStage,
    required this.onSelectStage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FilterChipRow(
          title: 'Tür:',
          items: types,
          selectedItem: selectedType,
          onSelect: onSelectType,
        ),
        AppSpacing.gapH8,
        _FilterChipRow(
          title: 'Aşama:',
          items: stages,
          selectedItem: selectedStage,
          onSelect: onSelectStage,
        ),
      ],
    );
  }
}

class _FilterChipRow extends StatelessWidget {
  final String title;
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onSelect;

  const _FilterChipRow({
    required this.title,
    required this.items,
    required this.selectedItem,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.paddingHorizontalMd,
        itemCount: items.length + 1,
        separatorBuilder: (context, index) => AppSpacing.gapW8,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Center(
              child: Text(title, style: context.textTheme.labelLarge),
            );
          }
          final item = items[index - 1];
          final isSelected = item == selectedItem;
          return _InteractiveChip(
            label: item,
            isSelected: isSelected,
            onTap: () => onSelect(item),
          );
        },
      ),
    );
  }
}

class _InteractiveChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _InteractiveChip({
    required this.label,
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
        label,
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
