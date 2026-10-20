import 'package:flutter/foundation.dart';

/// Yörünge Platformu - Topluluk Gönderisi Yanıt Modeli
@immutable
class ReplyModel {
  final String id;
  final String authorName;
  final String content;
  final DateTime createdAt;

  const ReplyModel({
    required this.id,
    required this.authorName,
    required this.content,
    required this.createdAt,
  });

  ReplyModel copyWith({
    String? id,
    String? authorName,
    String? content,
    DateTime? createdAt,
  }) {
    return ReplyModel(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReplyModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          authorName == other.authorName &&
          content == other.content &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      authorName.hashCode ^
      content.hashCode ^
      createdAt.hashCode;
}
