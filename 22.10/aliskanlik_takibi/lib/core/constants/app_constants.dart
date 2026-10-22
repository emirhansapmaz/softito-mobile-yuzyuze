class AppConstants {
  AppConstants._();

  static const String appName = 'Alışkanlık Takibi';
  static const String appTagline = 'Küçük adımlar, büyük değişimler.';

  // Firestore Koleksiyon İsimleri (04_veritabani_modelleri.md ile birebir uyumlu)
  static const String usersCollection = 'users';
  static const String habitsCollection = 'habits';
  static const String habitLogsCollection = 'habit_logs';
  static const String tipsCollection = 'uyari_bilgileri';

  // Liderlik & Streak Sabitleri
  static const int minPasswordLength = 6;
  static const int leaderboardLimit = 100;
  static const int streakMultiplierThreshold = 10;
  static const double streakMultiplier = 1.5;
}
