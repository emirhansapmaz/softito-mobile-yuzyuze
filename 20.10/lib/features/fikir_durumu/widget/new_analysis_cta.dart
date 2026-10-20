import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../analiz/view/analiz_view.dart';

/// Yeni bir iş planı analizi başlatma çağrısı (CTA) butonu.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class NewAnalysisCta extends StatelessWidget {
  final VoidCallback? onCustomTap;

  const NewAnalysisCta({super.key, this.onCustomTap});

  void _navigate(BuildContext context) {
    if (onCustomTap != null) {
      onCustomTap!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AnalizView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: AppSpacing.paddingVerticalMd,
        ),
        onPressed: () => _navigate(context),
        icon: const Icon(Icons.add_chart_rounded),
        label: const Text('Yeni İş Planı Analizi Başlat'),
      ),
    );
  }
}
