import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Yörünge Platformu - Kozmik Giriş Butonu.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String title;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.title = 'Giriş Yap',
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        boxShadow: [
          BoxShadow(
            color: colors.glow.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
        ),
        child: isLoading ? _buildLoader(colors) : _buildButtonContent(context),
      ),
    );
  }

  Widget _buildLoader(dynamic colors) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(colors.surface),
      ),
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.spaceColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.surface,
          ),
        ),
        AppSpacing.gapW8,
        Icon(Icons.arrow_forward_rounded, size: 20, color: colors.surface),
      ],
    );
  }
}
