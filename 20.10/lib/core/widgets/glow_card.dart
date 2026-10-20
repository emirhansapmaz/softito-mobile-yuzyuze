import 'package:flutter/material.dart';
import '../constants/app_spacing.dart';
import '../extensions/context_extensions.dart';

/// Yörünge Platformu - Kozmik Parıltılı Kapsül Kartı.
/// 2. Kural: Sabit renk ve stil kullanılmaz, `context.spaceColors` kullanılır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class GlowCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool hasGlow;

  const GlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.borderRadius,
    this.hasGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final effectiveRadius =
        borderRadius ?? BorderRadius.circular(AppSpacing.radiusMd);

    return Container(
      margin: margin,
      decoration: _buildDecoration(colors, effectiveRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: effectiveRadius,
          child: Padding(
            padding: padding ?? AppSpacing.paddingAllMd,
            child: child,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(dynamic colors, BorderRadius radius) {
    return BoxDecoration(
      color: colors.cardBackground,
      borderRadius: radius,
      border: Border.all(
        color: hasGlow ? colors.primary.withValues(alpha: 0.35) : colors.border,
        width: 1.0,
      ),
      boxShadow: [
        if (hasGlow)
          BoxShadow(
            color: colors.glow,
            blurRadius: 16.0,
            spreadRadius: -2.0,
            offset: const Offset(0, 4),
          ),
      ],
    );
  }
}
