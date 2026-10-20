import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';

/// Aylık girişimci gelir desteği taahhüdü ve hak ediş ilerleme kartı.
/// 2. Kural: Sabit stil ve renk kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class IncomeSupportCard extends StatelessWidget {
  final double progress;

  const IncomeSupportCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;
    final percent = (progress * 100).toInt();

    return GlowCard(
      padding: AppSpacing.paddingAllMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Aylık Gelir Desteği Taahhüdü', style: texts.titleMedium),
              Text('%$percent', style: texts.titleLarge?.copyWith(color: colors.accent)),
            ],
          ),
          AppSpacing.gapH8,
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: colors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            ),
          ),
          AppSpacing.gapH8,
          Text(
            'İş planı hedefleri ve şirketleşme aşamaları doğrulandıkça fonlama aktarımı devam eder.',
            style: texts.bodyMedium,
          ),
        ],
      ),
    );
  }
}
