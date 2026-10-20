import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/starfield_background.dart';
import '../controller/yatirimci_controller.dart';
import '../models/yatirimci_model.dart';
import '../widget/yatirimci_card.dart';
import '../widget/yatirimci_filter_bar.dart';

/// Yörünge Platformu - Yatırımcılar ve Fonlama Ağı Modülü.
/// 1. Kural: Sayfa düzeyinde setState yok, ValueListenableBuilder ile reaktif.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class YatirimciView extends StatefulWidget {
  const YatirimciView({super.key});

  @override
  State<YatirimciView> createState() => _YatirimciViewState();
}

class _YatirimciViewState extends State<YatirimciView> {
  late final YatirimciController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YatirimciController();
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
                child: _YatirimciHeaderSection(controller: _controller),
              ),
              _YatirimciGridSliver(controller: _controller),
              const SliverToBoxAdapter(child: AppSpacing.gapH24),
            ],
          ),
        ),
      ),
    );
  }
}

class _YatirimciHeaderSection extends StatelessWidget {
  final YatirimciController controller;

  const _YatirimciHeaderSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.gapH12,
        const _HeaderTitle(),
        AppSpacing.gapH12,
        _FilterBarSection(controller: controller),
        AppSpacing.gapH16,
      ],
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    final texts = context.textTheme;
    return Padding(
      padding: AppSpacing.paddingHorizontalMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Yatırımcı Ağı', style: texts.headlineMedium),
          Text(
            'Girişiminiz için en uygun fonu, kurumsal sermayeyi ve melek ağı keşfedin.',
            style: texts.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _FilterBarSection extends StatelessWidget {
  final YatirimciController controller;

  const _FilterBarSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: controller.selectedTypeNotifier,
      builder: (context, selectedType, _) {
        return ValueListenableBuilder<String>(
          valueListenable: controller.selectedStageNotifier,
          builder: (context, selectedStage, _) {
            return YatirimciFilterBar(
              types: controller.types,
              selectedType: selectedType,
              onSelectType: (type) => controller.filter(type: type),
              stages: controller.stages,
              selectedStage: selectedStage,
              onSelectStage: (stage) => controller.filter(stage: stage),
            );
          },
        );
      },
    );
  }
}

class _YatirimciGridSliver extends StatelessWidget {
  final YatirimciController controller;

  const _YatirimciGridSliver({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<YatirimciModel>>(
      valueListenable: controller.yatirimcilarNotifier,
      builder: (context, yatirimcilar, _) {
        if (yatirimcilar.isEmpty) {
          return const SliverToBoxAdapter(child: _YatirimciEmptyState());
        }

        final crossAxisCount = context.screenWidth > 600 ? 2 : 1;

        return SliverPadding(
          padding: AppSpacing.paddingHorizontalMd,
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              mainAxisExtent: 220,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final yatirimci = yatirimcilar[index];
                return YatirimciCard(
                  yatirimci: yatirimci,
                  onInspect: () => controller.openWebsite(yatirimci.websiteUrl),
                );
              },
              childCount: yatirimcilar.length,
            ),
          ),
        );
      },
    );
  }
}

class _YatirimciEmptyState extends StatelessWidget {
  const _YatirimciEmptyState();

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Padding(
      padding: AppSpacing.paddingAllXl,
      child: Center(
        child: Column(
          children: [
            Icon(Icons.filter_alt_off_rounded,
                size: 48, color: colors.textSecondary),
            AppSpacing.gapH8,
            Text('Yatırımcı Bulunamadı', style: texts.titleMedium),
            AppSpacing.gapH4,
            Text(
              'Seçilen tür ve aşama kriterlerine uygun yatırımcı bulunamadı.',
              style: texts.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
