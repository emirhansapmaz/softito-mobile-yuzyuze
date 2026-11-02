// Yemek tarifinin tüm özelliklerini barındıran model sınıfımız
class RecipeModel {
  // Tarifin benzersiz kimlik (ID) numarası
  final String id;
  // Yemeğin adı / başlığı
  final String name;
  // Tarifin adım adım hazırlanış açıklaması
  final String description;
  // Tarif için gereken malzemelerin listesi
  final List<String> ingredients;
  // Yemeğin porsiyon başına kalori değeri
  final int calories;
  // Yemeğin nasıl servis edileceğine dair sunum önerisi
  final String servingSuggestion;
  // Bu yemeğin yanına en iyi yakışan eşlikçi içecek veya yan yemek önerisi
  final String pairsWellWith;
  // Yemeğin görseline ait internet linki (URL)
  final String imageUrl;
  // Tarif kategorisi ('Düşük Kalorili', 'Bütçe Dostu', 'Pratik' vb.)
  final String category;

  // RecipeModel sınıfının değişmez (const) kurucu metodu
  const RecipeModel({
    // ID alanının zorunlu olduğunu belirtiyoruz
    required this.id,
    // Yemek adının zorunlu olduğunu belirtiyoruz
    required this.name,
    // Açıklamanın zorunlu olduğunu belirtiyoruz
    required this.description,
    // Malzemeler listesinin zorunlu olduğunu belirtiyoruz
    required this.ingredients,
    // Kalori miktarının zorunlu olduğunu belirtiyoruz
    required this.calories,
    // Sunum önerisinin zorunlu olduğunu belirtiyoruz
    required this.servingSuggestion,
    // Eşlikçi yiyecek önerisinin zorunlu olduğunu belirtiyoruz
    required this.pairsWellWith,
    // Resim linkinin zorunlu olduğunu belirtiyoruz
    required this.imageUrl,
    // Kategori belirtilmediyse varsayılan olarak 'Pratik' atıyoruz
    this.category = 'Pratik',
  // Kurucu metodun kapanış parantezi
  });

  // Modeli Firestore veritabanına kaydederken Map koleksiyonuna çeviren metot
  Map<String, dynamic> toMap() {
    // Dart Map yapısını geriye döndürüyoruz
    return {
      // Haritadaki 'id' alanı
      'id': id,
      // Haritadaki 'name' alanı
      'name': name,
      // Haritadaki 'description' alanı
      'description': description,
      // Haritadaki 'ingredients' malzeme listesi
      'ingredients': ingredients,
      // Haritadaki 'calories' değeri
      'calories': calories,
      // Haritadaki 'servingSuggestion' sunum önerisi
      'servingSuggestion': servingSuggestion,
      // Haritadaki 'pairsWellWith' eşlikçi yemek
      'pairsWellWith': pairsWellWith,
      // Haritadaki 'imageUrl' resim linki
      'imageUrl': imageUrl,
      // Haritadaki 'category' kategori alanı
      'category': category,
    // Map kapanışı
    };
  // toMap metodunun kapanış parantezi
  }

  // Firestore'dan gelen Map haritasını RecipeModel nesnesine dönüştüren fabrika kurucusu
  factory RecipeModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    // Yeni RecipeModel nesnesi oluşturup geriye döndürüyoruz
    return RecipeModel(
      // Doküman ID'si varsa onu, yoksa haritadaki 'id'yi alıyoruz
      id: documentId ?? map['id'] as String? ?? '',
      // Yemek adını okuyoruz, yoksa boş metin atıyoruz
      name: map['name'] as String? ?? '',
      // Açıklama metnini okuyoruz
      description: map['description'] as String? ?? '',
      // Malzemeler listesini String listesine dönüştürerek güvenle okuyoruz
      ingredients: (map['ingredients'] as List<dynamic>?)
              // Listedeki her bir elemanı String'e çeviriyoruz
              ?.map((e) => e.toString())
              // Standart Dart Listesine çeviriyoruz
              .toList() ??
          // Liste null ise boş liste atıyoruz
          [],
      // Kalori değerini tam sayı olarak güvenle alıyoruz
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      // Sunum önerisini okuyoruz
      servingSuggestion: map['servingSuggestion'] as String? ?? '',
      // Eşlikçi önerisini okuyoruz
      pairsWellWith: map['pairsWellWith'] as String? ?? '',
      // Resim URL adresini okuyoruz
      imageUrl: map['imageUrl'] as String? ?? '',
      // Kategori alanını okuyoruz, yoksa 'Pratik' atıyoruz
      category: map['category'] as String? ?? 'Pratik',
    // RecipeModel nesne çağrısının kapanışı
    );
  // fromMap fabrika metodunun kapanış parantezi
  }

  // Nesnenin istenilen alanlarını güncelleyip yeni bir kopyasını üreten copyWith metodu
  RecipeModel copyWith({
    // İsteğe bağlı yeni ID
    String? id,
    // İsteğe bağlı yeni isim
    String? name,
    // İsteğe bağlı yeni açıklama
    String? description,
    // İsteğe bağlı yeni malzeme listesi
    List<String>? ingredients,
    // İsteğe bağlı yeni kalori
    int? calories,
    // İsteğe bağlı yeni sunum önerisi
    String? servingSuggestion,
    // İsteğe bağlı yeni eşlikçi
    String? pairsWellWith,
    // İsteğe bağlı yeni görsel linki
    String? imageUrl,
    // İsteğe bağlı yeni kategori
    String? category,
  // copyWith parametreleri kapanışı
  }) {
    // Yeni değerler verilmişse onları, verilmemişse eski değerleri koruyarak yeni model döndürüyoruz
    return RecipeModel(
      // id güncellemesi
      id: id ?? this.id,
      // name güncellemesi
      name: name ?? this.name,
      // description güncellemesi
      description: description ?? this.description,
      // ingredients güncellemesi
      ingredients: ingredients ?? this.ingredients,
      // calories güncellemesi
      calories: calories ?? this.calories,
      // servingSuggestion güncellemesi
      servingSuggestion: servingSuggestion ?? this.servingSuggestion,
      // pairsWellWith güncellemesi
      pairsWellWith: pairsWellWith ?? this.pairsWellWith,
      // imageUrl güncellemesi
      imageUrl: imageUrl ?? this.imageUrl,
      // category güncellemesi
      category: category ?? this.category,
    // RecipeModel çağrısı kapanışı
    );
  // copyWith metodunun kapanış parantezi
  }
// RecipeModel sınıfının kapanış parantezi
}
