import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/program_model.dart';

/// Destek programı başvuru durumu rozeti.
/// 2. Kural: Renkler `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ProgramStatusBadge extends StatelessWidget {
  final ProgramStatus status;

  const ProgramStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    final (color, label) = switch (status) {
      ProgramStatus.open => (colors.success, 'Başvuru Açık'),
      ProgramStatus.upcoming => (colors.warning, 'Pek Yakında'),
      ProgramStatus.closed => (colors.textSecondary, 'Sona Erdi'),
    };

    return Container(
      padding: AppSpacing.paddingHorizontalSm + const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: texts.labelLarge?.copyWith(color: color),
      ),
    );
  }
}
