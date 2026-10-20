import 'package:flutter/material.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../../core/widgets/starfield_background.dart';
import '../controller/topluluk_controller.dart';
import '../models/post_model.dart';
import '../widget/create_post_input.dart';
import '../widget/post_card.dart';

/// Yörünge Platformu - Girişimcilik Ekosistemi & Topluluk Akışı.
/// 1. Kural: Sayfa düzeyinde setState yok, ValueListenableBuilder ile reaktif.
/// Güvenlik Kuralı: errorNotifier ile yetkisiz işlem SnackBar uyarısı.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class ToplulukView extends StatefulWidget {
  const ToplulukView({super.key});

  @override
  State<ToplulukView> createState() => _ToplulukViewState();
}

class _ToplulukViewState extends State<ToplulukView> {
  late final ToplulukController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ToplulukController();
    _controller.errorNotifier.addListener(_onErrorChanged);
  }

  void _onErrorChanged() {
    final error = _controller.errorNotifier.value;
    if (error != null && mounted) {
      final colors = context.spaceColors;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          backgroundColor: colors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _controller.clearError();
    }
  }

  @override
  void dispose() {
    _controller.errorNotifier.removeListener(_onErrorChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: StarfieldBackground(
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ToplulukHeaderSection(controller: _controller),
              ),
              _PostListSliver(controller: _controller),
              const SliverToBoxAdapter(child: AppSpacing.gapH24),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToplulukHeaderSection extends StatelessWidget {
  final ToplulukController controller;

  const _ToplulukHeaderSection({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.paddingHorizontalMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSpacing.gapH12,
          const _HeaderTexts(),
          AppSpacing.gapH12,
          CreatePostInput(onShare: controller.createPost),
          AppSpacing.gapH16,
        ],
      ),
    );
  }
}

class _HeaderTexts extends StatelessWidget {
  const _HeaderTexts();

  @override
  Widget build(BuildContext context) {
    final texts = context.textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Girişimci Topluluğu', style: texts.headlineMedium),
        Text(
          'Deneyimleri, dönüm noktalarını ve soru işaretlerini ekosistemle paylaşın.',
          style: texts.bodyMedium,
        ),
      ],
    );
  }
}

class _PostListSliver extends StatelessWidget {
  final ToplulukController controller;

  const _PostListSliver({required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PostModel>>(
      valueListenable: controller.postsNotifier,
      builder: (context, posts, _) {
        return SliverPadding(
          padding: AppSpacing.paddingHorizontalMd,
          sliver: SliverList.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return PostCard(
                post: post,
                onLike: () => controller.likePost(post.id),
                onAddReply: (content) => controller.addReply(post.id, content),
              );
            },
          ),
        );
      },
    );
  }
}
