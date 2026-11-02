/// Yörünge Platformu - Kullanıcı Rolleri Numaralandırması
enum UserRole {
  // Girişimci rolü (Fikrini projeye dönüştürüp yatırım arayan kurucu)
  entrepreneur,
  // Mentor rolü (Deneyimlerini paylaşıp yol gösteren uzman rehber)
  mentor,
  // Yatırımcı rolü (Yüksek potansiyelli girişimlere sermaye sağlayan melek/fon)
  investor;

  // Rolün kullanıcıya gösterilecek Türkçe başlığını döndüren getter
  String get displayName {
    // Switch deseni ile eşleştirme
    return switch (this) {
      // Girişimci başlığı
      UserRole.entrepreneur => 'Girişimci',
      // Mentor başlığı
      UserRole.mentor => 'Mentor',
      // Yatırımcı başlığı
      UserRole.investor => 'Yatırımcı',
    }; // switch sonu
  } // displayName getter kapanışı

  // Rolün açıklamasını döndüren getter
  String get description {
    // Switch deseni ile eşleştirme
    return switch (this) {
      // Girişimci açıklaması
      UserRole.entrepreneur => 'Fikrinden şirkete giden yolda yatırım ve destek arayan kurucu.',
      // Mentor açıklaması
      UserRole.mentor => 'Deneyimleriyle yeni nesil girişimcilere rehberlik eden uzman.',
      // Yatırımcı açıklaması
      UserRole.investor => 'Geleceğin teknolojilerine sermaye ve akıllı ağ sağlayan fon/melek.',
    }; // switch sonu
  } // description getter kapanışı
} // UserRole enum kapanışı
