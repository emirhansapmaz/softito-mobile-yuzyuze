import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Yörünge Platformu - Özel Giriş Alanı (Email / Şifre).
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.labelMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        AppSpacing.gapH8,
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          style: textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
          decoration: _buildInputDecoration(colors, textTheme),
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(dynamic colors, TextTheme textTheme) {
    return InputDecoration(
      hintText: widget.hint,
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colors.textSecondary.withValues(alpha: 0.5),
      ),
      prefixIcon: Icon(widget.prefixIcon, color: colors.textSecondary, size: 20),
      suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: colors.textSecondary,
                size: 20,
              ),
              onPressed: () => setState(() => _obscureText = !_obscureText),
            )
          : null,
      filled: true,
      fillColor: colors.cardBackground,
      contentPadding: AppSpacing.paddingHorizontalMd.add(AppSpacing.paddingVerticalSm),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ),
    );
  }
}
