import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';

/// 6 adımlı Türkiye mevzuatı şirketleşme yol haritası zaman çizelgesi.
/// 2. Kural: Renkler ve stiller context uzantılarından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class LegalTimelineView extends StatelessWidget {
  final List<String> steps;
  final int currentStepIndex;

  const LegalTimelineView({
    super.key,
    required this.steps,
    required this.currentStepIndex,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      padding: AppSpacing.paddingAllMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Şirketleşme & Hukuki Yol Haritası',
              style: context.textTheme.titleMedium),
          AppSpacing.gapH16,
          ...List.generate(steps.length, (index) {
            final isCompleted = index < currentStepIndex;
            final isCurrent = index == currentStepIndex;
            final isLast = index == steps.length - 1;

            return _TimelineStepItem(
              stepNumber: index + 1,
              title: steps[index],
              isCompleted: isCompleted,
              isCurrent: isCurrent,
              isLast: isLast,
            );
          }),
        ],
      ),
    );
  }
}

class _TimelineStepItem extends StatelessWidget {
  final int stepNumber;
  final String title;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const _TimelineStepItem({
    required this.stepNumber,
    required this.title,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    final dotColor = isCompleted
        ? colors.success
        : isCurrent
            ? colors.primary
            : colors.border;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepIndicatorCol(
            dotColor: dotColor,
            isCompleted: isCompleted,
            isCurrent: isCurrent,
            isLast: isLast,
            stepNumber: stepNumber,
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                title,
                style: texts.bodyMedium?.copyWith(
                  fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w400,
                  color: isCurrent
                      ? colors.textPrimary
                      : isCompleted
                          ? colors.success
                          : colors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIndicatorCol extends StatelessWidget {
  final Color dotColor;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;
  final int stepNumber;

  const _StepIndicatorCol({
    required this.dotColor,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
    required this.stepNumber,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: dotColor.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: dotColor, width: 2),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check_rounded, size: 14, color: dotColor)
                : Text('$stepNumber',
                    style: TextStyle(fontSize: 10, color: dotColor)),
          ),
        ),
        if (!isLast)
          Expanded(
            child: Container(
              width: 2,
              color: isCompleted ? colors.success : colors.border,
            ),
          ),
      ],
    );
  }
}
