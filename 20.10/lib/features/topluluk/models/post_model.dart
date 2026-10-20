import 'package:flutter/foundation.dart';
import 'reply_model.dart';

/// Yörünge Platformu - Topluluk Mikro-Paylaşım Modeli
@immutable
class PostModel {
  final String id;
  final String authorName;
  final String content; // Maks 280 karakter
  final int likeCount;
  final List<ReplyModel> replies;
  final bool isLikedByMe;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.authorName,
    required this.content,
    required this.likeCount,
    required this.replies,
    this.isLikedByMe = false,
    required this.createdAt,
  });

  PostModel copyWith({
    String? id,
    String? authorName,
    String? content,
    int? likeCount,
    List<ReplyModel>? replies,
    bool? isLikedByMe,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      likeCount: likeCount ?? this.likeCount,
      replies: replies ?? this.replies,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PostModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          authorName == other.authorName &&
          content == other.content &&
          likeCount == other.likeCount &&
          listEquals(replies, other.replies) &&
          isLikedByMe == other.isLikedByMe &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      authorName.hashCode ^
      content.hashCode ^
      likeCount.hashCode ^
      replies.hashCode ^
      isLikedByMe.hashCode ^
      createdAt.hashCode;
}
