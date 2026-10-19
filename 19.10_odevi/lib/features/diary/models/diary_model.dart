import 'package:flutter/foundation.dart';

/// Günlük girdisi için immutable veri modeli.
/// SKILL.md kurallarına uygun olarak copyWith, fromJson ve toJson metotlarını içerir.
@immutable
class DiaryEntry {
  final String id;
  final String title;
  final String content;
  final String dateString; // YYYY-MM-DD formatında eşleştirme için
  final String timeString; // HH:mm formatında yazılma saati
  final String mood; // 'happy', 'peaceful', 'calm', 'inspired', 'melancholic', 'energetic'

  const DiaryEntry({
    required this.id,
    this.title = '',
    required this.content,
    required this.dateString,
    this.timeString = '12:00',
    required this.mood,
  });

  /// Nesnenin değişmezliğini koruyarak güncellenmiş kopyasını döner.
  DiaryEntry copyWith({
    String? id,
    String? title,
    String? content,
    String? dateString,
    String? timeString,
    String? mood,
  }) {
    return DiaryEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      dateString: dateString ?? this.dateString,
      timeString: timeString ?? this.timeString,
      mood: mood ?? this.mood,
    );
  }

  /// JSON haritasından nesne oluşturur
  factory DiaryEntry.fromJson(Map<String, dynamic> json) => DiaryEntry(
        id: json['id'] as String,
        title: (json['title'] as String?) ?? '',
        content: json['content'] as String,
        dateString: json['dateString'] as String,
        timeString: (json['timeString'] as String?) ?? '12:00',
        mood: json['mood'] as String,
      );

  /// Nesneyi JSON haritasına dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'dateString': dateString,
      'timeString': timeString,
      'mood': mood,
    };
  }

  /// Ruh haline karşılık gelen görsel emoji
  String get moodEmoji {
    switch (mood) {
      case 'happy':
        return '😊';
      case 'peaceful':
        return '🌿';
      case 'calm':
        return '☕';
      case 'inspired':
        return '✨';
      case 'melancholic':
        return '🌧️';
      case 'energetic':
        return '⚡';
      default:
        return '📝';
    }
  }

  /// Ruh halinin Türkçe metin karşılığı
  String get moodLabel {
    switch (mood) {
      case 'happy':
        return 'Mutlu';
      case 'peaceful':
        return 'Huzurlu';
      case 'calm':
        return 'Sakin';
      case 'inspired':
        return 'İlham Dolu';
      case 'melancholic':
        return 'Dalgın';
      case 'energetic':
        return 'Enerjik';
      default:
        return 'Günlük';
    }
  }

  /// En fazla 2-3 satırlık kısa özet
  String get contentSnippet {
    if (content.length <= 110) {
      return content;
    }
    return '${content.substring(0, 107)}...';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiaryEntry &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content &&
          dateString == other.dateString &&
          timeString == other.timeString &&
          mood == other.mood;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      content.hashCode ^
      dateString.hashCode ^
      timeString.hashCode ^
      mood.hashCode;
}
