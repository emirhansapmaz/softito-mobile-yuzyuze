import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';

/// Atanan ücretsiz avukat ve hukuki danışmanlık bilgi kartı.
/// 2. Kural: Renkler `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class LawyerInfoCard extends StatelessWidget {
  final String lawyerName;
  final String lawyerContact;

  const LawyerInfoCard({
    super.key,
    required this.lawyerName,
    required this.lawyerContact,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return GlowCard(
      padding: AppSpacing.paddingAllMd,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: colors.primary.withValues(alpha: 0.15),
            child: Icon(Icons.gavel_rounded, color: colors.primary, size: 24),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ücretsiz Hukuki Danışmanınız', style: texts.labelLarge),
                AppSpacing.gapH4,
                Text(lawyerName, style: texts.titleMedium),
                Text(lawyerContact, style: texts.bodyMedium),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hukuki Danışmana Ulaş',
            icon: Icon(Icons.mail_outline_rounded, color: colors.primary),
            onPressed: () => debugPrint('Hukuk müşaviri ile iletişim: $lawyerContact'),
          ),
        ],
      ),
    );
  }
}
