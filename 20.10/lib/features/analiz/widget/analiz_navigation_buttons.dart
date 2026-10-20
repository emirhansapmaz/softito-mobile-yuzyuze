import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Analiz stepper akışının alt gezinme ve kaydetme butonları.
/// 2. Kural: Renkler ve stiller context uzantılarından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class AnalizNavigationButtons extends StatelessWidget {
  final int currentStep;
  final bool isCompleted;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const AnalizNavigationButtons({
    super.key,
    required this.currentStep,
    required this.isCompleted,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final isFirstStep = currentStep == 0;
    final isLastStep = currentStep == 7;

    final nextLabel = isLastStep
        ? (isCompleted ? 'Tamamlandı' : 'Analizi Tamamla')
        : 'İleri & Kaydet';

    return Padding(
      padding: AppSpacing.paddingHorizontalMd,
      child: Row(
        children: [
          if (!isFirstStep) ...[
            OutlinedButton.icon(
              onPressed: onPrevious,
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Geri'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: colors.border),
                foregroundColor: colors.textSecondary,
              ),
            ),
            AppSpacing.gapW12,
          ],
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: Icon(
                isLastStep ? Icons.check_circle_rounded : Icons.arrow_forward_rounded,
                size: 16,
              ),
              label: Text(nextLabel),
            ),
          ),
        ],
      ),
    );
  }
}
