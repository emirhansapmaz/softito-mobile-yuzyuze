import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/starfield_background.dart';
import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';
import '../widget/analiz_navigation_buttons.dart';
import '../widget/analiz_step_indicator.dart';
import '../widget/step_content_builder.dart';

/// Yörünge Platformu - 8 Adımlı Girişim Analizi ve İş Planı Modülü.
/// 1. Kural: Sayfa düzeyinde setState yok, ValueListenableBuilder ile reaktif.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class AnalizView extends StatefulWidget {
  const AnalizView({super.key});

  @override
  State<AnalizView> createState() => _AnalizViewState();
}

class _AnalizViewState extends State<AnalizView> {
  late final AnalizController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnalizController();
    _controller.loadDraft();
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
          child: Column(
            children: [
              _AnalizTopBar(controller: _controller),
              AppSpacing.gapH8,
              Expanded(
                child: _AnalizScrollableBody(controller: _controller),
              ),
              _AnalizBottomSection(controller: _controller),
              AppSpacing.gapH12,
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalizTopBar extends StatelessWidget {
  final AnalizController controller;

  const _AnalizTopBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.gapH12,
        Padding(
          padding: AppSpacing.paddingHorizontalMd,
          child: Text('8 Adımlı İş Planı Analizi',
              style: context.textTheme.headlineMedium),
        ),
        AppSpacing.gapH8,
        ValueListenableBuilder<int>(
          valueListenable: controller.currentStepNotifier,
          builder: (context, currentStep, _) {
            return AnalizStepIndicator(
              currentStep: currentStep,
              onStepTapped: controller.goToStep,
            );
          },
        ),
      ],
    );
  }
}

class _AnalizScrollableBody extends StatelessWidget {
  final AnalizController controller;

  const _AnalizScrollableBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: AppSpacing.paddingHorizontalMd,
      child: ValueListenableBuilder<int>(
        valueListenable: controller.currentStepNotifier,
        builder: (context, step, _) {
          return ValueListenableBuilder<AnalizModel>(
            valueListenable: controller.formNotifier,
            builder: (context, model, _) {
              return StepContentBuilder(
                currentStep: step,
                model: model,
                onUpdate: controller.updateField,
              );
            },
          );
        },
      ),
    );
  }
}

class _AnalizBottomSection extends StatelessWidget {
  final AnalizController controller;

  const _AnalizBottomSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: controller.currentStepNotifier,
      builder: (context, step, _) {
        return ValueListenableBuilder<AnalizModel>(
          valueListenable: controller.formNotifier,
          builder: (context, model, _) {
            return AnalizNavigationButtons(
              currentStep: step,
              isCompleted: model.isCompleted,
              onPrevious: controller.previousStep,
              onNext: controller.nextStep,
            );
          },
        );
      },
    );
  }
}
