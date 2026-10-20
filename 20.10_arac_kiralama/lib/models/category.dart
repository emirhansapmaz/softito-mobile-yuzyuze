class Category {
  final String id;
  final String name;
  final String description;
  final String iconName;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconName: json['iconName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'iconName': iconName,
    };
  }
}
