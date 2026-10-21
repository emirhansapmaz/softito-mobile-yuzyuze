import 'package:cloud_firestore/cloud_firestore.dart';

class ChefRecipeModel {
  final String id;
  final String userId;
  final String name;
  final List<String> ingredients;
  final int calories;
  final String steps;
  final DateTime createdAt;

  const ChefRecipeModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.ingredients,
    required this.calories,
    required this.steps,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'ingredients': ingredients,
      'calories': calories,
      'steps': steps,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ChefRecipeModel.fromMap(Map<String, dynamic> map, {String? documentId}) {
    DateTime parsedDate;
    final rawDate = map['createdAt'];
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    return ChefRecipeModel(
      id: documentId ?? map['id'] as String? ?? '',
      userId: map['userId'] as String? ?? '',
      name: map['name'] as String? ?? '',
      ingredients: (map['ingredients'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      steps: map['steps'] as String? ?? '',
      createdAt: parsedDate,
    );
  }

  ChefRecipeModel copyWith({
    String? id,
    String? userId,
    String? name,
    List<String>? ingredients,
    int? calories,
    String? steps,
    DateTime? createdAt,
  }) {
    return ChefRecipeModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      calories: calories ?? this.calories,
      steps: steps ?? this.steps,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
