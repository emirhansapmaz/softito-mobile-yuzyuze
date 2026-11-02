// Uygulama genelinde tekrar tekrar kullanılan sabit metin ve koleksiyon isimlerini tuttuğumuz sınıfımız
class AppConstants {
  // Uygulamanın ekranda ve başlıklarda görünen resmi adı
  static const String appName = 'Bugün Ne Yesem?';

  // Firestore Veritabanı Koleksiyon İsimleri (yazım hatasını önlemek için sabit tanımladık)
  // Kullanıcı profillerini tuttuğumuz Firestore koleksiyon adı
  static const String usersCollection = 'users';
  // Yemek tariflerinin kaydedildiği ana koleksiyon adı
  static const String recipesCollection = 'recipes';
  // Kullanıcıların favorilediği yemeklerin tutulduğu koleksiyon adı
  static const String userFavoritesCollection = 'user_favorites';
  // Kullanıcının evdeki buzdolabı/dolap malzemelerini tuttuğumuz envanter koleksiyonu adı
  static const String userInventoryCollection = 'user_inventory';
  // Şeflerin özel tariflerinin listelendiği koleksiyon adı
  static const String chefRecipesCollection = 'chef_recipes';
// AppConstants sınıfının kapanış parantezi
}
