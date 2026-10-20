import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/analiz_model.dart';

/// 8 farklı adımın içerik form alanlarını oluşturan builder bileşeni.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class StepContentBuilder extends StatelessWidget {
  final int currentStep;
  final AnalizModel model;
  final Function({
    String? ideaSummary,
    String? teamDetails,
    String? traction,
    String? innovation,
    String? planTables,
    String? marketAnalysis,
    String? brandPositioning,
    bool? isCompleted,
  }) onUpdate;

  const StepContentBuilder({
    super.key,
    required this.currentStep,
    required this.model,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return switch (currentStep) {
      0 => _StepFormCard(
          title: '1. İş Fikri Özeti',
          hint: 'Girişiminizin çözdüğü temel problemi ve ana değer önerisini özetleyin...',
          initialValue: model.ideaSummary,
          onChanged: (val) => onUpdate(ideaSummary: val),
        ),
      1 => _StepFormCard(
          title: '2. Kurucu Ekip & Yetkinlikler',
          hint: 'Ekip üyelerinin rolleri, uzmanlıkları ve daha önceki girişimcilik deneyimleri...',
          initialValue: model.teamDetails,
          onChanged: (val) => onUpdate(teamDetails: val),
        ),
      2 => _StepFormCard(
          title: '3. Çekiş & Büyüme (Traction)',
          hint: 'Mevcut kullanıcı/müşteri sayısı, retention, MRR ve büyüme oranları...',
          initialValue: model.traction,
          onChanged: (val) => onUpdate(traction: val),
        ),
      3 => _StepFormCard(
          title: '4. İnovasyon & Teknik Çözüm',
          hint: 'Ürününüzün teknolojik üstünlüğü, IP/patent durumu ve Ar-Ge içeriği...',
          initialValue: model.innovation,
          onChanged: (val) => onUpdate(innovation: val),
        ),
      4 => _StepFormCard(
          title: '5. Finansal Tablolar & Bütçe',
          hint: 'Yıllık gelir modeli, birim ekonomi (CAC, LTV) ve sermaye kullanım planı...',
          initialValue: model.planTables,
          onChanged: (val) => onUpdate(planTables: val),
        ),
      5 => _StepFormCard(
          title: '6. Pazar Büyüklüğü (TAM/SAM/SOM)',
          hint: 'Toplam pazar hacmi, hedef müşteri segmenti ve doğrudan/dolaylı rakipler...',
          initialValue: model.marketAnalysis,
          onChanged: (val) => onUpdate(marketAnalysis: val),
        ),
      6 => _StepFormCard(
          title: '7. Marka Konumlandırma & Go-to-Market',
          hint: 'Müşteri kazanım kanalları, lansman takvimi ve satış stratejisi...',
          initialValue: model.brandPositioning,
          onChanged: (val) => onUpdate(brandPositioning: val),
        ),
      _ => _StepFinalSummary(model: model),
    };
  }
}

class _StepFormCard extends StatefulWidget {
  final String title;
  final String hint;
  final String initialValue;
  final ValueChanged<String> onChanged;

  const _StepFormCard({
    required this.title,
    required this.hint,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_StepFormCard> createState() => _StepFormCardState();
}

class _StepFormCardState extends State<_StepFormCard> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant _StepFormCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text != widget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      padding: AppSpacing.paddingAllMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: context.textTheme.titleMedium),
          AppSpacing.gapH12,
          TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            maxLines: 8,
            style: context.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hint,
              alignLabelWithHint: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepFinalSummary extends StatelessWidget {
  final AnalizModel model;

  const _StepFinalSummary({required this.model});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return GlowCard(
      padding: AppSpacing.paddingAllMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.verified_rounded, color: colors.success, size: 28),
              AppSpacing.gapW8,
              Text('8. Analiz Özeti ve İnceleme', style: texts.titleMedium),
            ],
          ),
          AppSpacing.gapH12,
          _SummaryRow(label: 'Fikir:', text: model.ideaSummary),
          _SummaryRow(label: 'Ekip:', text: model.teamDetails),
          _SummaryRow(label: 'Traction:', text: model.traction),
          _SummaryRow(label: 'İnovasyon:', text: model.innovation),
          _SummaryRow(label: 'Pazar:', text: model.marketAnalysis),
          AppSpacing.gapH8,
          Text(
            model.isCompleted
                ? '✅ İş Planı Başarıyla Tamamlandı ve Kaydedildi.'
                : 'Bilgilerinizi gözden geçirip alttaki "Analizi Tamamla" butonuna basınız.',
            style: texts.labelLarge?.copyWith(
              color: model.isCompleted ? colors.success : colors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String text;

  const _SummaryRow({required this.label, required this.text});

  @override
  Widget build(BuildContext context) {
    final texts = context.textTheme;
    final display = text.isNotEmpty ? text : '(Henüz girilmedi)';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Text(
        '$label $display',
        style: texts.bodyMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
