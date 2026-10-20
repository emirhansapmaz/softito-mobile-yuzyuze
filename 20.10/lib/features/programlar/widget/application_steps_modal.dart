import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/program_model.dart';

/// Destek programı başvuru adımlarını gösteren alt modal pencere.
/// 2. Kural: Sabit stil ve renk yazılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ApplicationStepsModal extends StatelessWidget {
  final ProgramModel program;

  const ApplicationStepsModal({super.key, required this.program});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return Container(
      padding: AppSpacing.paddingAllMd,
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ModalHeader(program: program),
            AppSpacing.gapH16,
            _StepsList(steps: program.applicationSteps),
            AppSpacing.gapH16,
          ],
        ),
      ),
    );
  }
}

class _ModalHeader extends StatelessWidget {
  final ProgramModel program;

  const _ModalHeader({required this.program});

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
        IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _StepsList extends StatelessWidget {
  final List<String> steps;

  const _StepsList({required this.steps});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      separatorBuilder: (context, index) => AppSpacing.gapH12,
      itemBuilder: (context, index) {
        return _StepItem(
          stepIndex: index + 1,
          description: steps[index],
        );
      },
    );
  }
}

class _StepItem extends StatelessWidget {
  final int stepIndex;
  final String description;

  const _StepItem({required this.stepIndex, required this.description});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: colors.primary.withValues(alpha: 0.2),
          child: Text(
            '$stepIndex',
            style: texts.labelLarge?.copyWith(fontSize: 11),
          ),
        ),
        AppSpacing.gapW12,
        Expanded(
          child: Text(description, style: texts.bodyMedium),
        ),
      ],
    );
  }
}
