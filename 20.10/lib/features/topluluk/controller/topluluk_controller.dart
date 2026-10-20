import 'package:flutter/foundation.dart';
import '../data/mock_topluluk_data.dart';
import '../models/post_model.dart';
import '../models/reply_model.dart';

/// Yörünge Platformu - Topluluk Akışı Denetleyicisi.
/// 1. Kural: Sadece foundation.dart import edilir.
/// Güvenlik Kuralı: Okuma serbest, etkileşimler yalnızca onaylı girişimcilere açıktır.
class ToplulukController {
  late final List<PostModel> _posts;

  /// Mock Yetki Durumu: Onaylı Girişimci mi? (Varsayılan: false)
  bool isApprovedEntrepreneur = false;

  /// Gönderileri tutan ve dinleyen reaktif bildirimci
  late final ValueNotifier<List<PostModel>> postsNotifier;

  /// Yetkisiz işlem denendiğinde hata mesajını ileten bildirimci (Varsayılan: null)
  final ValueNotifier<String?> errorNotifier = ValueNotifier<String?>(null);

  ToplulukController({List<PostModel>? initialPosts}) {
    _posts = List<PostModel>.from(initialPosts ?? kMockPosts);
    postsNotifier = ValueNotifier<List<PostModel>>(List.unmodifiable(_posts));
  }

  /// Girişimci onay durumunu değiştirme (Test & Demo amaçlı)
  void setApproved(bool value) {
    isApprovedEntrepreneur = value;
  }

  /// Gönderi beğenme işlevi (Onaylı girişimci kontrolü zorunludur)
  void likePost(String postId) {
    if (!isApprovedEntrepreneur) {
      errorNotifier.value =
          'Bu işlem için onaylı girişimci olmanız gerekmektedir.';
      return;
    }

    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final isLiked = post.isLikedByMe;
    final newCount = isLiked ? post.likeCount - 1 : post.likeCount + 1;

    _posts[index] = post.copyWith(
      likeCount: newCount,
      isLikedByMe: !isLiked,
    );

    postsNotifier.value = List.unmodifiable(_posts);
  }

  /// Gönderiye yanıt yazma işlevi (Onaylı girişimci kontrolü zorunludur)
  void addReply(String postId, String content) {
    if (!isApprovedEntrepreneur) {
      errorNotifier.value =
          'Bu işlem için onaylı girişimci olmanız gerekmektedir.';
      return;
    }

    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    final newReply = ReplyModel(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'Siz (Girişimci)',
      content: trimmed,
      createdAt: DateTime.now(),
    );

    final updatedReplies = List<ReplyModel>.from(post.replies)..add(newReply);
    _posts[index] = post.copyWith(replies: updatedReplies);

    postsNotifier.value = List.unmodifiable(_posts);
  }

  /// Yeni mikro-paylaşım oluşturma (Onaylı girişimci kontrolü zorunludur)
  void createPost(String content) {
    if (!isApprovedEntrepreneur) {
      errorNotifier.value =
          'Bu işlem için onaylı girişimci olmanız gerekmektedir.';
      return;
    }

    final trimmed = content.trim();
    if (trimmed.isEmpty || trimmed.length > 280) return;

    final newPost = PostModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'Siz (Girişimci)',
      content: trimmed,
      likeCount: 0,
      replies: const [],
      createdAt: DateTime.now(),
    );

    _posts.insert(0, newPost);
    postsNotifier.value = List.unmodifiable(_posts);
  }

  /// Hata durumunu sıfırlama
  void clearError() {
    errorNotifier.value = null;
  }

  /// Bildirimcileri bellekten temizler
  void dispose() {
    postsNotifier.dispose();
    errorNotifier.dispose();
  }
}
