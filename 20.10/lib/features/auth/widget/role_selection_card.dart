import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/user_role.dart';

/// Yörünge Platformu - Rol Seçim Kartı.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class RoleSelectionCard extends StatelessWidget {
  final UserRole role;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleSelectionCard({
    super.key,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return GlowCard(
      hasGlow: isSelected,
      onTap: onTap,
      padding: AppSpacing.paddingAllMd,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          _buildRoleIcon(colors),
          AppSpacing.gapW16,
          Expanded(child: _buildRoleInfo(context)),
          _buildSelectionIndicator(colors),
        ],
      ),
    );
  }

  Widget _buildRoleIcon(dynamic colors) {
    final iconData = switch (role) {
      UserRole.entrepreneur => Icons.rocket_launch_rounded,
      UserRole.mentor => Icons.psychology_rounded,
      UserRole.investor => Icons.account_balance_rounded,
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: isSelected
            ? colors.primary.withValues(alpha: 0.2)
            : colors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isSelected ? colors.primary : colors.border,
          width: 1.0,
        ),
      ),
      child: Icon(
        iconData,
        color: isSelected ? colors.primary : colors.textSecondary,
        size: 22,
      ),
    );
  }

  Widget _buildRoleInfo(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          role.displayName,
          style: textTheme.titleMedium?.copyWith(
            color: isSelected ? colors.primary : colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.gapH4,
        Text(
          role.description,
          style: textTheme.bodySmall?.copyWith(
            color: colors.textSecondary,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator(dynamic colors) {
    return Icon(
      isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
      color: isSelected ? colors.primary : colors.textSecondary,
      size: 22,
    );
  }
}
