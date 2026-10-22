import 'package:flutter/material.dart';

enum BadgeCategory {
  streak,
  saving;

  String get title {
    switch (this) {
      case BadgeCategory.streak:
        return 'Seri Başarıları';
      case BadgeCategory.saving:
        return 'Tasarruf Başarıları';
    }
  }
}

class BadgeModel {
  final String id;
  final String baslik;
  final String aciklama;
  final IconData icon;
  final BadgeCategory kategori;
  final double hedefDeger;

  const BadgeModel({
    required this.id,
    required this.baslik,
    required this.aciklama,
    required this.icon,
    required this.kategori,
    required this.hedefDeger,
  });

  /// Kullanıcının verilerine göre bu rozetin açılıp açılmadığını denetler
  bool isUnlocked({
    required int maxStreak,
    required double totalSavings,
  }) {
    if (kategori == BadgeCategory.streak) {
      return maxStreak >= hedefDeger;
    } else {
      return totalSavings >= hedefDeger;
    }
  }

  /// 03_ana_ekranlar.md tanımlı tüm rozetler
  static const List<BadgeModel> allBadges = [
    // Seri Başarıları
    BadgeModel(
      id: 'streak_3',
      baslik: '3 Günlük Seri',
      aciklama: 'Bir alışkanlığı aralıksız 3 gün sürdürdün.',
      icon: Icons.local_fire_department_rounded,
      kategori: BadgeCategory.streak,
      hedefDeger: 3,
    ),
    BadgeModel(
      id: 'streak_7',
      baslik: '1 Haftalık İrade',
      aciklama: 'Zinciri kırmadan tam 7 günü geride bıraktın.',
      icon: Icons.bolt_rounded,
      kategori: BadgeCategory.streak,
      hedefDeger: 7,
    ),
    BadgeModel(
      id: 'streak_30',
      baslik: '1 Aylık Şampiyon',
      aciklama: 'Yeni bir alışkanlığı hayatına kalıcı olarak kattın!',
      icon: Icons.workspace_premium_rounded,
      kategori: BadgeCategory.streak,
      hedefDeger: 30,
    ),
    BadgeModel(
      id: 'streak_100',
      baslik: '100 Günlük Efsane',
      aciklama: '100 gün boyunca sarsılmaz bir irade sergiledin.',
      icon: Icons.shield_rounded,
      kategori: BadgeCategory.streak,
      hedefDeger: 100,
    ),

    // Tasarruf Başarıları
    BadgeModel(
      id: 'save_100',
      baslik: 'İlk 100 ₺ Cepte',
      aciklama: 'Zararlı alışkanlığı bırakarak ilk 100 ₺ tasarruf ettin.',
      icon: Icons.savings_rounded,
      kategori: BadgeCategory.saving,
      hedefDeger: 100,
    ),
    BadgeModel(
      id: 'save_500',
      baslik: '500 ₺ Birikim',
      aciklama: 'Cebinde kalan 500 ₺ ile kendine güzel bir ödül ver!',
      icon: Icons.account_balance_wallet_rounded,
      kategori: BadgeCategory.saving,
      hedefDeger: 500,
    ),
    BadgeModel(
      id: 'save_1000',
      baslik: '1.000 ₺ Tasarruf',
      aciklama: 'Tasarrufun 4 basamaklı rakamlara ulaştı.',
      icon: Icons.paid_rounded,
      kategori: BadgeCategory.saving,
      hedefDeger: 1000,
    ),
    BadgeModel(
      id: 'save_5000',
      baslik: 'Finansal Özgürlük',
      aciklama: '5.000 ₺ üzeri tasarruf ile hem sağlığını hem bütçeni kurtardın.',
      icon: Icons.diamond_rounded,
      kategori: BadgeCategory.saving,
      hedefDeger: 5000,
    ),
  ];
}
