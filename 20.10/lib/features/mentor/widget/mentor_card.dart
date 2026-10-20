import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/mentor_model.dart';

/// Yörünge Platformu - Mentor Profil Kartı.
/// 2. Kural: Sabit stil/renk yazılmaz; context uzantıları kullanılır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class MentorCard extends StatelessWidget {
  final MentorModel mentor;
  final VoidCallback onRequestMatch;

  const MentorCard({
    super.key,
    required this.mentor,
    required this.onRequestMatch,
  });

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      margin: AppSpacing.paddingVerticalSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MentorHeader(mentor: mentor),
          AppSpacing.gapH8,
          _ExpertiseChips(expertise: mentor.expertise),
          AppSpacing.gapH12,
          _MatchButton(
            status: mentor.matchStatus,
            onPressed: onRequestMatch,
          ),
        ],
      ),
    );
  }
}

class _MentorHeader extends StatelessWidget {
  final MentorModel mentor;

  const _MentorHeader({required this.mentor});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: colors.primary.withValues(alpha: 0.15),
          child: Text(
            mentor.name.isNotEmpty ? mentor.name[0] : '?',
            style: texts.titleLarge?.copyWith(color: colors.primary),
          ),
        ),
        AppSpacing.gapW12,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mentor.name, style: texts.titleMedium),
              Text(
                '${mentor.title} • ${mentor.company}',
                style: texts.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        _SectorTag(sector: mentor.sector),
      ],
    );
  }
}

class _SectorTag extends StatelessWidget {
  final String sector;

  const _SectorTag({required this.sector});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    return Container(
      padding: AppSpacing.paddingHorizontalSm + AppSpacing.paddingAllXs,
      decoration: BoxDecoration(
        color: colors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Text(
        sector,
        style: context.textTheme.labelLarge,
      ),
    );
  }
}

class _ExpertiseChips extends StatelessWidget {
  final List<String> expertise;

  const _ExpertiseChips({required this.expertise});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: expertise.map((item) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
            border: Border.all(color: colors.border),
          ),
          child: Text(item, style: context.textTheme.bodyMedium),
        );
      }).toList(),
    );
  }
}

class _MatchButton extends StatelessWidget {
  final MatchStatus status;
  final VoidCallback onPressed;

  const _MatchButton({
    required this.status,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final isPending = status == MatchStatus.pending;
    final isMatched = status == MatchStatus.matched;

    final bgColor = isMatched
        ? colors.success
        : isPending
            ? colors.warning.withValues(alpha: 0.2)
            : colors.primary;

    final fgColor = isPending ? colors.warning : Colors.black;
    final label = isMatched
        ? 'Eşleşildi'
        : isPending
            ? 'Talep İletildi'
            : 'Eşleşme İste';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
        ),
        onPressed: status == MatchStatus.none ? onPressed : null,
        child: Text(label),
      ),
    );
  }
}
