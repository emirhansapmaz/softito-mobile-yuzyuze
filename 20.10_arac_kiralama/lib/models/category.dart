/// Araç kategorilerini (Sedan, SUV, Hatchback vb.) temsil eden veri modeli.
class Category {
  /// Kategorinin benzersiz kimliği (örn: 'sedan', 'suv', 'luxury')
  final String id;
  
  /// Kullanıcıya gösterilen kategori adı (örn: 'Sedan Araçlar')
  final String name;
  
  /// Kategori hakkında kısa açıklama
  final String description;
  
  /// Kategoriye ait ikonun sembolik adı veya tipi
  final String iconName;

  /// Category sınıfının kurucu metodu (Constructor)
  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
  });

  /// JSON formatındaki Map verisini Category nesnesine dönüştüren fabrika kurucu metot
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      // JSON içinden kategori ID'sini alıyoruz.
      id: json['id'] as String,
      // Kategori adını alıyoruz.
      name: json['name'] as String,
      // Kategori açıklama metnini alıyoruz.
      description: json['description'] as String,
      // İkon adını alıyoruz.
      iconName: json['iconName'] as String,
    );
  }

  /// Category nesnesini JSON Map formatına dönüştüren metot
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
    };
  }
}
