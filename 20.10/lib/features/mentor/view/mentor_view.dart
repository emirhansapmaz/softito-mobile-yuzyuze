import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/starfield_background.dart';
import '../controller/mentor_controller.dart';
import '../models/mentor_model.dart';
import '../widget/featured_mentors_section.dart';
import '../widget/mentor_card.dart';
import '../widget/mentor_search_bar.dart';
import '../widget/sector_filter_list.dart';

/// Yörünge Platformu - Mentorluk ve Girişim Rehberliği Modülü.
/// 1. Kural: Sayfa düzeyinde setState yok, ValueListenableBuilder ile reaktif.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class MentorView extends StatefulWidget {
  const MentorView({super.key});

  @override
  State<MentorView> createState() => _MentorViewState();
}

class _MentorViewState extends State<MentorView> {
  late final MentorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MentorController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StarfieldBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _MentorHeaderSection(controller: _controller),
              ),
              _MentorListSliver(controller: _controller),
              const SliverToBoxAdapter(child: AppSpacing.gapH24),
            ],
          ),
        ),
      ),
    );
  }
}

class _MentorHeaderSection extends StatelessWidget {
  final MentorController controller;

  const _MentorHeaderSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.gapH12,
        MentorSearchBar(onChanged: controller.search),
        AppSpacing.gapH16,
        _SectorFilterSection(controller: controller),
        AppSpacing.gapH16,
        FeaturedMentorsSection(
          mentors: controller.featuredMentors,
          onRequestMatch: controller.requestMatch,
        ),
        AppSpacing.gapH16,
        const _AllMentorsTitle(),
        AppSpacing.gapH8,
      ],
    );
  }
}

class _SectorFilterSection extends StatelessWidget {
  final MentorController controller;

  const _SectorFilterSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: controller.selectedSectorNotifier,
      builder: (context, selectedSector, _) {
        return SectorFilterList(
          sectors: controller.sectors,
          selectedSector: selectedSector,
          onSelectSector: controller.filterBySector,
        );
      },
    );
  }
}

class _AllMentorsTitle extends StatelessWidget {
  const _AllMentorsTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontalMd,
      child: Text(
        'Tüm Mentorlar',
        style: context.textTheme.titleMedium,
      ),
    );
  }
}

class _MentorListSliver extends StatelessWidget {
  final MentorController controller;

  const _MentorListSliver({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<MentorModel>>(
      valueListenable: controller.mentorsNotifier,
      builder: (context, mentors, _) {
        if (mentors.isEmpty) {
          return const SliverToBoxAdapter(child: _MentorEmptyState());
        }

        return SliverPadding(
          padding: AppSpacing.paddingHorizontalMd,
          sliver: SliverList.builder(
            itemCount: mentors.length,
            itemBuilder: (context, index) {
              final mentor = mentors[index];
              return MentorCard(
                mentor: mentor,
                onRequestMatch: () => controller.requestMatch(mentor.id),
              );
            },
          ),
        );
      },
    );
  }
}

class _MentorEmptyState extends StatelessWidget {
  const _MentorEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Padding(
      padding: AppSpacing.paddingAllXl,
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: colors.textSecondary),
            AppSpacing.gapH8,
            Text('Mentor Bulunamadı', style: texts.titleMedium),
            AppSpacing.gapH4,
            Text(
              'Arama veya sektör filtrenize uygun mentor bulunamadı.',
              style: texts.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
