import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Yörünge Platformu - Sektör Filtreleme Çipleri.
/// 2. Kural: Renkler `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class SectorFilterList extends StatelessWidget {
  final List<String> sectors;
  final String selectedSector;
  final ValueChanged<String> onSelectSector;

  const SectorFilterList({
    super.key,
    required this.sectors,
    required this.selectedSector,
    required this.onSelectSector,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.paddingHorizontalMd,
        itemCount: sectors.length,
        separatorBuilder: (context, index) => AppSpacing.gapW8,
        itemBuilder: (context, index) {
          final sector = sectors[index];
          final isSelected = sector == selectedSector;
          return _SectorChip(
            title: sector,
            isSelected: isSelected,
            onTap: () => onSelectSector(sector),
          );
        },
      ),
    );
  }
}

class _SectorChip extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _SectorChip({
    required this.title,
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
        title,
        style: isSelected
            ? texts.labelLarge?.copyWith(color: Colors.black)
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
