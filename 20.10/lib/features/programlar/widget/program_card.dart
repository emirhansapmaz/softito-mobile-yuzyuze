import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/program_model.dart';
import 'application_steps_modal.dart';
import 'program_status_badge.dart';

/// Yörünge Platformu - Destek Programı Kartı.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ProgramCard extends StatelessWidget {
  final ProgramModel program;
  final VoidCallback onAddToCalendar;

  const ProgramCard({
    super.key,
    required this.program,
    required this.onAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      margin: AppSpacing.paddingVerticalSm,
      onTap: () => _openStepsModal(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProgramCardHeader(program: program),
          AppSpacing.gapH8,
          Text(program.description,
              style: context.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
          AppSpacing.gapH12,
          _ProgramCardFooter(
            deadline: program.deadline,
            onAddToCalendar: onAddToCalendar,
          ),
        ],
      ),
    );
  }

  void _openStepsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ApplicationStepsModal(program: program),
    );
  }
}

class _ProgramCardHeader extends StatelessWidget {
  final ProgramModel program;

  const _ProgramCardHeader({required this.program});

  @override
  Widget build(BuildContext context) {
    final texts = context.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(program.provider, style: texts.labelLarge),
              AppSpacing.gapH4,
              Text(program.title, style: texts.titleMedium),
            ],
          ),
        ),
        AppSpacing.gapW8,
        ProgramStatusBadge(status: program.status),
      ],
    );
  }
}

class _ProgramCardFooter extends StatelessWidget {
  final DateTime deadline;
  final VoidCallback onAddToCalendar;

  const _ProgramCardFooter({
    required this.deadline,
    required this.onAddToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;
    final formattedDate = '${deadline.day}.${deadline.month}.${deadline.year}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.event_outlined, size: 16, color: colors.secondary),
            AppSpacing.gapW4,
            Text('Son Tarih: $formattedDate', style: texts.bodyMedium),
          ],
        ),
        IconButton(
          tooltip: 'Takvime Ekle',
          icon: Icon(Icons.calendar_month_rounded, color: colors.primary),
          onPressed: onAddToCalendar,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
