import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../fikir_durumu/view/fikir_durumu_view.dart';

/// AppBar üzerinde yer alan "Fikir Durumu" profil rozeti.
/// Tıklandığında Şirketleşme & Hukuki Durum gösterge panelini açar.
/// 2. Kural: Sabit stil ve renk kullanılmaz, context uzantıları kullanılır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ProfileBadge extends StatelessWidget {
  const ProfileBadge({super.key});

  void _openFikirDurumu(BuildContext context) {
    debugPrint('Fikir Durumu rozetine tıklandı -> FikirDurumuView açılıyor.');
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FikirDurumuView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Padding(
      padding: AppSpacing.paddingHorizontalSm,
      child: InkWell(
        onTap: () => _openFikirDurumu(context),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        child: Container(
          padding: AppSpacing.paddingHorizontalSm + AppSpacing.paddingAllXs,
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(color: colors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lightbulb_outline_rounded,
                  size: 16, color: colors.accent),
              AppSpacing.gapW4,
              Text('Fikir Durumu', style: texts.labelLarge),
            ],
          ),
        ),
      ),
    );
  }
}
