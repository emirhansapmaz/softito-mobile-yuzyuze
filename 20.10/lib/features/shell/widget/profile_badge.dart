// Flutter materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Standart boşluk ve kenarlık yarıçapı değerlerini içeri alıyoruz
import '../../../core/constants/app_spacing.dart';
// BuildContext tema ve tipografi yardımcı uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';
// Fikir durumu & şirketleşme analiz ekranını içeri alıyoruz
import '../../fikir_durumu/view/fikir_durumu_view.dart';

/// AppBar üzerinde yer alan "Fikir Durumu" profil rozeti.
/// Tıklandığında Şirketleşme & Hukuki Durum gösterge panelini açar.
/// 2. Kural: Sabit stil ve renk kullanılmaz, context uzantıları kullanılır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ProfileBadge extends StatelessWidget {
  // Sabit kurucu metot
  const ProfileBadge({super.key});

  // Fikir durumu ekranına yönlendiren fonksiyon
  void _openFikirDurumu(BuildContext context) {
    // Konsola log düşüyoruz
    debugPrint('Fikir Durumu rozetine tıklandı -> FikirDurumuView açılıyor.');
    // Fikir durumu sayfasına geçiş yapıyoruz
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FikirDurumuView()),
    ); // push kapanışı
  } // _openFikirDurumu metodu kapanışı

  // Arayüzü inşa eden build metodu
  @override
  Widget build(BuildContext context) {
    // Tema renkleri
    final colors = context.spaceColors;
    // Tipografi teması
    final texts = context.textTheme;

    // Yatay kenar boşluklu kapsül rozet
    return Padding(
      padding: AppSpacing.paddingHorizontalSm,
      // Tıklanma efekti InkWell
      child: InkWell(
        onTap: () => _openFikirDurumu(context),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        // Kapsül kutu
        child: Container(
          padding: AppSpacing.paddingHorizontalSm + AppSpacing.paddingAllXs,
          decoration: BoxDecoration(
            color: colors.cardBackground,
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            border: Border.all(color: colors.border),
          ), // BoxDecoration kapanışı
          // Satır içi lamba ikonu ve metin
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ampul ikonu
              Icon(Icons.lightbulb_outline_rounded,
                  size: 16, color: colors.accent),
              // 4 piksel yatay boşluk
              AppSpacing.gapW4,
              // Fikir Durumu rozet metni
              Text('Fikir Durumu', style: texts.labelLarge),
            ], // Row çocukları kapanışı
          ), // Row kapanışı
        ), // Container kapanışı
      ), // InkWell kapanışı
    ); // Padding kapanışı
  } // build metodu kapanışı
} // ProfileBadge sınıfı kapanışı
