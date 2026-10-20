import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/yatirimci_model.dart';

/// Yörünge Platformu - Yatırımcı Profil Kartı.
/// 2. Kural: Sabit stil ve renk yazılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class YatirimciCard extends StatelessWidget {
  final YatirimciModel yatirimci;
  final VoidCallback onInspect;

  const YatirimciCard({
    super.key,
    required this.yatirimci,
    required this.onInspect,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      padding: AppSpacing.paddingAllMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _YatirimciHeader(
            name: yatirimci.name,
            type: yatirimci.type,
          ),
          AppSpacing.gapH8,
          _YatirimciMetrics(
            stage: yatirimci.investmentStage,
            ticketSize: yatirimci.ticketSize,
          ),
          AppSpacing.gapH8,
          Text(
            yatirimci.description,
            style: context.textTheme.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.gapH12,
          _InspectButton(onPressed: onInspect),
        ],
      ),
    );
  }
}

class _YatirimciHeader extends StatelessWidget {
  final String name;
  final String type;

  const _YatirimciHeader({required this.name, required this.type});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            style: texts.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        AppSpacing.gapW8,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            border: Border.all(color: colors.primary.withValues(alpha: 0.3)),
          ),
          child: Text(type, style: texts.labelLarge),
        ),
      ],
    );
  }
}

class _YatirimciMetrics extends StatelessWidget {
  final String stage;
  final String ticketSize;

  const _YatirimciMetrics({required this.stage, required this.ticketSize});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Row(
      children: [
        Icon(Icons.layers_outlined, size: 16, color: colors.secondary),
        AppSpacing.gapW4,
        Text(stage, style: texts.bodyMedium),
        const Spacer(),
        Icon(Icons.monetization_on_outlined, size: 16, color: colors.accent),
        AppSpacing.gapW4,
        Text(ticketSize, style: texts.bodyMedium),
      ],
    );
  }
}

class _InspectButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _InspectButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colors.primary),
          foregroundColor: colors.primary,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        onPressed: onPressed,
        child: const Text('İncele'),
      ),
    );
  }
}
