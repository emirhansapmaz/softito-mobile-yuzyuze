import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

enum ButtonVariant { primary, secondary, outline }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final ButtonVariant variant;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.variant = ButtonVariant.primary,
    this.height = 52,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Color backgroundColor;
    Color foregroundColor;
    BorderSide? borderSide;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = isDark ? AppColors.sageGreen : AppColors.deepSage;
        foregroundColor = isDark ? AppColors.backgroundDark : Colors.white;
        borderSide = BorderSide.none;
        break;
      case ButtonVariant.secondary:
        backgroundColor = isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight;
        foregroundColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
        borderSide = BorderSide.none;
        break;
      case ButtonVariant.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = isDark ? AppColors.sageGreen : AppColors.deepSage;
        borderSide = BorderSide(
          color: isDark ? AppColors.sageGreen : AppColors.deepSage,
          width: 1.2,
        );
        break;
    }

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: borderSide,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: isLoading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: foregroundColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: foregroundColor,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
