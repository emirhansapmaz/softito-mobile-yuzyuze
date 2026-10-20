/// Yörünge Platformu - Kullanıcı Rolleri
enum UserRole {
  entrepreneur, // Girişimci (Yatırım İsteyen)
  mentor, // Mentor (Rehberlik Eden)
  investor; // Yatırımcı (Sermaye Sağlayan)

  String get displayName {
    return switch (this) {
      UserRole.entrepreneur => 'Girişimci',
      UserRole.mentor => 'Mentor',
      UserRole.investor => 'Yatırımcı',
    };
  }

  String get description {
    return switch (this) {
      UserRole.entrepreneur => 'Fikrinden şirkete giden yolda yatırım ve destek arayan kurucu.',
      UserRole.mentor => 'Deneyimleriyle yeni nesil girişimcilere rehberlik eden uzman.',
      UserRole.investor => 'Geleceğin teknolojilerine sermaye ve akıllı ağ sağlayan fon/melek.',
    };
  }
}
