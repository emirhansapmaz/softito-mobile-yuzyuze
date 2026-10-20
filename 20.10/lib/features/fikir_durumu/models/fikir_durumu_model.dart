import 'package:flutter/foundation.dart';

/// Yörünge Platformu - Fikir Durumu ve Şirketleşme Modeli
@immutable
class FikirDurumuModel {
  final String id;
  final String projectName;
  final int currentStepIndex; // 0 ile 5 arası (Toplam 6 yasal adım)
  final String lawyerName;
  final String lawyerContact;
  final double incomeSupportProgress; // 0.0 ile 1.0 arası oran
  final bool isApproved;

  const FikirDurumuModel({
    required this.id,
    required this.projectName,
    required this.currentStepIndex,
    required this.lawyerName,
    required this.lawyerContact,
    required this.incomeSupportProgress,
    required this.isApproved,
  });

  FikirDurumuModel copyWith({
    String? id,
    String? projectName,
    int? currentStepIndex,
    String? lawyerName,
    String? lawyerContact,
    double? incomeSupportProgress,
    bool? isApproved,
  }) {
    return FikirDurumuModel(
      id: id ?? this.id,
      projectName: projectName ?? this.projectName,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      lawyerName: lawyerName ?? this.lawyerName,
      lawyerContact: lawyerContact ?? this.lawyerContact,
      incomeSupportProgress:
          incomeSupportProgress ?? this.incomeSupportProgress,
      isApproved: isApproved ?? this.isApproved,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FikirDurumuModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          projectName == other.projectName &&
          currentStepIndex == other.currentStepIndex &&
          lawyerName == other.lawyerName &&
          lawyerContact == other.lawyerContact &&
          incomeSupportProgress == other.incomeSupportProgress &&
          isApproved == other.isApproved;

  @override
  int get hashCode =>
      id.hashCode ^
      projectName.hashCode ^
      currentStepIndex.hashCode ^
      lawyerName.hashCode ^
      lawyerContact.hashCode ^
      incomeSupportProgress.hashCode ^
      isApproved.hashCode;
}
