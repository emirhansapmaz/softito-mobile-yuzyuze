// Flutter'ın temel materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Standart boşluk ve kenarlık yarıçapı değerlerini içeri alıyoruz
import '../../../core/constants/app_spacing.dart';
// BuildContext tema ve tipografi yardımcı uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';
// Kozmik parıltılı kart bileşenini içeri alıyoruz
import '../../../core/widgets/glow_card.dart';
// Kullanıcı rolü numaralandırmasını içeri alıyoruz
import '../models/user_role.dart';

/// Yörünge Platformu - Rol Seçim Kartı.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class RoleSelectionCard extends StatelessWidget {
  // Kartın temsil ettiği kullanıcı rolü
  final UserRole role;
  // Rolün o an seçili olup olmadığı bilgisi
  final bool isSelected;
  // Karta tıklandığında tetiklenecek fonksiyon
  final VoidCallback onTap;

  // RoleSelectionCard kurucu metodu
  const RoleSelectionCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  }); // Kurucu metod kapanışı

  // Arayüzü inşa eden build metodu
  @override
  Widget build(BuildContext context) {
    // Uzay renklerimizi tema uzantısından alıyoruz
    final colors = context.spaceColors;

    // Seçili ise parıldayan GlowCard bileşeni döndürüyoruz
    return GlowCard(
      // Seçiliyse parıltıyı yak
      hasGlow: isSelected,
      // Tıklanma olayı
      onTap: onTap,
      // İç kenar boşluğu 16 piksel
      padding: AppSpacing.paddingAllMd,
      // Alt kenar boşluğu 8 piksel
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      // Kart içi yatay satır dizilimi
      child: Row(
        children: [
          // Sol rol simge ikonu
          _buildRoleIcon(colors),
          // 16 piksel yatay boşluk
          AppSpacing.gapW16,
          // Orta kısım: Rol adı ve açıklaması
          Expanded(child: _buildRoleInfo(context)),
          // Sağ kısım: Seçim radyo ikonu
          _buildSelectionIndicator(colors),
        ], // Row çocukları kapanışı
      ), // Row kapanışı
    ); // GlowCard kapanışı
  } // build metodu kapanışı

  // Role özgü roket/beyin/banka ikonunu kutu içinde üreten yardımcı metot
  Widget _buildRoleIcon(dynamic colors) {
    // Switch deseni ile role uygun ikonu seçiyoruz
    final iconData = switch (role) {
      // Girişimci için fırlatma roketi ikonu
      UserRole.entrepreneur => Icons.rocket_launch_rounded,
      // Mentor için akıl/psikoloji rehberlik ikonu
      UserRole.mentor => Icons.psychology_rounded,
      // Yatırımcı için finansal banka ikonu
      UserRole.investor => Icons.account_balance_rounded,
    }; // switch sonu

    // İkonu saran kutu
    return Container(
      // Genişlik 44 piksel
      width: 44,
      // Yükseklik 44 piksel
      height: 44,
      // Kutu dekorasyonu
      decoration: BoxDecoration(
        // Seçiliyse birincil rengin hafif saydam tonu
        color: isSelected
            ? colors.primary.withValues(alpha: 0.2)
            : colors.surface.withValues(alpha: 0.5),
        // Yuvarlak köşeler
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        // Kenarlık çizgisi
        border: Border.all(
          color: isSelected ? colors.primary : colors.border,
          width: 1.0,
        ), // Border.all kapanışı
      ), // BoxDecoration kapanışı
      // Seçilen ikonu ortala
      child: Icon(
        iconData,
        color: isSelected ? colors.primary : colors.textSecondary,
        size: 22,
      ), // Icon kapanışı
    ); // Container kapanışı
  } // _buildRoleIcon metodu kapanışı

  // Rolün adını ve açıklamasını alt alta yazan kolon
  Widget _buildRoleInfo(BuildContext context) {
    // Tema renkleri
    final colors = context.spaceColors;
    // Tipografi teması
    final textTheme = context.textTheme;

    // Dikey kolon
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rol adı başlığı
        Text(
          role.displayName,
          style: textTheme.titleMedium?.copyWith(
            color: isSelected ? colors.primary : colors.textPrimary,
            fontWeight: FontWeight.bold,
          ), // copyWith kapanışı
        ), // Text kapanışı
        // 4 piksel dikey boşluk
        AppSpacing.gapH4,
        // Rol açıklaması
        Text(
          role.description,
          style: textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ), // copyWith kapanışı
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ), // Text kapanışı
      ], // Column çocukları kapanışı
    ); // Column kapanışı
  } // _buildRoleInfo metodu kapanışı

  // Sağ taraftaki onay tik/radyo işaretini üreten yardımcı metot
  Widget _buildSelectionIndicator(dynamic colors) {
    return Icon(
      // Seçiliyse dolu daireli onay ikonu, değilse boş çember
      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
      color: isSelected ? colors.primary : colors.textSecondary,
      size: 22,
    ); // Icon kapanışı
  } // _buildSelectionIndicator metodu kapanışı
} // RoleSelectionCard sınıfı kapanışı
