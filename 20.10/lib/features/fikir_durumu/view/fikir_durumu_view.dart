import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/starfield_background.dart';
import '../controller/fikir_durumu_controller.dart';
import '../models/fikir_durumu_model.dart';
import '../widget/income_support_card.dart';
import '../widget/lawyer_info_card.dart';
import '../widget/legal_timeline_view.dart';
import '../widget/new_analysis_cta.dart';

/// Yörünge Platformu - Fikir Durumu ve Şirketleşme Paneli Görünümü.
/// 1. Kural: Sayfa düzeyinde setState yok, ValueListenableBuilder ile reaktif.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class FikirDurumuView extends StatefulWidget {
  const FikirDurumuView({super.key});

  @override
  State<FikirDurumuView> createState() => _FikirDurumuViewState();
}

class _FikirDurumuViewState extends State<FikirDurumuView> {
  late final FikirDurumuController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FikirDurumuController();
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
      appBar: AppBar(
        title: Text('Fikir & Hukuki Durum', style: context.textTheme.titleMedium),
      ),
      body: StarfieldBackground(
        child: SafeArea(
          child: ValueListenableBuilder<FikirDurumuModel>(
            valueListenable: _controller.currentIdeaNotifier,
            builder: (context, idea, _) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: _DashboardHeader(idea: idea),
                  ),
                  SliverPadding(
                    padding: AppSpacing.paddingHorizontalMd,
                    sliver: SliverToBoxAdapter(
                      child: _DashboardContent(
                        idea: idea,
                        steps: _controller.legalSteps,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: AppSpacing.gapH24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final FikirDurumuModel idea;

  const _DashboardHeader({required this.idea});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Padding(
      padding: AppSpacing.paddingAllMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.rocket_launch_rounded,
                  size: 20, color: colors.secondary),
              AppSpacing.gapW8,
              Expanded(
                child: Text(idea.projectName, style: texts.headlineMedium),
              ),
              _ApprovalBadge(isApproved: idea.isApproved),
            ],
          ),
          AppSpacing.gapH4,
          Text(
            'İş planı onayınız ve hukuki şirketleşme süreciniz tek panelde.',
            style: texts.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ApprovalBadge extends StatelessWidget {
  final bool isApproved;

  const _ApprovalBadge({required this.isApproved});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (isApproved ? colors.success : colors.warning)
            .withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
        border: Border.all(
          color: isApproved ? colors.success : colors.warning,
        ),
      ),
      child: Text(
        isApproved ? 'Fikir Onaylandı' : 'İncelemede',
        style: texts.labelLarge?.copyWith(
          color: isApproved ? colors.success : colors.warning,
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final FikirDurumuModel idea;
  final List<String> steps;

  const _DashboardContent({required this.idea, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LawyerInfoCard(
          lawyerName: idea.lawyerName,
          lawyerContact: idea.lawyerContact,
        ),
        AppSpacing.gapH16,
        IncomeSupportCard(progress: idea.incomeSupportProgress),
        AppSpacing.gapH16,
        LegalTimelineView(
          steps: steps,
          currentStepIndex: idea.currentStepIndex,
        ),
        AppSpacing.gapH24,
        const NewAnalysisCta(),
      ],
    );
  }
}
