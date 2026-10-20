import 'package:flutter/foundation.dart';

/// Destek programı başvuru durumu
enum ProgramStatus {
  open,
  upcoming,
  closed,
}

/// Yörünge Platformu - Destek Programı Veri Modeli
@immutable
class ProgramModel {
  final String id;
  final String title;
  final String provider; // TÜBİTAK, KOSGEB vb.
  final String category; // Hibe, Devlet Desteği, Yurtdışı, Özel Fon, Kuluçka
  final ProgramStatus status;
  final DateTime deadline;
  final String description;
  final List<String> applicationSteps;

  const ProgramModel({
    required this.id,
    required this.title,
    required this.provider,
    required this.category,
    required this.status,
    required this.deadline,
    required this.description,
    required this.applicationSteps,
  });

  ProgramModel copyWith({
    String? id,
    String? title,
    String? provider,
    String? category,
    ProgramStatus? status,
    DateTime? deadline,
    String? description,
    List<String>? applicationSteps,
  }) {
    return ProgramModel(
      id: id ?? this.id,
      title: title ?? this.title,
      provider: provider ?? this.provider,
      category: category ?? this.category,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      applicationSteps: applicationSteps ?? this.applicationSteps,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          provider == other.provider &&
          category == other.category &&
          status == other.status &&
          deadline == other.deadline &&
          description == other.description &&
          listEquals(applicationSteps, other.applicationSteps);

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      provider.hashCode ^
      category.hashCode ^
      status.hashCode ^
      deadline.hashCode ^
      description.hashCode ^
      applicationSteps.hashCode;
}
