import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/glow_card.dart';

/// Topluluk akışına yeni mikro-paylaşım gönderme bileşeni.
/// 2. Kural: Sabit stil ve renk yazılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class CreatePostInput extends StatefulWidget {
  final ValueChanged<String> onShare;

  const CreatePostInput({super.key, required this.onShare});

  @override
  State<CreatePostInput> createState() => _CreatePostInputState();
}

class _CreatePostInputState extends State<CreatePostInput> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleShare() {
    final text = _textController.text.trim();
    if (text.isNotEmpty && text.length <= 280) {
      widget.onShare(text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      padding: AppSpacing.paddingAllMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _InputField(controller: _textController),
          AppSpacing.gapH8,
          _ActionRow(
            controller: _textController,
            onShare: _handleShare,
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;

  const _InputField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 280,
      maxLines: 3,
      style: context.textTheme.bodyMedium,
      decoration: const InputDecoration(
        hintText: 'Ekosistemle ne paylaşmak istersin? (Maks 280 karakter)',
        counterText: '',
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onShare;

  const _ActionRow({required this.controller, required this.onShare});

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final remaining = 280 - value.text.length;
            return Text(
              '$remaining karakter',
              style: context.textTheme.bodyMedium?.copyWith(
                color: remaining < 20 ? colors.error : colors.textSecondary,
              ),
            );
          },
        ),
        ElevatedButton.icon(
          onPressed: onShare,
          icon: const Icon(Icons.rocket_launch_rounded, size: 16),
          label: const Text('Paylaş'),
        ),
      ],
    );
  }
}
