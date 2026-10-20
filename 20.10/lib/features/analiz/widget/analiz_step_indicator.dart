import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// 8 adımlı analiz sürecini yatay olarak gösteren gösterge çubuğu.
/// 2. Kural: Renkler `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class AnalizStepIndicator extends StatelessWidget {
  final int currentStep;
  final ValueChanged<int> onStepTapped;

  const AnalizStepIndicator({
    super.key,
    required this.currentStep,
    required this.onStepTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: AppSpacing.paddingHorizontalMd,
        itemCount: 8,
        separatorBuilder: (context, index) => AppSpacing.gapW8,
        itemBuilder: (context, index) {
          final isCurrent = index == currentStep;
          final isCompleted = index < currentStep;
          return _StepIndicatorCircle(
            stepIndex: index,
            isCurrent: isCurrent,
            isCompleted: isCompleted,
            onTap: () => onStepTapped(index),
          );
        },
      ),
    );
  }
}

class _StepIndicatorCircle extends StatelessWidget {
  final int stepIndex;
  final bool isCurrent;
  final bool isCompleted;
  final VoidCallback onTap;

  const _StepIndicatorCircle({
    required this.stepIndex,
    required this.isCurrent,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    final bgColor = isCurrent
        ? colors.primary
        : isCompleted
            ? colors.success.withValues(alpha: 0.25)
            : colors.surface;

    final borderColor = isCurrent
        ? colors.primary
        : isCompleted
            ? colors.success
            : colors.border;

    final fgColor = isCurrent ? Colors.black : texts.bodyMedium?.color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: isCompleted
              ? Icon(Icons.check_rounded, size: 18, color: colors.success)
              : Text('${stepIndex + 1}',
                  style: texts.labelLarge?.copyWith(color: fgColor)),
        ),
      ),
    );
  }
}
