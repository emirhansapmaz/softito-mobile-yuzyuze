import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/mentor_model.dart';

/// Yörünge Platformu - Öne Çıkan Mentorlar Yatay Vitrini.
/// 2. Kural: Sabit stil/renk kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class FeaturedMentorsSection extends StatelessWidget {
  final List<MentorModel> mentors;
  final ValueChanged<String> onRequestMatch;

  const FeaturedMentorsSection({
    super.key,
    required this.mentors,
    required this.onRequestMatch,
  });

  @override
  Widget build(BuildContext context) {
    if (mentors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _FeaturedHeader(),
        AppSpacing.gapH8,
        SizedBox(
          height: 165,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSpacing.paddingHorizontalMd,
            itemCount: mentors.length,
            separatorBuilder: (context, index) => AppSpacing.gapW12,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              return _FeaturedMentorCard(
                mentor: mentor,
                onMatchTap: () => onRequestMatch(mentor.id),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FeaturedHeader extends StatelessWidget {
  const _FeaturedHeader();

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Padding(
      padding: AppSpacing.paddingHorizontalMd,
      child: Row(
        children: [
          Icon(Icons.stars_rounded, size: 20, color: colors.accent),
          AppSpacing.gapW8,
          Text('Öne Çıkan Mentorlar', style: texts.titleMedium),
        ],
      ),
    );
  }
}

class _FeaturedMentorCard extends StatelessWidget {
  final MentorModel mentor;
  final VoidCallback onMatchTap;

  const _FeaturedMentorCard({
    required this.mentor,
    required this.onMatchTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return SizedBox(
      width: 220,
      child: GlowCard(
        padding: AppSpacing.paddingAllSm,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: colors.secondary.withValues(alpha: 0.2),
                  child: Text(
                    mentor.name.isNotEmpty ? mentor.name[0] : '?',
                    style: texts.titleMedium?.copyWith(color: colors.secondary),
                  ),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mentor.name,
                          style: texts.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(mentor.sector,
                          style: texts.labelLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              '${mentor.title} @ ${mentor.company}',
              style: texts.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            _FeaturedButton(
              status: mentor.matchStatus,
              onTap: onMatchTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedButton extends StatelessWidget {
  final MatchStatus status;
  final VoidCallback onTap;

  const _FeaturedButton({required this.status, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final isPending = status == MatchStatus.pending;
    final isNone = status == MatchStatus.none;

    return InkWell(
      onTap: isNone ? onTap : null,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isPending
              ? colors.warning.withValues(alpha: 0.15)
              : colors.primary.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
          border: Border.all(
            color: isPending ? colors.warning : colors.primary,
          ),
        ),
        child: Center(
          child: Text(
            isPending ? 'Talep Gönderildi' : 'Hızlı Eşleş',
            style: context.textTheme.labelLarge?.copyWith(
              color: isPending ? colors.warning : colors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
