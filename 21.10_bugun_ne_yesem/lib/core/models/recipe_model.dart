class RecipeModel {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final int calories;
  final String servingSuggestion;
  final String pairsWellWith;
  final String imageUrl;
  final String category; // 'Düşük Kalorili', 'Bütçe Dostu', 'Pratik' vb.

  const RecipeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.ingredients,
    required this.calories,
    required this.servingSuggestion,
    required this.pairsWellWith,
    required this.imageUrl,
    this.category = 'Pratik',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ingredients': ingredients,
      'calories': calories,
      'servingSuggestion': servingSuggestion,
      'pairsWellWith': pairsWellWith,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  factory RecipeModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    return RecipeModel(
      id: documentId ?? map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      ingredients: (map['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      servingSuggestion: map['servingSuggestion'] as String? ?? '',
      pairsWellWith: map['pairsWellWith'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      category: map['category'] as String? ?? 'Pratik',
    );
  }

  RecipeModel copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? ingredients,
    int? calories,
    String? servingSuggestion,
    String? pairsWellWith,
    String? imageUrl,
    String? category,
  }) {
    return RecipeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      calories: calories ?? this.calories,
      servingSuggestion: servingSuggestion ?? this.servingSuggestion,
      pairsWellWith: pairsWellWith ?? this.pairsWellWith,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
    );
  }
}
