import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';

/// Gönderi altındaki beğeni ve yanıt etkileşim çubuğu.
/// 2. Kural: Renkler `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class PostActionBar extends StatelessWidget {
  final int likeCount;
  final int replyCount;
  final bool isLikedByMe;
  final VoidCallback onLike;
  final VoidCallback onReply;

  const PostActionBar({
    super.key,
    required this.likeCount,
    required this.replyCount,
    required this.isLikedByMe,
    required this.onLike,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Row(
      children: [
        _ActionItem(
          icon: isLikedByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          iconColor: isLikedByMe ? colors.secondary : colors.textSecondary,
          label: '$likeCount',
          labelStyle: texts.bodyMedium,
          onTap: onLike,
        ),
        AppSpacing.gapW24,
        _ActionItem(
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: colors.primary,
          label: '$replyCount',
          labelStyle: texts.bodyMedium,
          onTap: onReply,
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final TextStyle? labelStyle;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.labelStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: iconColor),
            AppSpacing.gapW4,
            Text(label, style: labelStyle),
          ],
        ),
      ),
    );
  }
}
