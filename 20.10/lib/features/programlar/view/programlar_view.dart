import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/starfield_background.dart';
import '../controller/program_controller.dart';
import '../models/program_model.dart';
import '../widget/program_card.dart';
import '../widget/program_filter_list.dart';

/// Yörünge Platformu - Destek Programları ve Hibeler Modülü.
/// 1. Kural: Sayfa düzeyinde setState yok, ValueListenableBuilder ile reaktif.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ProgramlarView extends StatefulWidget {
  const ProgramlarView({super.key});

  @override
  State<ProgramlarView> createState() => _ProgramlarViewState();
}

class _ProgramlarViewState extends State<ProgramlarView> {
  late final ProgramController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProgramController();
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
                child: _ProgramlarHeaderSection(controller: _controller),
              ),
              _ProgramlarListSliver(controller: _controller),
              const SliverToBoxAdapter(child: AppSpacing.gapH24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgramlarHeaderSection extends StatelessWidget {
  final ProgramController controller;

  const _ProgramlarHeaderSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.gapH12,
        const _ProgramlarTitle(),
        AppSpacing.gapH12,
        _ProgramlarFilterSection(controller: controller),
        AppSpacing.gapH16,
      ],
    );
  }
}

class _ProgramlarTitle extends StatelessWidget {
  const _ProgramlarTitle();

  @override
  Widget build(BuildContext context) {
    final texts = context.textTheme;
    return Padding(
      padding: AppSpacing.paddingHorizontalMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Destek Programları', style: texts.headlineMedium),
          Text(
            'Hibe, kuluçka ve hızlandırma destekleriyle girişiminizi yörüngeye taşıyın.',
            style: texts.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ProgramlarFilterSection extends StatelessWidget {
  final ProgramController controller;

  const _ProgramlarFilterSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: controller.selectedCategoryNotifier,
      builder: (context, selectedCategory, _) {
        return ProgramFilterList(
          categories: controller.categories,
          selectedCategory: selectedCategory,
          onSelectCategory: controller.filterByCategory,
        );
      },
    );
  }
}

class _ProgramlarListSliver extends StatelessWidget {
  final ProgramController controller;

  const _ProgramlarListSliver({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProgramModel>>(
      valueListenable: controller.programlarNotifier,
      builder: (context, programlar, _) {
        if (programlar.isEmpty) {
          return const SliverToBoxAdapter(child: _ProgramEmptyState());
        }

        return SliverPadding(
          padding: AppSpacing.paddingHorizontalMd,
          sliver: SliverList.builder(
            itemCount: programlar.length,
            itemBuilder: (context, index) {
              final program = programlar[index];
              return ProgramCard(
                program: program,
                onAddToCalendar: () => controller.addToCalendar(program),
              );
            },
          ),
        );
      },
    );
  }
}

class _ProgramEmptyState extends StatelessWidget {
  const _ProgramEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Padding(
      padding: AppSpacing.paddingAllXl,
      child: Center(
        child: Column(
          children: [
            Icon(Icons.folder_off_outlined,
                size: 48, color: colors.textSecondary),
            AppSpacing.gapH8,
            Text('Program Bulunamadı', style: texts.titleMedium),
            AppSpacing.gapH4,
            Text(
              'Bu kategoride şu anda listelenen aktif bir program bulunmuyor.',
              style: texts.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
