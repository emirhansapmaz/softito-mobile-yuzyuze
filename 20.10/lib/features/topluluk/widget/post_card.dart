import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';
import '../models/post_model.dart';
import '../models/reply_model.dart';
import 'post_action_bar.dart';

/// Topluluk akışındaki tek bir mikro-paylaşım kartı.
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class PostCard extends StatefulWidget {
  final PostModel post;
  final VoidCallback onLike;
  final ValueChanged<String> onAddReply;

  const PostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onAddReply,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool _showReplies = false;

  void _toggleReplies() {
    setState(() => _showReplies = !_showReplies);
  }

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      margin: AppSpacing.paddingVerticalSm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PostAuthorRow(authorName: widget.post.authorName),
          AppSpacing.gapH8,
          Text(widget.post.content, style: context.textTheme.bodyLarge),
          AppSpacing.gapH12,
          PostActionBar(
            likeCount: widget.post.likeCount,
            replyCount: widget.post.replies.length,
            isLikedByMe: widget.post.isLikedByMe,
            onLike: widget.onLike,
            onReply: _toggleReplies,
          ),
          if (_showReplies) ...[
            AppSpacing.gapH12,
            _RepliesList(
              replies: widget.post.replies,
              onAddReply: widget.onAddReply,
            ),
          ],
        ],
      ),
    );
  }
}

class _PostAuthorRow extends StatelessWidget {
  final String authorName;

  const _PostAuthorRow({required this.authorName});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: colors.primary.withValues(alpha: 0.15),
          child: Text(
            authorName.isNotEmpty ? authorName[0] : '?',
            style: texts.labelLarge?.copyWith(color: colors.primary),
          ),
        ),
        AppSpacing.gapW8,
        Expanded(
          child: Text(
            authorName,
            style: texts.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RepliesList extends StatelessWidget {
  final List<ReplyModel> replies;
  final ValueChanged<String> onAddReply;

  const _RepliesList({required this.replies, required this.onAddReply});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1),
        AppSpacing.gapH8,
        if (replies.isEmpty)
          Text('Henüz yanıt yok. İlk yanıtı siz yazın!',
              style: context.textTheme.bodyMedium)
        else
          ...replies.map((r) => _ReplyBubble(reply: r)),
        AppSpacing.gapH8,
        _QuickReplyInput(onSend: onAddReply),
      ],
    );
  }
}

class _ReplyBubble extends StatelessWidget {
  final ReplyModel reply;

  const _ReplyBubble({required this.reply});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final texts = context.textTheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: AppSpacing.paddingAllSm,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(reply.authorName, style: texts.labelLarge),
          AppSpacing.gapH4,
          Text(reply.content, style: texts.bodyMedium),
        ],
      ),
    );
  }
}

class _QuickReplyInput extends StatefulWidget {
  final ValueChanged<String> onSend;

  const _QuickReplyInput({required this.onSend});

  @override
  State<QuickReplyInput> createState() => _QuickReplyInputState();
}

typedef QuickReplyInput = _QuickReplyInput;

class _QuickReplyInputState extends State<_QuickReplyInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            style: context.textTheme.bodyMedium,
            decoration: const InputDecoration(
              hintText: 'Yanıt yaz...',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send_rounded,
              size: 20, color: context.spaceColors.primary),
          onPressed: _submit,
        ),
      ],
    );
  }
}
