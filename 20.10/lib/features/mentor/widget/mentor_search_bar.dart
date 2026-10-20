import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Yörünge Platformu - Mentor Arama Çubuğu.
/// 2. Kural: Sabit stil ve renk kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class MentorSearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hintText;

  const MentorSearchBar({
    super.key,
    required this.onChanged,
    this.hintText = 'Mentor, şirket veya uzmanlık ara...',
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Padding(
      padding: AppSpacing.paddingHorizontalMd,
      child: TextField(
        onChanged: onChanged,
        style: texts.bodyLarge,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(Icons.search_rounded, color: colors.primary),
          filled: true,
          fillColor: colors.cardBackground,
          contentPadding: AppSpacing.paddingAllMd,
        ),
      ),
    );
  }
}
