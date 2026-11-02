// Firestore zaman damgası (Timestamp) türünü kullanabilmek için gerekli kütüphane
import 'package:cloud_firestore/cloud_firestore.dart';

// Şefler ve kullanıcılar tarafından özel olarak oluşturulan tarifleri tuttuğumuz model sınıfımız
class ChefRecipeModel {
  // Şef tarifinin benzersiz doküman ID'si
  final String id;
  // Tarifi oluşturan kullanıcının/şefin kullanıcı ID'si (UID)
  final String userId;
  // Özel tarifin adı
  final String name;
  // Tarifte kullanılan özel malzemeler listesi
  final List<String> ingredients;
  // Tarifin kalori miktarı
  final int calories;
  // Tarifin adım adım yapılış yönergeleri / adımları
  final String steps;
  // Tarifin sisteme eklenme tarihi ve saati
  final DateTime createdAt;

  // ChefRecipeModel sınıfının değişmez (const) kurucu metodu
  const ChefRecipeModel({
    // Doküman ID alanının zorunlu olduğunu belirtiyoruz
    required this.id,
    // Kullanıcı ID alanının zorunlu olduğunu belirtiyoruz
    required this.userId,
    // Tarif adının zorunlu olduğunu belirtiyoruz
    required this.name,
    // Malzeme listesinin zorunlu olduğunu belirtiyoruz
    required this.ingredients,
    // Kalori alanının zorunlu olduğunu belirtiyoruz
    required this.calories,
    // Adımlar metninin zorunlu olduğunu belirtiyoruz
    required this.steps,
    // Eklenme tarihinin zorunlu olduğunu belirtiyoruz
    required this.createdAt,
  // Kurucu metodun kapanış parantezi
  });

  // Modeli Firestore'a yazarken JSON Map yapısına dönüştüren fonksiyon
  Map<String, dynamic> toMap() {
    // Dart Map koleksiyonunu döndürüyoruz
    return {
      // Veritabanındaki 'id' alanı
      'id': id,
      // Veritabanındaki 'userId' alanı
      'userId': userId,
      // Veritabanındaki 'name' alanı
      'name': name,
      // Veritabanındaki 'ingredients' alanı
      'ingredients': ingredients,
      // Veritabanındaki 'calories' alanı
      'calories': calories,
      // Veritabanındaki 'steps' alanı
      'steps': steps,
      // DateTime nesnesini Firestore'un anladığı Timestamp formatına çeviriyoruz
      'createdAt': Timestamp.fromDate(createdAt),
    // Map kapanışı
    };
  // toMap metodunun kapanış parantezi
  }

  // Firestore'dan gelen Map verisini okuyup güvenli ChefRecipeModel nesnesi üreten fabrika kurucusu
  factory ChefRecipeModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    // Çözümlenecek tarih değişkenimiz
    DateTime parsedDate;
    // Haritadaki ham tarih verisini alıyoruz
    final rawDate = map['createdAt'];
    // Eğer Firestore Timestamp nesnesi geldiyse doğrudan toDate() ile çeviriyoruz
    if (rawDate is Timestamp) {
      // Timestamp'ten DateTime'a dönüşüm
      parsedDate = rawDate.toDate();
    // Eğer ISO String geldiyse parse etmeyi deniyoruz
    } else if (rawDate is String) {
      // tryParse ile güvenli çözümleme, hata verirse şu anki zamanı atıyoruz
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    // Hiçbiri değilse varsayılan şu anki zamanı veriyoruz
    } else {
      // Şu anki tarih ve saat
      parsedDate = DateTime.now();
    // if-else kapanışı
    }

    // Yeni ChefRecipeModel nesnesi oluşturup geriye döndürüyoruz
    return ChefRecipeModel(
      // Doküman ID'si varsa onu, yoksa haritadaki 'id'yi alıyoruz
      id: documentId ?? map['id'] as String? ?? '',
      // Kullanıcı ID'sini okuyoruz
      userId: map['userId'] as String? ?? '',
      // Tarif adını okuyoruz
      name: map['name'] as String? ?? '',
      // Malzemeleri dinamik listeden String listesine dönüştürüyoruz
      ingredients: (map['ingredients'] as List<dynamic>?)
              // Her elemanı String yapıyoruz
              ?.map((e) => e.toString())
              // Dart Listesine çeviriyoruz
              .toList() ??
          // Boşsa boş liste veriyoruz
          [],
      // Kaloriyi tam sayı olarak güvenle alıyoruz
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      // Yapılış adımlarını okuyoruz
      steps: map['steps'] as String? ?? '',
      // Çözümlediğimiz tarihi atıyoruz
      createdAt: parsedDate,
    // ChefRecipeModel nesne çağrısının kapanışı
    );
  // fromMap fabrika metodunun kapanış parantezi
  }

  // Nesnenin sadece istenen alanlarını değiştirip yeni bir kopyasını üreten copyWith fonksiyonumuz
  ChefRecipeModel copyWith({
    // Yeni ID (isteğe bağlı)
    String? id,
    // Yeni kullanıcı ID (isteğe bağlı)
    String? userId,
    // Yeni tarif adı (isteğe bağlı)
    String? name,
    // Yeni malzeme listesi (isteğe bağlı)
    List<String>? ingredients,
    // Yeni kalori (isteğe bağlı)
    int? calories,
    // Yeni adımlar (isteğe bağlı)
    String? steps,
    // Yeni tarih (isteğe bağlı)
    DateTime? createdAt,
  // copyWith parametreleri kapanışı
  }) {
    // Verilmişse yeni değeri, verilmemişse eski değeri koruyarak yeni model döndürüyoruz
    return ChefRecipeModel(
      // id güncellemesi
      id: id ?? this.id,
      // userId güncellemesi
      userId: userId ?? this.userId,
      // name güncellemesi
      name: name ?? this.name,
      // ingredients güncellemesi
      ingredients: ingredients ?? this.ingredients,
      // calories güncellemesi
      calories: calories ?? this.calories,
      // steps güncellemesi
      steps: steps ?? this.steps,
      // createdAt güncellemesi
      createdAt: createdAt ?? this.createdAt,
    // ChefRecipeModel çağrısı kapanışı
    );
  // copyWith metodunun kapanış parantezi
  }
// ChefRecipeModel sınıfının kapanış parantezi
}
